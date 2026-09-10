<!-- 登录日志 详情页（全屏） -->
<template>
  <div class="member-login-log-detail art-full-height">
    <ElCard shadow="never" class="art-table-card">
      <template #header>
        <div class="flex items-center justify-between">
          <span class="font-bold text-lg">登录日志详情</span>
          <ElButton @click="goBack">
            <ArtSvgIcon icon="ri:arrow-left-line" class="text-sm mr-1" />
            返回列表
          </ElButton>
        </div>
      </template>

      <div v-if="loading" class="flex justify-center py-20">
        <ElIcon class="is-loading" :size="32"><Loading /></ElIcon>
      </div>

      <ElDescriptions v-else-if="detail" :column="2" border class="detail-descriptions">
        <ElDescriptionsItem label="ID">{{ detail.id ?? '-' }}</ElDescriptionsItem>
        <ElDescriptionsItem label="会员ID">{{ detail.memberId ?? '-' }}</ElDescriptionsItem>
        <ElDescriptionsItem label="用户名">{{ detail.username ?? '-' }}</ElDescriptionsItem>
        <ElDescriptionsItem label="登录IP">
          <ElTag size="small">{{ detail.ip ?? '-' }}</ElTag>
        </ElDescriptionsItem>
        <ElDescriptionsItem label="User-Agent">{{ detail.userAgent ?? '-' }}</ElDescriptionsItem>
        <ElDescriptionsItem label="状态">
          <ElTag :type="detail.status === 1 ? 'success' : 'danger'" size="small">{{ detail.status === 1 ? '成功' : '失败' }}</ElTag>
        </ElDescriptionsItem>
        <ElDescriptionsItem label="提示信息">{{ detail.message ?? '-' }}</ElDescriptionsItem>
        <ElDescriptionsItem label="登录时间">{{ formatTimestamp(detail.createdAt) }}</ElDescriptionsItem>
      </ElDescriptions>

      <div v-else class="py-20 text-center text-gray-400">
        数据加载失败
      </div>
    </ElCard>
  </div>
</template>

<script setup lang="ts">
  import { Loading } from '@element-plus/icons-vue'
  import ArtSvgIcon from '@/components/core/base/art-svg-icon/index.vue'
  import { fetchMemberLoginLogView } from '@/api/backend/member/member-login-log'
  import { useRoute, useRouter } from 'vue-router'
  import { formatTimestamp } from '@/utils/time'

  defineOptions({ name: 'MemberLoginLogDetail' })

  const route = useRoute()
  const router = useRouter()
  const loading = ref(false)
  const detail = ref<Record<string, any> | null>(null)

  const goBack = () => {
    router.back()
  }

  onMounted(async () => {
    const id = Number(route.query.id || route.params.id)
    if (!id) return
    loading.value = true
    try {
      detail.value = await fetchMemberLoginLogView(id) as any
    } catch { detail.value = null }
    loading.value = false
  })
</script>

<style scoped>
  .detail-descriptions {
    :deep(.el-descriptions__label) {
      width: 140px;
      font-weight: 600;
    }
  }
</style>
