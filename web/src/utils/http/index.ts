/**
 * HTTP 请求封装模块
 * 基于 Axios 封装的 HTTP 请求工具，提供统一的请求/响应处理
 *
 * ## 主要功能
 *
 * - 请求/响应拦截器（自动添加 Token、统一错误处理）
 * - 401 未授权自动登出（带防抖机制）
 * - 请求失败自动重试（可配置）
 * - 统一的成功/错误消息提示
 * - 支持 GET/POST/PUT/DELETE 等常用方法
 *
 * @module utils/http
 * @author Art Design Pro Team
 */

import axios, { AxiosRequestConfig, AxiosResponse, InternalAxiosRequestConfig } from 'axios'
import { useUserStore } from '@/store/modules/user'
import { useMemberStore } from '@/store/modules/member'
import { ApiStatus } from './status'
import { HttpError, handleError, showError, showSuccess } from './error'
import { $t } from '@/locales'
import { BaseResponse } from '@/types'
import { router } from '@/router'
import { ADMIN_LOGIN_PATH } from '@/router/routesAlias'

/** 请求配置常量 */
const REQUEST_TIMEOUT = 15000 // 临时改成1ms复现context canceled，测完改回15000
const LOGOUT_DELAY = 500
const MAX_RETRIES = 0
const RETRY_DELAY = 1000
const UNAUTHORIZED_DEBOUNCE_TIME = 3000

/** 401防抖状态 */
let isUnauthorizedErrorShown = false
let unauthorizedTimer: NodeJS.Timeout | null = null

/** Token 刷新状态 */
let isAdminRefreshing = false
let adminPendingRequests: Array<{ resolve: (value: any) => void; reject: (reason: any) => void; config: any }> = []
let isMemberRefreshing = false
let memberPendingRequests: Array<{ resolve: (value: any) => void; reject: (reason: any) => void; config: any }> = []

/** 扩展 AxiosRequestConfig */
interface ExtendedAxiosRequestConfig extends AxiosRequestConfig {
  showErrorMessage?: boolean
  showSuccessMessage?: boolean
}

const { VITE_API_URL, VITE_WITH_CREDENTIALS } = import.meta.env

/** Axios实例 */
const axiosInstance = axios.create({
  timeout: REQUEST_TIMEOUT,
  baseURL: VITE_API_URL,
  withCredentials: VITE_WITH_CREDENTIALS === 'true',
  validateStatus: (status) => status >= 200 && status < 300,
  transformResponse: [
    (data, headers) => {
      const contentType = headers['content-type']
      if (contentType?.includes('application/json')) {
        try {
          return JSON.parse(data)
        } catch {
          return data
        }
      }
      return data
    }
  ]
})

/**
 * 判断是否为会员接口请求
 */
function isMemberRequest(url: string): boolean {
  return url.startsWith('/member')
}

/** 请求拦截器 */
axiosInstance.interceptors.request.use(
  (request: InternalAxiosRequestConfig) => {
    const url = request.url || ''

    // 根据请求 URL 区分 Token
    if (isMemberRequest(url)) {
      // 会员接口：使用 Xy-User-Token
      const memberStore = useMemberStore()
      const memberToken = memberStore.getToken()
      if (memberToken) {
        request.headers.set('Xy-User-Token', memberToken)
      }
    } else {
      // 后台接口：使用 Authorization Bearer
      const { accessToken } = useUserStore()
      if (accessToken) {
        const hasBearer = accessToken.toLowerCase().startsWith('bearer ')
        request.headers.set('Authorization', hasBearer ? accessToken : `Bearer ${accessToken}`)
      }
    }

    if (request.data && !(request.data instanceof FormData) && !request.headers['Content-Type']) {
      request.headers.set('Content-Type', 'application/json')
      request.data = JSON.stringify(request.data)
    }

    return request
  },
  (error) => {
    showError(createHttpError($t('httpMsg.requestConfigError'), ApiStatus.error))
    return Promise.reject(error)
  }
)

/** 响应拦截器 */
axiosInstance.interceptors.response.use(
  async (response: AxiosResponse<BaseResponse>) => {
    const { code, msg, message } = response.data as any
    const errorMsg = msg || message
    const url = response.config.url || ''
    const isMember = isMemberRequest(url)

    if (code === ApiStatus.success) return response
    if (code === ApiStatus.kickedOut) handleKickedOutError(errorMsg, isMember)

    if (code === ApiStatus.unauthorized && !isRefreshRequest(response.config)) {
      const result = await tryTokenRefresh(response.config, isMember)
      if (result) return result
      handleUnauthorizedError(errorMsg, isMember)
    }

    throw createHttpError(errorMsg || $t('httpMsg.requestFailed'), code)
  },
  async (error) => {
    const url = error.config?.url || ''
    const isMember = isMemberRequest(url)

    if ((error.response?.status === 401 || error.response?.status === ApiStatus.unauthorized) && !isRefreshRequest(error.config)) {
      const result = await tryTokenRefresh(error.config, isMember)
      if (result) return result
      handleUnauthorizedError(undefined, isMember)
    }

    return Promise.reject(handleError(error))
  }
)

