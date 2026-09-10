<!-- 登录日志 搜索栏 -->
<template>
  <ArtSearchBar
    v-model="formFilters"
    :items="formItems"
    @reset="handleReset"
    @search="handleSearch"
  />
</template>

<script setup lang="ts">
  const props = defineProps<{ modelValue: Record<string, any> }>()
  const emit = defineEmits<{
    (e: 'update:modelValue', v: Record<string, any>): void
    (e: 'search', params: Record<string, any>): void
    (e: 'reset'): void
  }>()

  const formFilters = reactive({ ...props.modelValue })

  const formItems = computed(() => [
    {
      label: '状态',
      key: 'status',
      type: 'select',
      props: {
        clearable: true,
        options: [{ label: '成功', value: 1 }, { label: '失败', value: 0 }]
      }
    },
    {
      label: '用户名',
      key: 'member_username',
      type: 'input',
      props: { clearable: true }
    },
  ])

  const handleSearch = () => {
    const params: Record<string, any> = { ...formFilters }
    emit('update:modelValue', params)
    emit('search', params)
  }

  const handleReset = () => {
    Object.keys(formFilters).forEach(k => (formFilters[k] = undefined))
    emit('update:modelValue', { ...formFilters })
    emit('reset')
  }
</script>
