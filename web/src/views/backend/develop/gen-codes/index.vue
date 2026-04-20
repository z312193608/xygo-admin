<!-- +----------------------------------------------------------------------
  | XYGo Admin [ Vue3 + GoFrame 企业级中后台管理系统 ]
  +----------------------------------------------------------------------
  | Copyright (c) 2026 大连星韵网络科技有限公司 All rights reserved.
  +----------------------------------------------------------------------
  | Licensed ( https://opensource.org/licenses/MIT )
  +----------------------------------------------------------------------
  | Author: 喜羊羊 <751300685@qq.com>
  +---------------------------------------------------------------------- -->
<!-- 代码生成器 -->
<template>
  <div class="gen-codes-page art-full-height">
    <ElCard shadow="never" class="art-table-card">
      <!-- 步骤条 -->
      <div class="step-header">
        <ElSteps :active="activeStep" finish-status="success" align-center>
          <ElStep title="数据源" description="选择或创建数据表" />
          <ElStep title="基础配置" description="生成类型与路径" />
          <ElStep title="字段配置" description="字段属性与组件" />
          <ElStep title="预览生成" description="预览代码并生成" />
        </ElSteps>
      </div>

      <!-- 内容区域 -->
      <div class="step-body">
        <!-- Step 1: 数据源选择 -->
        <div v-show="activeStep === 0" class="step-content">
          <ElAlert type="warning" :closable="true" show-icon class="mb-4" style="max-width:800px;margin:0 auto 16px">
            <template #title>
              生成后需重启后端服务才能生效。若勾选了「生成前运行 gf gen dao」，请确保 <b>hack/config.yaml</b> 与 <b>manifest/config/config.yaml</b> 的数据库连接配置一致。
            </template>
          </ElAlert>
          <div class="source-cards">
            <div
              v-for="item in sourceOptions"
              :key="item.key"
              class="source-card"
              :class="{ active: sourceMode === item.key }"
              @click="sourceMode = item.key"
            >
              <div class="source-card__icon" :style="{ background: item.bg }">
                <ArtSvgIcon :icon="item.icon" class="text-2xl text-white" />
              </div>
              <h3 class="source-card__title">{{ item.title }}</h3>
              <p class="source-card__desc">{{ item.desc }}</p>
            </div>
          </div> 

          <!-- 选择已有表面板 -->
          <div v-if="sourceMode === 'existing'" class="source-panel">
            <ElSelect
              v-model="selectedTable"
              filterable
              placeholder="搜索并选择数据库表..."
              class="w-full"
              size="large"
              @change="handleTableSelect"
            >
              <ElOption
                v-for="t in tableList"
                :key="t.tableName"
                :label="`${t.tableName} — ${t.tableComment || '无注释'}`"
                :value="t.tableName"
              />
            </ElSelect>
            <div v-if="selectedTable" class="selected-info">
              <div class="info-tag"><span class="info-label">表名</span>{{ selectedTable }}</div>
              <div class="info-tag"><span class="info-label">注释</span>{{ selectedTableComment }}</div>
              <div class="info-tag"><span class="info-label">实体名</span>{{ formData.varName }}</div>
            </div>
          </div>

          <!-- 从零建表面板 -->
          <div v-if="sourceMode === 'create'" class="source-panel source-panel--wide">
            <CreateTableDesigner ref="tableDesignerRef" @created="handleTableCreated" />
          </div>

          <!-- 历史记录面板 -->
          <div v-if="sourceMode === 'history'" class="source-panel source-panel--wide">
            <HistoryList @select="handleHistorySelect" @deleted="loadTableList" />
          </div>
        </div>

        <!-- Step 2: 基础配置 -->
        <div v-show="activeStep === 1" class="step-content">
          <ElForm
            ref="basicFormRef"
            :model="formData"
            :rules="basicRules"
            label-width="120px"
            class="basic-form"
          >
            <ElFormItem label="数据表" prop="tableName">
              <ElInput v-model="formData.tableName" disabled />
            </ElFormItem>
            <ElFormItem label="表注释" prop="tableComment">
              <ElInput v-model="formData.tableComment" placeholder="用作菜单名和代码注释" />
            </ElFormItem>
            <ElFormItem label="实体名称" prop="varName">
              <ElInput v-model="formData.varName" placeholder="PascalCase，如 BizArticle">
                <template #append>
                  <ElTooltip content="自动从表名推断，可修改" placement="top">
                    <ArtSvgIcon icon="ri:question-line" class="text-sm" />
                  </ElTooltip>
                </template>
              </ElInput>
            </ElFormItem>
            <ElFormItem label="生成类型" prop="genType">
              <ElRadioGroup v-model="formData.genType">
                <ElRadioButton :value="10">普通列表</ElRadioButton>
                <ElRadioButton :value="11" :disabled="!hasParentIdColumn">树表</ElRadioButton>
              </ElRadioGroup>
              <span v-if="!hasParentIdColumn" class="ml-2 text-xs text-color-g-400">
                (表中无 parent_id 字段)
              </span>
            </ElFormItem>
            <template v-if="formData.genType === 11">
              <ElFormItem label="树标题字段">
                <ElSelect v-model="options.tree.titleColumn" placeholder="选择标题字段" class="w-full">
                  <ElOption v-for="col in formData.columns" :key="col.name" :label="`${col.name} (${col.comment})`" :value="col.name" />
                </ElSelect>
              </ElFormItem>
              <ElFormItem label="父ID字段">
                <ElSelect v-model="options.tree.pidColumn" placeholder="选择父ID字段" class="w-full">
                  <ElOption v-for="col in formData.columns" :key="col.name" :label="`${col.name} (${col.comment})`" :value="col.name" />
                </ElSelect>
              </ElFormItem>
            </template>
            <!-- ====== 生成选项（对齐 HotGo） ====== -->
            <ElDivider content-position="left">
              <span class="text-xs text-gray-500 font-medium">表格头部按钮</span>
            </ElDivider>
            <ElFormItem>
              <ElCheckboxGroup v-model="options.headOps">
                <ElCheckbox value="add" label="新增按钮" />
                <ElCheckbox value="batchDel" label="批量删除按钮" />
                <ElCheckbox value="export" label="导出按钮" />
              </ElCheckboxGroup>
            </ElFormItem>

            <ElDivider content-position="left">
              <span class="text-xs text-gray-500 font-medium">表格列操作</span>
            </ElDivider>
            <ElFormItem>
              <ElCheckboxGroup v-model="options.columnOps">
                <ElCheckbox value="edit" label="编辑" />
                <ElCheckbox value="status" label="状态修改" />
                <ElCheckbox value="del" label="删除" />
                <ElCheckbox value="view" label="详情页" />
                <ElCheckbox value="check" label="开启勾选列" />
              </ElCheckboxGroup>
            </ElFormItem>
            <ElFormItem v-if="options.columnOps.includes('view')" label="查看模式">
              <ElRadioGroup v-model="options.viewMode">
                <ElRadioButton value="drawer">抽屉</ElRadioButton>
                <ElRadioButton value="page">新标签页</ElRadioButton>
              </ElRadioGroup>
            </ElFormItem>

            <ElDivider content-position="left">
              <span class="text-xs text-gray-500 font-medium">高级设置</span>
            </ElDivider>
            <ElFormItem>
              <ElCheckboxGroup v-model="options.autoOps">
                <ElCheckbox value="genMenuPermissions" label="生成菜单权限" />
                <ElCheckbox value="runDao" label="生成前运行 [gf gen dao]" />
                <ElCheckbox value="runService" label="生成后运行 [gf gen service]" />
                <ElCheckbox value="forcedCover" label="强制覆盖" />
              </ElCheckboxGroup>
            </ElFormItem>

            <!-- ====== 菜单配置 ====== -->
            <ElFormItem label="上级菜单">
              <ElTreeSelect
                v-model="options.menu.pid"
                :data="menuTreeData"
                :props="{ label: 'title', value: 'id', children: 'children' }"
                placeholder="选择上级菜单（留空为顶级）"
                clearable
                check-strictly
                :render-after-expand="false"
                default-expand-all
                style="width: 100%"
              />
            </ElFormItem>
            <ElFormItem label="菜单图标">
              <ArtIconSelector v-model="options.menu.icon" clearable />
            </ElFormItem>
            <ElFormItem label="菜单排序">
              <ElInputNumber v-model="options.menu.sort" :min="0" :max="999" controls-position="right" />
            </ElFormItem>

            <!-- 高级配置：生成路径 -->
            <ElDivider content-position="left">
              <span class="text-xs text-gray-400 cursor-pointer" @click="showAdvanced = !showAdvanced">
                高级配置（生成路径）
                <ArtSvgIcon :icon="showAdvanced ? 'ri:arrow-up-s-line' : 'ri:arrow-down-s-line'" class="text-sm ml-0.5" />
              </span>
            </ElDivider>
            <template v-if="showAdvanced">
              <ElFormItem label="API路径">
                <ElInput :model-value="options.genPaths.api || effectivePaths.apiPath" @update:model-value="v => options.genPaths.api = v" />
              </ElFormItem>
              <ElFormItem label="控制器路径">
                <ElInput :model-value="options.genPaths.controller || effectivePaths.controllerPath" @update:model-value="v => options.genPaths.controller = v" />
              </ElFormItem>
              <ElFormItem label="Logic路径">
                <ElInput :model-value="options.genPaths.logic || effectivePaths.logicPath" @update:model-value="v => options.genPaths.logic = v" />
              </ElFormItem>
              <ElFormItem label="Input路径">
                <ElInput :model-value="options.genPaths.input || effectivePaths.inputPath" @update:model-value="v => options.genPaths.input = v" />
              </ElFormItem>
              <ElFormItem label="前端API路径">
                <ElInput :model-value="options.genPaths.webApi || effectivePaths.webApiPath" @update:model-value="v => options.genPaths.webApi = v" />
              </ElFormItem>
              <ElFormItem label="前端页面路径">
                <ElInput :model-value="options.genPaths.webIndex || effectivePaths.webViewsPath" @update:model-value="v => options.genPaths.webIndex = v" />
              </ElFormItem>
            </template>
          </ElForm>
        </div>

        <!-- Step 3: 字段配置 -->
        <div v-show="activeStep === 2" class="step-content step-content--full">
          <FieldConfigTable v-model="formData.columns" :selects="selectsData" :table-name="formData.tableName" />
        </div>

        <!-- Step 4: 预览生成 -->
        <div v-show="activeStep === 3" class="step-content step-content--full">
          <PreviewPanel
            ref="previewRef"
            :form-data="buildParams"
            @generated="handleGenerated"
          />
        </div>
      </div>

      <!-- 底部操作栏 -->
      <div class="step-footer">
        <ElButton v-if="activeStep > 0" @click="prevStep">
          <ArtSvgIcon icon="ri:arrow-left-line" class="text-sm mr-1" />
          上一步
        </ElButton>
        <div v-else />
        <ElTooltip
          v-if="activeStep < 3"
          :disabled="canNext"
          :content="nextStepTip"
          placement="top"
        >
          <ElButton type="primary" :disabled="!canNext" @click="nextStep">
            下一步
            <ArtSvgIcon icon="ri:arrow-right-line" class="text-sm ml-1" />
          </ElButton>
        </ElTooltip>
      </div>
    </ElCard>
  </div>
</template>

<script setup lang="ts">
  import { fetchGenCodesSelects, fetchGenCodesTableSelect, fetchGenCodesColumnList } from '@/api/backend/develop/genCodes'
  import { fetchGetMenuTree } from '@/api/backend/system/menu'
  import ArtSvgIcon from '@/components/core/base/art-svg-icon/index.vue'
  import ArtIconSelector from '@/components/core/forms/art-icon-selector/index.vue'
  import CreateTableDesigner from './modules/create-table-designer.vue'
  import HistoryList from './modules/history-list.vue'
  import FieldConfigTable from './modules/field-config-table.vue'
  import PreviewPanel from './modules/preview-panel.vue'
  import type { FormInstance, FormRules } from 'element-plus'

  defineOptions({ name: 'GenCodes' })

  const activeStep = ref(0)
  const sourceMode = ref<'existing' | 'create' | 'history'>('existing')
  const tableCreated = ref(false)
  const selectedTable = ref('')
  const selectedTableComment = ref('')
  const tableList = ref<any[]>([])
  const selectsData = ref<any>({})
  const basicFormRef = ref<FormInstance>()
  const previewRef = ref<any>()
  const showAdvanced = ref(false)
  const defaultPaths = ref<Record<string, string>>({})
  const menuTreeData = ref<any[]>([])

  // 根据上级菜单推导的前端路径（动态 placeholder）
  const inferredRouteName = computed(() => {
    if (!formData.varName) return ''
    const vn = formData.varName
    // camelToKebab
    return vn.replace(/([A-Z])/g, (m: string, p1: string, offset: number) => (offset ? '-' : '') + p1.toLowerCase())
  })

  const parentMenuPath = computed(() => {
    if (!options.menu.pid || options.menu.pid === 0) return ''
    // 从 menuTreeData 递归查找
    const find = (nodes: any[], id: number): string => {
      for (const n of nodes) {
        if (n.id === id) return (n.path || '').replace(/^\/+/, '')
        if (n.children) {
          const r = find(n.children, id)
          if (r !== '') return r
        }
      }
      return ''
    }
    return find(menuTreeData.value, options.menu.pid)
  })

  const effectivePaths = computed(() => {
    const base = defaultPaths.value
    const route = inferredRouteName.value
    const parent = parentMenuPath.value
    const modulePath = parent ? `${parent}/${route}` : route
    return {
      apiPath: base.apiPath || 'api/admin',
      controllerPath: base.controllerPath || 'internal/controller/admin',
      logicPath: base.logicPath || 'internal/logic',
      inputPath: base.inputPath || 'internal/model/input/adminin',
      webApiPath: `${base.webApiPath || '../newweb/src/api/backend'}/${modulePath}`,
      webViewsPath: `${base.webViewsPath || '../newweb/src/views/backend'}/${modulePath}`,
    }
  })

  type SourceMode = 'existing' | 'create' | 'history'

  const sourceOptions: { key: SourceMode; icon: string; title: string; desc: string; bg: string }[] = [
    { key: 'existing', icon: 'ri:database-2-line', title: '选择已有表', desc: '从数据库中选择表自动导入', bg: 'var(--el-color-primary)' },
    { key: 'create', icon: 'ri:add-circle-line', title: '从零建表', desc: '可视化设计表结构并创建', bg: 'var(--el-color-success)' },
    { key: 'history', icon: 'ri:history-line', title: '历史记录', desc: '查看并管理生成过的记录', bg: 'var(--el-color-warning)' }
  ]

  const formData = reactive({
    id: 0,
    genType: 10,
    dbName: '',
    tableName: '',
    tableComment: '',
    varName: '',
    options: '',
    columns: [] as any[]
  })

  const options = reactive({
    genType: 10,
    headOps: ['add', 'batchDel', 'export'] as string[],
    columnOps: ['edit', 'del', 'view', 'status', 'check'] as string[],
    autoOps: ['genMenuPermissions', 'runDao', 'runService'] as string[],
    viewMode: 'drawer' as string, // 查看模式：drawer(抽屉) | page(新标签页)
    apiPrefix: '',
    genPaths: {} as Record<string, string>,
    menu: { pid: 0, icon: 'ri:file-list-line', sort: 100 },
    tree: { titleColumn: 'name', pidColumn: 'parent_id' }
  })

  const basicRules = reactive<FormRules>({
    tableName: [{ required: true, message: '请选择数据表', trigger: 'change' }],
    tableComment: [{ required: true, message: '请输入表注释', trigger: 'blur' }],
    varName: [{ required: true, message: '请输入实体名称', trigger: 'blur' }]
  })

  const hasParentIdColumn = computed(() =>
    formData.columns.some((c: any) => c.name === 'parent_id' || c.name === 'pid')
  )

  const unconfiguredRemoteFields = computed(() => {
    return formData.columns.filter((col: any) =>
      (col.designType === 'remoteSelect' || col.designType === 'remoteSelects') &&
      !col._formProps?.['remote-table']
    )
  })

  const canNext = computed(() => {
    if (activeStep.value === 0) {
      if (sourceMode.value === 'create') return tableCreated.value
      if (sourceMode.value === 'history') return true
      return formData.tableName !== ''
    }
    if (activeStep.value === 1) {
      return !!(formData.tableName && formData.tableComment && formData.varName)
    }
    if (activeStep.value === 2) {
      return unconfiguredRemoteFields.value.length === 0
    }
    return true
  })

  const nextStepTip = computed(() => {
    if (activeStep.value === 0 && sourceMode.value === 'create' && !tableCreated.value) {
      return '请先点击「创建数据表」按钮'
    }
    if (activeStep.value === 2 && unconfiguredRemoteFields.value.length > 0) {
      const names = unconfiguredRemoteFields.value.map((c: any) => c.name).join('、')
      return `字段 [${names}] 为远程下拉类型，请先配置关联表`
    }
    return ''
  })

  const buildParams = computed(() => {
    // 序列化每个字段的 _formProps / _tableProps 到 extra JSON
    const columns = formData.columns.map((col: any) => {
      const c = { ...col }
      if (col._formProps || col._tableProps) {
        c.extra = JSON.stringify({
          _formProps: col._formProps || {},
          _tableProps: col._tableProps || {},
        })
      }
      // 移除运行时属性
      delete c._formProps
      delete c._tableProps
      return c
    })
    return {
      ...formData,
      columns,
      options: JSON.stringify(options)
    }
  })

  watch(sourceMode, (mode) => {
    tableCreated.value = false
    if (mode === 'create') {
      formData.id = 0
      formData.tableName = ''
      formData.tableComment = ''
      formData.varName = ''
      formData.columns = []
      selectedTable.value = ''
      selectedTableComment.value = ''
    }
  })

  onMounted(async () => {
    try {
      const [selects, tables, menuTree] = await Promise.all([
        fetchGenCodesSelects(),
        fetchGenCodesTableSelect(),
        fetchGetMenuTree().catch(() => [])
      ])
      selectsData.value = selects
      tableList.value = tables.list || []
      menuTreeData.value = [
        { id: 0, title: '顶级菜单', children: menuTree || [] }
      ]
      // 从后端获取默认路径配置
      if (selects.genPaths) {
        defaultPaths.value = selects.genPaths
      }
    } catch (e) {
      console.error('加载数据失败:', e)
    }
  })

  const loadTableList = async () => {
    try {
      const tables = await fetchGenCodesTableSelect()
      tableList.value = tables.list || []
    } catch { /* ignore */ }
  }

  const handleTableSelect = async (tableName: string) => {
    const info = tableList.value.find((t: any) => t.tableName === tableName)
    if (info) {
      formData.tableName = tableName
      formData.tableComment = info.tableComment || ''
      formData.varName = info.varName || ''
      selectedTableComment.value = info.tableComment || ''
    }
    try {
      const res = await fetchGenCodesColumnList(tableName)
      formData.columns = res.list || []
    } catch (e) {
      console.error('加载字段失败:', e)
    }
  }

  const handleTableCreated = async (tableName: string) => {
    await loadTableList()
    selectedTable.value = tableName
    await handleTableSelect(tableName)
    tableCreated.value = true
    sourceMode.value = 'existing'
    ElMessage.success(`表 ${tableName} 创建成功，已自动选中`)
  }

  const handleHistorySelect = async (record: any) => {
    formData.id = record.id
    formData.genType = record.genType
    formData.tableName = record.tableName
    formData.tableComment = record.tableComment
    formData.varName = record.varName
    selectedTable.value = record.tableName
    selectedTableComment.value = record.tableComment
    if (record.options) {
      try {
        const opts = typeof record.options === 'string' ? JSON.parse(record.options) : record.options
        Object.assign(options, opts)
      } catch { /* ignore */ }
    }
    if (record.columns && record.columns.length) {
      formData.columns = record.columns.map((col: any) => deserializeColumnExtra(col))
    } else {
      try {
        const res = await fetchGenCodesColumnList(record.tableName)
        formData.columns = res.list || []
      } catch { /* ignore */ }
    }
    activeStep.value = 1
  }

  /** 反序列化 column.extra -> _formProps / _tableProps */
  const deserializeColumnExtra = (col: any) => {
    const c = { ...col, _formProps: {}, _tableProps: {} }
    if (col.extra) {
      try {
        const extra = typeof col.extra === 'string' ? JSON.parse(col.extra) : col.extra
        c._formProps = extra._formProps || {}
        c._tableProps = extra._tableProps || {}
      } catch { /* ignore */ }
    }
    return c
  }

  const handleGenerated = () => {
    ElMessage.success('代码生成成功！')
  }

  const prevStep = () => { if (activeStep.value > 0) activeStep.value-- }
  const nextStep = async () => {
    if (activeStep.value === 1 && basicFormRef.value) {
      try { await basicFormRef.value.validate() } catch { return }
    }
    if (activeStep.value < 3) {
      activeStep.value++
      // 进入预览步骤时自动刷新预览
      if (activeStep.value === 3) {
        nextTick(() => previewRef.value?.refresh())
      }
    }
  }
</script>

<style scoped>
  @reference '@styles/core/tailwind.css';

  .gen-codes-page {
    display: flex;
    flex-direction: column;
    height: calc(100vh - 120px);
    min-height: 0;
  }

  /* 步骤条区域 */
  .step-header {
    flex-shrink: 0;
    padding: 20px 40px 16px;
    border-bottom: 1px solid var(--el-border-color-lighter);
  }

  /* 内容区域 */
  .step-body {
    flex: 1;
    overflow: auto;
    padding: 24px 20px;
    min-height: 0;
  }

  .step-content {
    max-width: 800px;
    margin: 0 auto;
  }

  .step-content--full {
    max-width: 100%;
  }

  /* 数据源卡片组 */
  .source-cards {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 20px;
    margin-bottom: 28px;
  }

  .source-card {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 28px 16px 22px;
    border: 2px solid var(--el-border-color-lighter);
    border-radius: calc(var(--custom-radius) + 4px);
    cursor: pointer;
    transition: all 0.25s ease;
    background: var(--default-box-color);
  }

  .source-card:hover {
    border-color: var(--el-color-primary-light-5);
    transform: translateY(-2px);
    box-shadow: 0 6px 16px rgba(0, 0, 0, 0.06);
  }

  .source-card.active {
    border-color: var(--el-color-primary);
    background: var(--el-color-primary-light-9);
    box-shadow: 0 2px 12px rgba(var(--el-color-primary-rgb), 0.15);
  }

  .source-card__icon {
    width: 56px;
    height: 56px;
    border-radius: calc(var(--custom-radius) + 2px);
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 14px;
  }

  .source-card__title {
    font-size: 15px;
    font-weight: 600;
    margin-bottom: 6px;
    color: var(--el-text-color-primary);
  }

  .source-card__desc {
    font-size: 12px;
    color: var(--el-text-color-secondary);
  }

  /* 操作面板 */
  .source-panel {
    max-width: 640px;
    margin: 0 auto;
  }

  .source-panel--wide {
    max-width: 100%;
  }

  .selected-info {
    display: flex;
    flex-wrap: wrap;
    gap: 12px;
    margin-top: 14px;
    padding: 14px 16px;
    border-radius: calc(var(--custom-radius) / 2 + 2px);
    background: var(--el-fill-color-lighter);
  }

  .info-tag {
    font-size: 13px;
    color: var(--el-text-color-regular);
  }

  .info-label {
    display: inline-block;
    padding: 2px 8px;
    margin-right: 6px;
    font-size: 12px;
    font-weight: 500;
    color: var(--el-color-primary);
    background: var(--el-color-primary-light-9);
    border-radius: 4px;
  }

  /* 基础配置表单 */
  .basic-form {
    max-width: 580px;
    margin: 16px auto 0;
  }

  /* 底部操作栏 */
  .step-footer {
    flex-shrink: 0;
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 14px 20px;
    border-top: 1px solid var(--el-border-color-lighter);
    background: var(--default-box-color);
  }
</style>

<style>
.gen-codes-page .el-card {
  display: flex;
  flex-direction: column;
  flex: 1;
  min-height: 0;
  overflow: hidden;
}
.gen-codes-page .el-card__body {
  display: flex;
  flex-direction: column;
  flex: 1;
  min-height: 0;
  overflow: hidden;
  padding: 0;
}
</style>
