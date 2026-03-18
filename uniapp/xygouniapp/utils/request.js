import config from './config'

const request = (options = {}) => {
  return new Promise((resolve, reject) => {
    const token = uni.getStorageSync(config.TOKEN_KEY)

    const header = {
      'Content-Type': 'application/json',
      ...options.header,
    }
    if (token) {
      header['Xy-User-Token'] = token
    }

    uni.request({
      url: config.BASE_URL + options.url,
      method: options.method || 'GET',
      data: options.data,
      header,
      success: (res) => {
        if (res.statusCode === 200) {
          const data = res.data
          if (data.code === 0) {
            resolve(data.data)
          } else if (data.code === 401) {
            uni.removeStorageSync(config.TOKEN_KEY)
            uni.showToast({ title: '请先登录', icon: 'none' })
            reject(data)
          } else {
            uni.showToast({ title: data.message || '请求失败', icon: 'none' })
            reject(data)
          }
        } else {
          uni.showToast({ title: `网络错误 ${res.statusCode}`, icon: 'none' })
          reject(res)
        }
      },
      fail: (err) => {
        uni.showToast({ title: '网络连接失败', icon: 'none' })
        reject(err)
      },
    })
  })
}

export const get = (url, data) => request({ url, method: 'GET', data })
export const post = (url, data) => request({ url, method: 'POST', data })

export default request
