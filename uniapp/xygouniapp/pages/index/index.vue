<template>
  <view class="home-page">
    <view class="banner">
      <view class="banner-content">
        <text class="banner-title">XYGo Admin</text>
        <text class="banner-desc">Vue3 + GoFrame 企业级中后台管理系统</text>
      </view>
    </view>

    <view class="grid-section">
      <view class="section-title">功能导航</view>
      <view class="grid">
        <view class="grid-item" v-for="item in features" :key="item.id" @tap="handleFeature(item)">
          <view class="grid-icon" :style="{ background: item.color }">
            <text class="icon-text">{{ item.icon }}</text>
          </view>
          <text class="grid-label">{{ item.label }}</text>
        </view>
      </view>
    </view>

    <view class="about-section">
      <view class="section-title">技术栈</view>
      <view class="tech-list">
        <view class="tech-item" v-for="tech in techStack" :key="tech">
          <text class="tech-dot"></text>
          <text class="tech-text">{{ tech }}</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      features: [
        { id: 'login', icon: '🔐', label: '登录', color: '#e8f5e9', path: '/pages/login/index' },
        { id: 'user', icon: '👤', label: '我的', color: '#e3f2fd', tab: '/pages/user/index' },
        { id: 'doc', icon: '📖', label: '文档', color: '#fff3e0', url: 'https://www.xygoadmin.com/docs' },
        { id: 'github', icon: '⭐', label: '开源', color: '#f3e5f5', url: 'https://gitee.com/nickcxf/xygoadmin-open' },
      ],
      techStack: [
        'GoFrame v2 + Vue3 + Element Plus',
        'UniApp (小程序 / H5 / App)',
        'MySQL / PostgreSQL 双驱动',
        'Redis 缓存 + 消息队列',
        'JWT 认证 + WebSocket 即时通讯',
      ],
    }
  },
  methods: {
    handleFeature(item) {
      if (item.tab) {
        uni.switchTab({ url: item.tab })
      } else if (item.path) {
        uni.navigateTo({ url: item.path })
      } else if (item.url) {
        // #ifdef H5
        window.open(item.url, '_blank')
        // #endif
        // #ifndef H5
        uni.setClipboardData({
          data: item.url,
          success: () => uni.showToast({ title: '链接已复制', icon: 'success' }),
        })
        // #endif
      }
    },
  },
}
</script>

<style scoped>
.home-page {
  min-height: 100vh;
  background: #f5f5f5;
}

.banner {
  background: linear-gradient(135deg, #4C84FF 0%, #6a9cff 100%);
  padding: 60rpx 40rpx 80rpx;
  border-radius: 0 0 40rpx 40rpx;
}

.banner-title {
  font-size: 48rpx;
  font-weight: 800;
  color: #fff;
}

.banner-desc {
  font-size: 26rpx;
  color: rgba(255, 255, 255, 0.8);
  margin-top: 12rpx;
  display: block;
}

.grid-section {
  margin: -30rpx 24rpx 0;
  position: relative;
  z-index: 1;
}

.section-title {
  font-size: 30rpx;
  font-weight: 600;
  color: #333;
  margin-bottom: 20rpx;
  padding-left: 8rpx;
  margin-top: 24rpx;
}

.grid {
  display: flex;
  flex-wrap: wrap;
  background: #fff;
  border-radius: 20rpx;
  padding: 16rpx;
}

.grid-item {
  width: 25%;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 24rpx 0;
}

.grid-item:active {
  opacity: 0.7;
}

.grid-icon {
  width: 96rpx;
  height: 96rpx;
  border-radius: 24rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.icon-text {
  font-size: 44rpx;
}

.grid-label {
  font-size: 24rpx;
  color: #666;
  margin-top: 12rpx;
}

.about-section {
  margin: 0 24rpx 40rpx;
}

.tech-list {
  background: #fff;
  border-radius: 16rpx;
  padding: 24rpx 32rpx;
}

.tech-item {
  display: flex;
  align-items: center;
  padding: 16rpx 0;
}

.tech-dot {
  width: 12rpx;
  height: 12rpx;
  border-radius: 6rpx;
  background: #4C84FF;
  margin-right: 20rpx;
  flex-shrink: 0;
}

.tech-text {
  font-size: 26rpx;
  color: #666;
}
</style>