/** 统一创建HttpError */
function createHttpError(message: string, code: number) {
  return new HttpError(message, code)
}

/** 处理被踢下线错误（SSO单点/管理员强制下线） */
function handleKickedOutError(message?: string, isMember: boolean = false): never {
  const error = createHttpError(
    message || '您的账号已在其他设备登录，请重新登录',
    ApiStatus.kickedOut
  )

  if (!isUnauthorizedErrorShown) {
    isUnauthorizedErrorShown = true

    // 使用 MessageBox 弹窗提示（比普通过期更醒目）
    import('element-plus').then(({ ElMessageBox }) => {
      ElMessageBox.alert(
        message || '您的账号已在其他设备登录，当前会话已失效。',
        '账号异地登录',
        {
          confirmButtonText: '重新登录',
          type: 'warning',
          callback: () => {
            if (isMember) {
              logOutMember()
            } else {
              logOut()
            }
            resetUnauthorizedError()
          }
        }
      )
    })

    unauthorizedTimer = setTimeout(resetUnauthorizedError, UNAUTHORIZED_DEBOUNCE_TIME)
    throw error
  }

  throw error
}

/** 判断是否为刷新令牌请求（防止递归刷新） */
function isRefreshRequest(config: any): boolean {
  const url = config?.url || ''
  return url.includes('/auth/refresh')
}

/** 直接调用 admin 刷新接口（不通过 adminRequest，避免循环依赖） */
async function doAdminRefresh(refreshToken: string) {
  const response = await axiosInstance.post('/admin/auth/refresh', { refreshToken })
  return response.data?.data as { accessToken: string; expiresIn: number } | undefined
}

/** 直接调用 member 刷新接口 */
async function doMemberRefresh(refreshToken: string) {
  const response = await axiosInstance.post('/member/auth/refresh', { refreshToken })
  return response.data?.data as { accessToken: string; expiresIn: number } | undefined
}

/** 尝试用 refreshToken 静默刷新，成功则重试原请求 */
async function tryTokenRefresh(config: any, isMember: boolean): Promise<AxiosResponse | null> {
  if (isMember) {
    return tryMemberRefresh(config)
  }
  return tryAdminRefresh(config)
}

async function tryAdminRefresh(config: any): Promise<AxiosResponse | null> {
  const userStore = useUserStore()
  const { refreshToken } = userStore
  if (!refreshToken) return null

  if (isAdminRefreshing) {
    return new Promise((resolve, reject) => {
      adminPendingRequests.push({ resolve, reject, config })
    })
  }

  isAdminRefreshing = true
  try {
    const res = await doAdminRefresh(refreshToken)
    if (!res?.accessToken) return null

    userStore.setToken(res.accessToken)
    adminPendingRequests.forEach(({ resolve, config: c }) => {
      resolve(axiosInstance.request(c))
    })
    adminPendingRequests = []
    return axiosInstance.request(config)
  } catch {
    adminPendingRequests.forEach(({ reject }) => {
      reject(new HttpError('refresh failed', ApiStatus.unauthorized))
    })
    adminPendingRequests = []
    return null
  } finally {
    isAdminRefreshing = false
  }
}

async function tryMemberRefresh(config: any): Promise<AxiosResponse | null> {
  const memberStore = useMemberStore()
  const refreshToken = memberStore.getRefreshToken()
  if (!refreshToken) return null

  if (isMemberRefreshing) {
    return new Promise((resolve, reject) => {
      memberPendingRequests.push({ resolve, reject, config })
    })
  }

  isMemberRefreshing = true
  try {
    const res = await doMemberRefresh(refreshToken)
    if (!res?.accessToken) return null

    memberStore.setToken(res.accessToken)
    memberPendingRequests.forEach(({ resolve, config: c }) => {
      resolve(axiosInstance.request(c))
    })
    memberPendingRequests = []
    return axiosInstance.request(config)
  } catch {
    memberPendingRequests.forEach(({ reject }) => {
      reject(new HttpError('refresh failed', ApiStatus.unauthorized))
    })
    memberPendingRequests = []
    return null
  } finally {
    isMemberRefreshing = false
  }
}

/** 处理401错误（带防抖） */
function handleUnauthorizedError(message?: string, isMember: boolean = false): never {
  const error = createHttpError(message || $t('httpMsg.unauthorized'), ApiStatus.unauthorized)

  if (!isUnauthorizedErrorShown) {
    isUnauthorizedErrorShown = true

    // 根据请求类型决定登出哪个账户
    if (isMember) {
      logOutMember()
    } else {
      logOut()
    }

    unauthorizedTimer = setTimeout(resetUnauthorizedError, UNAUTHORIZED_DEBOUNCE_TIME)

    showError(error, true)
    throw error
  }

  throw error
}

