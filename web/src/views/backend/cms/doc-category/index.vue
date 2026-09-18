<!-- +----------------------------------------------------------------------
  | XYGo Admin [ Vue3 + GoFrame 企业级中后台管理系统 ]
  +----------------------------------------------------------------------
  | Copyright (c) 2026 大连星韵网络科技有限公司 All rights reserved.
  +----------------------------------------------------------------------
  | Licensed ( https://opensource.org/licenses/MIT )
  +----------------------------------------------------------------------
  | Author: 喜羊羊 <751300685@qq.com>
  +---------------------------------------------------------------------- -->
<!-- 文档分类管理页面（树形 CRUD） -->
<template>
  <div class="doc-category-page art-full-height">
    <!-- 搜索栏 -->
    <ElCard class="art-search-card" shadow="never">
      <ElForm :model="searchForm" inline>
        <ElFormItem label="分类名称">
          <ElInput v-model="searchForm.title" placeholder="请输入分类名称" clearable @keyup.enter="handleSearch" />
        </ElFormItem>
        <ElFormItem label="状态">
          <ElSelect v-model="searchForm.status" placeholder="全部" clearable style="width: 120px">
            <ElOption label="正常" :value="1" />
            <ElOption label="禁用" :value="2" />
          </ElSelect>
        </ElFormItem>
        <ElFormItem>
          <ElButton type="primary" @click="handleSearch" v-ripple>搜索</ElButton>
          <ElButton @click="handleReset" v-ripple>重置</ElButton>
        </ElFormItem>
      </ElForm>
    </ElCard>

    <ElCard class="art-table-card" shadow="never">
      <ArtTableHeader :showZebra="false" :loading="loading" @refresh="loadData">
        <template #left>
          <ElButton @click="handleAdd()" v-ripple>添加分类</ElButton>
          <ElButton @click="toggleExpand" v-ripple type="primary">
            {{ isExpanded ? '收起' : '展开' }}
          </ElButton>
        </template>
      </ArtTableHeader>

      <ArtTable
        ref="tableRef"
        rowKey="id"
        :loading="loading"
        :data="tableData"
        :stripe="false"
        :tree-props="{ children: 'children', hasChildren: 'hasChildren' }"
        default-expand-all
      >
        <ElTableColumn prop="title" label="分类名称" min-width="200" />
        <ElTableColumn prop="icon" label="图标" width="80" align="center">
          <template #default="{ row }">
            <ArtSvgIcon v-if="row.icon" :icon="row.icon" :size="18" />
            <span v-else>-</span>
          </template>
        </ElTableColumn>
        <ElTableColumn prop="sort" label="排序" width="80" align="center" />
        <ElTableColumn prop="status" label="状态" width="80" align="center">
          <template #default="{ row }">
            <ElTag :type="row.status === 1 ? 'success' : 'danger'" size="small">
              {{ row.status === 1 ? '正常' : '禁用' }}
            </ElTag>
          </template>
        </ElTableColumn>
        <ElTableColumn prop="remark" label="备注" min-width="150" show-overflow-tooltip />
        <ElTableColumn label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <ElButton link type="primary" size="small" @click="handleAdd(row)">添加子分类</ElButton>
            <ElButton link type="primary" size="small" @click="handleEdit(row)">编辑</ElButton>
            <ElPopconfirm title="确定删除该分类吗？" @confirm="handleDelete(row.id)">
              <template #reference>
                <ElButton link type="danger" size="small">删除</ElButton>
              </template>
            </ElPopconfirm>
          </template>
        </ElTableColumn>
      </ArtTable>
    </ElCard>

    <!-- 新增/编辑弹窗 -->
    <DocCategoryDialog
      ref="dialogRef"
      :tree-data="tableData"
      @submit="handleSubmit"
    />
  </div>
</template>

<script setup lang="ts">
  import { ref, reactive, nextTick } from 'vue'
  import { ElMessage } from 'element-plus'
  import { fetchDocCategoryList, fetchSaveDocCategory, fetchDeleteDocCategory } from '@/api/backend/cms/doc-category'
  import DocCategoryDialog from './modules/doc-category-dialog.vue'

  const loading = ref(false)
  const tableData = ref<any[]>([])
  const tableRef = ref()
  const dialogRef = ref()
  const isExpanded = ref(true)

  const searchForm = reactive({ title: '', status: undefined as number | undefined })

  const loadData = async () => {
    loading.value = true
    try {
      tableData.value = await fetchDocCategoryList({ ...searchForm, status: searchForm.status ?? -1 })
    } finally {
      loading.value = false
    }
  }

  const handleSearch = () => loadData()
  const handleReset = () => {
    searchForm.title = ''
    searchForm.status = undefined
    loadData()
  }

  const handleAdd = (parent?: any) => {
    dialogRef.value?.open('add', parent ? { pid: parent.id } : {}, parent)
  }

  const handleEdit = (row: any) => {
    dialogRef.value?.open('edit', { ...row })
  }

  const handleSubmit = async (formData: any) => {
    await fetchSaveDocCategory(formData)
    ElMessage.success('保存成功')
    loadData()
  }

  const handleDelete = async (id: number) => {
    await fetchDeleteDocCategory(id)
    ElMessage.success('删除成功')
    loadData()
  }

  const toggleExpand = () => {
    isExpanded.value = !isExpanded.value
    nextTick(() => {
      if (tableRef.value?.elTableRef) {
        const processRows = (rows: any[]) => {
          rows.forEach((row: any) => {
            tableRef.value.elTableRef.toggleRowExpansion(row, isExpanded.value)
            if (row.children?.length) processRows(row.children)
          })
        }
        processRows(tableData.value)
      }
    })
  }

  loadData()
</script>
