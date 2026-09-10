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
	"bytes"
	"context"
	"io"
	"strings"
	"time"

	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/net/ghttp"
	"github.com/gogf/gf/v2/os/gctx"
	"github.com/gogf/gf/v2/util/gconv"

	"xygo/internal/library/contexts"
	logLogic "xygo/internal/logic/log"
	"xygo/internal/model/entity"
	"xygo/internal/service"
)

// operationLogConfig 操作日志配置
type operationLogConfig struct {
	// 需要记录日志的 HTTP 方法（写操作）
	methods map[string]bool
	// 不记录日志的精确路径
	excludePaths map[string]bool
	// 不记录日志的路径后缀（查询类接口虽然用 POST，但本质是读操作）
	excludeSuffixes []string
}

var opLogConfig = operationLogConfig{
	methods: map[string]bool{
		"POST":   true,
		"PUT":    true,
		"DELETE": true,
	},
	excludePaths: map[string]bool{
		"/admin/auth/login":  true, // 登录单独在 LoginLog 记录
		"/admin/auth/logout": true, // 登出不需要记录操作日志
		"/admin/upload/file": true, // 文件上传（multipart 二进制，不宜入库）
	},
	excludeSuffixes: []string{
		"/list",   // 列表查询
		"/detail", // 详情查询
		"/info",   // 信息查询
		"/tree",   // 树形查询
		"/select", // 下拉选项查询
		"/option",
		"/options",
	},
}

// OperationLog 操作日志中间件
// 仅对后台管理的写操作（POST/PUT/DELETE）进行记录
func OperationLog(r *ghttp.Request) {
	// 只记录写操作
	if !opLogConfig.methods[r.Method] {
		r.Middleware.Next()
		return
	}

	// 排除不需要记录的精确路径
	if opLogConfig.excludePaths[r.URL.Path] {
		r.Middleware.Next()
		return
	}

	// 排除查询类接口（路径以 /list、/detail 等结尾的 POST 请求本质是读操作）
	for _, suffix := range opLogConfig.excludeSuffixes {
		if strings.HasSuffix(r.URL.Path, suffix) {
			r.Middleware.Next()
			return
		}
	}

	// 记录请求开始时间
	startTime := time.Now()

	// ---- 在 goroutine 之前提取所有请求相关数据 ----

	// 请求基本信息
	method := r.Method
	urlPath := r.URL.Path
	ua := r.Header.Get("User-Agent")
	ip := logLogic.GetClientIP(r.GetCtx())
	traceId := gctx.CtxId(r.GetCtx()) // ✨ 提取 TraceId 用于全链路串联

	// 读取请求体（需要在 Next 之前读取，否则可能被消费掉）
	requestBody := captureRequestBody(r)

	// 获取当前用户信息（AdminAuth 中间件已设置 context）
	var userId uint
	var username string
	user := contexts.GetUser(r.GetCtx())
	if user != nil {
		userId = uint(user.Id)
		username = user.Username
	}

	// 获取 API 路由信息（module 和 title），从菜单缓存中查找
	module, title := getRouteInfo(r)

	// 执行后续处理
	r.Middleware.Next()

	// ---- Next() 之后提取响应数据 ----
	responseBody := r.Response.BufferString()
	var status int = 1
	var errorMessage string
	if r.GetError() != nil {
		status = 0
		errorMessage = r.GetError().Error()
	}
	elapsed := time.Since(startTime).Milliseconds()

	// ✨ 慢查询阈值检测（复用操作日志的耗时数据）
	slowQueryEnabled := g.Cfg().MustGet(r.GetCtx(), "performance.slowQuery.enabled").Bool()
	if slowQueryEnabled && elapsed > 0 {
		threshold := g.Cfg().MustGet(r.GetCtx(), "performance.slowQuery.threshold").Int64()
		if threshold <= 0 {
			threshold = 200
		}
		if elapsed >= threshold {
			g.Log().Warningf(r.GetCtx(),
				"[慢操作] %s %s | 耗时: %dms | 阈值: %dms | 用户: %s | TraceId: %s",
				method, urlPath, elapsed, threshold, username, traceId,
			)
		}
	}

	// 异步写入数据库（使用独立 context，避免请求结束后被取消）
	go func() {
		// 用 g.Map 构造数据，避免 Entity 字段类型在 MySQL/PG 间不一致导致编译错误
		log := new(entity.AdminOperationLog)
		gconv.Struct(g.Map{
			"user_id":       userId,
			"username":      username,
			"module":        module,
			"title":         title,
			"method":        method,
			"url":           urlPath,
			"ip":            ip,
			"user_agent":    ua,
			"request_body":  requestBody,
			"response_body": responseBody,
			"error_message": errorMessage,
			"status":        status,
			"elapsed":       elapsed,
			"created_at":    logLogic.NowTime(),
		}, log)

		service.AdminLog().RecordOperationLog(context.Background(), log)
	}()
}

func isFileUploadRequest(r *ghttp.Request) bool {
	ct := strings.ToLower(r.Header.Get("Content-Type"))
	if strings.Contains(ct, "multipart/form-data") {
		return true
	}
	path := strings.ToLower(r.URL.Path)
	return strings.Contains(path, "/upload")
}

func captureRequestBody(r *ghttp.Request) string {
	if isFileUploadRequest(r) {
		return "[file upload omitted]"
	}
	body := r.GetBodyString()
	if body == "" {
		bodyBytes, _ := io.ReadAll(r.Body)
		if len(bodyBytes) > 0 {
			body = string(bodyBytes)
			r.Body = io.NopCloser(bytes.NewBuffer(bodyBytes))
		}
	}
	if len(body) > 4096 {
		return body[:4096] + "...(truncated)"
	}
	return body
}

// getRouteInfo 从菜单表缓存中查找模块名称和操作标题
// 优先使用菜单表的权限点匹配，fallback 到 URL 路径解析
func getRouteInfo(r *ghttp.Request) (module, title string) {
	path := r.URL.Path
	perm := r.Method + " " + path

	// 从菜单缓存中查找
	info := logLogic.GetRouteInfoByPerm(r.GetCtx(), perm)
	if info != nil {
		return info.Module, info.Title
	}

	// fallback: 从 URL 路径动态提取
	parts := strings.Split(strings.Trim(path, "/"), "/")
	if len(parts) >= 3 {
		module = strings.Join(parts[1:len(parts)-1], "/")
	} else if len(parts) >= 2 {
		module = parts[1]
	} else {
		module = path
	}
	title = r.Method + " " + path

	return
}
