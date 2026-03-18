import { post, get } from '@/utils/request'

export const wxMappLogin = (code) => post('/wm/auth/login', { code })

export const oaAuthUrl = (redirect) => get('/wm/oa/auth/url', { redirect })

export const oaCallback = (code, state) => get('/wm/oa/auth/callback', { code, state })

export const getProfile = () => get('/wm/auth/profile')
