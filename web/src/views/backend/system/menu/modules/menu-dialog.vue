<!-- +----------------------------------------------------------------------
  | XYGo Admin [ Vue3 + GoFrame 企业级中后台管理系统 ]
  +----------------------------------------------------------------------
  | Copyright (c) 2026 大连星韵网络科技有限公司 All rights reserved.
  +----------------------------------------------------------------------
  | Licensed ( https://opensource.org/licenses/MIT )
  +----------------------------------------------------------------------
  | Author: 喜羊羊 <751300685@qq.com>
  +---------------------------------------------------------------------- -->
  <template>
    <ElDialog
      :title="dialogTitle"
      :model-value="visible"
      @update:model-value="handleCancel"
      width="860px"
      align-center
      class="menu-dialog"
      @closed="handleClosed"
    >
      <ArtForm
        ref="formRef"
        v-model="form"
        :items="formItems"
        :rules="rules"
        :span="width > 640 ? 12 : 24"
        :gutter="20"
        label-width="100px"
        :show-reset="false"
        :show-submit="false"
      >
        <template #menuType>
          <ElRadioGroup v-model="form.menuType" :disabled="disableMenuType">
            <ElRadioButton value="directory" label="directory">目录</ElRadioButton>
            <ElRadioButton value="menu" label="menu">菜单</ElRadioButton>
            <ElRadioButton value="button" label="button">按钮</ElRadioButton>
          </ElRadioGroup>
        </template>
        <template #icon>
          <ArtIconSelector v-model="form.icon" />
        </template>
      </ArtForm>
  
      <template #footer>
        <span class="dialog-footer">
          <ElButton @click="handleCancel">取 消</ElButton>
          <ElButton type="primary" @click="handleSubmit">确 定</ElButton>
        </span>
      </template>
    </ElDialog>
  </template>
  
  <script setup lang="ts">
    import type { FormRules } from 'element-plus'
    import { ElIcon, ElTooltip } from 'element-plus'
    import { QuestionFilled } from '@element-plus/icons-vue'
    import { formatMenuTitle } from '@/utils/router'
    import type { AppRouteRecord } from '@/types/router'
    import type { FormItem } from '@/components/core/forms/art-form/index.vue'
    import ArtForm from '@/components/core/forms/art-form/index.vue'
    import ArtIconSelector from '@/components/core/forms/art-icon-selector/index.vue'
    import { useWindowSize } from '@vueuse/core'
    import { fetchResourceList } from '@/api/backend/system'
  
    const { width } = useWindowSize()
  
    // 资源列表
    const resourceOptions = ref<Array<{ label: string; value: string }>>([])
  
    // 加载资源列表
    const loadResources = async () => {
      try {
        const res = await fetchResourceList()
        resourceOptions.value = res.list.map((item: any) => ({
          label: `${item.label}（${item.code}）`,
          value: item.code
        }))
      } catch (error) {
        console.error('加载资源列表失败:', error)
      }
    }
  
    // 组件挂载时加载资源列表
    onMounted(() => {
      loadResources()
    })
  
    /**
     * 创建带 tooltip 的表单标签
     * @param label 标签文本
     * @param tooltip 提示文本
     * @returns 渲染函数
     */
    const createLabelTooltip = (label: string, tooltip: string) => {
      return () =>
        h('span', { class: 'flex items-center' }, [
          h('span', label),
          h(
            ElTooltip,
            {
              content: tooltip,
              placement: 'top'
            },
            () => h(ElIcon, { class: 'ml-0.5 cursor-help' }, () => h(QuestionFilled))
          )
        ])
    }
  
    interface MenuFormData {
      id: number
      parentId: number  // 上级菜单ID
      name: string
      path: string
      label: string
      component: string
      icon: string
      resource: string  // 关联数据表名
      isEnable: boolean
      sort: number
      isMenu: boolean
      keepAlive: boolean
      isHide: boolean
      isHideTab: boolean
      link: string
      isIframe: boolean
      showBadge: boolean
      showTextBadge: string
      fixedTab: boolean
      activePath: string
      roles: string[]
      isFullPage: boolean
      authName: string
      authLabel: string
      authIcon: string
      authSort: number
    }
  
    interface Props {
      visible: boolean
      editData?: AppRouteRecord | any
      type?: 'directory' | 'menu' | 'button'
      lockType?: boolean
      parentMenu?: any  // 上级菜单数据
      menuTree?: any[]  // 完整菜单树（用于上级菜单选择）
    }
  
  
    interface Emits {
      (e: 'update:visible', value: boolean): void
      (e: 'submit', data: MenuFormData): void
    }
  
    const props = withDefaults(defineProps<Props>(), {
      visible: false,
      type: 'menu',
      lockType: false,
      parentMenu: null,
      menuTree: () => []
    })
  
    const emit = defineEmits<Emits>()
  
    const formRef = ref()
    const isEdit = ref(false)
  
    const form = reactive<MenuFormData & { menuType: 'directory' | 'menu' | 'button' }>({
      menuType: 'menu',
      id: 0,
      parentId: null as any,  // 使用null表示未选择（顶级）
      name: '',
      path: '',
      label: '',
      component: '',
      icon: '',
      resource: '',
      isEnable: true,
      sort: 1,
      isMenu: true,
      keepAlive: true,
      isHide: false,
      isHideTab: false,
      link: '',
      isIframe: false,
      showBadge: false,
      showTextBadge: '',
      fixedTab: false,
      activePath: '',
      roles: [],
      isFullPage: false,
      authName: '',
      authLabel: '',
      authIcon: '',
      authSort: 1
    })
  
    const rules = reactive<FormRules>({
      name: [
        { required: true, message: '请输入菜单名称', trigger: 'blur' },
        { min: 2, max: 20, message: '长度在 2 到 20 个字符', trigger: 'blur' }
      ],
      path: [{ required: true, message: '请输入路由地址', trigger: 'blur' }],
      label: [{ required: true, message: '输入权限标识', trigger: 'blur' }],
      authName: [{ required: true, message: '请输入权限名称', trigger: 'blur' }],
      authLabel: [{ required: true, message: '请输入权限标识', trigger: 'blur' }]
    })
  
    /**
     * 表单项配置
     */
    const formItems = computed<FormItem[]>(() => {
      const baseItems: FormItem[] = [{ label: '菜单类型', key: 'menuType', span: 24 }]
  
      // Switch 组件的 span：小屏幕 12，大屏幕 6
      const switchSpan = width.value < 640 ? 12 : 6
  
      if (form.menuType === 'directory') {
        return [
          ...baseItems,
          { label: '目录名称', key: 'name', type: 'input', props: { placeholder: '目录名称' } },
          {
            label: '上级菜单',
            key: 'parentId',
            type: 'treeselect',
            props: {
              data: props.menuTree || [],
              props: { label: 'title', value: 'id', children: 'children' },
              placeholder: '请选择上级菜单（不选则为顶级）',
              clearable: true,
              checkStrictly: true,
              defaultExpandAll: false,
              filterable: true
            }
          },
          {
            label: createLabelTooltip(
              '路由地址',
              '目录路由以 / 开头（如 /system）'
            ),
            key: 'path',
            type: 'input',
            props: { placeholder: '如：/system' }
          },
          { label: '权限标识', key: 'label', type: 'input', props: { placeholder: '如：System' } },
          { label: '图标', key: 'icon' },
          {
            label: '菜单排序',
            key: 'sort',
            type: 'number',
            props: { min: 1, controlsPosition: 'right', style: { width: '100%' } }
          },
          { label: '是否启用', key: 'isEnable', type: 'switch', span: width.value < 640 ? 12 : 6 },
          { label: '隐藏菜单', key: 'isHide', type: 'switch', span: width.value < 640 ? 12 : 6 }
        ]
      }
  
      if (form.menuType === 'menu') {
        return [
          ...baseItems,
          { label: '菜单名称', key: 'name', type: 'input', props: { placeholder: '菜单名称' } },
          {
            label: '上级菜单',
            key: 'parentId',
            type: 'treeselect',
            props: {
              data: props.menuTree || [],
              props: { label: 'title', value: 'id', children: 'children' },
              placeholder: '请选择上级菜单（不选则为顶级）',
              clearable: true,
              checkStrictly: true,
              defaultExpandAll: false,
              filterable: true
            }
          },
          {
            label: createLabelTooltip(
              '路由地址',
              '一级菜单：以 / 开头的绝对路径（如 /dashboard）\n二级及以下：相对路径（如 console、user）'
            ),
            key: 'path',
            type: 'input',
            props: { placeholder: '如：/dashboard 或 console' }
          },
          { label: '权限标识', key: 'label', type: 'input', props: { placeholder: '如：User' } },
          {
            label: createLabelTooltip(
              '关联数据表',
              '用于字段权限控制，选择关联的数据表\n系统会自动从已注册的资源中加载'
            ),
            key: 'resource',
            type: 'select',
            props: {
              options: resourceOptions.value,
              placeholder: '选择关联数据表',
              clearable: true,
              filterable: true
            }
          },
          {
            label: createLabelTooltip(
              '组件路径',
              '一级父级菜单：填写 /index/index\n具体页面：填写组件路径（如 /system/user）\n目录菜单：留空'
            ),
            key: 'component',
            type: 'input',
            props: { placeholder: '如：/system/user 或留空' }
          },
          { label: '图标', key: 'icon' },
          {
            label: createLabelTooltip(
              '角色权限',
              '仅用于前端权限模式：配置角色标识（如 R_SUPER、R_ADMIN）\n后端权限模式：无需配置'
            ),
            key: 'roles',
            type: 'inputtag',
            props: { placeholder: '输入角色标识后按回车，如：R_SUPER' }
          },
          {
            label: '菜单排序',
            key: 'sort',
            type: 'number',
            props: { min: 1, controlsPosition: 'right', style: { width: '100%' } } 
          },
          {
            label: createLabelTooltip(
              '外部链接',
              '填写完整 URL 后，点击该菜单时：\n· 「是否内嵌」关闭 → 新标签页打开外链\n· 「是否内嵌」开启 → 在页面内 iframe 中嵌入显示'
            ),
            key: 'link',
            type: 'input',
            props: { placeholder: '如：https://www.example.com' }
          },
          {
            label: '文本徽章',
            key: 'showTextBadge',
            type: 'input',
            props: { placeholder: '如：New、Hot' }
          },
          {
            label: createLabelTooltip(
              '激活路径',
              '用于详情页等隐藏菜单，指定高亮显示的父级菜单路径\n例如：用户详情页高亮显示"用户管理"菜单'
            ),
            key: 'activePath',
            type: 'input',
            props: { placeholder: '如：/system/user' }
          },
          { label: '是否启用', key: 'isEnable', type: 'switch', span: switchSpan },
          { label: '页面缓存', key: 'keepAlive', type: 'switch', span: switchSpan },
          { label: '隐藏菜单', key: 'isHide', type: 'switch', span: switchSpan },
          { label: '是否内嵌', key: 'isIframe', type: 'switch', span: switchSpan },
          { label: '显示徽章', key: 'showBadge', type: 'switch', span: switchSpan },
          { label: '固定标签', key: 'fixedTab', type: 'switch', span: switchSpan },
          { label: '标签隐藏', key: 'isHideTab', type: 'switch', span: switchSpan },
          { label: '全屏页面', key: 'isFullPage', type: 'switch', span: switchSpan }
        ]
      } else {
        return [
          ...baseItems,
          {
            label: '权限名称',
            key: 'authName',
            type: 'input',
            props: { placeholder: '如：新增、编辑、删除' }
          },
          {
            label: '权限标识',
            key: 'authLabel',
            type: 'input',
            props: { placeholder: '如：add、edit、delete' }
          },
          {
            label: '权限排序',
            key: 'authSort',
            type: 'number',
            props: { min: 1, controlsPosition: 'right', style: { width: '100%' } }
          }
        ]
      }
    })
  
    const dialogTitle = computed(() => {
      const typeMap = { directory: '目录', menu: '菜单', button: '按钮' }
      const type = typeMap[form.menuType] || '菜单'
      return isEdit.value ? `编辑${type}` : `新建${type}`
    })
  
    /**
     * 是否禁用菜单类型切换
     */
    const disableMenuType = computed(() => {
      if (isEdit.value) return true
      if (!isEdit.value && form.menuType === 'menu' && props.lockType) return true
      return false
    })
  
    // 监听弹窗打开，初始化parentId和resource
    watch(() => props.visible, (val) => {
      if (val) {
        nextTick(() => {
          // parentId: null=未选择（顶级），数字=选中的上级菜单ID
          const pid = props.parentMenu?.id || props.editData?.parentId
          form.parentId = (pid && pid > 0) ? pid : null
          form.resource = props.editData?.resource || ''
        })
      }
    })
  
    /**
     * 重置表单数据
     */
    const resetForm = (): void => {
      formRef.value?.reset()
      form.id = 0
      form.menuType = 'menu'
    }
  
    /**
     * 加载表单数据（编辑模式）
     */
    const loadFormData = (): void => {
      if (!props.editData) return
  
      isEdit.value = true
  
      if (form.menuType === 'directory' || form.menuType === 'menu') {
        const row = props.editData
        form.id = row.id || 0
        // ⚠️ 不要在这里设置parentId和resource，在watch中已经设置了
        // form.parentId 和 form.resource 已在watch中正确设置
        form.name = formatMenuTitle(row.meta?.title || '')
        form.path = row.path || ''
        form.label = row.name || ''
        form.component = row.component || ''
        form.icon = row.meta?.icon || ''
        form.sort = row.meta?.sort || 1
        form.isMenu = row.meta?.isMenu ?? true
        form.keepAlive = row.meta?.keepAlive ?? false
        form.isHide = row.meta?.isHide ?? false
        form.isHideTab = row.meta?.isHideTab ?? false
        form.isEnable = row.meta?.isEnable ?? true
        form.link = row.meta?.link || ''
        form.isIframe = row.meta?.isIframe ?? false
        form.showBadge = row.meta?.showBadge ?? false
        form.showTextBadge = row.meta?.showTextBadge || ''
        form.fixedTab = row.meta?.fixedTab ?? false
        form.activePath = row.meta?.activePath || ''
        form.roles = row.meta?.roles || []
        form.isFullPage = row.meta?.isFullPage ?? false
      } else {
        const row = props.editData
        form.authName = row.title || ''
        form.authLabel = row.authMark || ''
        form.authIcon = row.icon || ''
        form.authSort = row.sort || 1
      }
    }
  
    /**
     * 提交表单
     */
    const handleSubmit = async (): Promise<void> => {
      if (!formRef.value) return
  
      try {
        await formRef.value.validate()
        emit('submit', { ...form })
        // 不关闭弹窗、不提示，完全由父组件控制
      } catch {
        // 表单校验失败
      }
    }
  
    /**
     * 取消操作
     */
    const handleCancel = (): void => {
      emit('update:visible', false)
    }
  
    /**
     * 对话框关闭后的回调
     */
    const handleClosed = (): void => {
      resetForm()
      isEdit.value = false
    }
  
    /**
     * 监听对话框显示状态
     */
    watch(
      () => props.visible,
      async (newVal) => {
        if (newVal) {
          form.menuType = props.type
          
          // 确保资源列表已加载
          if (resourceOptions.value.length === 0) {
            await loadResources()
          }
          
          await nextTick()
          
          if (props.editData) {
            // 先加载表单数据
            loadFormData()
            // 然后设置parentId和resource
            const pid = props.parentMenu?.id || props.editData?.parentId
            form.parentId = (pid && pid > 0) ? pid : null
            form.resource = props.editData?.resource || ''
          } else {
            // 新建模式，使用parentMenu
            form.id = 0
            form.parentId = props.parentMenu?.id || null
            form.resource = ''
          }
        }
      }
    )
  
    /**
     * 监听菜单类型变化
     */
    watch(
      () => props.type,
      (newType) => {
        if (props.visible) {
          form.menuType = newType
        }
      }
    )
  </script>
  