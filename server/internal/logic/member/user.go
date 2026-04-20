// =================================================================================
// 会员信息逻辑层
// =================================================================================

package member

import (
	"context"

	"github.com/gogf/gf/v2/crypto/gmd5"
	"github.com/gogf/gf/v2/errors/gerror"
	"github.com/gogf/gf/v2/util/grand"

	"xygo/internal/consts"
	"xygo/internal/dao"
	"xygo/internal/model"
	"xygo/internal/model/entity"
	"xygo/internal/model/input/memberin"
)

type sMemberUser struct{}

// NewMemberUser 构造会员信息服务
func NewMemberUser() *sMemberUser {
	return &sMemberUser{}
}

// GetInfo 获取当前会员信息
func (s *sMemberUser) GetInfo(ctx context.Context, memberId uint64) (out *memberin.GetInfoOutput, err error) {
	var member *entity.Member
	err = dao.Member.Ctx(ctx).
		Where("id", memberId).
		Scan(&member)
	if err != nil {
		return nil, err
	}

	if member == nil {
		return nil, gerror.NewCode(consts.CodeDataNotFound, "会员不存在")
	}

	return &memberin.GetInfoOutput{
		Id:       member.Id,
		Username: member.Username,
		Nickname: member.Nickname,
		Avatar:   member.Avatar,
		Mobile:   member.Mobile,
		Email:    member.Email,
		Gender:   member.Gender,
		Level:    uint(member.Level),
		GroupId:  member.GroupId,
		Score:       member.Score,
		Money:       member.Money,
		LastLoginAt: member.LastLoginAt,
		LastLoginIp: member.LastLoginIp,
	}, nil
}

// UpdateProfile 更新会员资料
func (s *sMemberUser) UpdateProfile(ctx context.Context, memberId uint64, in *memberin.UpdateProfileInput) (err error) {
	data := map[string]interface{}{}

	if in.Nickname != "" {
		data["nickname"] = in.Nickname
	}
	if in.Avatar != "" {
		data["avatar"] = in.Avatar
	}
	if in.Gender >= 0 && in.Gender <= 2 {
		data["gender"] = in.Gender
	}
	if in.Birthday != nil {
		data["birthday"] = in.Birthday
	}
	if in.Email != "" {
		data["email"] = in.Email
	}
	if in.Mobile != "" {
		data["mobile"] = in.Mobile
	}

	_, err = dao.Member.Ctx(ctx).
		Where("id", memberId).
		Data(data).
		Update()

	return err
}

// ChangePassword 修改密码
func (s *sMemberUser) ChangePassword(ctx context.Context, memberId uint64, in *memberin.ChangePasswordInput) (err error) {
	// 1. 查询会员
	var member *entity.Member
	err = dao.Member.Ctx(ctx).
		Where("id", memberId).
		Scan(&member)
	if err != nil {
		return err
	}

	if member == nil {
		return gerror.NewCode(consts.CodeDataNotFound, "会员不存在")
	}

	// 2. 验证原密码（MD5 + salt）
	if gmd5.MustEncryptString(in.OldPassword+member.Salt) != member.Password {
		return gerror.NewCode(consts.CodeBusinessError, "原密码错误")
	}

	// 3. 生成新盐 + 加密新密码
	newSalt := grand.S(6)

	// 4. 更新密码
	_, err = dao.Member.Ctx(ctx).
		Where("id", memberId).
		Data(map[string]interface{}{
			"password": gmd5.MustEncryptString(in.NewPassword + newSalt),
			"salt":     newSalt,
		}).
		Update()

	return err
}

// GetByUsername 根据用户名获取会员
func (s *sMemberUser) GetByUsername(ctx context.Context, username string) (out *model.MemberUser, err error) {
	var member *entity.Member
	err = dao.Member.Ctx(ctx).
		Where("username", username).
		Scan(&member)
	if err != nil {
		return nil, err
	}

	if member == nil {
		return nil, nil
	}

	return &model.MemberUser{
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
	}, nil
}

