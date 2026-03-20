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
  <main class="pt-20 pb-8 px-6 flex items-center justify-center min-h-[80vh]">
    <!-- 会员中心已禁用提示 -->
    <div v-if="!memberCenterOpen" class="w-full max-w-md">
      <div class="bg-white/70 backdrop-blur-2xl rounded-[48px] shadow-clay-deep border border-[#d1d9e6]/40 p-10 md:p-12 text-center">
        <div class="w-20 h-20 rounded-[24px] bg-[#f0f3f8] shadow-clay-pressed flex items-center justify-center mx-auto mb-6">
          <ArtSvgIcon icon="ri:lock-2-line" class="text-[36px] text-clay-muted" />
        </div>
        <h2 class="font-heading font-black text-2xl text-clay-foreground mb-3">会员中心已关闭</h2>
        <p class="text-clay-muted font-medium leading-relaxed">会员中心已禁用，请联系网站管理员开启。</p>
        <RouterLink to="/" class="inline-block mt-8 px-8 py-3 rounded-2xl bg-white shadow-clay-btn hover:shadow-clay-btn-hover font-bold text-clay-foreground active:scale-95 transition-all">
          返回首页
        </RouterLink>
      </div>
    </div>

    <div v-else class="w-full max-w-md relative">
      <div class="bg-white/70 backdrop-blur-2xl rounded-[48px] shadow-clay-deep border border-[#d1d9e6]/40 p-10 md:p-12 relative z-10">
        <!-- Header -->
        <div class="text-center mb-10">
          <img v-if="siteStore.getLogo()" :src="siteStore.getLogo()" alt="logo" class="w-16 h-16 rounded-[20px] shadow-clay-btn mb-6 mx-auto object-cover animate-breathe" />
          <div v-else class="inline-flex w-16 h-16 rounded-[20px] bg-gradient-to-br from-blue-400 to-blue-600 shadow-clay-btn items-center justify-center text-white text-3xl font-black mb-6 animate-breathe">
            {{ siteName.charAt(0) }}
          </div>
          <h1 class="font-heading font-black text-3xl text-clay-foreground mb-2">创建账号</h1>
          <p class="text-clay-muted font-medium">注册 {{ siteName }} 会员</p>
        </div>

        <!-- 表单 -->
        <ElForm ref="formRef" :model="formData" :rules="rules" @keyup.enter="handleSubmit" class="space-y-6">
          <ElFormItem prop="username" class="!mb-0">
            <label class="block text-sm font-bold text-clay-foreground mb-3 ml-1">用户名</label>
            <ElInput v-model.trim="formData.username" placeholder="4-20位字母数字" size="large" class="clay-input">
              <template #prefix>
                <ArtSvgIcon icon="ri:user-line" class="text-lg text-clay-muted" />
              </template>
            </ElInput>
          </ElFormItem>

          <ElFormItem prop="password" class="!mb-0">
            <label class="block text-sm font-bold text-clay-foreground mb-3 ml-1">密码</label>
            <ElInput v-model.trim="formData.password" placeholder="不少于6位" type="password" show-password size="large" class="clay-input">
              <template #prefix>
                <ArtSvgIcon icon="ri:lock-line" class="text-lg text-clay-muted" />
              </template>
            </ElInput>
          </ElFormItem>

          <ElFormItem prop="confirmPassword" class="!mb-0">
            <label class="block text-sm font-bold text-clay-foreground mb-3 ml-1">确认密码</label>
            <ElInput v-model.trim="formData.confirmPassword" placeholder="再次输入密码" type="password" show-password size="large" class="clay-input">
              <template #prefix>
                <ArtSvgIcon icon="ri:lock-line" class="text-lg text-clay-muted" />
              </template>
            </ElInput>
          </ElFormItem>

          <ElFormItem prop="mobile" class="!mb-0">
            <label class="block text-sm font-bold text-clay-foreground mb-3 ml-1">手机号</label>
            <ElInput v-model.trim="formData.mobile" placeholder="请输入手机号" size="large" maxlength="11" class="clay-input">
              <template #prefix>
                <ArtSvgIcon icon="ri:phone-line" class="text-lg text-clay-muted" />
              </template>
            </ElInput>
          </ElFormItem>

          <!-- 协议 -->
          <div class="px-1 pt-2">
            <ElCheckbox v-model="formData.agree">
              <span class="text-xs text-clay-muted">
                我已阅读并同意
                <a href="javascript:;" class="text-clay-accent font-bold">服务条款</a>
                和
                <a href="javascript:;" class="text-clay-accent font-bold">隐私政策</a>
              </span>
            </ElCheckbox>
          </div>

          <!-- 提交按钮 -->
          <button
            type="button"
            class="w-full h-14 rounded-2xl bg-gradient-to-br from-blue-400 to-blue-600 text-white font-black text-lg shadow-clay-btn hover:shadow-clay-btn-hover hover:-translate-y-1 active:scale-95 active:shadow-clay-pressed transition-all duration-300 mt-4 flex items-center justify-center gap-2"
            :disabled="loading"
            @click="handleSubmit"
          >
            <ArtSvgIcon v-if="loading" icon="ri:loader-4-line" class="text-xl animate-spin" />
            {{ loading ? '注册中...' : '立即注册' }}
          </button>
        </ElForm>

        <!-- Footer -->
        <div class="mt-10 text-center">
          <p class="text-sm text-clay-muted font-medium">
            已有账号？
            <RouterLink to="/user/login" class="text-clay-accent font-black hover:underline ml-1">返回登录</RouterLink>
          </p>
        </div>
      </div>

      <!-- 装饰 -->
      <div class="absolute -bottom-8 -right-8 w-24 h-24 rounded-full bg-gradient-to-br from-cyan-300 to-cyan-500 opacity-20 blur-2xl animate-float z-0"></div>
    </div>
  </main>
