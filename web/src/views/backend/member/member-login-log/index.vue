<!-- 登录日志管理 -->
<template>
  <div class="member-login-log-page art-full-height">
    <!-- 搜索栏 -->
    <MemberLoginLogSearch v-model="searchForm" @search="handleSearch" @reset="resetSearchParams" />

    <ElCard class="art-table-card" shadow="never">
      <!-- 表格头部 -->
      <ArtTableHeader v-model:columns="columnChecks" :loading="loading" @refresh="refreshData">
        <template #left>
          <ElSpace wrap>
            <ElButton v-auth="'batchDel'" type="danger" :disabled="selectedRows.length === 0" @click="handleBatchDelete" v-ripple>批量删除</ElButton>
            <ElButton v-auth="'export'" @click="handleExport" v-ripple>导出</ElButton>
          </ElSpace>
        </template>
      </ArtTableHeader>

      <!-- 表格 -->
      <ArtTable
        :loading="loading"
        :data="data"
        :columns="columns"
        :pagination="pagination"
        @selection-change="handleSelectionChange"
        @pagination:size-change="handleSizeChange"
        @pagination:current-change="handleCurrentChange"
      />
    </ElCard>
  </div>
</template>

<script setup lang="ts">
  import ArtButtonTable from '@/components/core/forms/art-button-table/index.vue'
  import ArtSvgIcon from '@/components/core/base/art-svg-icon/index.vue'
  import { useTable } from '@/hooks/core/useTable'
  import { useAuth } from '@/hooks/core/useAuth'
  import { fetchMemberLoginLogList, fetchMemberLoginLogDelete } from '@/api/backend/member/member-login-log'
  import MemberLoginLogSearch from './modules/member-login-log-search.vue'
  import { ElTag, ElImage, ElMessageBox } from 'element-plus'
  import { useRouter } from 'vue-router'
  import { formatTimestamp } from '@/utils/time'

  defineOptions({ name: 'MemberLoginLog' })
  const { hasAuth } = useAuth()
  const router = useRouter()
  const selectedRows = ref<any[]>([])

  const searchForm = ref({
    status: undefined,
    member_username: undefined,
  })

  const {
    columns, columnChecks, data, loading, pagination,
    getData, searchParams, resetSearchParams,
    handleSizeChange, handleCurrentChange, refreshData
  } = useTable({
    core: {
      apiFn: fetchMemberLoginLogList,
      apiParams: {
        page: 1,
        pageSize: 20,
        ...searchForm.value
      },
      paginationKey: { current: 'page', size: 'pageSize' },
      columnsFactory: () => [
        { type: 'selection' },
        {
          prop: 'id',
          label: 'ID',minWidth: 100,
          formatter: (row: any) => row.id ?? '-'
        },
        {
          prop: 'memberId',
          label: '会员ID',minWidth: 120,
          formatter: (row: any) => row.memberId ?? '-'
        },
        {
          prop: 'username',
          label: '用户名',minWidth: 120,
          formatter: (row: any) => row.username ?? '-'
        },
        {
          prop: 'ip',
          label: '登录IP',
          width: 100,
          align: 'center',
          formatter: (row: any) => h(ElTag, { size: 'small' }, () => String(row.ip ?? '-'))
        },
        {
          prop: 'userAgent',
          label: 'User-Agent',minWidth: 160,
          formatter: (row: any) => row.userAgent ?? '-'
        },
        {
          prop: 'status',
          label: '状态',
          width: 100,
          align: 'center',
          formatter: (row: any) => {
            const map: Record<string, [string, string]> = { '1': ['成功', 'success'], '0': ['失败', 'danger'] }
            const m = map[String(row.status)]
            return m ? h(ElTag, { type: m[1] as any, size: 'small' }, () => m[0]) : h(ElTag, { size: 'small' }, () => String(row.status ?? '-'))
          }
        },
        {
          prop: 'message',
          label: '提示信息',minWidth: 120,
          formatter: (row: any) => row.message ?? '-'
        },
        {
          prop: 'createdAt',
          label: '登录时间',
          width: 180,
          formatter: (row: any) => formatTimestamp(row.createdAt)
        },
        // ---- 关联表展示字段 ----
        {
          prop: 'member_username',
          label: '用户名',
          formatter: (row: any) => row.member_username ?? '-'
        },
        {
          prop: 'operation',
          label: '操作',
          width: 180,
          fixed: 'right',
          formatter: (row: any) =>
            h('div', { class: 'flex items-center gap-1' }, [
              hasAuth('view') ? h(ArtButtonTable, { type: 'view', onClick: () => handleView(row) }) : null,
              hasAuth('delete') ? h(ArtButtonTable, { type: 'delete', onClick: () => handleDelete(row) }) : null,
            ].filter(Boolean))
        }
      ]
    }
  })

  const handleSearch = (params: Record<string, any>) => {
    // 先清空旧搜索值（保留分页参数），再写入新值
    const paramsRecord = searchParams as Record<string, unknown>
    Object.keys(paramsRecord).forEach(key => {
      if (key !== 'page' && key !== 'pageSize') {
        delete paramsRecord[key]
      }
    })
    // 过滤掉空值，避免后端收到空字符串参数
    for (const [k, v] of Object.entries(params)) {
      if (v !== undefined && v !== null && v !== '') {
        paramsRecord[k] = v
      }
    }
    paramsRecord['page'] = 1 // 搜索时回到第一页
    getData()
  }

  const handleView = (row: any) => {
    router.push({ name: 'MemberLoginLogDetail', query: { id: row.id } })
  }

  const handleDelete = async (row: any) => {
    try {
      await ElMessageBox.confirm('确定要删除该记录吗？删除后无法恢复', '删除确认', {
        confirmButtonText: '确定', cancelButtonText: '取消', type: 'warning'
      })
      await fetchMemberLoginLogDelete(row.id)
      ElMessage.success('删除成功')
      refreshData()
    } catch (e) { if (e !== 'cancel') console.error(e) }
  }

  const handleBatchDelete = async () => {
    if (selectedRows.value.length === 0) return
    try {
      await ElMessageBox.confirm(`确定要删除选中的 ${selectedRows.value.length} 条记录吗？`, '批量删除', {
        confirmButtonText: '确定', cancelButtonText: '取消', type: 'warning'
      })
      for (const row of selectedRows.value) {
        await fetchMemberLoginLogDelete(row.id)
      }
      ElMessage.success('批量删除成功')
      selectedRows.value = []
      refreshData()
    } catch (e) { if (e !== 'cancel') console.error(e) }
  }

  const handleExport = () => {
    ElMessage.info('导出功能开发中')
  }

  const handleSelectionChange = (selection: any[]) => { selectedRows.value = selection }
</script>
