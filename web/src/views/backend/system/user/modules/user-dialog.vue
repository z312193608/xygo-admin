<template>
  <ElDialog
    v-model="dialogVisible"
    :title="dialogType === 'add' ? '添加用户' : '编辑用户'"
    width="600px"
    align-center
    :close-on-click-modal="false"
  >
    <ElForm ref="formRef" :model="formData" :rules="computedRules" label-width="80px">
      <!-- 头像 -->
      <ElFormItem label="头像">
        <div class="flex-c gap-3">
          <ElAvatar :size="64" :src="formData.avatar || undefined">
            <span class="text-lg">{{ formData.username?.charAt(0) || '?' }}</span>
          </ElAvatar>
          <div>
            <ElButton size="small" @click="triggerAvatarUpload">上传头像</ElButton>
            <ElButton v-if="formData.avatar" size="small" type="danger" link @click="formData.avatar = ''">移除</ElButton>
            <input ref="avatarInput" type="file" accept="image/*" class="hidden" @change="handleAvatarUpload" />
          </div>
        </div>
      </ElFormItem>

      <ElRow :gutter="16">
        <ElCol :span="12">
          <ElFormItem label="用户名" prop="username">
            <ElInput v-model="formData.username" placeholder="请输入用户名" :disabled="dialogType === 'edit'" />
          </ElFormItem>
        </ElCol>
        <ElCol :span="12">
          <ElFormItem label="昵称" prop="nickname">
            <ElInput v-model="formData.nickname" placeholder="请输入昵称" />
          </ElFormItem>
        </ElCol>
      </ElRow>

      <ElRow :gutter="16">
        <ElCol :span="12">
          <ElFormItem label="手机号" prop="mobile">
            <ElInput v-model="formData.mobile" placeholder="请输入手机号" maxlength="11" />
          </ElFormItem>
        </ElCol>
        <ElCol :span="12">
          <ElFormItem label="邮箱" prop="email">
            <ElInput v-model="formData.email" placeholder="请输入邮箱" />
          </ElFormItem>
        </ElCol>
      </ElRow>

      <ElRow :gutter="16">
        <ElCol :span="12">
          <ElFormItem :label="dialogType === 'add' ? '密码' : '新密码'" prop="password">
            <ElInput v-model="formData.password" type="password" :placeholder="dialogType === 'add' ? '请输入密码' : '留空则不修改'" show-password />
          </ElFormItem>
        </ElCol>
        <ElCol :span="12">
          <ElFormItem label="性别" prop="gender">
            <ElSelect v-model="formData.gender" class="!w-full">
              <ElOption label="男" value="1" />
              <ElOption label="女" value="2" />
              <ElOption label="未知" value="0" />
            </ElSelect>
          </ElFormItem>
        </ElCol>
      </ElRow>

      <!-- 部门 -->
      <ElFormItem label="部门" prop="deptId">
        <ElTreeSelect
          v-model="formData.deptId"
          :data="deptTree"
          :props="{ label: 'name', value: 'id', children: 'children' }"
          placeholder="请选择部门"
          clearable
          check-strictly
          :render-after-expand="false"
          class="!w-full"
        />
      </ElFormItem>

      <!-- 角色 -->
      <ElFormItem label="角色" prop="roleIds">
        <ElTreeSelect
          v-model="formData.roleIds"
          :data="roleList"
          :props="{ label: 'name', value: 'id', children: 'children' }"
          multiple
          placeholder="请选择角色"
          check-strictly
          :render-after-expand="false"
          class="!w-full"
        />
      </ElFormItem>

      <!-- 岗位 -->
      <ElFormItem label="岗位" prop="postIds">
        <ElSelect v-model="formData.postIds" multiple placeholder="请选择岗位" class="!w-full">
          <ElOption
            v-for="post in postList"
            :key="post.id"
            :label="post.name"
            :value="post.id"
          />
        </ElSelect>
      </ElFormItem>

      <ElFormItem label="状态" prop="status">
        <ElSwitch v-model="formData.status" :active-value="1" :inactive-value="0" />
      </ElFormItem>
    </ElForm>
    <template #footer>
      <div class="dialog-footer">
        <ElButton @click="dialogVisible = false">取消</ElButton>
        <ElButton type="primary" :loading="submitting" @click="handleSubmit">提交</ElButton>
      </div>
    </template>
  </ElDialog>
</template>

