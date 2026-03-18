// +----------------------------------------------------------------------
// | XYGo Admin [ Vue3 + GoFrame 企业级中后台管理系统 ]
// +----------------------------------------------------------------------
// | Copyright (c) 2026 大连星韵网络科技有限公司 All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( https://opensource.org/licenses/MIT )
// +----------------------------------------------------------------------
// | Author: 喜羊羊 <751300685@qq.com>
// +----------------------------------------------------------------------

package wm

import (
	"context"

	"github.com/gogf/gf/v2/errors/gerror"

	wmApi "xygo/api/wm"
	"xygo/internal/consts"
	"xygo/internal/library/contexts"
	"xygo/internal/model/input/wmin"
	"xygo/internal/service"
)

// WxLogin 微信小程序 code 登录
func (c *ControllerV1) WxLogin(ctx context.Context, req *wmApi.WxLoginReq) (res *wmApi.WxLoginRes, err error) {
	output, err := service.WmAuth().WxLogin(ctx, &wmin.WxLoginInput{
		Code: req.Code,
	})
	if err != nil {
		return nil, err
	}

	return &wmApi.WxLoginRes{
		WxLoginOutput: output,
	}, nil
}

// OaAuthUrl 获取公众号授权跳转URL
func (c *ControllerV1) OaAuthUrl(ctx context.Context, req *wmApi.OaAuthUrlReq) (res *wmApi.OaAuthUrlRes, err error) {
	output, err := service.WmAuth().OaAuthUrl(ctx, &wmin.OaAuthUrlInput{
		Redirect: req.Redirect,
	})
	if err != nil {
		return nil, err
	}

	return &wmApi.OaAuthUrlRes{
		Url: output.Url,
	}, nil
}

// OaCallback 公众号授权回调
func (c *ControllerV1) OaCallback(ctx context.Context, req *wmApi.OaCallbackReq) (res *wmApi.OaCallbackRes, err error) {
	output, err := service.WmAuth().OaCallback(ctx, &wmin.OaCallbackInput{
		Code:  req.Code,
		State: req.State,
	})
	if err != nil {
		return nil, err
	}

	return &wmApi.OaCallbackRes{
		OaCallbackOutput: output,
	}, nil
}

// Profile 获取当前登录用户信息
func (c *ControllerV1) Profile(ctx context.Context, req *wmApi.ProfileReq) (res *wmApi.ProfileRes, err error) {
	member := contexts.GetMember(ctx)
	if member == nil {
		return nil, gerror.NewCode(consts.CodeNotAuthorized, "请先登录")
	}

	return &wmApi.ProfileRes{
		Id:       member.Id,
		Nickname: member.Nickname,
		Avatar:   member.Avatar,
		Score:    member.Score,
		Money:    member.Money,
		Level:    int(member.Level),
	}, nil
}
