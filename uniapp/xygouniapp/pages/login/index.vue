<template>
  <view class="login-page">
    <view class="status-bar" :style="{ height: statusBarHeight + 'px' }"></view>

    <view class="logo-area">
      <image class="logo" src="/static/logo.png" mode="aspectFit"></image>
      <text class="app-name">XYGo Admin</text>
      <text class="app-desc">企业级中后台管理系统</text>
    </view>

    <view class="login-area">
      <!-- #ifdef MP-WEIXIN -->
      <button class="login-btn wx-btn" :loading="loading" @tap="handleWxLogin">
        微信一键登录
      </button>
      <!-- #endif -->

      <!-- #ifdef H5 -->
      <button class="login-btn wx-btn" :loading="loading" @tap="handleOaLogin">
        微信公众号登录
      </button>
      <!-- #endif -->

      <!-- #ifndef MP-WEIXIN || H5 -->
      <button class="login-btn wx-btn" disabled>
        暂不支持当前平台登录
      </button>
      <!-- #endif -->
    </view>

    <view class="agreement">
      <text class="agree-text">登录即表示同意</text>
      <text class="agree-link">《用户协议》</text>
      <text class="agree-text">和</text>
      <text class="agree-link">《隐私政策》</text>
    </view>
  </view>
</template>

<script>
import { useUserStore } from '@/store/user'
import { wxMappLogin, oaAuthUrl, oaCallback } from '@/api/auth'

export default {
  data() {
    return {
      loading: false,
      statusBarHeight: 44,
    }
  },
  onLoad(query) {
    const sysInfo = uni.getSystemInfoSync()
    this.statusBarHeight = sysInfo.statusBarHeight || 44

    // #ifdef H5
    const urlParams = new URLSearchParams(window.location.search)
    const code = urlParams.get('code')
    const state = urlParams.get('state')
    if (code) {
      this.handleOaCallback(code, state || '')
    }
    // #endif
  },
  methods: {
    // 小程序微信登录
    async handleWxLogin() {
      if (this.loading) return
      this.loading = true
      try {
        const loginRes = await new Promise((resolve, reject) => {
          uni.login({
            provider: 'weixin',
            success: resolve,
            fail: reject,
          })
        })
        if (!loginRes?.code) {
          uni.showToast({ title: '获取微信授权失败', icon: 'none' })
          return
        }
        const data = await wxMappLogin(loginRes.code)
        const store = useUserStore()
        store.setToken(data.token)
        await store.fetchProfile()
        uni.showToast({ title: '登录成功', icon: 'success' })
        setTimeout(() => {
          uni.switchTab({ url: '/pages/user/index' })
        }, 500)
      } catch (e) {
        console.error('登录失败', e)
      } finally {
        this.loading = false
      }
    },

    // H5 公众号登录 - 跳转授权
    async handleOaLogin() {
      if (this.loading) return
      this.loading = true
      try {
        // #ifdef H5
        const redirect = window.location.origin + window.location.pathname
        const data = await oaAuthUrl(redirect)
        window.location.href = data.url
        // #endif
      } catch (e) {
        console.error('获取授权链接失败', e)
        this.loading = false
      }
    },

    // H5 公众号登录 - 回调处理
    async handleOaCallback(code, state) {
      this.loading = true
      try {
        const data = await oaCallback(code, state)
        const store = useUserStore()
        store.setToken(data.token)
        await store.fetchProfile()
        uni.showToast({ title: '登录成功', icon: 'success' })
        setTimeout(() => {
          uni.switchTab({ url: '/pages/user/index' })
        }, 500)
      } catch (e) {
        console.error('公众号回调登录失败', e)
      } finally {
        this.loading = false
      }
    },
  },
}
</script>

<style scoped>
.login-page {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  background: linear-gradient(180deg, #e8f0fe 0%, #f5f5f5 50%);
}

.logo-area {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-top: 120rpx;
}

.logo {
  width: 160rpx;
  height: 160rpx;
  border-radius: 32rpx;
}

.app-name {
  font-size: 44rpx;
  font-weight: 700;
  color: #1a1a1a;
  margin-top: 32rpx;
}

.app-desc {
  font-size: 26rpx;
  color: #999;
  margin-top: 12rpx;
}

.login-area {
  width: 100%;
  padding: 0 80rpx;
  margin-top: 120rpx;
}

.login-btn {
  width: 100%;
  height: 96rpx;
  line-height: 96rpx;
  border-radius: 48rpx;
  font-size: 32rpx;
  font-weight: 600;
  letter-spacing: 2rpx;
  border: none;
  display: flex;
  align-items: center;
  justify-content: center;
}

.login-btn::after {
  border: none;
}

.wx-btn {
  background: #07c160;
  color: #ffffff;
}

.wx-btn:active {
  background: #06ad56;
}

.agreement {
  position: fixed;
  bottom: 60rpx;
  display: flex;
  align-items: center;
}

.agree-text {
  font-size: 22rpx;
  color: #999;
}

.agree-link {
  font-size: 22rpx;
  color: #4C84FF;
}
</style>