</template>

<script setup lang="ts">
import { useSiteStore } from '@/store/modules/site'
import { ElMessage, type FormInstance, type FormRules } from 'element-plus'
import { memberRegister } from '@/api/frontend'

defineOptions({ name: 'UserRegister' })

const router = useRouter()
const siteStore = useSiteStore()
const siteName = computed(() => siteStore.getSiteName())
const memberCenterOpen = computed(() => siteStore.isUserCenterEnabled())

const formRef = ref<FormInstance>()
const formData = reactive({
  username: '',
  password: '',
  confirmPassword: '',
  mobile: '',
  agree: false
})

const rules: FormRules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 4, max: 20, message: '用户名长度 4-20 位', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, message: '密码不少于 6 位', trigger: 'blur' }
  ],
  confirmPassword: [
    { required: true, message: '请再次输入密码', trigger: 'blur' },
    {
      validator: (_rule: any, value: string, callback: any) => {
        if (value !== formData.password) {
          callback(new Error('两次密码不一致'))
        } else {
          callback()
        }
      },
      trigger: 'blur'
    }
  ],
  mobile: [
    { required: true, message: '请输入手机号', trigger: 'blur' },
    { pattern: /^1[3-9]\d{9}$/, message: '手机号格式不正确', trigger: 'blur' }
  ]
}

const loading = ref(false)

const handleSubmit = async () => {
  if (!formRef.value) return
  const valid = await formRef.value.validate().catch(() => false)
  if (!valid) return

  if (!formData.agree) {
    ElMessage.warning('请先同意服务条款和隐私政策')
    return
  }

  loading.value = true
  try {
    await memberRegister({
      username: formData.username,
      password: formData.password,
      mobile: formData.mobile
    })
    ElMessage.success('注册成功，请登录')
    router.push('/user/login')
  } catch {
    // 错误已由拦截器处理
  } finally {
    loading.value = false
  }
}
</script>

<style lang="scss" scoped>
.text-clay-foreground { color: #32325d; }
.text-clay-muted { color: #8898aa; }
.text-clay-accent { color: #5a8dee; }
.font-heading { font-family: 'Nunito', 'PingFang SC', sans-serif; }

.shadow-clay-deep {
  box-shadow: 30px 30px 60px #d1d9e6, -30px -30px 60px #ffffff,
    inset 10px 10px 20px rgba(90, 141, 238, 0.05), inset -10px -10px 20px rgba(255, 255, 255, 0.8);
}
.shadow-clay-btn {
  box-shadow: 12px 12px 24px rgba(90, 141, 238, 0.3), -8px -8px 16px rgba(255, 255, 255, 0.4),
    inset 4px 4px 8px rgba(255, 255, 255, 0.4), inset -4px -4px 8px rgba(0, 0, 0, 0.05);
}
.shadow-clay-btn-hover {
  box-shadow: 16px 16px 32px rgba(90, 141, 238, 0.4), -10px -10px 20px rgba(255, 255, 255, 0.5),
    inset 4px 4px 8px rgba(255, 255, 255, 0.4), inset -4px -4px 8px rgba(0, 0, 0, 0.05);
}
.shadow-clay-pressed {
  box-shadow: inset 10px 10px 20px #e0e5ec, inset -10px -10px 20px #ffffff;
}

@keyframes breathe { 0%, 100% { transform: scale(1); } 50% { transform: scale(1.05); } }
.animate-breathe { animation: breathe 6s ease-in-out infinite; }
@keyframes float { 0%, 100% { transform: translateY(0); } 50% { transform: translateY(-20px); } }
.animate-float { animation: float 8s ease-in-out infinite; }

:deep(.clay-input) {
  .el-input__wrapper {
    height: 48px;
    padding: 0 16px;
    border-radius: 16px;
    background: #f0f3f8;
    box-shadow: inset 10px 10px 20px #e0e5ec, inset -10px -10px 20px #ffffff;
    border: none;
    transition: all 0.3s;
    &.is-focus {
      background: #fff;
      box-shadow: 16px 16px 32px rgba(165, 175, 190, 0.3), -10px -10px 24px rgba(255, 255, 255, 0.9),
        inset 6px 6px 12px rgba(90, 141, 238, 0.03), inset -6px -6px 12px rgba(255, 255, 255, 1);
    }
  }
  .el-input__inner { font-weight: 500; color: #32325d; }
}
</style>