/** 重置401防抖状态 */
function resetUnauthorizedError() {
  isUnauthorizedErrorShown = false
  if (unauthorizedTimer) clearTimeout(unauthorizedTimer)
  unauthorizedTimer = null
}

function getCurrentHashPath() {
  const hash = window.location.hash || ''
  const path = hash.startsWith('#') ? hash.slice(1) : hash
  return path || router.currentRoute.value.fullPath || '/'
}

/** 后台管理员退出登录 */
function logOut() {
  setTimeout(() => {
    const redirectPath = getCurrentHashPath()
    useUserStore().logOut({ redirect: false })
    if (router.currentRoute.value.path !== ADMIN_LOGIN_PATH) {
      router.push({
        path: ADMIN_LOGIN_PATH,
        query: redirectPath && redirectPath !== ADMIN_LOGIN_PATH ? { redirect: redirectPath } : undefined
      })
    }
  }, LOGOUT_DELAY)
}

/** 前台会员退出登录（防重复调用） */
let memberLogoutPending = false
function logOutMember() {
  if (memberLogoutPending) return
  memberLogoutPending = true
  setTimeout(() => {
    useMemberStore().logOut()
    setTimeout(() => { memberLogoutPending = false }, UNAUTHORIZED_DEBOUNCE_TIME)
  }, LOGOUT_DELAY)
}

/** 是否需要重试 */
function shouldRetry(statusCode: number) {
  return [
    ApiStatus.requestTimeout,
    ApiStatus.internalServerError,
    ApiStatus.badGateway,
    ApiStatus.serviceUnavailable,
    ApiStatus.gatewayTimeout
  ].includes(statusCode)
}

/** 请求重试逻辑 */
async function retryRequest<T>(
  config: ExtendedAxiosRequestConfig,
  retries: number = MAX_RETRIES
): Promise<T> {
  try {
    return await request<T>(config)
  } catch (error) {
    if (retries > 0 && error instanceof HttpError && shouldRetry(error.code)) {
      await delay(RETRY_DELAY)
      return retryRequest<T>(config, retries - 1)
    }
    throw error
  }
}

/** 延迟函数 */
function delay(ms: number) {
  return new Promise((resolve) => setTimeout(resolve, ms))
}

/** 请求函数 */
async function request<T = any>(config: ExtendedAxiosRequestConfig): Promise<T> {
  // POST | PUT 参数自动填充
  if (
    ['POST', 'PUT'].includes(config.method?.toUpperCase() || '') &&
    config.params &&
    !config.data
  ) {
    config.data = config.params
    config.params = undefined
  }

  try {
    const res = await axiosInstance.request<BaseResponse<T>>(config)

    // 显示成功消息（兼容msg和message字段）
    const successMsg = (res.data as any).msg || (res.data as any).message
    if (config.showSuccessMessage && successMsg) {
      showSuccess(successMsg)
    }

    return res.data.data as T
  } catch (error) {
    if (error instanceof HttpError && error.code !== ApiStatus.unauthorized && error.code !== 401) {
      const showMsg = config.showErrorMessage !== false
      showError(error, showMsg)
    }
    return Promise.reject(error)
  }
}

/** 创建带前缀的请求API */
function createPrefixedApi(prefix: string = '') {
  const addPrefix = (config: ExtendedAxiosRequestConfig): ExtendedAxiosRequestConfig => {
    const url = config.url || ''
    // 如果 URL 已经是此前缀，或此前缀下的子路径，不重复添加
    if (prefix && url !== prefix && !url.startsWith(`${prefix}/`)) {
      config.url = prefix + (url.startsWith('/') ? url : '/' + url)
    }
    return config
  }

  return {
    get<T>(config: ExtendedAxiosRequestConfig) {
      return retryRequest<T>({ ...addPrefix(config), method: 'GET' })
    },
    post<T>(config: ExtendedAxiosRequestConfig) {
      return retryRequest<T>({ ...addPrefix(config), method: 'POST' })
    },
    put<T>(config: ExtendedAxiosRequestConfig) {
      return retryRequest<T>({ ...addPrefix(config), method: 'PUT' })
    },
    del<T>(config: ExtendedAxiosRequestConfig) {
      return retryRequest<T>({ ...addPrefix(config), method: 'DELETE' })
    },
    request<T>(config: ExtendedAxiosRequestConfig) {
      return retryRequest<T>(addPrefix(config))
    }
  }
}

/** API方法集合（默认，无前缀） */
const api = createPrefixedApi()

/** 后台管理员请求（前缀 /admin） */
export const adminRequest = createPrefixedApi('/admin')

/** 前台会员请求（前缀 /member） */
export const memberRequest = createPrefixedApi('/member')

/** 前台公共请求（前缀 /site） */
export const siteRequest = createPrefixedApi('/site')

export default api
