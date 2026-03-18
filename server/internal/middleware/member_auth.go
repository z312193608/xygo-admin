// +----------------------------------------------------------------------
// | XYGo Admin [ Vue3 + GoFrame 企业级中后台管理系统 ]
// +----------------------------------------------------------------------
// | Copyright (c) 2026 大连星韵网络科技有限公司 All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( https://opensource.org/licenses/MIT )
// +----------------------------------------------------------------------
// | Author: 喜羊羊 <751300685@qq.com>
// +----------------------------------------------------------------------

package middleware

import (
	"github.com/gogf/gf/v2/errors/gerror"
	"github.com/gogf/gf/v2/net/ghttp"

	"xygo/internal/consts"
	"xygo/internal/library/contexts"
	"xygo/internal/library/token"
	"xygo/internal/service"
)

// 始终放行的接口（不受会员中心开关影响，站点导航需要）
var memberAlwaysAllow = []string{
	"/member/user/menus", // 前台菜单（返回 nav 导航 + 公开菜单，站点运行必需）
}

// 会员接口白名单（无需登录即可访问，但受会员中心开关控制）
var memberWhitelist = []string{
	"/member/auth/login",
	"/member/auth/register",
	"/member/auth/captcha",
	"/member/auth/checkCaptcha",
	"/member/user/menus", // 菜单接口：有 token 返回完整菜单，无 token 返回公开菜单
	"/wm/auth/login",         // 微信小程序登录接口
	"/wm/oa/auth/url",        // 公众号授权URL
	"/wm/oa/auth/callback",   // 公众号授权回调
}

// isMemberCenterOpen 检查会员中心是否开启（从 basics 分组读取 open_member_center）
func isMemberCenterOpen(r *ghttp.Request) bool {
	cfgSvc := service.SysConfig()
	if cfgSvc == nil {
		return true // 服务未初始化时默认开启
	}
	items, err := cfgSvc.GetConfigByGroup(r.Context(), "basics")
	if err != nil {
		return true // 读取失败时默认开启
	}
	if v, ok := items["open_member_center"]; ok && v == "0" {
		return false
	}
	return true
}

// MemberAuth 会员接口鉴权中间件
// - 始终放行菜单接口（站点导航不受开关影响）
// - 检查会员中心是否开启
// - 从 Header 获取 Xy-User-Token
// - 验证通过后注入会员信息到上下文
func MemberAuth(r *ghttp.Request) {
	path := r.URL.Path

	// 初始化自定义上下文
	customCtx := &contexts.Context{
		Module: "member",
	}
	contexts.Init(r, customCtx)

	// 1. 始终放行的接口（如菜单），不受会员中心开关影响
	for _, p := range memberAlwaysAllow {
		if path == p {
			tokenStr := r.Header.Get("Xy-User-Token")
			if tokenStr != "" {
				if memberUser, err := token.ParseMember(r.Context(), tokenStr); err == nil {
					contexts.SetMember(r.Context(), memberUser)
				}
			}
			r.Middleware.Next()
			return
		}
	}

	// 2. 会员中心关闭时，拒绝其余所有会员接口（登录/注册/认证接口等）
	if !isMemberCenterOpen(r) {
		r.SetError(gerror.NewCode(consts.CodeBusinessError, "会员中心已禁用，请联系网站管理员开启"))
		return
	}

	// 3. 白名单接口：放行但仍尝试解析 Token（有则注入上下文，无则跳过）
	for _, p := range memberWhitelist {
		if path == p {
			tokenStr := r.Header.Get("Xy-User-Token")
			if tokenStr != "" {
				if memberUser, err := token.ParseMember(r.Context(), tokenStr); err == nil {
					contexts.SetMember(r.Context(), memberUser)
				}
			}
			r.Middleware.Next()
			return
		}
	}

	// 4. 获取会员 Token（使用 Xy-User-Token 头）
	tokenStr := r.Header.Get("Xy-User-Token")
	if tokenStr == "" {
		r.SetError(gerror.NewCode(consts.CodeNotAuthorized, "请先登录"))
		return
	}

	// 5. 解析 Token（使用 member 应用名）
	memberUser, err := token.ParseMember(r.Context(), tokenStr)
	if err != nil {
		r.SetError(gerror.NewCode(consts.CodeNotAuthorized, "登录已过期，请重新登录"))
		return
	}

	// 注入会员信息到上下文
	contexts.SetMember(r.Context(), memberUser)

	r.Middleware.Next()
}
