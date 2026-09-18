package admin

import (
	"context"
	"fmt"
	"net/url"
	"strings"

	"github.com/gogf/gf/v2/crypto/gmd5"
	"github.com/gogf/gf/v2/errors/gerror"
	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/net/ghttp"
	"github.com/gogf/gf/v2/util/gconv"

	api "xygo/api/admin"
	"xygo/internal/consts"
	"xygo/internal/dao"
	captchaLib "xygo/internal/library/captcha"
	"xygo/internal/library/security"
	"xygo/internal/library/storager"
	"xygo/internal/library/token"
	logLogic "xygo/internal/logic/log"
	"xygo/internal/model"
	"xygo/internal/model/entity"
	"xygo/internal/model/input/adminin"
	"xygo/internal/service"
)

// Login 管理员登录（先做账号密码校验，后续再接 JWT/会话）
func (c *ControllerV1) Login(ctx context.Context, req *api.LoginReq) (res *api.LoginRes, err error) {
	// 获取客户端信息（用于登录日志）
	ip := logLogic.GetClientIP(ctx)
	ua := ""
	if r := ghttp.RequestFromCtx(ctx); r != nil {
		ua = r.Header.Get("User-Agent")
	}
	browser, osName := logLogic.ParseUserAgent(ua)

	// 记录登录日志的辅助函数（使用独立 context，避免请求结束后 ctx 被取消）
	// UserId 类型在 MySQL(uint) 和 PG(uint64) 间不一致，用 gconv.Struct 避免编译错误
	recordLog := func(userId uint, username string, status int, message string) {
		log := new(entity.AdminLoginLog)
		gconv.Struct(g.Map{
			"user_id":    userId,
			"username":   username,
			"ip":         ip,
			"user_agent": ua,
			"browser":    browser,
			"os":         osName,
			"status":     status,
			"message":    message,
			"created_at": logLogic.NowTime(),
		}, log)
		go service.AdminLog().RecordLoginLog(context.Background(), log)
	}

	// ✨ 防暴力破解：检查是否已被锁定
	if locked, remainMin := security.CheckLoginLocked(ctx, ip, req.Username); locked {
		recordLog(0, req.Username, 0, fmt.Sprintf("账号被锁定%d分钟", remainMin))
		return nil, gerror.Newf("登录失败次数过多，请%d分钟后再试", remainMin)
	}

	// 点选验证码必验：缺字段或错误都拒绝，禁止空值绕过
	if !captchaLib.VerifyClick(ctx, req.CaptchaId, req.CaptchaInfo) {
		recordLog(0, req.Username, 0, "验证码错误")
		return nil, gerror.New("验证码错误或已过期，请重试")
	}

	var user *entity.AdminUser

	// 根据用户名查询
	if err = dao.AdminUser.Ctx(ctx).
		Where("username", req.Username).
		Scan(&user); err != nil {
		return nil, err
	}

	if user == nil || user.Status != 1 {
		// ✨ 记录失败次数
		locked, remain := security.RecordLoginFail(ctx, ip, req.Username)
		if locked {
			recordLog(0, req.Username, 0, "连续失败，账号已锁定")
			return nil, gerror.New("登录失败次数过多，账号已临时锁定")
		}
		recordLog(0, req.Username, 0, fmt.Sprintf("账号或密码错误（剩余%d次）", remain))
		return nil, gerror.Newf("账号或密码错误，还可尝试%d次", remain)
	}

	// 简单密码校验：md5(password + salt)
	hashed := gmd5.MustEncryptString(req.Password + user.Salt)
	if hashed != user.Password {
		// ✨ 记录失败次数
		locked, remain := security.RecordLoginFail(ctx, ip, req.Username)
		if locked {
			recordLog(uint(user.Id), req.Username, 0, "连续失败，账号已锁定")
			return nil, gerror.New("登录失败次数过多，账号已临时锁定")
		}
		recordLog(uint(user.Id), req.Username, 0, fmt.Sprintf("密码错误（剩余%d次）", remain))
		return nil, gerror.Newf("账号或密码错误，还可尝试%d次", remain)
	}

	// 查询用户的角色信息（第一个启用的角色）
	var role *entity.AdminRole
	err = dao.AdminRole.Ctx(ctx).
		LeftJoin(dao.AdminUserRole.Table()+" aur", "aur.role_id = "+dao.AdminRole.Table()+".id").
		Where("aur.user_id", user.Id).
		Where(dao.AdminRole.Table()+".status", 1).
		OrderAsc(dao.AdminRole.Table() + ".id").
		Limit(1).
		Scan(&role)
	if err != nil {
		return nil, err
	}

	// 构建完整的 AuthUser 上下文
	var roleId uint64
	var roleKey string
	if role != nil {
		roleId = uint64(role.Id)
		roleKey = role.Key
	}

	authUser := model.AuthUser{
		Id:       user.Id,
		Username: user.Username,
		Nickname: user.Nickname,
		Avatar:   user.Avatar,
		Email:    user.Email,
		Mobile:   user.Mobile,
		Pid:      user.Pid,
		DeptId:   user.DeptId,
		RoleId:   roleId,
		RoleKey:  roleKey,
	}

	// 生成 accessToken + refreshToken
	accessToken, refreshToken, expiresIn, refreshExpiresIn, err := token.Generate(ctx, authUser)
	if err != nil {
		return nil, err
	}

	// ✨ 登录成功，清除失败计数
	security.ClearLoginFail(ctx, ip, req.Username)

	// 记录登录成功日志
	recordLog(uint(user.Id), user.Username, 1, "登录成功")

	res = new(api.LoginRes)
	res.LoginModel = &adminin.LoginModel{
		Id:               user.Id,
		Username:         user.Username,
		Nickname:         user.Nickname,
		AccessToken:      accessToken,
		ExpiresIn:        expiresIn,
		RefreshToken:     refreshToken,
		RefreshExpiresIn: refreshExpiresIn,
	}
	return
}

