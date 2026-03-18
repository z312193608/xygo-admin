// +----------------------------------------------------------------------
// | XYGo Admin [ Vue3 + GoFrame 企业级中后台管理系统 ]
// +----------------------------------------------------------------------
// | Copyright (c) 2026 大连星韵网络科技有限公司 All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( https://opensource.org/licenses/MIT )
// +----------------------------------------------------------------------
// | Author: 喜羊羊 <751300685@qq.com>
// +----------------------------------------------------------------------

// =================================================================================
// 微信小程序登录（复用 Member 体系，适用于小游戏/小程序场景）
// =================================================================================

package wm

import (
	"context"
	"fmt"
	"io"
	"net/http"

	"github.com/gogf/gf/v2/encoding/gjson"
	"github.com/gogf/gf/v2/errors/gerror"
	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/net/ghttp"
	"github.com/gogf/gf/v2/os/gtime"
	"golang.org/x/crypto/bcrypt"

	"xygo/internal/consts"
	"xygo/internal/dao"
	"xygo/internal/library/token"
	"xygo/internal/model"
	"xygo/internal/model/entity"
	"xygo/internal/model/input/wmin"
	"xygo/internal/service"
)

type sWmAuth struct{}

func NewWmAuth() *sWmAuth {
	return &sWmAuth{}
}

