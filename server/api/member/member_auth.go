// +----------------------------------------------------------------------
// | XYGo Admin [ Vue3 + GoFrame 企业级中后台管理系统 ]
// +----------------------------------------------------------------------
// | Copyright (c) 2026 大连星韵网络科技有限公司 All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( https://opensource.org/licenses/MIT )
// +----------------------------------------------------------------------
// | Author: 喜羊羊 <751300685@qq.com>
// +----------------------------------------------------------------------

package member

import "github.com/gogf/gf/v2/frame/g"

// ==================== 登录 ====================

// LoginReq 会员登录请求
type LoginReq struct {
	g.Meta    `path:"/auth/login" method:"post" tags:"会员认证" summary:"会员登录"`
	Username  string `json:"username" v:"required#请输入用户名"`
	Password  string `json:"password" v:"required#请输入密码"`
	Captcha   string `json:"captcha"`
	CaptchaId string `json:"captchaId"`
}

// LoginRes 会员登录响应
type LoginRes struct {
	Token     string `json:"token"`
	ExpiresIn int64  `json:"expiresIn"`
}

// ==================== 注册 ====================

// RegisterReq 会员注册请求
type RegisterReq struct {
	g.Meta   `path:"/auth/register" method:"post" tags:"会员认证" summary:"会员注册"`
	Username string `json:"username" v:"required|length:4,20#请输入用户名|用户名长度4-20位"`
	Password string `json:"password" v:"required|length:6,32#请输入密码|密码长度6-32位"`
	Mobile   string `json:"mobile" v:"required|phone#请输入手机号|手机号格式不正确"`
	Email    string `json:"email" v:"email#邮箱格式不正确"`
	Code     string `json:"code"` // 验证码（可选）
}

// RegisterRes 会员注册响应
type RegisterRes struct {
	Id uint64 `json:"id"`
}

// ==================== 退出登录 ====================

// LogoutReq 会员退出登录请求
type LogoutReq struct {
	g.Meta `path:"/auth/logout" method:"post" tags:"会员认证" summary:"退出登录"`
}

// LogoutRes 会员退出登录响应
type LogoutRes struct{}

// 注：验证码已统一到公共接口 /captcha/click 和 /captcha/checkClick
// 前后台共用，无需在 member 模块下重复定义