// Refresh 刷新 accessToken
func (c *ControllerV1) Refresh(ctx context.Context, req *api.RefreshReq) (res *api.RefreshRes, err error) {
	userId, err := token.ValidateRefreshToken(ctx, token.AppAdmin, req.RefreshToken)
	if err != nil {
		return nil, gerror.New("刷新令牌无效或已过期，请重新登录")
	}

	var user *entity.AdminUser
	if err = dao.AdminUser.Ctx(ctx).Where("id", userId).Scan(&user); err != nil {
		return nil, err
	}
	if user == nil || user.Status != 1 {
		return nil, gerror.New("用户不存在或已禁用")
	}

	var role *entity.AdminRole
	_ = dao.AdminRole.Ctx(ctx).
		LeftJoin(dao.AdminUserRole.Table()+" aur", "aur.role_id = "+dao.AdminRole.Table()+".id").
		Where("aur.user_id", user.Id).
		Where(dao.AdminRole.Table()+".status", 1).
		OrderAsc(dao.AdminRole.Table() + ".id").
		Limit(1).
		Scan(&role)

	var roleId uint64
	var roleKey string
	if role != nil {
		roleId = uint64(role.Id)
		roleKey = role.Key
	}

	authUser := model.AuthUser{
		Id:       user.Id,
		Username: user.Username,
		Nickname: user.Nickname,
		Avatar:   user.Avatar,
		Email:    user.Email,
		Mobile:   user.Mobile,
		Pid:      user.Pid,
		DeptId:   user.DeptId,
		RoleId:   roleId,
		RoleKey:  roleKey,
	}

	accessToken, expiresIn, err := token.RefreshAccessAdmin(ctx, req.RefreshToken, authUser)
	if err != nil {
		return nil, gerror.New("刷新令牌无效或已过期，请重新登录")
	}

	return &api.RefreshRes{
		AccessToken: accessToken,
		ExpiresIn:   expiresIn,
	}, nil
}

