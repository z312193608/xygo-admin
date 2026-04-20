<!-- {{.TableComment}}管理(树表) -->
<template>
  <div class="{{.CssClass}}-page art-full-height">
{{- if .QueryColumns}}
    <!-- 搜索栏 -->
    <{{.VarName}}Search v-model="searchForm" @search="handleSearch" @reset="handleReset" />
{{- end}}

    <ElCard class="art-table-card" shadow="never">
      <!-- 表格头部 -->
      <ArtTableHeader
        :showZebra="false"
        :loading="loading"
        v-model:columns="columnChecks"
        @refresh="fetchData"
      >
        <template #left>
          <ElSpace wrap>
            <ElButton @click="showDialog('add')" v-ripple>新增</ElButton>
            <ElButton @click="toggleExpand" v-ripple type="info" plain>
              {{"{{ isExpanded ? '全部收起' : '全部展开' }}"}}
            </ElButton>
          </ElSpace>
        </template>
      </ArtTableHeader>

      <ArtTable
        ref="tableRef"
        rowKey="{{.PkTsName}}"
        :loading="loading"
        :columns="columns"
        :data="tableData"
        :stripe="false"
        :tree-props="{ children: 'children', hasChildren: 'hasChildren' }"
        :default-expand-all="false"
      />

      <!-- 弹窗 -->
      <{{.VarName}}Dialog
        v-model:visible="dialogVisible"
        :type="dialogType"
        :edit-data="currentRow"
        :tree-data="tableData"
        @submit="handleSubmit"
      />
    </ElCard>
  </div>
</template>

<script setup lang="ts">
  import ArtButtonTable from '@/components/core/forms/art-button-table/index.vue'
  import ArtSvgIcon from '@/components/core/base/art-svg-icon/index.vue'
  import { useTableColumns } from '@/hooks/core/useTableColumns'
  import { formatTimestamp } from '@/utils/time'
  import { fetch{{.VarName}}List, fetch{{.VarName}}Edit, fetch{{.VarName}}Delete } from '@/api/backend/{{.ModulePath}}'
{{- if .QueryColumns}}
  import {{.VarName}}Search from './modules/{{.FilePrefix}}-search.vue'
{{- end}}
  import {{.VarName}}Dialog from './modules/{{.FilePrefix}}-dialog.vue'
  import { ElTag, ElImage, ElButton, ElMessageBox } from 'element-plus'

  defineOptions({ name: '{{.VarName}}' })

  const loading = ref(false)
  const isExpanded = ref(false)
  const tableRef = ref()
  const tableData = ref<any[]>([])

  const dialogVisible = ref(false)
  const dialogType = ref<'add' | 'edit'>('add')
  const currentRow = ref<any>({})

