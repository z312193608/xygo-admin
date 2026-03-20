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
// 微信公众号网页授权登录（OAuth2，复用 Member 体系）
// =================================================================================

package wm

import (
	"context"
	"fmt"
	"io"
	"net/http"
	"net/url"

	"github.com/gogf/gf/v2/crypto/gmd5"
	"github.com/gogf/gf/v2/encoding/gjson"
	"github.com/gogf/gf/v2/errors/gerror"
	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/net/ghttp"
	"github.com/gogf/gf/v2/os/gtime"
	"github.com/gogf/gf/v2/util/grand"

	"xygo/internal/consts"
	"xygo/internal/dao"
	"xygo/internal/library/token"
	"xygo/internal/model"
	"xygo/internal/model/entity"
	"xygo/internal/model/input/wmin"
	"xygo/internal/service"
)

// OaAuthUrl 生成公众号网页授权跳转URL
//
// 流程：
//  1. 从 xy_sys_config 读取 we_oa 分组的 appid
//  2. 将 redirect 编码后拼接成微信授权 URL
//  3. state 参数用 redirect 的 md5 做防伪校验
func (s *sWmAuth) OaAuthUrl(ctx context.Context, in *wmin.OaAuthUrlInput) (out *wmin.OaAuthUrlOutput, err error) {
	cfg, err := service.SysConfig().GetConfigByGroup(ctx, "we_oa")
	if err != nil {
		return nil, gerror.NewCode(consts.CodeServerError, "读取公众号配置失败")
	}
	appId := cfg["weoa_appid"]
	if appId == "" {
		return nil, gerror.NewCode(consts.CodeServerError, "公众号 AppID 未配置，请在后台-系统配置中填写")
	}

	r := ghttp.RequestFromCtx(ctx)
	if r == nil {
		return nil, gerror.NewCode(consts.CodeServerError, "无法获取请求上下文")
	}

	callbackUrl := fmt.Sprintf("%s://%s/wm/oa/auth/callback", r.GetSchema(), r.Host)
	state, _ := gmd5.Encrypt(in.Redirect + appId)

	redirectParam := url.QueryEscape(callbackUrl + "?redirect=" + url.QueryEscape(in.Redirect))

	authUrl := fmt.Sprintf(
		"https://open.weixin.qq.com/connect/oauth2/authorize?appid=%s&redirect_uri=%s&response_type=code&scope=snsapi_userinfo&state=%s#wechat_redirect",
		appId, redirectParam, state,
	)

	return &wmin.OaAuthUrlOutput{Url: authUrl}, nil
}

