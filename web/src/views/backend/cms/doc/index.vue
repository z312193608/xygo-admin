<!-- +----------------------------------------------------------------------
  | XYGo Admin [ Vue3 + GoFrame 企业级中后台管理系统 ]
  +----------------------------------------------------------------------
  | Copyright (c) 2026 大连星韵网络科技有限公司 All rights reserved.
  +----------------------------------------------------------------------
  | Licensed ( https://opensource.org/licenses/MIT )
  +----------------------------------------------------------------------
  | Author: 喜羊羊 <751300685@qq.com>
  +---------------------------------------------------------------------- -->
<!-- 文档内容管理页面 -->
<template>
  <div class="doc-page art-full-height">
    <!-- 搜索栏 -->
    <ElCard class="art-search-card" shadow="never">
      <ElForm :model="searchForm" inline>
        <ElFormItem label="文档标题">
          <ElInput v-model="searchForm.title" placeholder="请输入标题" clearable @keyup.enter="handleSearch" />
        </ElFormItem>
        <ElFormItem label="分类">
          <ElTreeSelect
            v-model="searchForm.categoryId"
            :data="categoryTree"
            :props="{ label: 'title', value: 'id', children: 'children' }"
            placeholder="全部分类"
            clearable
            check-strictly
            style="width: 200px"
          />
        </ElFormItem>
        <ElFormItem label="状态">
          <ElSelect v-model="searchForm.status" placeholder="全部" clearable style="width: 120px">
            <ElOption label="已发布" :value="1" />
            <ElOption label="草稿" :value="2" />
            <ElOption label="下架" :value="3" />
          </ElSelect>
        </ElFormItem>
        <ElFormItem>
          <ElButton type="primary" @click="handleSearch" v-ripple>搜索</ElButton>
          <ElButton @click="handleReset" v-ripple>重置</ElButton>
        </ElFormItem>
      </ElForm>
    </ElCard>

    <ElCard class="art-table-card" shadow="never">
      <ArtTableHeader :loading="loading" @refresh="loadData">
        <template #left>
          <ElButton type="primary" @click="handleAdd" v-ripple>新增文档</ElButton>
        </template>
      </ArtTableHeader>

      <ArtTable :loading="loading" :data="tableData">
        <ElTableColumn prop="title" label="标题" min-width="200" show-overflow-tooltip />
        <ElTableColumn prop="categoryName" label="分类" width="120" />
        <ElTableColumn prop="author" label="作者" width="100" />
        <ElTableColumn prop="views" label="浏览量" width="80" align="center" />
        <ElTableColumn prop="sort" label="排序" width="70" align="center" />
        <ElTableColumn prop="status" label="状态" width="80" align="center">
          <template #default="{ row }">
            <ElTag :type="statusMap[row.status]?.type" size="small">
              {{ statusMap[row.status]?.label }}
            </ElTag>
          </template>
        </ElTableColumn>
        <ElTableColumn prop="isTop" label="置顶" width="70" align="center">
          <template #default="{ row }">
            <ElTag v-if="row.isTop" type="warning" size="small">置顶</ElTag>
            <span v-else>-</span>
          </template>
        </ElTableColumn>
        <ElTableColumn label="操作" width="150" fixed="right">
          <template #default="{ row }">
            <ElButton link type="primary" size="small" @click="handleEdit(row)">编辑</ElButton>
            <ElPopconfirm title="确定删除该文档吗？" @confirm="handleDelete(row.id)">
              <template #reference>
                <ElButton link type="danger" size="small">删除</ElButton>
              </template>
            </ElPopconfirm>
          </template>
        </ElTableColumn>
      </ArtTable>

      <!-- 分页 -->
      <div class="art-pagination">
        <ElPagination
          v-model:current-page="searchForm.page"
          v-model:page-size="searchForm.pageSize"
          :total="total"
          :page-sizes="[10, 20, 50]"
          layout="total, sizes, prev, pager, next, jumper"
          @size-change="loadData"
          @current-change="loadData"
        />
      </div>
    </ElCard>

    <!-- 新增/编辑弹窗 -->
    <DocDialog
      ref="dialogRef"
      :category-tree="categoryTree"
      @submit="handleSubmit"
    />
  </div>
</template>

<script setup lang="ts">
  import { ref, reactive, onMounted } from 'vue'
  import { ElMessage } from 'element-plus'
  import { fetchDocList, fetchDocDetail, fetchSaveDoc, fetchDeleteDoc } from '@/api/backend/cms/doc'
  import { fetchDocCategoryList } from '@/api/backend/cms/doc-category'
  import DocDialog from './modules/doc-dialog.vue'

  const statusMap: Record<number, { label: string; type: 'success' | 'info' | 'danger' | 'primary' | 'warning' }> = {
    1: { label: '已发布', type: 'success' },
    2: { label: '草稿', type: 'info' },
    3: { label: '下架', type: 'danger' }
  }

  const loading = ref(false)
  const tableData = ref<any[]>([])
  const total = ref(0)
  const categoryTree = ref<any[]>([])
  const dialogRef = ref()

  const searchForm = reactive({
    title: '',
    categoryId: undefined as number | undefined,
    status: undefined as number | undefined,
    page: 1,
    pageSize: 20
  })

  const loadCategoryTree = async () => {
    categoryTree.value = await fetchDocCategoryList({ status: 1 })
  }

  const loadData = async () => {
    loading.value = true
    try {
      const res = await fetchDocList({ ...searchForm, status: searchForm.status ?? -1 })
      tableData.value = res?.list ?? []
      total.value = res?.total ?? 0
    } finally {
      loading.value = false
    }
  }

  const handleSearch = () => {
    searchForm.page = 1
    loadData()
  }

  const handleReset = () => {
    searchForm.title = ''
    searchForm.categoryId = undefined
    searchForm.status = undefined
    searchForm.page = 1
    loadData()
  }

  const handleAdd = () => {
    dialogRef.value?.open('add')
  }

  const handleEdit = async (row: any) => {
    const detail = await fetchDocDetail(row.id)
    dialogRef.value?.open('edit', { ...row, ...detail })
  }

  const handleSubmit = async (formData: any) => {
    await fetchSaveDoc(formData)
    ElMessage.success('保存成功')
    loadData()
  }

  const handleDelete = async (id: number) => {
    await fetchDeleteDoc(id)
    ElMessage.success('删除成功')
    loadData()
  }

  onMounted(() => {
    loadCategoryTree()
    loadData()
  })
</script>
