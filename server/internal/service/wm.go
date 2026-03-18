package service

import (
	"context"
	"xygo/internal/model/input/wmin"
)

type (
	IWmAuth interface {
		// WxLogin 微信小程序 code 登录（自动注册）
		WxLogin(ctx context.Context, in *wmin.WxLoginInput) (out *wmin.WxLoginOutput, err error)
		// OaAuthUrl 生成公众号网页授权跳转URL
		OaAuthUrl(ctx context.Context, in *wmin.OaAuthUrlInput) (out *wmin.OaAuthUrlOutput, err error)
		// OaCallback 公众号网页授权回调处理
		OaCallback(ctx context.Context, in *wmin.OaCallbackInput) (out *wmin.OaCallbackOutput, err error)
	}
)

var (
	localWmAuth IWmAuth
)

func WmAuth() IWmAuth {
	if localWmAuth == nil {
		panic("implement not found for interface IWmAuth, forgot register?")
	}
	return localWmAuth
}

func RegisterWmAuth(i IWmAuth) {
	localWmAuth = i
}
