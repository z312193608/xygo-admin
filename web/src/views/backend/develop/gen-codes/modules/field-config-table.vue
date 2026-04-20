<!-- +----------------------------------------------------------------------
  | XYGo Admin [ Vue3 + GoFrame 企业级中后台管理系统 ]
  +----------------------------------------------------------------------
  | Copyright (c) 2026 大连星韵网络科技有限公司 All rights reserved.
  +----------------------------------------------------------------------
  | Licensed ( https://opensource.org/licenses/MIT )
  +----------------------------------------------------------------------
  | Author: 喜羊羊 <751300685@qq.com>
  +---------------------------------------------------------------------- -->
<!-- 字段设计器 - 三栏布局 -->
<template>
  <div class="field-designer">
    <ElRow :gutter="16" class="field-designer__row">
      <!-- 左栏：字段库 -->
      <ElCol :xs="24" :sm="5" :md="5">
        <div class="panel panel--left">
          <div class="panel__header">
            <ArtSvgIcon icon="ri:apps-2-line" class="text-sm mr-1" />
            字段库
          </div>
          <ElCollapse v-model="collapseNames" class="field-library">
            <ElCollapseItem title="常用字段" name="common">
              <div ref="commonRef" class="field-chips" data-group="common">
                <div
                  v-for="(f, idx) in commonFields"
                  :key="idx"
                  class="field-chip"
                  :data-index="idx"
                  :title="f.comment"
                >
                  <ArtSvgIcon :icon="getFieldIcon(f.designType)" class="text-xs mr-1 opacity-60" />
                  {{ f.title }}
                </div>
              </div>
            </ElCollapseItem>
            <ElCollapseItem title="基础字段" name="base">
              <div ref="baseRef" class="field-chips" data-group="base">
                <div
                  v-for="(f, idx) in baseFields"
                  :key="idx"
                  class="field-chip"
                  :data-index="idx"
                  :title="f.comment"
                >
                  <ArtSvgIcon :icon="getFieldIcon(f.designType)" class="text-xs mr-1 opacity-60" />
                  {{ f.title }}
                </div>
              </div>
            </ElCollapseItem>
            <ElCollapseItem title="高级字段" name="senior">
              <div ref="seniorRef" class="field-chips" data-group="senior">
                <div
                  v-for="(f, idx) in seniorFields"
                  :key="idx"
                  class="field-chip"
                  :data-index="idx"
                  :title="f.comment"
                >
                  <ArtSvgIcon :icon="getFieldIcon(f.designType)" class="text-xs mr-1 opacity-60" />
                  {{ f.title }}
                </div>
              </div>
            </ElCollapseItem>
          </ElCollapse>
        </div>
      </ElCol>

      <!-- 中栏：设计区 -->
      <ElCol :xs="24" :sm="13" :md="13">
        <div class="panel panel--center">
          <!-- Tab 栏：主表字段 + 关联表 -->
          <div class="tab-toolbar">
            <ElTabs v-model="activeTab" class="relation-tabs" type="card" @tab-remove="handleRemoveRelTab" style="flex:1">
            <ElTabPane label="字段列表" name="master" :closable="false">
              <template #label>
                <div style="display:flex;align-items:center;gap:4px">
                  <ArtSvgIcon icon="ri:layout-grid-line" class="text-sm" />
                  <span>字段列表</span>
                  <span class="text-xs text-gray-400">({{ modelValue.length }})</span>
                </div>
              </template>
            </ElTabPane>
            <ElTabPane
              v-for="rel in relationTabs"
              :key="rel.fieldName"
              :name="'rel-' + rel.fieldName"
              :closable="false"
            >
              <template #label>
                <div style="display:flex;align-items:center;gap:4px">
                  <ArtSvgIcon icon="ri:links-line" class="text-sm" />
                  <span>{{ rel.label }}</span>
                </div>
              </template>
            </ElTabPane>
          </ElTabs>
            <ElTooltip content="从数据库同步新增字段到设计器（先在数据库中增删字段，再点此按钮同步）" placement="top">
              <ElButton size="small" :loading="syncLoading" @click="handleSyncFromDb" style="margin-left:8px;margin-right:10px;flex-shrink:0">
                <ArtSvgIcon icon="ri:refresh-line" class="text-sm mr-1" />
                同步字段
              </ElButton>
            </ElTooltip>
          </div>

          <!-- 主表字段设计区 -->
          <div v-show="activeTab === 'master'"
            ref="designAreaRef"
            class="design-area"
            :class="{ 'design-area--dragging': isDragging }"
          >
            <div
              v-for="(field, idx) in modelValue"
              :key="field.name + '-' + idx"
              class="field-card"
              :class="{ 'field-card--active': activeIndex === idx, 'field-card--pk': field.isPk === 1 }"
              @click="activateField(idx)"
            >
              <div class="field-card__drag">
                <ArtSvgIcon icon="ri:draggable" class="text-sm text-gray-300" />
              </div>
              <div class="field-card__info">
                <span class="field-card__name">{{ field.name }}</span>
                <span class="field-card__comment">{{ field.comment || '无注释' }}</span>
              </div>
              <ElTag v-if="field.designType" size="small" :type="getTagType(field.designType)" class="field-card__tag">
                {{ getDesignTypeName(field.designType) }}
              </ElTag>
              <div class="field-card__badges">
                <ElTag v-if="field.isList" size="small" effect="plain" class="badge">列</ElTag>
                <ElTag v-if="field.isEdit" size="small" effect="plain" class="badge">编</ElTag>
                <ElTag v-if="field.isQuery" size="small" effect="plain" type="warning" class="badge">搜</ElTag>
                <ElTag v-if="field.isRequired" size="small" effect="plain" type="danger" class="badge">必</ElTag>
                <ElTag v-if="field.isQuery && field.queryType && field.queryType !== 'eq'" size="small" effect="plain" type="info" class="badge">{{ field.queryType }}</ElTag>
              </div>
              <ElButton
                v-if="field.isPk !== 1"
                type="danger"
                text
                size="small"
                class="field-card__delete"
                @click.stop="removeField(idx)"
              >
                <ArtSvgIcon icon="ri:delete-bin-line" class="text-sm" />
              </ElButton>
            </div>

            <!-- 空状态 -->
            <div v-if="!modelValue.length" class="design-area__empty">
              <ArtSvgIcon icon="ri:drag-drop-line" class="text-4xl text-gray-300 mb-2" />
              <p class="text-sm text-gray-400">从左侧拖拽字段到此处</p>
              <p class="text-xs text-gray-300">或选择数据表自动加载字段</p>
            </div>
          </div>

          <!-- 关联表字段配置表格 -->
          <div v-for="rel in relationTabs" :key="'panel-' + rel.fieldName" v-show="activeTab === 'rel-' + rel.fieldName" class="relation-table-wrapper">
            <RelationFieldTable :field="rel.sourceField" :remote-table="rel.remoteTable" />
          </div>
        </div>
      </ElCol>

      <!-- 右栏：属性面板 -->
      <ElCol :xs="24" :sm="6" :md="6">
        <div class="panel panel--right">
          <div class="panel__header">
            <ArtSvgIcon icon="ri:settings-3-line" class="text-sm mr-1" />
            属性配置
          </div>
          <FieldPropertyPanel
            :field="activeField"
            :selects="selects"
          />
        </div>
      </ElCol>
    </ElRow>
  </div>
</template>

<script setup lang="ts">
  import { onMounted, onBeforeUnmount } from 'vue'
  import Sortable from 'sortablejs'
  import ArtSvgIcon from '@/components/core/base/art-svg-icon/index.vue'
  import FieldPropertyPanel from './field-property-panel.vue'
  import RelationFieldTable from './relation-field-table.vue'
  import { fetchGenCodesColumnList } from '@/api/backend/develop/genCodes'
  import {
    commonFields,
    baseFields,
    seniorFields,
    designTypes,
    getDesignTypeName,
    snakeToPascal,
    snakeToCamel,
    type PresetField,
  } from './field-library'

  const props = defineProps<{
    modelValue: any[]
    selects: any
    tableName?: string
  }>()

  const emit = defineEmits<{
    (e: 'update:modelValue', v: any[]): void
  }>()

  const collapseNames = ref(['common', 'base', 'senior'])
  const activeIndex = ref(-1)
  const isDragging = ref(false)
  const activeTab = ref('master')

  // 关联表 Tab 列表：从 columns 中自动提取已配置关联表的 remoteSelect/remoteSelects 字段
  const relationTabs = computed(() => {
    return props.modelValue
      .filter((col: any) =>
        (col.designType === 'remoteSelect' || col.designType === 'remoteSelects') &&
        col._formProps?.['remote-table']
      )
      .map((col: any) => ({
        fieldName: col.name,
        remoteTable: col._formProps['remote-table'],
        label: `关联表[${col._formProps['remote-table'].replace(/^xy_/, '')}]`,
        sourceField: col,
      }))
  })

  const handleRemoveRelTab = (_name: string | number) => {
    // Tab 不可手动关闭，由字段配置驱动
  }

  // ==================== 同步字段（数据库 → 设计器） ====================
  const syncLoading = ref(false)

  const handleSyncFromDb = async () => {
    if (!props.tableName) {
      ElMessage.warning('请先选择数据表')
      return
    }
    syncLoading.value = true
    try {
      const res = await fetchGenCodesColumnList(props.tableName)
      const dbColumns = res.list || []
      const dbNameSet = new Set(dbColumns.map((c: any) => c.name || c.columnName))
      const existingNames = new Set(props.modelValue.map((c: any) => c.name))

      // 移除数据库中已删除的字段（保留主键）
      const filtered = props.modelValue.filter((c: any) => dbNameSet.has(c.name) || c.isPk === 1)
      const removedCount = props.modelValue.length - filtered.length

      // 新增数据库中有但设计器没有的字段
      let addedCount = 0
      for (const col of dbColumns) {
        const name = col.name || col.columnName
        if (!existingNames.has(name)) {
          filtered.push({
            name,
            goName: snakeToPascal(name),
            tsName: snakeToCamel(name),
            dbType: col.dbType || col.columnType || 'varchar(100)',
            goType: col.goType || 'string',
            tsType: col.tsType || 'string',
            comment: col.comment || col.columnComment || '',
            designType: col.designType || 'string',
            formType: col.formType || 'input',
            queryType: col.queryType || 'eq',
            isPk: col.isPk || 0,
            isList: col.isList ?? 1,
            isEdit: col.isEdit ?? 1,
            isQuery: col.isQuery ?? 0,
            isRequired: col.isRequired ?? 0,
            _formProps: {},
            _tableProps: {},
          })
          addedCount++
        }
      }

      if (addedCount > 0 || removedCount > 0) {
        emit('update:modelValue', filtered)
        const parts = []
        if (addedCount > 0) parts.push(`新增 ${addedCount} 个`)
        if (removedCount > 0) parts.push(`移除 ${removedCount} 个`)
        ElMessage.success(`同步完成：${parts.join('，')}字段`)
      } else {
        ElMessage.info('设计器字段与数据库一致，无变更')
      }
    } catch (e) {
      console.error('同步字段失败:', e)
    } finally {
      syncLoading.value = false
    }
  }

  // Refs
  const designAreaRef = ref<HTMLElement>()
  const commonRef = ref<HTMLElement>()
  const baseRef = ref<HTMLElement>()
  const seniorRef = ref<HTMLElement>()

  // Sortable 实例
  let designSortable: Sortable | null = null
  let librarySortables: Sortable[] = []

  // 当前选中的字段
  const activeField = computed(() => {
    if (activeIndex.value >= 0 && activeIndex.value < props.modelValue.length) {
      return props.modelValue[activeIndex.value]
    }
    return null
  })

  const activateField = (idx: number) => {
    activeIndex.value = idx
  }

  const removeField = (idx: number) => {
    const list = [...props.modelValue]
    list.splice(idx, 1)
    emit('update:modelValue', list)
    if (activeIndex.value === idx) {
      activeIndex.value = -1
    } else if (activeIndex.value > idx) {
      activeIndex.value--
    }
  }

  // designType -> 图标映射
  const getFieldIcon = (dt: string): string => {
    const iconMap: Record<string, string> = {
      pk: 'ri:key-line',
      string: 'ri:text',
      number: 'ri:hashtag',
      float: 'ri:percent-line',
      switch: 'ri:toggle-line',
      radio: 'ri:radio-button-line',
      checkbox: 'ri:checkbox-line',
      select: 'ri:arrow-down-s-line',
      selects: 'ri:list-check',
      textarea: 'ri:file-text-line',
      password: 'ri:lock-line',
      datetime: 'ri:calendar-line',
      date: 'ri:calendar-2-line',
      time: 'ri:time-line',
      timestamp: 'ri:timer-line',
      image: 'ri:image-line',
      images: 'ri:image-2-line',
      file: 'ri:file-line',
      files: 'ri:folder-line',
      editor: 'ri:quill-pen-line',
      color: 'ri:palette-line',
      icon: 'ri:star-line',
      city: 'ri:map-pin-line',
      remoteSelect: 'ri:links-line',
      remoteSelects: 'ri:link-m',
      weigh: 'ri:drag-move-line',
    }
    return iconMap[dt] || 'ri:code-line'
  }

  // designType -> Tag 类型颜色
  const getTagType = (dt: string): 'primary' | 'success' | 'warning' | 'danger' | 'info' => {
    if (dt === 'pk') return 'danger'
    if (['switch', 'radio', 'checkbox', 'select', 'selects'].includes(dt)) return 'warning'
    if (['image', 'images', 'file', 'files', 'editor'].includes(dt)) return 'success'
    if (['remoteSelect', 'remoteSelects'].includes(dt)) return 'danger'
    if (['datetime', 'date', 'time', 'timestamp'].includes(dt)) return 'info'
    return 'primary'
  }

  // 生成不重复字段名
  const uniqueFieldName = (baseName: string): string => {
    const existing = new Set(props.modelValue.map((f: any) => f.name))
    if (!existing.has(baseName)) return baseName
    for (let i = 2; i < 100; i++) {
      const name = `${baseName}_${i}`
      if (!existing.has(name)) return name
    }
    return `${baseName}_${Date.now()}`
  }

  // 从预设字段创建列数据
  const createColumnFromPreset = (preset: PresetField): any => {
    const name = uniqueFieldName(preset.name)
    return {
      id: 0,
      genId: 0,
      name,
      goName: snakeToPascal(name),
      tsName: snakeToCamel(name),
      dbType: preset.dbType || designTypes[preset.designType]?.defaultDbType || 'varchar(255)',
      goType: preset.goType || designTypes[preset.designType]?.defaultGoType || 'string',
      tsType: preset.tsType || designTypes[preset.designType]?.defaultTsType || 'string',
      comment: preset.comment,
      isPk: preset.isPk ?? 0,
      isRequired: 0,
      isList: preset.isList ?? 1,
      isEdit: preset.isEdit ?? 1,
      isQuery: 0,
      queryType: 'eq',
      formType: designTypeToFormType(preset.designType),
      designType: preset.designType,
      dictType: '',
      sort: 0,
      _tableProps: {},
      _formProps: {},
    }
  }

  const designTypeToFormType = (dt: string): string => {
    const map: Record<string, string> = {
      pk: 'input', string: 'input', number: 'inputNumber', float: 'inputNumber',
      switch: 'switch', radio: 'radio', checkbox: 'checkbox', select: 'select',
      selects: 'select', textarea: 'textarea', password: 'input',
      datetime: 'datetime', date: 'date', time: 'input', timestamp: 'datetime',
      image: 'imageUpload', images: 'imagesUpload', file: 'fileUpload', files: 'fileUpload',
      editor: 'richEditor', color: 'colorPicker', icon: 'iconSelector',
      city: 'input', remoteSelect: 'remoteSelect', remoteSelects: 'remoteSelect',
      weigh: 'inputNumber',
    }
    return map[dt] || 'input'
  }

  // 获取预设字段列表
  const fieldGroups: Record<string, PresetField[]> = {
    common: commonFields,
    base: baseFields,
    senior: seniorFields,
  }

  // 初始化 Sortable
  onMounted(() => {
    nextTick(() => {
      initSortable()
    })
  })

  onBeforeUnmount(() => {
    designSortable?.destroy()
    librarySortables.forEach(s => s.destroy())
  })

  const initSortable = () => {
    if (!designAreaRef.value) return

    // 设计区 Sortable（接受拖入 + 排序）
    designSortable = Sortable.create(designAreaRef.value, {
      group: 'field-designer',
      animation: 200,
      handle: '.field-card__drag',
      ghostClass: 'field-card--ghost',
      dragClass: 'field-card--drag',
      filter: '.design-area__empty',
      onAdd: (evt: Sortable.SortableEvent) => {
        // 从字段库拖入
        const groupName = evt.from.dataset.group
        if (!groupName || !fieldGroups[groupName]) return

        const oldIdx = evt.oldIndex!
        const newIdx = evt.newIndex!
        const preset = fieldGroups[groupName][oldIdx]
        if (!preset) return

        const newField = createColumnFromPreset(preset)
        const list = [...props.modelValue]
        list.splice(newIdx, 0, newField)

        // 移除 Sortable 自动插入的 DOM 元素（避免重复渲染）
        const addedEl = designAreaRef.value!.children[newIdx]
        if (addedEl && addedEl.classList.contains('field-chip')) {
          addedEl.remove()
        }

        emit('update:modelValue', list)
        activeIndex.value = newIdx
      },
      onEnd: (evt: Sortable.SortableEvent) => {
        if (evt.from === evt.to && evt.oldIndex !== evt.newIndex) {
          const list = [...props.modelValue]
          const [moved] = list.splice(evt.oldIndex!, 1)
          list.splice(evt.newIndex!, 0, moved)
          emit('update:modelValue', list)

          // 更新选中索引
          if (activeIndex.value === evt.oldIndex) {
            activeIndex.value = evt.newIndex!
          }
        }
      },
      onStart: () => { isDragging.value = true },
      onUnchoose: () => { isDragging.value = false },
    })

    // 字段库 Sortable（仅拖出 clone）
    const refs = [
      { el: commonRef.value, group: 'common' },
      { el: baseRef.value, group: 'base' },
      { el: seniorRef.value, group: 'senior' },
    ]

    refs.forEach(({ el }) => {
      if (!el) return
      const s = Sortable.create(el, {
        sort: false,
        group: {
          name: 'field-designer',
          pull: 'clone',
          put: false,
        },
        animation: 200,
        onStart: () => { isDragging.value = true },
        onEnd: () => { isDragging.value = false },
      })
      librarySortables.push(s)
    })
  }
</script>

<style scoped>
  @reference '@styles/core/tailwind.css';

  .field-designer {
    width: 100%;
  }

  .field-designer__row {
    min-height: 500px;
  }

  /* 面板通用样式 */
  .panel {
    background: var(--default-box-color);
    border: 1px solid var(--el-border-color-lighter);
    border-radius: calc(var(--custom-radius) / 2 + 2px);
    height: 100%;
    display: flex;
    flex-direction: column;
    overflow: hidden;
  }

  .panel__header {
    display: flex;
    align-items: center;
    padding: 10px 14px;
    font-size: 13px;
    font-weight: 600;
    color: var(--el-text-color-primary);
    border-bottom: 1px solid var(--el-border-color-lighter);
    background: var(--el-fill-color-lighter);
  }

  /* 左栏：字段库 */
  .panel--left {
    max-height: calc(100vh - 280px);
    overflow-y: auto;
  }

  .field-library {
    border: none;
  }

  .field-chips {
    display: flex;
    flex-wrap: wrap;
    gap: 6px;
  }

  .field-chip {
    display: inline-flex;
    align-items: center;
    padding: 4px 10px;
    font-size: 12px;
    color: var(--el-text-color-regular);
    background: var(--el-fill-color-light);
    border: 1px solid var(--el-border-color-lighter);
    border-radius: 4px;
    cursor: grab;
    transition: all 0.2s;
    user-select: none;
  }

  .field-chip:hover {
    border-color: var(--el-color-primary-light-5);
    color: var(--el-color-primary);
    background: var(--el-color-primary-light-9);
  }

  .field-chip:active {
    cursor: grabbing;
  }

  /* 中栏：设计区 */
  .panel--center {
    min-height: 0;
  }

  .tab-toolbar {
    display: flex;
    align-items: flex-end;
    gap: 0;
    margin-bottom: 4px;
  }

  .relation-tabs {
  }

  .relation-table-wrapper {
    flex: 1;
    overflow: auto;
    padding: 4px 0;
  }

  .design-area {
    flex: 1;
    overflow-y: auto;
    padding: 10px;
    min-height: 200px;
    max-height: calc(100vh - 360px);
    transition: border-color 0.2s;
  }

  .design-area--dragging {
    border: 2px dashed var(--el-color-primary-light-3);
    border-radius: 4px;
    background: var(--el-color-primary-light-9);
  }

  .design-area__empty {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    height: 300px;
    pointer-events: none;
  }

  /* 字段卡片 */
  .field-card {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 8px 10px;
    margin-bottom: 4px;
    border: 1px solid var(--el-border-color-lighter);
    border-radius: calc(var(--custom-radius) / 2);
    background: var(--default-box-color);
    cursor: pointer;
    transition: all 0.15s;
  }

  .field-card:hover {
    border-color: var(--el-color-primary-light-5);
    box-shadow: 0 1px 4px rgba(0, 0, 0, 0.04);
  }

  .field-card--active {
    border-color: var(--el-color-primary);
    background: var(--el-color-primary-light-9);
    box-shadow: 0 0 0 1px var(--el-color-primary-light-5);
  }

  .field-card--pk {
    background: var(--el-fill-color-lighter);
  }

  .field-card--ghost {
    opacity: 0.4;
    border-style: dashed;
  }

  .field-card--drag {
    opacity: 0.8;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  }

  .field-card__drag {
    cursor: grab;
    flex-shrink: 0;
  }

  .field-card__drag:active {
    cursor: grabbing;
  }

  .field-card__info {
    flex: 1;
    min-width: 0;
    display: flex;
    flex-direction: column;
    gap: 1px;
  }

  .field-card__name {
    font-size: 13px;
    font-weight: 600;
    color: var(--el-text-color-primary);
    font-family: 'Menlo', 'Monaco', 'Consolas', monospace;
  }

  .field-card__comment {
    font-size: 11px;
    color: var(--el-text-color-secondary);
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  .field-card__tag {
    flex-shrink: 0;
  }

  .field-card__badges {
    display: flex;
    gap: 2px;
    flex-shrink: 0;
  }

  .field-card__badges .badge {
    padding: 0 4px;
    height: 18px;
    line-height: 18px;
    font-size: 10px;
  }

  .field-card__delete {
    flex-shrink: 0;
    opacity: 0;
    transition: opacity 0.2s;
  }

  .field-card:hover .field-card__delete {
    opacity: 1;
  }

  /* 右栏：属性面板 */
  .panel--right {
    height: calc(100vh - 320px);
    max-height: calc(100vh - 320px);
  }

</style>

<style>
.field-library .el-collapse-item__header {
  padding: 0 12px;
  font-size: 12px;
  font-weight: 600;
  height: 36px;
  line-height: 36px;
  background: transparent;
}
.field-library .el-collapse-item__wrap {
  border-bottom: none;
}
.field-library .el-collapse-item__content {
  padding: 4px 10px 10px;
}
.relation-tabs .el-tabs__header {
  margin-bottom: 0;
}
.relation-tabs .el-tabs__content {
  display: none;
}
.panel--right .property-panel {
  flex: 1;
  overflow-y: auto;
  padding: 10px 12px;
  min-height: 0;
  max-height: calc(100vh - 370px);
}
</style>
