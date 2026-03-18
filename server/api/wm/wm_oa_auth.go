package wm

import (
	"github.com/gogf/gf/v2/frame/g"
	"xygo/internal/model/input/wmin"
)

// OaAuthUrlReq 公众号网页授权 - 获取授权跳转URL
type OaAuthUrlReq struct {
	g.Meta   `path:"/oa/auth/url" method:"get" tags:"公众号认证" summary:"获取公众号授权跳转URL"`
	Redirect string `json:"redirect" v:"required#请提供授权后回跳地址"`
}

// OaAuthUrlRes 公众号网页授权 - 授权URL响应
type OaAuthUrlRes struct {
	Url string `json:"url"`
}

// OaCallbackReq 公众号网页授权 - 回调处理
type OaCallbackReq struct {
	g.Meta `path:"/oa/auth/callback" method:"get" tags:"公众号认证" summary:"公众号授权回调"`
	Code   string `json:"code" v:"required#缺少授权code"`
	State  string `json:"state"`
}

// OaCallbackRes 公众号网页授权 - 回调响应
type OaCallbackRes struct {
	*wmin.OaCallbackOutput
}