// WxLogin 微信小程序 code 登录
//
// 流程：
//  1. 从 xy_sys_config 读取 wm 分组的 appid / appsecret
//  2. 调用微信 jscode2session 换取 openid + session_key
//  3. 按 openid 查 xy_member，不存在则自动注册
//  4. 复用 token.GenerateMember 生成 JWT
func (s *sWmAuth) WxLogin(ctx context.Context, in *wmin.WxLoginInput) (out *wmin.WxLoginOutput, err error) {
	// ---- 1. 从数据库配置表读取微信参数 ----
	cfg, err := service.SysConfig().GetConfigByGroup(ctx, "we_mapp")
	if err != nil {
		return nil, gerror.NewCode(consts.CodeServerError, "读取小程序配置失败")
	}
	appId := cfg["wmapp_appid"]
	appSecret := cfg["wmapp_secret"]
	if appId == "" || appSecret == "" {
		return nil, gerror.NewCode(consts.CodeServerError, "小程序 appid / appsecret 未配置，请在后台-系统配置中填写")
	}

	// ---- 2. 调用微信 code2Session ----
	openid, sessionKey, err := code2Session(appId, appSecret, in.Code)
	if err != nil {
		return nil, gerror.NewCode(consts.CodeServerError, "微信登录失败: "+err.Error())
	}

	// 获取客户端信息（用于登录日志）
	ip := getWmClientIP(ctx)
	ua := ""
	if r := ghttp.RequestFromCtx(ctx); r != nil {
		ua = r.Header.Get("User-Agent")
	}

	// ---- 3. 查询或自动注册会员 ----
	var member *entity.Member
	err = dao.Member.Ctx(ctx).Where("openid_mapp", openid).Scan(&member)
	if err != nil {
		return nil, err
	}

	isNew := false

	if member == nil {
		// 自动注册
		isNew = true
		now := gtime.Now().Unix()
		dummyPwd, _ := bcrypt.GenerateFromPassword([]byte("wx_"+openid), bcrypt.DefaultCost)
		shortId := openid
		if len(shortId) > 16 {
			shortId = shortId[len(shortId)-16:]
		}
		result, insertErr := dao.Member.Ctx(ctx).Data(g.Map{
			"username":     "wx_" + shortId,
			"password":     string(dummyPwd),
			"nickname":     "微信用户",
			"mobile":       "wx_" + shortId,
			"openid_mapp":  openid,
			"session_key":  sessionKey,
			"status":      1,
			"group_id":    1,
			"level":       1,
			"score":       0,
			"created_at":  now,
			"updated_at":  now,
		}).Insert()
		if insertErr != nil {
			return nil, gerror.NewCode(consts.CodeServerError, "创建用户失败")
		}
		id, _ := result.LastInsertId()
		err = dao.Member.Ctx(ctx).Where("id", id).Scan(&member)
		if err != nil || member == nil {
			return nil, gerror.NewCode(consts.CodeServerError, "用户创建后查询失败")
		}
	} else {
		// 已存在用户：更新 session_key
		_, _ = dao.Member.Ctx(ctx).Where("id", member.Id).Data(g.Map{
			"session_key": sessionKey,
		}).Update()
	}

	// ---- 4. 生成 JWT Token（复用 Member 体系） ----
	memberUser := model.MemberUser{
		Id:       member.Id,
		Username: member.Username,
		Nickname: member.Nickname,
		Avatar:   member.Avatar,
		Email:    member.Email,
		Mobile:   member.Mobile,
		Gender:   member.Gender,
		Level:    uint(member.Level),
		GroupId:  member.GroupId,
		Score:    member.Score,
		Money:    member.Money,
		LoginAt:  gtime.Now().Unix(),
	}

	accessToken, expiresIn, err := token.GenerateMember(ctx, memberUser)
	if err != nil {
		return nil, gerror.NewCode(consts.CodeServerError, "Token 生成失败")
	}

	// ---- 5. 更新登录信息 ----
	_, _ = dao.Member.Ctx(ctx).Where("id", member.Id).Data(g.Map{
		"last_login_at": gtime.Now().Unix(),
		"last_login_ip": ip,
		"login_count":   member.LoginCount + 1,
	}).Update()

	// 异步记录登录日志
	go func() {
		_, _ = dao.MemberLoginLog.Ctx(context.Background()).Data(g.Map{
			"member_id":  member.Id,
			"username":   member.Username,
			"ip":         ip,
			"user_agent": ua,
			"status":     1,
			"message":    "微信小程序登录",
		}).Insert()
	}()

	return &wmin.WxLoginOutput{
		Token:     accessToken,
		ExpiresIn: expiresIn,
		IsNew:     isNew,
	}, nil
}
// code2Session 调用微信 jscode2session 接口
func code2Session(appId, appSecret, code string) (openid, sessionKey string, err error) {
	url := fmt.Sprintf(
		"https://api.weixin.qq.com/sns/jscode2session?appid=%s&secret=%s&js_code=%s&grant_type=authorization_code",
		appId, appSecret, code,
	)

	resp, err := http.Get(url)
	if err != nil {
		return "", "", fmt.Errorf("请求微信 API 失败: %w", err)
	}
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return "", "", fmt.Errorf("读取响应失败: %w", err)
	}

	j, err := gjson.DecodeToJson(body)
	if err != nil {
		return "", "", fmt.Errorf("解析响应失败: %w", err)
	}

	if errcode := j.Get("errcode").Int(); errcode != 0 {
		return "", "", fmt.Errorf("微信返回错误(%d): %s", errcode, j.Get("errmsg").String())
	}

	openid = j.Get("openid").String()
	sessionKey = j.Get("session_key").String()
	if openid == "" {
		return "", "", fmt.Errorf("未获取到 openid")
	}

	return openid, sessionKey, nil
}

// getWmClientIP 获取客户端 IP（支持代理头）
func getWmClientIP(ctx context.Context) string {
	r := g.RequestFromCtx(ctx)
	if r == nil {
		return ""
	}
	ip := r.Header.Get("X-Forwarded-For")
	if ip != "" {
		for i, c := range ip {
			if c == ',' {
				ip = ip[:i]
				break
			}
		}
	} else {
		ip = r.Header.Get("X-Real-IP")
		if ip == "" {
			ip = r.GetClientIp()
		}
	}
	if ip == "::1" || ip == "[::1]" {
		ip = "127.0.0.1"
	}
	return ip
}