{{- if .QueryColumns}}
  const searchForm = ref({
{{- range .QueryColumns}}
{{- if eq .QueryType "between"}}
{{- if or (eq .DesignType "date") (eq .DesignType "datetime") (eq .DesignType "timestamp") (eq .DesignType "time") (eq .FormType "date") (eq .FormType "datetime")}}
    {{.TsName}}Range: [],
{{- else}}
    {{.TsName}}Start: undefined,
    {{.TsName}}End: undefined,
{{- end}}
{{- else}}
    {{.TsName}}: undefined,
{{- end}}
{{- end}}
  })
{{- end}}

  const { columns, columnChecks } = useTableColumns(() => [
{{- range .ListColumns}}
{{- if or (eq .Render "switch") (and (eq .Render "") (eq .DesignType "switch"))}}
    {
      prop: '{{.TsName}}',
      label: '{{.Label}}',
      width: 100,
      align: 'center',
      formatter: (row: any) =>
        h(ElTag, { type: row.{{.TsName}} === 1 ? 'success' : 'danger', size: 'small' },
          () => row.{{.TsName}} === 1 ? '启用' : '禁用')
    },
{{- else if or (eq .Render "image") (and (eq .Render "") (eq .DesignType "image"))}}
    {
      prop: '{{.TsName}}',
      label: '{{.Label}}',
      width: 80,
      align: 'center',
      formatter: (row: any) =>
        row.{{.TsName}} ? h(ElImage, { src: row.{{.TsName}}, style: 'width:40px;height:40px', fit: 'cover', previewSrcList: [row.{{.TsName}}], previewTeleported: true }) : '-'
    },
{{- else if or (eq .Render "images") (and (eq .Render "") (eq .DesignType "images"))}}
    {
      prop: '{{.TsName}}',
      label: '{{.Label}}',
      width: 100,
      align: 'center',
      formatter: (row: any) => {
        const imgs = Array.isArray(row.{{.TsName}}) ? row.{{.TsName}} : (row.{{.TsName}} || '').split(',').filter(Boolean)
        if (!imgs.length) return '-'
        return h('div', { style: 'display:flex;align-items:center;gap:2px' }, [
          h(ElImage, { src: imgs[0], style: 'width:40px;height:40px', fit: 'cover', previewSrcList: imgs, previewTeleported: true }),
          imgs.length > 1 ? h('span', { style: 'font-size:12px;color:#999' }, `+${imgs.length - 1}`) : null
        ])
      }
    },
{{- else if or (eq .Render "color") (and (eq .Render "") (eq .DesignType "color"))}}
    {
      prop: '{{.TsName}}',
      label: '{{.Label}}',
      width: 80,
      align: 'center',
      formatter: (row: any) =>
        row.{{.TsName}} ? h('span', { style: `display:inline-block;width:20px;height:20px;border-radius:4px;background:${row.{{.TsName}}}` }) : '-'
    },
{{- else if or (eq .Render "icon") (and (eq .Render "") (eq .DesignType "icon"))}}
    {
      prop: '{{.TsName}}',
      label: '{{.Label}}',
      width: 80,
      align: 'center',
      formatter: (row: any) =>
        row.{{.TsName}} ? h(ArtSvgIcon, { icon: row.{{.TsName}}, class: 'text-lg' }) : '-'
    },
{{- else if or (eq .Render "tag") (and (eq .Render "") (or (eq .DesignType "radio") (eq .DesignType "select")))}}
    {
      prop: '{{.TsName}}',
      label: '{{.Label}}',
      width: 100,
      align: 'center',
{{- if .RadioOptions}}
      formatter: (row: any) => {
        const map: Record<string, [string, string]> = { {{range .RadioOptions}}'{{.Value}}': ['{{.Label}}', '{{.TagType}}'], {{end}} }
        const m = map[String(row.{{.TsName}})]
        return m ? h(ElTag, { type: m[1] as any, size: 'small' }, () => m[0]) : h(ElTag, { size: 'small' }, () => String(row.{{.TsName}} ?? '-'))
      }
{{- else}}
      formatter: (row: any) => h(ElTag, { size: 'small' }, () => String(row.{{.TsName}} ?? '-'))
{{- end}}
    },
{{- else if or (eq .Render "url") (and (eq .Render "") (eq .DesignType "file"))}}
    {
      prop: '{{.TsName}}',
      label: '{{.Label}}',
      minWidth: 120,
      formatter: (row: any) => row.{{.TsName}} ? h('a', { href: row.{{.TsName}}, target: '_blank', style: 'color:var(--el-color-primary)' }, '查看文件') : '-'
    },
{{- else if and (eq .Render "") (eq .DesignType "files")}}
    {
      prop: '{{.TsName}}',
      label: '{{.Label}}',
      minWidth: 100,
      formatter: (row: any) => {
        const files = Array.isArray(row.{{.TsName}}) ? row.{{.TsName}} : (row.{{.TsName}} || '').split(',').filter(Boolean)
        return files.length ? `${files.length} 个文件` : '-'
      }
    },
{{- else if or (eq .DesignType "date") (eq .DesignType "time") (eq .DesignType "year")}}
    {
      prop: '{{.TsName}}',
      label: '{{.Label}}',
      width: {{if eq .DesignType "date"}}120{{else if eq .DesignType "time"}}100{{else}}80{{end}},
      formatter: (row: any) => formatTimestamp(row.{{.TsName}}, '{{.DesignType}}')
    },
{{- else if or (eq .Render "tags") (and (eq .Render "") (or (eq .DesignType "checkbox") (eq .DesignType "selects")))}}
    {
      prop: '{{.TsName}}',
      label: '{{.Label}}',
      minWidth: 120,
{{- if .HasOptions}}
      formatter: (row: any) => {
        const map: Record<string, string> = { {{range .Options}}'{{.Value}}': '{{.Label}}', {{end}} }
        const vals = Array.isArray(row.{{.TsName}}) ? row.{{.TsName}} : String(row.{{.TsName}} ?? '').split(',').filter(Boolean)
        return vals.length ? h('div', { style: 'display:flex;gap:4px;flex-wrap:wrap' }, vals.map((v: string) => h(ElTag, { size: 'small' }, () => map[v] || v))) : '-'
      }
{{- else}} 
      formatter: (row: any) => {
        const vals = Array.isArray(row.{{.TsName}}) ? row.{{.TsName}} : String(row.{{.TsName}} ?? '').split(',').filter(Boolean)
        return vals.join(', ') || '-'
      }
{{- end}}
    },
{{- else if or (eq .Render "datetime") (and (eq .Render "") (or (eq .DesignType "timestamp") (eq .DesignType "datetime")))}}
    {
      prop: '{{.TsName}}',
      label: '{{.Label}}',
      width: 180,
      formatter: (row: any) => formatTimestamp(row.{{.TsName}})
    },
{{- else}}
    {
      prop: '{{.TsName}}',
      label: '{{.Label}}',
      {{- if .MinWidth}}minWidth: {{.MinWidth}},{{end}}
      formatter: (row: any) => row.{{.TsName}} ?? '-'
    },
{{- end}}
{{- end}}
    {
      prop: 'operation',
      label: '操作',
      width: 220,
      fixed: 'right',
      formatter: (row: any) =>
        h('div', { class: 'flex items-center gap-1' }, [
          h(ArtButtonTable, { type: 'edit', onClick: () => showDialog('edit', row) }),
          h(ArtButtonTable, { type: 'delete', onClick: () => handleDelete(row) }),
          h(ElButton, {
            size: 'small', link: true, type: 'primary',
            onClick: () => showDialog('add', { {{.TreePidTsColumn}}: row.{{.PkTsName}} })
          }, () => '添加子项')
        ])
    }
  ])

  // 加载数据
  // 应用展开/收起状态到表格
  const applyExpandState = () => {
    nextTick(() => {
      if (tableRef.value?.elTableRef && tableData.value) {
        const processRows = (rows: any[]) => {
          rows.forEach((row: any) => {
            if (row.children?.length) {
              tableRef.value.elTableRef.toggleRowExpansion(row, isExpanded.value)
              processRows(row.children)
            }
          })
        }
        processRows(tableData.value)
      }
    })
  }

  const fetchData = async (params?: Record<string, any>) => {
    loading.value = true
    try {
      const res = await fetch{{.VarName}}List(params || {})
      tableData.value = buildTree(res.list || [], '{{.PkTsName}}', '{{.TreePidTsColumn}}')
      // 数据加载后保持当前展开/收起状态
      applyExpandState()
    } finally {
      loading.value = false
    }
  }

  // 构建树
  const buildTree = (list: any[], idKey: string, pidKey: string, pid: any = 0): any[] => {
    return list
      .filter(item => item[pidKey] === pid || item[pidKey] === String(pid))
      .map(item => {
        const children = buildTree(list, idKey, pidKey, item[idKey])
        return children.length ? { ...item, children } : { ...item }
      })
  }

  const toggleExpand = () => {
    isExpanded.value = !isExpanded.value
    applyExpandState()
  }

  const showDialog = (type: 'add' | 'edit', row?: any) => {
    dialogType.value = type
    currentRow.value = row || {}
    nextTick(() => { dialogVisible.value = true })
  }

  const handleDelete = async (row: any) => {
    try {
      await ElMessageBox.confirm('确定删除该记录吗？', '删除确认', {
        confirmButtonText: '确定', cancelButtonText: '取消', type: 'warning'
      })
      await fetch{{.VarName}}Delete(row.{{.PkTsName}})
      ElMessage.success('删除成功')
      fetchData()
    } catch (e) { if (e !== 'cancel') console.error(e) }
  }

  const handleSubmit = async (formData: any) => {
    try {
      await fetch{{.VarName}}Edit(formData)
      ElMessage.success('操作成功')
      dialogVisible.value = false
      fetchData()
    } catch (e) { console.error(e) }
  }

{{- if .QueryColumns}}
  const handleSearch = (params: Record<string, any>) => {
    // 过滤空值
    const clean: Record<string, any> = {}
    for (const [k, v] of Object.entries(params)) {
      if (v !== undefined && v !== null && v !== '') clean[k] = v
    }
    fetchData(Object.keys(clean).length ? clean : undefined)
  }
  const handleReset = () => fetchData()
{{- end}}

  onMounted(() => fetchData())
</script>