// Logout 管理员退出登录
func (c *ControllerV1) Logout(ctx context.Context, req *api.LogoutReq) (res *api.LogoutRes, err error) {
	r := ghttp.RequestFromCtx(ctx)
	if r == nil {
		return &api.LogoutRes{}, nil
	}
	authHeader := r.Header.Get("Authorization")
	tokenStr := strings.TrimPrefix(authHeader, "Bearer ")
	if tokenStr != "" {
		au, parseErr := token.Parse(ctx, tokenStr)
		if parseErr == nil && au != nil {
			_ = token.DeleteSession(ctx, token.AppAdmin, tokenStr, au.Id)
		} else {
			_ = token.Delete(ctx, tokenStr)
		}
	}
	return &api.LogoutRes{}, nil
}

// Profile 获取当前登录管理员信息
func (c *ControllerV1) Profile(ctx context.Context, req *api.ProfileReq) (res *api.ProfileRes, err error) {
	r := ghttp.RequestFromCtx(ctx)
	if r == nil {
		return nil, gerror.New("请求上下文异常")
	}
	authHeader := r.Header.Get("Authorization")
	tokenStr := strings.TrimPrefix(authHeader, "Bearer ")
	if tokenStr == "" {
		return nil, gerror.New("未登录")
	}
	au, err := token.Parse(ctx, tokenStr)
	if err != nil {
		return nil, gerror.New("登录已失效，请重新登录")
	}

	// 查询完整的用户信息
	var user *entity.AdminUser
	err = dao.AdminUser.Ctx(ctx).Where("id", au.Id).Scan(&user)
	if err != nil {
		return nil, err
	}
	if user == nil {
		return nil, gerror.New("用户不存在")
	}

	// 查询当前用户绑定的角色编码列表（role.key），状态为启用的角色才生效
	var roleKeys []string
	err = dao.AdminRole.Ctx(ctx).
		LeftJoin(dao.AdminUserRole.Table()+" aur", "aur.role_id = "+dao.AdminRole.Table()+".id").
		Where("aur.user_id", au.Id).
		Where(dao.AdminRole.Table()+".status", 1).
		Fields(dao.AdminRole.Columns().Key).
		Scan(&roleKeys)
	if err != nil {
		return nil, err
	}

	// 查询部门全路径
	var deptName, deptFullPath string
	if user.DeptId > 0 {
		var dept *entity.AdminDept
		_ = dao.AdminDept.Ctx(ctx).Where("id", user.DeptId).Scan(&dept)
		if dept != nil {
			deptName = dept.Name
			// 递归查询上级部门构建全路径
			deptFullPath = buildDeptPath(ctx, dept)
		}
	}

	// 查询用户岗位列表
	var postNames []string
	var postRows []struct {
		Name string `json:"name"`
	}
	_ = dao.AdminPost.Ctx(ctx).
		LeftJoin(dao.AdminUserPost.Table()+" aup", "aup.post_id = "+dao.AdminPost.Table()+".id").
		Where("aup.user_id", user.Id).
		Where(dao.AdminPost.Table()+".status", 1).
		Fields(dao.AdminPost.Columns().Name).
		Scan(&postRows)
	for _, p := range postRows {
		postNames = append(postNames, p.Name)
	}

	// 处理头像：云存储时解析为 CDN URL；无头像则生成字母头像
	avatar := strings.TrimSpace(user.Avatar)
	if avatar != "" && !strings.HasPrefix(avatar, "http://") && !strings.HasPrefix(avatar, "https://") {
		avatar = storager.CdnUrlByPath(ctx, avatar)
	}
	if avatar == "" {
		name := ""
		if name == "" {
			name = user.Username
		}
		if name == "" {
			name = fmt.Sprintf("U%d", user.Id)
		}
		avatar = fmt.Sprintf("https://ui-avatars.com/api/?background=random&name=%s", url.QueryEscape(name))
	}

	res = new(api.ProfileRes)
	res.ProfileModel = &adminin.ProfileModel{
		Id:           user.Id,
		Username:     user.Username,
		Nickname:     user.Nickname,
		RealName:     user.RealName,
		Avatar:       avatar,
		Email:        user.Email,
		Mobile:       user.Mobile,
		Address:      user.Address,
		Remark:       user.Remark,
		Gender:       user.Gender,
		DeptId:       user.DeptId,
		DeptName:     deptName,
		DeptFullPath: deptFullPath,
		PostNames:    postNames,
		IsSuper:      consts.IsSuperRole(au.RoleKey),
		Roles:        roleKeys,
		Buttons:      nil,
	}
	return
}

