<!-- 通知管理页面 -->
<template>
  <div class="notice-page art-full-height">
    <!-- 搜索栏 -->
    <ArtSearchBar v-model="searchForm" :items="searchItems as any" @search="handleSearch" @reset="resetSearchParams" />

    <ElCard class="art-table-card" shadow="never">
      <ArtTableHeader v-model:columns="columnChecks" :loading="loading" @refresh="refreshData">
        <template #left>
          <ElButton v-auth="'add'" type="primary" @click="showDialog('add')" v-ripple>
            <ArtSvgIcon icon="ri:add-line" class="text-sm mr-1" />
            发布通知
          </ElButton>
        </template>
      </ArtTableHeader>

      <ArtTable
        :loading="loading"
        :data="data as any"
        :columns="columns"
        :pagination="pagination"
        @pagination:size-change="handleSizeChange"
        @pagination:current-change="handleCurrentChange"
      />
    </ElCard>

    <!-- 发布/编辑弹窗 -->
    <ElDialog v-model="dialogVisible" :title="dialogType === 'add' ? '发布通知' : '编辑通知'" width="640px" :close-on-click-modal="false" @close="resetForm">
      <ElForm ref="formRef" :model="formData" :rules="rules" label-width="80px">
        <ElFormItem label="标题" prop="title">
          <ElInput v-model="formData.title" placeholder="请输入通知标题" />
        </ElFormItem>
        <ElFormItem label="类型" prop="type">
          <ElRadioGroup v-model="formData.type">
            <ElRadio :value="1">通知</ElRadio>
            <ElRadio :value="2">公告</ElRadio>
            <ElRadio :value="3">私信</ElRadio>
          </ElRadioGroup>
        </ElFormItem>
        <ElFormItem label="标签">
          <ElSelect v-model="formData.tag" placeholder="选择标签颜色" clearable>
            <ElOption value="info" label="信息(蓝)" />
            <ElOption value="success" label="成功(绿)" />
            <ElOption value="warning" label="警告(橙)" />
            <ElOption value="danger" label="紧急(红)" />
          </ElSelect>
        </ElFormItem>
        <ElFormItem v-if="formData.type === 3" label="接收人" prop="receiverId">
          <ElSelect
            v-model="formData.receiverId"
            filterable
            remote
            :remote-method="searchAdminUsers"
            placeholder="搜索用户名 / 昵称"
            clearable
            :loading="userSearchLoading"
            style="width: 100%"
          >
            <ElOption
              v-for="u in userOptions"
              :key="u.id"
              :value="u.id"
              :label="`${u.nickname || u.username} (ID:${u.id})`"
            />
          </ElSelect>
        </ElFormItem>
        <ElFormItem label="内容" prop="content">
          <ElInput v-model="formData.content" type="textarea" :rows="6" placeholder="请输入通知内容" />
        </ElFormItem>
        <ElFormItem label="状态">
          <ElSwitch v-model="formData.status" :active-value="1" :inactive-value="2" active-text="正常" inactive-text="关闭" />
        </ElFormItem>
      </ElForm>
      <template #footer>
        <ElButton @click="dialogVisible = false">取消</ElButton>
        <ElButton type="primary" :loading="submitLoading" @click="handleSubmit">确定</ElButton>
      </template>
    </ElDialog>
  </div>
</template>

