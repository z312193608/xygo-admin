<!-- {{.TableComment}} 详情抽屉 -->
<template>
  <ElDrawer
    v-model="visible"
    title="{{.TableComment}}详情"
    size="600px"
    :destroy-on-close="true"
  >
    <div v-if="loading" class="flex justify-center py-10">
      <ElIcon class="is-loading" :size="24"><Loading /></ElIcon>
    </div>
    <ElDescriptions v-else-if="detail" :column="1" border>
{{- range .ListColumns}}
{{- if or (eq .DesignType "image") (eq .Render "image")}}
      <ElDescriptionsItem label="{{.Label}}">
        <ElImage v-if="detail.{{.TsName}}" :src="detail.{{.TsName}}" style="width:80px;height:80px" fit="cover" :preview-src-list="[detail.{{.TsName}}]" />
        <span v-else>-</span>
      </ElDescriptionsItem>
{{- else if or (eq .DesignType "images") (eq .Render "images")}}
      <ElDescriptionsItem label="{{.Label}}">
        <div v-if="detail.{{.TsName}}" style="display:flex;gap:4px;flex-wrap:wrap">
          <ElImage v-for="(img, i) in (Array.isArray(detail.{{.TsName}}) ? detail.{{.TsName}} : String(detail.{{.TsName}} || '').split(',').filter(Boolean))" :key="i" :src="img" style="width:60px;height:60px" fit="cover" :preview-src-list="Array.isArray(detail.{{.TsName}}) ? detail.{{.TsName}} : String(detail.{{.TsName}} || '').split(',').filter(Boolean)" />
        </div>
        <span v-else>-</span>
      </ElDescriptionsItem>
{{- else if or (eq .DesignType "switch") (eq .Render "switch")}}
      <ElDescriptionsItem label="{{.Label}}">
        <ElTag :type="detail.{{.TsName}} === 1 ? 'success' : 'danger'" size="small">
          {{"{{"}} detail.{{.TsName}} === 1 ? '启用' : '禁用' {{"}}"}}
        </ElTag>
      </ElDescriptionsItem>
{{- else if or (eq .Render "tag") (and (eq .Render "") (or (eq .DesignType "radio") (eq .DesignType "select")))}}
      <ElDescriptionsItem label="{{.Label}}">
{{- if .RadioOptions}}
        <ElTag :type="(({ {{range .RadioOptions}}'{{.Value}}': '{{.TagType}}', {{end}} } as const)[String(detail.{{.TsName}})] ?? undefined)" size="small">{{"{{"}} ({ {{range .RadioOptions}}'{{.Value}}': '{{.Label}}', {{end}} })[String(detail.{{.TsName}})] || detail.{{.TsName}} {{"}}"}}</ElTag>
{{- else}}
        <ElTag size="small">{{"{{"}} detail.{{.TsName}} ?? '-' {{"}}"}}</ElTag>
{{- end}}
      </ElDescriptionsItem>
{{- else if or (eq .DesignType "color") (eq .Render "color")}}
      <ElDescriptionsItem label="{{.Label}}">
        <span v-if="detail.{{.TsName}}" :style="`display:inline-block;width:20px;height:20px;border-radius:4px;background:${detail.{{.TsName}}}`"></span>
        <span v-else>-</span>
      </ElDescriptionsItem>
{{- else if or (eq .Render "url") (and (eq .Render "") (eq .DesignType "file"))}}
      <ElDescriptionsItem label="{{.Label}}">
        <a v-if="detail.{{.TsName}}" :href="detail.{{.TsName}}" target="_blank" style="color:var(--el-color-primary)">{{"{{"}} detail.{{.TsName}} {{"}}"}}</a>
        <span v-else>-</span>
      </ElDescriptionsItem>
{{- else if or (eq .DesignType "timestamp") (eq .DesignType "datetime") (eq .Render "datetime")}}
      <ElDescriptionsItem label="{{.Label}}">{{"{{"}} formatTimestamp(detail.{{.TsName}}) {{"}}"}}</ElDescriptionsItem>
{{- else if eq .DesignType "editor"}}
      <ElDescriptionsItem label="{{.Label}}">
        <div v-if="detail.{{.TsName}}" v-html="detail.{{.TsName}}" class="max-h-[300px] overflow-auto"></div>
        <span v-else>-</span>
      </ElDescriptionsItem>
{{- else if or (eq .Render "icon") (and (eq .Render "") (eq .DesignType "icon"))}}
      <ElDescriptionsItem label="{{.Label}}">
        <ArtSvgIcon v-if="detail.{{.TsName}}" :icon="detail.{{.TsName}}" class="text-lg" />
        <span v-else>-</span>
      </ElDescriptionsItem>
{{- else if or (eq .Render "tags") (and (eq .Render "") (or (eq .DesignType "checkbox") (eq .DesignType "selects")))}}
      <ElDescriptionsItem label="{{.Label}}">
        <div v-if="detail.{{.TsName}}" style="display:flex;gap:4px;flex-wrap:wrap">
          <ElTag v-for="(v, i) in (Array.isArray(detail.{{.TsName}}) ? detail.{{.TsName}} : String(detail.{{.TsName}} || '').split(',').filter(Boolean))" :key="i" size="small">{{"{{"}} v {{"}}"}}</ElTag>
        </div>
        <span v-else>-</span>
      </ElDescriptionsItem>
{{- else if and (eq .Render "") (eq .DesignType "files")}}
      <ElDescriptionsItem label="{{.Label}}">
        <div v-if="detail.{{.TsName}}" style="display:flex;flex-direction:column;gap:4px">
          <a v-for="(f, i) in (Array.isArray(detail.{{.TsName}}) ? detail.{{.TsName}} : String(detail.{{.TsName}} || '').split(',').filter(Boolean))" :key="i" :href="f" target="_blank" style="color:var(--el-color-primary);font-size:13px">文件 {{"{{"}} i + 1 {{"}}"}}</a>
        </div>
        <span v-else>-</span>
      </ElDescriptionsItem>
{{- else}}
      <ElDescriptionsItem label="{{.Label}}">{{"{{"}} detail.{{.TsName}} ?? '-' {{"}}"}}</ElDescriptionsItem>
{{- end}}
{{- end}}
    </ElDescriptions>
  </ElDrawer>
</template>

<script setup lang="ts">
  import { Loading } from '@element-plus/icons-vue'
  import { fetch{{.VarName}}View } from '{{.WebApiImportPath}}'
  import { formatTimestamp } from '@/utils/time'

  const visible = defineModel<boolean>({ default: false })

  interface Props {
    viewId?: number
  }

  const props = defineProps<Props>()

  const loading = ref(false)
  const detail = ref<Record<string, any> | null>(null)

  watch(visible, async (val) => {
    if (val && props.viewId) {
      loading.value = true
      try {
        detail.value = await fetch{{.VarName}}View(props.viewId) as any
      } catch { detail.value = null }
      loading.value = false
    }
  })
</script>
