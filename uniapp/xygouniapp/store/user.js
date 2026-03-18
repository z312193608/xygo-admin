import { ref, computed } from 'vue'
import { getProfile } from '@/api/auth'
import config from '@/utils/config'

const token = ref(uni.getStorageSync(config.TOKEN_KEY) || '')
const userInfo = ref(null)

export function useUserStore() {
  const isLoggedIn = computed(() => !!token.value)

  function setToken(val) {
    token.value = val
    if (val) {
      uni.setStorageSync(config.TOKEN_KEY, val)
    } else {
      uni.removeStorageSync(config.TOKEN_KEY)
    }
  }

  async function fetchProfile() {
    if (!token.value) return
    try {
      const data = await getProfile()
      userInfo.value = data
    } catch (e) {
      console.error('获取用户信息失败', e)
    }
  }

  function logout() {
    setToken('')
    userInfo.value = null
    uni.reLaunch({ url: '/pages/index/index' })
  }

  return { token, userInfo, isLoggedIn, setToken, fetchProfile, logout }
}