<script setup lang="ts">
  import type { FormInstance, FormRules } from 'element-plus'
  import { fetchGetRoleList } from '@/api/backend/system/role'
  import { fetchGetDeptList } from '@/api/backend/system/dept'
  import { fetchGetPostList } from '@/api/backend/system/post'
  import { fetchGetUserDetail } from '@/api/backend/system/user'
  import { uploadImageApi } from '@/api/backend/common/upload'
  import { ElMessage } from 'element-plus'

  interface Props {
    visible: boolean
    type: string
    userData?: Partial<Api.SystemManage.UserListItem>
  }

  interface Emits {
    (e: 'update:visible', value: boolean): void
    (e: 'submit', formData: any): void
  }

  const props = defineProps<Props>()
  const emit = defineEmits<Emits>()

  // 对话框显示控制
  const dialogVisible = computed({
    get: () => props.visible,
    set: (value) => emit('update:visible', value)
  })

  const dialogType = computed(() => props.type)

  // 表单实例
  const formRef = ref<FormInstance>()
  const submitting = ref(false)
  const avatarInput = ref<HTMLInputElement | null>(null)

  // ==================== 下拉数据源 ====================
  const roleList = ref<any[]>([])
  const deptTree = ref<any[]>([])
  const postList = ref<any[]>([])

  const loadOptions = async () => {
    try {
      // 角色列表
      const roleRes = await fetchGetRoleList({ page: 1, pageSize: 100 }) as any
      roleList.value = roleRes?.list || []
    } catch { /* ignore */ }

    try {
      // 部门树
      deptTree.value = await fetchGetDeptList({})
    } catch { /* ignore */ }

    try {
      // 岗位列表
      const postRes = await fetchGetPostList({ page: 1, pageSize: 100 }) as any
      postList.value = postRes?.list || []
    } catch { /* ignore */ }
  }

  // ==================== 表单数据 ====================
  const formData = reactive({
    id: 0,
    username: '',
    nickname: '',
    mobile: '',
    email: '',
    gender: '1',
    password: '',
    avatar: '',
    deptId: 0 as number | undefined,
    status: 1,
    roleIds: [] as number[],
    postIds: [] as number[]
  })

  // 验证规则（新增时密码必填，编辑时非必填）
  const computedRules = computed<FormRules>(() => ({
    username: [
      { required: true, message: '请输入用户名', trigger: 'blur' },
      { min: 2, max: 20, message: '长度在 2 到 20 个字符', trigger: 'blur' }
    ],
    mobile: [
      { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号格式', trigger: 'blur' }
    ],
    email: [
      { type: 'email', message: '请输入正确的邮箱格式', trigger: 'blur' }
    ],
    password: dialogType.value === 'add'
      ? [
          { required: true, message: '请输入密码', trigger: 'blur' },
          { min: 6, message: '密码至少6位', trigger: 'blur' }
        ]
      : [
          { min: 6, message: '密码至少6位', trigger: 'blur' }
        ],
    gender: [{ required: true, message: '请选择性别', trigger: 'change' }]
  }))

  // ==================== 头像上传 ====================
  const triggerAvatarUpload = () => {
    avatarInput.value?.click()
  }

  const handleAvatarUpload = async (e: Event) => {
    const target = e.target as HTMLInputElement
    const file = target.files?.[0]
    if (!file) return
    target.value = ''

    try {
      const res = await uploadImageApi(file) as any
      if (res?.url) {
        formData.avatar = res.url
        ElMessage.success('头像上传成功')
      }
    } catch {
      ElMessage.error('头像上传失败')
    }
  }

  // ==================== 初始化表单 ====================
  const initFormData = async () => {
    const isEdit = props.type === 'edit' && props.userData
    const row = props.userData

    if (isEdit && row?.id) {
      // 编辑时从详情接口拉取未脱敏数据
      try {
        const detail = await fetchGetUserDetail(row.id) as any
        if (detail) {
          formData.id = detail.id || 0
          formData.username = detail.username || ''
          formData.nickname = detail.nickname || ''
          formData.mobile = detail.mobile || ''
          formData.email = detail.email || ''
          formData.gender = String(detail.gender ?? '0')
          formData.status = detail.status ?? 1
          formData.avatar = detail.avatar || ''
          formData.password = ''
          formData.deptId = detail.deptId || undefined
          formData.roleIds = detail.roleIds || []
          formData.postIds = detail.postIds || []
          return
        }
      } catch { /* fallback to list data */ }

      // 降级：用列表数据（脱敏的）
      formData.id = row.id || 0
      formData.username = row.username || ''
      formData.nickname = row.nickname || ''
      formData.mobile = ''
      formData.email = ''
      formData.gender = row.gender || '0'
      formData.status = row.status ?? 1
      formData.avatar = row.avatar || ''
      formData.password = ''
      formData.deptId = undefined
      formData.roleIds = []
      formData.postIds = []
    } else {
      formData.id = 0
      formData.username = ''
      formData.nickname = ''
      formData.mobile = ''
      formData.email = ''
      formData.gender = '1'
      formData.password = ''
      formData.avatar = ''
      formData.status = 1
      formData.deptId = undefined
      formData.roleIds = []
      formData.postIds = []
    }
  }

  // ==================== 监听弹窗 ====================
  watch(
    () => [props.visible, props.type, props.userData],
    ([visible]) => {
      if (visible) {
        loadOptions()
        initFormData()
        nextTick(() => {
          formRef.value?.clearValidate()
        })
      }
    },
    { immediate: true }
  )

  // ==================== 提交 ====================
  const handleSubmit = async () => {
    if (!formRef.value) return

    await formRef.value.validate((valid) => {
      if (valid) {
        submitting.value = true
        const data = { ...formData }
        // 编辑时如果密码为空则不传
        if (dialogType.value === 'edit' && !data.password) {
          delete (data as any).password
        }
        emit('submit', data)
        submitting.value = false
      }
    })
  }
</script>
