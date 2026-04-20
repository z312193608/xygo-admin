<!-- {{.TableComment}}管理 -->
<template>
  <div class="{{.CssClass}}-page art-full-height">
    <!-- 搜索栏 -->
    <{{.VarName}}Search v-model="searchForm" @search="handleSearch" @reset="resetSearchParams" />

    <ElCard class="art-table-card" shadow="never">
      <!-- 表格头部 -->
      <ArtTableHeader v-model:columns="columnChecks" :loading="loading" @refresh="refreshData">
        <template #left>
          <ElSpace wrap>
{{- if .HasAdd}}
            <ElButton @click="showDialog('add')" v-ripple>新增</ElButton>
{{- end}}
{{- if .HasBatchDel}}
            <ElButton type="danger" :disabled="selectedRows.length === 0" @click="handleBatchDelete" v-ripple>批量删除</ElButton>
{{- end}}
{{- if .HasExport}}
            <ElButton @click="handleExport" v-ripple>导出</ElButton>
{{- end}}
          </ElSpace>
        </template>
      </ArtTableHeader>

      <!-- 表格 -->
      <ArtTable
        :loading="loading"
        :data="data"
        :columns="columns"
        :pagination="pagination"
{{- if .HasCheck}}
        @selection-change="handleSelectionChange"
{{- end}}
        @pagination:size-change="handleSizeChange"
        @pagination:current-change="handleCurrentChange"
      />

{{- if or .HasAdd .HasEdit}}
      <!-- 编辑弹窗 -->
      <{{.VarName}}Dialog
        v-model:visible="dialogVisible"
        :type="dialogType"
        :edit-data="currentRow"
        @submit="handleDialogSubmit"
      />
{{- end}}
{{- if and .HasView (eq .ViewMode "drawer")}}
      <!-- 详情抽屉 -->
      <{{.VarName}}DetailDrawer v-model="detailVisible" :view-id="detailId" />
{{- end}}
    </ElCard>
  </div>
</template>

<script setup lang="ts">
  import ArtButtonTable from '@/components/core/forms/art-button-table/index.vue'
  import ArtSvgIcon from '@/components/core/base/art-svg-icon/index.vue'
  import { useTable } from '@/hooks/core/useTable'
  import { formatTimestamp } from '@/utils/time'
  import { fetch{{.VarName}}List{{if or .HasAdd .HasEdit}}, fetch{{.VarName}}Edit{{end}}{{if or .HasDel .HasBatchDel}}, fetch{{.VarName}}Delete{{end}} } from '@/api/backend/{{.ModulePath}}'
  import {{.VarName}}Search from './modules/{{.FilePrefix}}-search.vue'
{{- if or .HasAdd .HasEdit}}
  import {{.VarName}}Dialog from './modules/{{.FilePrefix}}-dialog.vue'
{{- end}}
{{- if and .HasView (eq .ViewMode "drawer")}}
  import {{.VarName}}DetailDrawer from './modules/{{.FilePrefix}}-detail-drawer.vue'
{{- end}}
  import { ElTag, ElImage, ElMessageBox } from 'element-plus'
{{- if and .HasView (eq .ViewMode "page")}}
  import { useRouter } from 'vue-router'
{{- end}}
{{- if or .HasAdd .HasEdit}}
  import { DialogType } from '@/types'
{{- end}}

  defineOptions({ name: '{{.VarName}}' })
{{- if and .HasView (eq .ViewMode "page")}}
  const router = useRouter()
{{- end}}