<script setup lang="ts">
  import { useTable } from '@/hooks/core/useTable'
  import { useAuth } from '@/hooks/core/useAuth'
  import { fetchNoticeList, fetchNoticeEdit, fetchNoticeDelete } from '@/api/backend/system/notice'
  import { fetchGetUserList } from '@/api/backend/system/user'
  import ArtButtonTable from '@/components/core/forms/art-button-table/index.vue'
  import ArtSvgIcon from '@/components/core/base/art-svg-icon/index.vue'
  import { ElTag, ElMessageBox } from 'element-plus'
  import type { FormInstance, FormRules } from 'element-plus'
  import { formatTimestamp } from '@/utils/time'

  defineOptions({ name: 'NoticeManage' })
  const { hasAuth } = useAuth()

  const searchForm = ref({ type: undefined, status: undefined })

  const searchItems = computed((): any[] => [
    {
      label: '类型', key: 'type', type: 'select',
      props: { clearable: true, placeholder: '全部类型' },
      options: [{ label: '通知', value: 1 }, { label: '公告', value: 2 }, { label: '私信', value: 3 }]
    },
    {
      label: '状态', key: 'status', type: 'select',
      props: { clearable: true, placeholder: '全部状态' },
      options: [{ label: '正常', value: 1 }, { label: '关闭', value: 2 }]
    }
  ])

  const { columns, columnChecks, data, loading, pagination, getData, searchParams, resetSearchParams, handleSizeChange, handleCurrentChange, refreshData } = useTable({
    core: {
      apiFn: fetchNoticeList,
      apiParams: { page: 1, pageSize: 20, ...searchForm.value },
      paginationKey: { current: 'page', size: 'pageSize' },
      columnsFactory: () => [
        { type: 'index', width: 60, label: '序号' },
        { prop: 'title', label: '标题', minWidth: 200, showOverflowTooltip: true },
        {
          prop: 'type', label: '类型', width: 90, align: 'center',
          formatter: (row: any) => {
            const m: Record<number, { label: string; type: any }> = {
              1: { label: '通知', type: 'primary' }, 2: { label: '公告', type: 'success' }, 3: { label: '私信', type: 'warning' }
            }
            const c = m[row.type] || { label: '未知', type: 'info' }
            return h(ElTag, { type: c.type, size: 'small', effect: 'light', round: true }, () => c.label)
          }
        },
        {
          prop: 'tag', label: '标签', width: 80, align: 'center',
          formatter: (row: any) => {
            if (!row.tag) return '-'
            return h(ElTag, { type: row.tag === 'danger' ? 'danger' : row.tag === 'warning' ? 'warning' : row.tag === 'success' ? 'success' : 'info', size: 'small', round: true }, () => row.tag)
          }
        },
        {
          prop: 'status', label: '状态', width: 80, align: 'center',
          formatter: (row: any) => h(ElTag, { type: row.status === 1 ? 'success' : 'danger', size: 'small' }, () => row.status === 1 ? '正常' : '关闭')
        },
        { prop: 'readCount', label: '已读', width: 70, align: 'center' },
        {
          prop: 'createdAt', label: '发布时间', width: 170,
          formatter: (row: any) => formatTimestamp(row.createdAt)
        },
        {
          prop: 'operation', label: '操作', width: 140, fixed: 'right',
          formatter: (row: any) => h('div', { class: 'flex items-center gap-1' }, [
            hasAuth('edit') ? h(ArtButtonTable, { type: 'edit', onClick: () => showDialog('edit', row) }) : null,
            hasAuth('delete') ? h(ArtButtonTable, { type: 'delete', onClick: () => handleDelete(row) }) : null,
          ].filter(Boolean))
        }
      ]
    }
  })

  const handleSearch = () => { Object.assign(searchParams, searchForm.value); getData() }

  // 弹窗
  const dialogVisible = ref(false)
  const dialogType = ref<'add' | 'edit'>('add')
  const formRef = ref<FormInstance>()
  const submitLoading = ref(false)

  const defaultForm = () => ({ id: 0, title: '', type: 1, content: '', tag: '', receiverId: null as number | null, status: 1, sort: 0, remark: '' })
  const formData = reactive(defaultForm())
  const rules: FormRules = {
    title: [{ required: true, message: '标题不能为空', trigger: 'blur' }],
    type: [{ required: true, message: '请选择类型', trigger: 'change' }],
  }

  // ==================== 接收人远程搜索 ====================
  const userOptions = ref<{ id: number; username: string; nickname: string }[]>([])
  const userSearchLoading = ref(false)

  const searchAdminUsers = async (query: string) => {
    userSearchLoading.value = true
    try {
      const res = await fetchGetUserList({ pageSize: 50, username: query || undefined })
      userOptions.value = (res.list || []).map((u: any) => ({ id: u.id, username: u.username, nickname: u.nickname }))
    } catch { /* ignore */ }
    userSearchLoading.value = false
  }

  const showDialog = (type: 'add' | 'edit', row?: any) => {
    dialogType.value = type
    if (type === 'edit' && row) {
      Object.assign(formData, row)
      if (row.type === 3 && row.receiverId) searchAdminUsers('')
    } else {
      Object.assign(formData, defaultForm())
    }
    dialogVisible.value = true
  }

  const resetForm = () => {
    formRef.value?.resetFields()
    Object.assign(formData, defaultForm())
  }

  const handleSubmit = async () => {
    if (!formRef.value) return
    await formRef.value.validate()
    submitLoading.value = true
    try {
      await fetchNoticeEdit({ ...formData, receiverId: formData.receiverId || 0 })
      ElMessage.success(dialogType.value === 'add' ? '发布成功' : '编辑成功')
      dialogVisible.value = false
      refreshData()
    } catch (e) { console.error(e) }
    submitLoading.value = false
  }

  const handleDelete = async (row: any) => {
    try {
      await ElMessageBox.confirm(`确定删除"${row.title}"？`, '删除确认', { type: 'warning' })
      await fetchNoticeDelete(row.id)
      ElMessage.success('删除成功')
      refreshData()
    } catch { /* cancel */ }
  }
</script>
