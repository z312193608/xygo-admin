<template>
  <view class="user-page">
    <!-- 用户信息卡片 -->
    <view class="user-card" @tap="handleCardTap">
      <view class="user-header">
        <image
          class="avatar"
          :src="avatarUrl"
          mode="aspectFill"
        ></image>
        <view class="user-meta" v-if="isLoggedIn && userInfo">
          <text class="nickname">{{ userInfo.nickname || '微信用户' }}</text>
          <view class="user-tags">
            <text class="tag">Lv.{{ userInfo.level || 1 }}</text>
            <text class="tag">{{ userInfo.score || 0 }} 积分</text>
          </view>
        </view>
        <view class="user-meta" v-else>
          <text class="nickname login-hint">点击登录</text>
          <text class="sub-text">登录后享受更多功能</text>
        </view>
        <text class="arrow">›</text>
      </view>

      <!-- 资产栏 -->
      <view class="asset-bar" v-if="isLoggedIn && userInfo">
        <view class="asset-item">
          <text class="asset-value">{{ formatMoney(userInfo.money) }}</text>
          <text class="asset-label">余额</text>
        </view>
        <view class="asset-divider"></view>
        <view class="asset-item">
          <text class="asset-value">{{ userInfo.score || 0 }}</text>
          <text class="asset-label">积分</text>
        </view>
        <view class="asset-divider"></view>
        <view class="asset-item">
          <text class="asset-value">Lv.{{ userInfo.level || 1 }}</text>
          <text class="asset-label">等级</text>
        </view>
      </view>
    </view>

    <!-- 功能菜单 -->
    <view class="menu-group">
      <view class="menu-title">常用功能</view>
      <view class="menu-list">
        <view class="menu-item" v-for="item in menuList" :key="item.id" @tap="handleMenu(item)">
          <text class="menu-icon">{{ item.icon }}</text>
          <text class="menu-text">{{ item.label }}</text>
          <text class="menu-arrow">›</text>
        </view>
      </view>
    </view>

    <!-- 退出登录 -->
    <view class="logout-area" v-if="isLoggedIn">
      <button class="logout-btn" @tap="handleLogout">退出登录</button>
    </view>
  </view>
</template>

<script>
import { useUserStore } from '@/store/user'

export default {
  data() {
    return {
      menuList: [
        { id: 'profile', icon: '👤', label: '个人资料' },
        { id: 'security', icon: '🔒', label: '账号安全' },
        { id: 'about', icon: 'ℹ️', label: '关于我们' },
      ],
    }
  },
  computed: {
    isLoggedIn() {
      return useUserStore().isLoggedIn.value
    },
    userInfo() {
      return useUserStore().userInfo.value
    },
    avatarUrl() {
      const info = this.userInfo
      if (info) {
        return info.avatar || info.wxAvatar || '/static/logo.png'
      }
      return '/static/logo.png'
    },
  },
  onShow() {
    const store = useUserStore()
    if (store.isLoggedIn.value) {
      store.fetchProfile()
    }
  },
  methods: {
    handleCardTap() {
      if (!this.isLoggedIn) {
        uni.navigateTo({ url: '/pages/login/index' })
      }
    },
    handleMenu(item) {
      if (!this.isLoggedIn) {
        uni.navigateTo({ url: '/pages/login/index' })
        return
      }
      uni.showToast({ title: item.label, icon: 'none' })
    },
    handleLogout() {
      uni.showModal({
        title: '提示',
        content: '确定退出登录吗？',
        success: (res) => {
          if (res.confirm) {
            useUserStore().logout()
          }
        },
      })
    },
    formatMoney(val) {
      if (!val && val !== 0) return '0.00'
      return Number(val).toFixed(2)
    },
  },
}
</script>

<style scoped>
.user-page {
  min-height: 100vh;
  background: #f5f5f5;
}

.user-card {
  margin: 24rpx;
  padding: 40rpx 32rpx;
  background: linear-gradient(135deg, #4C84FF 0%, #6a9cff 100%);
  border-radius: 24rpx;
  color: #fff;
}

.user-header {
  display: flex;
  align-items: center;
}

.avatar {
  width: 120rpx;
  height: 120rpx;
  border-radius: 60rpx;
  border: 4rpx solid rgba(255, 255, 255, 0.5);
  background: #fff;
}

.user-meta {
  flex: 1;
  margin-left: 28rpx;
}

.nickname {
  font-size: 36rpx;
  font-weight: 700;
}

.login-hint {
  opacity: 0.9;
}

.sub-text {
  font-size: 24rpx;
  opacity: 0.7;
  margin-top: 8rpx;
}

.user-tags {
  display: flex;
  margin-top: 12rpx;
  gap: 12rpx;
}

.tag {
  font-size: 22rpx;
  padding: 4rpx 16rpx;
  border-radius: 20rpx;
  background: rgba(255, 255, 255, 0.2);
}

.arrow {
  font-size: 40rpx;
  opacity: 0.6;
}

.asset-bar {
  display: flex;
  margin-top: 36rpx;
  padding-top: 28rpx;
  border-top: 1rpx solid rgba(255, 255, 255, 0.2);
}

.asset-item {
  flex: 1;
  text-align: center;
}

.asset-value {
  font-size: 36rpx;
  font-weight: 700;
}

.asset-label {
  font-size: 22rpx;
  opacity: 0.7;
  margin-top: 8rpx;
  display: block;
}

.asset-divider {
  width: 1rpx;
  background: rgba(255, 255, 255, 0.2);
}

.menu-group {
  margin: 24rpx;
}

.menu-title {
  font-size: 28rpx;
  font-weight: 600;
  color: #333;
  margin-bottom: 16rpx;
  padding-left: 8rpx;
}

.menu-list {
  background: #fff;
  border-radius: 16rpx;
  overflow: hidden;
}

.menu-item {
  display: flex;
  align-items: center;
  padding: 32rpx;
  border-bottom: 1rpx solid #f0f0f0;
}

.menu-item:last-child {
  border-bottom: none;
}

.menu-item:active {
  background: #f8f8f8;
}

.menu-icon {
  font-size: 40rpx;
  margin-right: 20rpx;
}

.menu-text {
  flex: 1;
  font-size: 30rpx;
  color: #333;
}

.menu-arrow {
  font-size: 32rpx;
  color: #ccc;
}

.logout-area {
  padding: 48rpx 24rpx;
}

.logout-btn {
  width: 100%;
  height: 88rpx;
  line-height: 88rpx;
  text-align: center;
  font-size: 30rpx;
  color: #ff4d4f;
  background: #fff;
  border-radius: 16rpx;
  border: none;
}

.logout-btn::after {
  border: none;
}

.logout-btn:active {
  background: #f8f8f8;
}
</style>