// UpdateProfile 更新当前用户信息
func (c *ControllerV1) UpdateProfile(ctx context.Context, req *api.UpdateProfileReq) (res *api.UpdateProfileRes, err error) {
	r := ghttp.RequestFromCtx(ctx)
	if r == nil {
		return nil, gerror.New("请求上下文异常")
	}
	authHeader := r.Header.Get("Authorization")
	tokenStr := strings.TrimPrefix(authHeader, "Bearer ")
	if tokenStr == "" {
		return nil, gerror.New("未登录")
	}
	au, err := token.Parse(ctx, tokenStr)
	if err != nil {
		return nil, gerror.New("登录已失效，请重新登录")
	}

	// 更新用户信息（使用OmitEmpty避免零值覆盖）
	_, err = dao.AdminUser.Ctx(ctx).
		Data(entity.AdminUser{
			Nickname: req.Nickname,
			RealName: req.RealName,
			Avatar:   req.Avatar,
			Email:    req.Email,
			Mobile:   req.Mobile,
			Address:  req.Address,
			Gender:   req.Gender,
			Remark:   req.Remark,
		}).
		OmitEmpty().
		Where("id", au.Id).
		Update()

	if err != nil {
		return nil, err
	}

	return &api.UpdateProfileRes{}, nil
}

// ChangePassword 修改当前用户密码
func (c *ControllerV1) ChangePassword(ctx context.Context, req *api.ChangePasswordReq) (res *api.ChangePasswordRes, err error) {
	r := ghttp.RequestFromCtx(ctx)
	if r == nil {
		return nil, gerror.New("请求上下文异常")
	}
	authHeader := r.Header.Get("Authorization")
	tokenStr := strings.TrimPrefix(authHeader, "Bearer ")
	if tokenStr == "" {
		return nil, gerror.New("未登录")
	}
	au, err := token.Parse(ctx, tokenStr)
	if err != nil {
		return nil, gerror.New("登录已失效，请重新登录")
	}

	// 查询当前用户
	var user *entity.AdminUser
	err = dao.AdminUser.Ctx(ctx).Where("id", au.Id).Scan(&user)
	if err != nil {
		return nil, err
	}
	if user == nil {
		return nil, gerror.New("用户不存在")
	}

	// 验证旧密码
	oldHashed := gmd5.MustEncryptString(req.OldPassword + user.Salt)
	if oldHashed != user.Password {
		return nil, gerror.New("当前密码错误")
	}

	// 生成新密码哈希
	newHashed := gmd5.MustEncryptString(req.NewPassword + user.Salt)

	// 更新密码
	_, err = dao.AdminUser.Ctx(ctx).
		Data(entity.AdminUser{Password: newHashed}).
		Where("id", au.Id).
		OmitEmpty().
		Update()

	if err != nil {
		return nil, err
	}

	return &api.ChangePasswordRes{}, nil
}

// buildDeptPath 构建部门全路径（递归查询上级部门）
func buildDeptPath(ctx context.Context, dept *entity.AdminDept) string {
	path := dept.Name
	currentDept := dept

	// 最多递归10层，防止死循环
	for i := 0; i < 10; i++ {
		if currentDept.ParentId == 0 {
			break
		}
		var parent *entity.AdminDept
		err := dao.AdminDept.Ctx(ctx).Where("id", currentDept.ParentId).Scan(&parent)
		if err != nil || parent == nil {
			break
		}
		path = parent.Name + " - " + path
		currentDept = parent
	}

	return path
}