// GetMenusByGroupId 根据分组ID获取菜单列表（前台会员用）
// 1. 查分组的 rules（逗号分隔的菜单ID，或 * 表示全部）
// 2. 按 rules 过滤 member_menu 中 status=1 的菜单
// 3. 如果未登录（groupId=0），只返回 no_login_valid=1 的菜单
func (s *sMemberUser) GetMenusByGroupId(ctx context.Context, groupId uint64) (menus []memberin.FrontendMenuItem, err error) {
	var allMenus []entity.MemberMenu

	if groupId == 0 {
		// 未登录：只取公开菜单
		err = dao.MemberMenu.Ctx(ctx).
			Where("status", 1).
			Where("no_login_valid", 1).
			OrderAsc("sort, id").
			Scan(&allMenus)
	} else {
		// 已登录：查分组权限
		var group *entity.MemberGroup
		err = dao.MemberGroup.Ctx(ctx).Where("id", groupId).Where("status", 1).Scan(&group)
		if err != nil {
			return nil, err
		}
		if group == nil {
			// 分组不存在或被禁用，只返回公开菜单
			err = dao.MemberMenu.Ctx(ctx).
				Where("status", 1).
				Where("no_login_valid", 1).
				OrderAsc("sort, id").
				Scan(&allMenus)
		} else if group.Rules == "*" {
			// 超级权限：返回全部启用菜单
			err = dao.MemberMenu.Ctx(ctx).
				Where("status", 1).
				OrderAsc("sort, id").
				Scan(&allMenus)
		} else if group.Rules != "" {
			// 按 rules 字段过滤 + 公开菜单
			err = dao.MemberMenu.Ctx(ctx).
				Where("status", 1).
				Where("id IN(?) OR no_login_valid = 1", group.Rules).
				OrderAsc("sort, id").
				Scan(&allMenus)
		} else {
			// 分组没有任何权限，只返回公开菜单
			err = dao.MemberMenu.Ctx(ctx).
				Where("status", 1).
				Where("no_login_valid", 1).
				OrderAsc("sort, id").
				Scan(&allMenus)
		}
	}

	if err != nil {
		return nil, err
	}

	// nav_show_children=1 的顶栏项：其直接子级跟随父级可见性，补充查询
	var navDropdownPids []uint64
	for _, m := range allMenus {
		if m.Type == "nav" && m.NavShowChildren == 1 {
			navDropdownPids = append(navDropdownPids, m.Id)
		}
	}
	if len(navDropdownPids) > 0 {
		existIds := make(map[uint64]struct{}, len(allMenus))
		for _, m := range allMenus {
			existIds[m.Id] = struct{}{}
		}
		var extraMenus []entity.MemberMenu
		err = dao.MemberMenu.Ctx(ctx).
			Where("status", 1).
			WhereIn("pid", navDropdownPids).
			OrderAsc("sort, id").
			Scan(&extraMenus)
		if err != nil {
			return nil, err
		}
		for _, m := range extraMenus {
			if _, ok := existIds[m.Id]; !ok {
				allMenus = append(allMenus, m)
				existIds[m.Id] = struct{}{}
			}
		}
	}

	// 转换为前端结构
	menus = make([]memberin.FrontendMenuItem, 0, len(allMenus))
	for _, m := range allMenus {
		menus = append(menus, memberin.FrontendMenuItem{
			Id:              m.Id,
			Pid:             m.Pid,
			Title:           m.Title,
			Name:            m.Name,
			Path:            m.Path,
			Component:       m.Component,
			Icon:            m.Icon,
			MenuType:        m.MenuType,
			Url:             m.Url,
			Type:            m.Type,
			NavShowChildren: m.NavShowChildren,
			NoLoginValid:    m.NoLoginValid,
			Sort:            m.Sort,
		})
	}
	return menus, nil
}