{{- if or .HasAdd .HasEdit}}
  const dialogType = ref<DialogType>('add')
  const dialogVisible = ref(false)
  const currentRow = ref<any>({})
{{- end}}
{{- if and .HasView (eq .ViewMode "drawer")}}
  const detailVisible = ref(false)
  const detailId = ref<number>()
{{- end}}
{{- if .HasCheck}}
  const selectedRows = ref<any[]>([])
{{- end}}

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
{{- if .HasRelations}}
{{- range $rel := .Relations}}
{{- if $rel.FieldConfigs}}
{{- range $fc := $rel.FieldConfigs}}
{{- if $fc.InSearch}}
{{- if or (eq $fc.SearchComponent "daterange") (eq $fc.SearchComponent "datetimerange")}}
    {{$rel.RelationAlias}}_{{$fc.Field}}Range: [],
{{- else}}
    {{$rel.RelationAlias}}_{{$fc.Field}}: undefined,
{{- end}}
{{- end}}
{{- end}}
{{- else}}
{{- range $f := $rel.SearchFields}}
    {{$rel.RelationAlias}}_{{$f}}: undefined,
{{- end}}
{{- end}}
{{- end}}
{{- end}}
  })

  const {
    columns, columnChecks, data, loading, pagination,
    getData, searchParams, resetSearchParams,
    handleSizeChange, handleCurrentChange, refreshData
  } = useTable({
    core: {
      apiFn: fetch{{.VarName}}List,
      apiParams: {
        page: 1,
        pageSize: 20,
        ...searchForm.value
      },
      paginationKey: { current: 'page', size: 'pageSize' },
      columnsFactory: () => [
{{- if .HasCheck}}
        { type: 'selection' },
{{- end}}
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
            return vals.length ? h('div', { style: 'display:flex;gap:4px;flex-wrap:wrap' }, vals.map((v: string) => h(ElTag, { size: 'small' }, () => v))) : '-'
          }
{{- end}}
        },
{{- else if or (eq .Render "url") (and (eq .Render "") (eq .DesignType "file"))}}
        {
          prop: '{{.TsName}}',
          label: '{{.Label}}',
          minWidth: 120,
          formatter: (row: any) => row.{{.TsName}} ? h('a', { href: row.{{.TsName}}, target: '_blank', style: 'color:var(--el-color-primary)' }, row.{{.TsName}}) : '-'
        },
{{- else if or (eq .Render "datetime") (and (eq .Render "") (or (eq .DesignType "timestamp") (eq .DesignType "datetime")))}}
        {
          prop: '{{.TsName}}',
          label: '{{.Label}}',
          width: 180,
          formatter: (row: any) => formatTimestamp(row.{{.TsName}})
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
{{- else if and (eq .Render "") (or (eq .DesignType "date") (eq .DesignType "time") (eq .DesignType "year"))}}
        {
          prop: '{{.TsName}}',
          label: '{{.Label}}',
          width: {{if eq .DesignType "date"}}120{{else if eq .DesignType "time"}}100{{else}}80{{end}},
          formatter: (row: any) => formatTimestamp(row.{{.TsName}}, '{{.DesignType}}')
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
{{- if .HasRelations}}
        // ---- 关联表展示字段 ----
{{- range $rel := .Relations}}
{{- if not $rel.IsMultiple}}
{{- if $rel.FieldConfigs}}
{{- range $fc := $rel.FieldConfigs}}
{{- if $fc.InList}}
{{- if eq $fc.ListRender "tag"}}
        {
          prop: '{{$rel.RelationAlias}}_{{$fc.Field}}',
          label: '{{$fc.Label}}',
          width: 100,
          align: 'center',
          formatter: (row: any) => h(ElTag, { size: 'small' }, () => row.{{$rel.RelationAlias}}_{{$fc.Field}} ?? '-')
        },
{{- else if eq $fc.ListRender "image"}}
        {
          prop: '{{$rel.RelationAlias}}_{{$fc.Field}}',
          label: '{{$fc.Label}}',
          width: 80,
          align: 'center',
          formatter: (row: any) => row.{{$rel.RelationAlias}}_{{$fc.Field}} ? h(ElImage, { src: row.{{$rel.RelationAlias}}_{{$fc.Field}}, style: 'width:40px;height:40px', fit: 'cover', previewSrcList: [row.{{$rel.RelationAlias}}_{{$fc.Field}}], previewTeleported: true }) : '-'
        },
{{- else if eq $fc.ListRender "link"}}
        {
          prop: '{{$rel.RelationAlias}}_{{$fc.Field}}',
          label: '{{$fc.Label}}',
          minWidth: 120,
          formatter: (row: any) => row.{{$rel.RelationAlias}}_{{$fc.Field}} ? h('a', { href: row.{{$rel.RelationAlias}}_{{$fc.Field}}, target: '_blank', style: 'color:var(--el-color-primary)' }, row.{{$rel.RelationAlias}}_{{$fc.Field}}) : '-'
        },
{{- else if eq $fc.ListRender "datetime"}}
        {
          prop: '{{$rel.RelationAlias}}_{{$fc.Field}}',
          label: '{{$fc.Label}}',
          width: 180,
          formatter: (row: any) => formatTimestamp(row.{{$rel.RelationAlias}}_{{$fc.Field}})
        },
{{- else}}
        {
          prop: '{{$rel.RelationAlias}}_{{$fc.Field}}',
          label: '{{$fc.Label}}',
          formatter: (row: any) => {
            const v = row.{{$rel.RelationAlias}}_{{$fc.Field}}
            if (v === undefined || v === null) return '-'
            // 自动检测时间戳（大于 1e9 的数字）
            if (typeof v === 'number' && v > 1e9) return formatTimestamp(v)
            return String(v)
          }
        },
{{- end}}
{{- end}}
{{- end}}
{{- else}}
{{- range $f := $rel.RelationFields}}
        {
          prop: '{{$rel.RelationAlias}}_{{$f}}',
          label: '{{$rel.RelationName}}{{$f}}',
          formatter: (row: any) => {
            const v = row.{{$rel.RelationAlias}}_{{$f}}
            if (v === undefined || v === null) return '-'
            if (typeof v === 'number' && v > 1e9) return formatTimestamp(v)
            return String(v)
          }
        },
{{- end}}
{{- end}}
{{- end}}
{{- end}}
{{- end}}
{{- if or .HasEdit .HasDel .HasView}}
        {
          prop: 'operation',
          label: '操作',
          width: {{if and .HasEdit .HasDel .HasView}}220{{else if or (and .HasEdit .HasDel) (and .HasEdit .HasView) (and .HasDel .HasView)}}180{{else}}120{{end}},
          fixed: 'right',
          formatter: (row: any) =>
            h('div', { class: 'flex items-center gap-1' }, [
{{- if .HasView}}
              h(ArtButtonTable, { type: 'view', onClick: () => handleView(row) }),
{{- end}}
{{- if .HasEdit}}
              h(ArtButtonTable, { type: 'edit', onClick: () => showDialog('edit', row) }),
{{- end}}
{{- if .HasDel}}
              h(ArtButtonTable, { type: 'delete', onClick: () => handleDelete(row) })
{{- end}}
            ])
        }
{{- end}}
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

{{- if or .HasAdd .HasEdit}}

  const showDialog = (type: DialogType, row?: any) => {
    dialogType.value = type
    currentRow.value = row || {}
    nextTick(() => { dialogVisible.value = true })
  }
{{- end}}

{{- if .HasView}}

  const handleView = (row: any) => {
{{- if eq .ViewMode "page"}}
    router.push({ name: '{{.VarName}}Detail', query: { id: row.{{.PkTsName}} } })
{{- else}}
    detailId.value = row.{{.PkTsName}}
    detailVisible.value = true
{{- end}}
  }
{{- end}}

{{- if .HasDel}}

  const handleDelete = async (row: any) => {
    try {
      await ElMessageBox.confirm('确定要删除该记录吗？删除后无法恢复', '删除确认', {
        confirmButtonText: '确定', cancelButtonText: '取消', type: 'warning'
      })
      await fetch{{.VarName}}Delete(row.{{.PkTsName}})
      ElMessage.success('删除成功')
      refreshData()
    } catch (e) { if (e !== 'cancel') console.error(e) }
  }
{{- end}}

{{- if .HasBatchDel}}

  const handleBatchDelete = async () => {
    if (selectedRows.value.length === 0) return
    try {
      await ElMessageBox.confirm(`确定要删除选中的 ${selectedRows.value.length} 条记录吗？`, '批量删除', {
        confirmButtonText: '确定', cancelButtonText: '取消', type: 'warning'
      })
      for (const row of selectedRows.value) {
        await fetch{{.VarName}}Delete(row.{{.PkTsName}})
      }
      ElMessage.success('批量删除成功')
      selectedRows.value = []
      refreshData()
    } catch (e) { if (e !== 'cancel') console.error(e) }
  }
{{- end}}

{{- if .HasExport}}

  const handleExport = () => {
    ElMessage.info('导出功能开发中')
  }
{{- end}}

{{- if or .HasAdd .HasEdit}}

  const handleDialogSubmit = async (formData: any) => {
    try {
      await fetch{{.VarName}}Edit(formData)
      ElMessage.success(formData.{{.PkTsName}} ? '编辑成功' : '添加成功')
      dialogVisible.value = false
      refreshData()
    } catch (e) { console.error(e) }
  }
{{- end}}

{{- if .HasCheck}}

  const handleSelectionChange = (selection: any[]) => { selectedRows.value = selection }
{{- end}}
</script>