// OaCallback 公众号网页授权回调
//
// 流程：
//  1. 从 xy_sys_config 读取 appid / appsecret
//  2. 用 code 换取 access_token + openid
//  3. 用 access_token 获取用户信息（昵称/头像）
//  4. 按 openid_oa 查 xy_member，不存在则自动注册
//  5. 复用 token.GenerateMember 生成 JWT
func (s *sWmAuth) OaCallback(ctx context.Context, in *wmin.OaCallbackInput) (out *wmin.OaCallbackOutput, err error) {
	cfg, err := service.SysConfig().GetConfigByGroup(ctx, "we_oa")
	if err != nil {
		return nil, gerror.NewCode(consts.CodeServerError, "读取公众号配置失败")
	}
	appId := cfg["weoa_appid"]
	appSecret := cfg["weoa_secret"]
	if appId == "" || appSecret == "" {
		return nil, gerror.NewCode(consts.CodeServerError, "公众号 AppID / AppSecret 未配置")
	}

	// ---- 1. code 换 access_token + openid ----
	openid, accessToken, err := oaCode2Token(appId, appSecret, in.Code)
	if err != nil {
		return nil, gerror.NewCode(consts.CodeServerError, "公众号授权失败: "+err.Error())
	}

	// ---- 2. 获取用户信息 ----
	wxNickname, wxAvatar, _ := oaGetUserInfo(accessToken, openid)

	ip := getWmClientIP(ctx)
	ua := ""
	if r := ghttp.RequestFromCtx(ctx); r != nil {
		ua = r.Header.Get("User-Agent")
	}

	// ---- 3. 通过 member_oauth 表查询或自动注册会员 ----
	var oauth *entity.MemberOauth
	err = dao.MemberOauth.Ctx(ctx).
		Where("platform", "wechat_oa").
		Where("openid", openid).
		Scan(&oauth)
	if err != nil {
		return nil, err
	}

	isNew := false
	var member *entity.Member

	if oauth == nil {
		isNew = true
		now := gtime.Now().Unix()
		salt := grand.S(6)
		shortId := openid
		if len(shortId) > 16 {
			shortId = shortId[len(shortId)-16:]
		}
		nickname := "微信用户"
		if wxNickname != "" {
			nickname = wxNickname
		}
		result, insertErr := dao.Member.Ctx(ctx).Data(g.Map{
			"username":   "oa_" + shortId,
			"password":   gmd5.MustEncryptString("oa_" + openid + salt),
			"salt":       salt,
			"nickname":   nickname,
			"mobile":     "oa_" + shortId,
			"avatar":     wxAvatar,
			"status":     1,
			"group_id":   1,
			"level":      1,
			"score":      0,
			"created_at": now,
			"updated_at": now,
		}).Insert()
		if insertErr != nil {
			return nil, gerror.NewCode(consts.CodeServerError, "创建用户失败")
		}
		memberId, _ := result.LastInsertId()

		_, _ = dao.MemberOauth.Ctx(ctx).Data(g.Map{
			"member_id":  memberId,
			"platform":   "wechat_oa",
			"openid":     openid,
			"nickname":   wxNickname,
			"avatar":     wxAvatar,
			"created_at": now,
			"updated_at": now,
		}).Insert()

		err = dao.Member.Ctx(ctx).Where("id", memberId).Scan(&member)
		if err != nil || member == nil {
			return nil, gerror.NewCode(consts.CodeServerError, "用户创建后查询失败")
		}
	} else {
		err = dao.Member.Ctx(ctx).Where("id", oauth.MemberId).Scan(&member)
		if err != nil || member == nil {
			return nil, gerror.NewCode(consts.CodeServerError, "查询会员信息失败")
		}

		// 更新 oauth 表的昵称头像
		oaUpdate := g.Map{"updated_at": gtime.Now().Unix()}
		memberUpdate := g.Map{}
		if wxNickname != "" {
			oaUpdate["nickname"] = wxNickname
			if member.Nickname == "微信用户" {
				memberUpdate["nickname"] = wxNickname
			}
		}
		if wxAvatar != "" {
			oaUpdate["avatar"] = wxAvatar
			memberUpdate["avatar"] = wxAvatar
		}
		_, _ = dao.MemberOauth.Ctx(ctx).Where("id", oauth.Id).Data(oaUpdate).Update()
		if len(memberUpdate) > 0 {
			_, _ = dao.Member.Ctx(ctx).Where("id", member.Id).Data(memberUpdate).Update()
		}
	}

	// ---- 4. 生成 JWT Token ----
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

	jwtToken, expiresIn, err := token.GenerateMember(ctx, memberUser)
	if err != nil {
		return nil, gerror.NewCode(consts.CodeServerError, "Token 生成失败")
	}

	// ---- 5. 更新登录信息 ----
	_, _ = dao.Member.Ctx(ctx).Where("id", member.Id).Data(g.Map{
		"last_login_at": gtime.Now().Unix(),
		"last_login_ip": ip,
		"login_count":   member.LoginCount + 1,
	}).Update()

	go func() {
		_, _ = dao.MemberLoginLog.Ctx(context.Background()).Data(g.Map{
			"member_id":  member.Id,
			"username":   member.Username,
			"ip":         ip,
			"user_agent": ua,
			"status":     1,
			"message":    "微信公众号登录",
		}).Insert()
	}()

	return &wmin.OaCallbackOutput{
		Token:     jwtToken,
		ExpiresIn: expiresIn,
		IsNew:     isNew,
	}, nil
}

// oaCode2Token 用 code 换取 access_token 和 openid
func oaCode2Token(appId, appSecret, code string) (openid, accessToken string, err error) {
	apiUrl := fmt.Sprintf(
		"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%s&secret=%s&code=%s&grant_type=authorization_code",
		appId, appSecret, code,
	)

	resp, err := http.Get(apiUrl)
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
	accessToken = j.Get("access_token").String()
	if openid == "" {
		return "", "", fmt.Errorf("未获取到 openid")
	}

	return openid, accessToken, nil
}

// oaGetUserInfo 使用 access_token 获取用户信息（昵称/头像）
func oaGetUserInfo(accessToken, openid string) (nickname, avatar string, err error) {
	apiUrl := fmt.Sprintf(
		"https://api.weixin.qq.com/sns/userinfo?access_token=%s&openid=%s&lang=zh_CN",
		accessToken, openid,
	)

	resp, err := http.Get(apiUrl)
	if err != nil {
		return "", "", fmt.Errorf("请求用户信息失败: %w", err)
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
		return "", "", fmt.Errorf("获取用户信息失败(%d): %s", errcode, j.Get("errmsg").String())
	}

	nickname = j.Get("nickname").String()
	avatar = j.Get("headimgurl").String()

	return nickname, avatar, nil
}
