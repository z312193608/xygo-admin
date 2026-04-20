// +----------------------------------------------------------------------
// | XYGo Admin [ Vue3 + GoFrame 企业级中后台管理系统 ]
// +----------------------------------------------------------------------
// | Copyright (c) 2026 大连星韵网络科技有限公司 All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( https://opensource.org/licenses/MIT )
// +----------------------------------------------------------------------
// | Author: 喜羊羊 <751300685@qq.com>
// +----------------------------------------------------------------------

/**
 * 前台会员信息 API
 *
 * 使用 Xy-User-Token 进行认证
 */
import { memberRequest } from '@/utils/http'
import type { MemberInfo } from '@/store/modules/member'

/** 更新资料参数 */
export interface UpdateProfileParams {
  nickname?: string
  avatar?: string
  gender?: number
  birthday?: string
  email?: string
  mobile?: string
}

/** 修改密码参数 */
export interface ChangePasswordParams {
  oldPassword: string
  newPassword: string
}

/**
 * 获取会员信息
 */
export function getMemberInfo() {
  return memberRequest.get<MemberInfo>({
    url: '/user/info'
  })
}

/**
 * 更新会员资料
 */
export function updateMemberProfile(params: UpdateProfileParams) {
  return memberRequest.put<void>({
    url: '/user/profile',
    data: params
  })
}

/**
 * 修改密码
 */
export function changeMemberPassword(params: ChangePasswordParams) {
  return memberRequest.put<void>({
    url: '/user/password',
    data: params
  })
}

/** 前台菜单项 */
export interface MemberMenuItem {
  id: number
  pid: number
  title: string
  name: string
  path: string
  component: string
  icon: string
  menuType: string // tab | link | iframe
  url: string
  type: string // route | menu_dir | menu | nav | nav_user_menu | button
  navShowChildren?: number
  sort?: number
  noLoginValid: number
  children?: MemberMenuItem[]
}

/** 前台菜单响应 */
export interface MemberMenusResult {
  menus: MemberMenuItem[] // 会员中心菜单
  nav: MemberMenuItem[]   // 顶栏导航
  rules: MemberMenuItem[] // 普通路由
}

/**
 * 获取当前会员菜单（按分组权限过滤）
 */
export function getMemberMenus() {
  return memberRequest.get<MemberMenusResult>({
    url: '/user/menus'
  })
}
