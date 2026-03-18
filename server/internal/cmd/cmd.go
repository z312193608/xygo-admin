// +----------------------------------------------------------------------
// | XYGo Admin [ Vue3 + GoFrame 企业级中后台管理系统 ]
// +----------------------------------------------------------------------
// | Copyright (c) 2026 大连星韵网络科技有限公司 All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( https://opensource.org/licenses/MIT )
// +----------------------------------------------------------------------
// | Author: 喜羊羊 <751300685@qq.com>
// +----------------------------------------------------------------------

package cmd

import (
	"context"
	"net/http"

	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/net/ghttp"
	"github.com/gogf/gf/v2/os/gcmd"
	"github.com/gogf/gf/v2/os/gfile"
	"github.com/gogf/gf/v2/os/gres"

	"xygo/internal/controller/admin"
	"xygo/internal/controller/hello"
	"xygo/internal/controller/member"
	"xygo/internal/controller/site"
	"xygo/internal/controller/system"
	"xygo/internal/controller/wm"
	"xygo/internal/library/cache"
	"xygo/internal/library/monitor"
	"xygo/internal/library/queue"
	cronlogic "xygo/internal/logic/cron"
	"xygo/internal/middleware"
	"xygo/internal/websocket"
)

var (
	Main = gcmd.Command{
		Name:  "main",
		Usage: "main",
		Brief: "start http server",
		Func: func(ctx context.Context, parser *gcmd.Parser) (err error) {
			// ✨ 初始化缓存系统（对齐 HotGo）
			cache.Init(ctx)

			// ✨ 初始化性能监控
			monitor.InitPerformanceMonitor(ctx)

			// ✨ 启动 WebSocket Hub
			websocket.Start()

			// ✨ 启动定时任务调度
			cronlogic.StartAll(ctx)

			// ✨ 初始化消息队列 & 启动消费者
			queue.Init(ctx)
			queue.StartConsumers(ctx)

			s := g.Server()

			// 静态文件服务：前端 dist + 上传文件
			s.SetServerRoot("resource/public/dist")
			s.AddStaticPath("/attachment", "resource/public/attachment")
			s.AddStaticPath("/m", "resource/public/mobile")
			s.SetIndexFolder(false)

			// SPA 回退：404 时返回 index.html 让前端路由接管
			s.BindStatusHandler(http.StatusNotFound, func(r *ghttp.Request) {
				indexPath := "resource/public/dist/index.html"
				if gres.Contains(indexPath) {
					r.Response.WriteStatus(http.StatusOK)
					r.Response.Write(gres.GetContent(indexPath))
				} else if gfile.Exists(indexPath) {
					r.Response.WriteStatus(http.StatusOK)
					r.Response.ServeFile(indexPath)
				}
			})

			// =============== 前端对接路由（受 CORS 白名单保护） ===============
			s.Group("/", func(group *ghttp.RouterGroup) {
				group.Middleware(
					middleware.CORS,            // CORS 白名单（配置化）
					middleware.SlowApiMonitor,  // 慢接口监控
					middleware.ResponseHandler, // 统一响应包装
				)

				// 示例接口（无鉴权）
				group.Bind(
					hello.NewV1(),
				)

				// 系统基础接口（无鉴权）
				group.Bind(
					system.NewV1(),
					site.NewV1(),
				)

			// 后台管理接口（带鉴权）
			group.Group("/", func(ag *ghttp.RouterGroup) {
				ag.Middleware(middleware.AdminAuth)
				ag.Middleware(middleware.DemoGuard)
				ag.Middleware(middleware.OperationLog)
					ag.Bind(
						admin.NewV1(),
					)
				})

			// 会员接口（前台用户，使用 Xy-User-Token）
			group.Group("/member", func(mg *ghttp.RouterGroup) {
				mg.Middleware(middleware.MemberAuth)
				mg.Middleware(middleware.DemoGuard)
				mg.Bind(
					member.NewV1(),
				)
			})
			// 微信小程序接口（复用 MemberAuth 体系，/wm/auth/login 已在白名单）
			group.Group("/wm", func(wg *ghttp.RouterGroup) {
				wg.Middleware(middleware.MemberAuth)
				wg.Bind(
					wm.NewV1(),
				)
			})
			})

			// =============== WebSocket 端点 ===============
			s.Group("/socket", func(group *ghttp.RouterGroup) {
				group.Middleware(middleware.CORS)
				group.Middleware(middleware.WsAuth)
				group.GET("/", websocket.WsHandler)
			})

			// =============== 开放 API 路由（不受 CORS 白名单限制） ===============
			// 用于第三方系统对接（支付回调、订单推送、开放平台等）
			// 安全性通过 API Key / 签名验证保证，而非 CORS
			// s.Group("/api", func(group *ghttp.RouterGroup) {
			// 	group.Middleware(
			// 		middleware.CORSOpen,        // 开放跨域（允许任何来源）
			// 		middleware.ResponseHandler, // 统一响应包装
			// 	)
			// 	// TODO: 添加 API Key / 签名验证中间件
			// 	// group.Middleware(middleware.ApiAuth)
			// 	// group.Bind(openapi.NewV1())
			// })

			s.Run()
			return nil
		},
	}
)
