// +----------------------------------------------------------------------
// | XYGo Admin [ Vue3 + GoFrame 企业级中后台管理系统 ]
// +----------------------------------------------------------------------
// | Copyright (c) 2026 大连星韵网络科技有限公司 All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( https://opensource.org/licenses/MIT )
// +----------------------------------------------------------------------
// | Author: 喜羊羊 <751300685@qq.com>
// +----------------------------------------------------------------------

package memberin

// LoginInput 会员登录输入
type LoginInput struct {
	Username  string `json:"username" v:"required#请输入用户名"`
	Password  string `json:"password" v:"required#请输入密码"`
	Captcha   string `json:"captcha"`
	CaptchaId string `json:"captchaId"`
}

// LoginOutput 会员登录输出
type LoginOutput struct {
	Token     string `json:"token"`
	ExpiresIn int64  `json:"expiresIn"`
}

// RegisterInput 会员注册输入
type RegisterInput struct {
	Username string `json:"username" v:"required|length:4,20#请输入用户名|用户名长度4-20位"`
	Password string `json:"password" v:"required|length:6,32#请输入密码|密码长度6-32位"`
	Mobile   string `json:"mobile" v:"required|phone#请输入手机号|手机号格式不正确"`
	Email    string `json:"email" v:"email#邮箱格式不正确"`
	Code     string `json:"code"` // 验证码（可选）
}

// RegisterOutput 会员注册输出
type RegisterOutput struct {
	Id uint64 `json:"id"`
}

// LogoutInput 会员退出输入
type LogoutInput struct{}

// LogoutOutput 会员退出输出
type LogoutOutput struct{}
