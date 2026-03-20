package admin

import (
	"context"

	"github.com/gogf/gf/v2/crypto/gmd5"
	"github.com/gogf/gf/v2/database/gdb"
	"github.com/gogf/gf/v2/errors/gerror"
	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/util/grand"

	"xygo/internal/dao"
	"xygo/internal/model/input/adminin"
	"xygo/internal/service"
)

func init() {
	service.RegisterAdminMember(NewAdminMember())
}

func NewAdminMember() *sAdminMember {
	return &sAdminMember{}
}

type sAdminMember struct{}

// List 会员列表
func (s *sAdminMember) List(ctx context.Context, in *adminin.MemberListInp) (list []adminin.MemberItem, total int, err error) {
	m := dao.Member.Ctx(ctx)

	// 条件过滤
	if in.Username != "" {
		m = m.WhereLike("username", "%"+in.Username+"%")
	}
	if in.Mobile != "" {
		m = m.WhereLike("mobile", "%"+in.Mobile+"%")
	}
	if in.Email != "" {
		m = m.WhereLike("email", "%"+in.Email+"%")
	}
	if in.Status >= 0 {
		m = m.Where("status", in.Status)
	}
	if in.GroupId > 0 {
		m = m.Where("group_id", in.GroupId)
	}

	// deleted_at 由 GoFrame 自动处理（bigint: 查询自动加 deleted_at=0）

	// 总数
	total, err = m.Count()
	if err != nil {
		return nil, 0, err
	}

	// 分页查询
	var members []gdb.Record
	err = m.Page(in.Page, in.PageSize).OrderDesc("id").Scan(&members)
	if err != nil {
		return nil, 0, err
	}

	// 获取分组名称映射
	groupMap := make(map[int64]string)
	var groups []gdb.Record
	_ = dao.MemberGroup.Ctx(ctx).Scan(&groups)
	for _, grp := range groups {
		groupMap[grp["id"].Int64()] = grp["name"].String()
	}

	// 组装返回数据
	list = make([]adminin.MemberItem, 0, len(members))
	for _, member := range members {
		groupName := groupMap[member["group_id"].Int64()]
		if groupName == "" {
			groupName = "未分组"
		}

		lastLoginAt := ""
		if member["last_login_at"].GTime() != nil {
			lastLoginAt = member["last_login_at"].GTime().Format("Y-m-d H:i:s")
		}

		createdAt := ""
		if member["created_at"].GTime() != nil {
			createdAt = member["created_at"].GTime().Format("Y-m-d H:i:s")
		}

		list = append(list, adminin.MemberItem{
			Id:          member["id"].Int64(),
			Username:    member["username"].String(),
			Nickname:    member["nickname"].String(),
			Mobile:      member["mobile"].String(),
			Email:       member["email"].String(),
			Avatar:      member["avatar"].String(),
			Gender:      member["gender"].Int(),
			Level:       member["level"].Int(),
			GroupId:     member["group_id"].Int64(),
			GroupName:   groupName,
			Score:       member["score"].Int(),
			Money:       member["money"].Float64(),
			Status:      member["status"].Int(),
			LoginCount:  member["login_count"].Int(),
			LastLoginAt: lastLoginAt,
			LastLoginIp: member["last_login_ip"].String(),
			CreatedAt:   createdAt,
		})
	}

	return list, total, nil
}

// Detail 会员详情
func (s *sAdminMember) Detail(ctx context.Context, in *adminin.MemberDetailInp) (out *adminin.MemberDetailModel, err error) {
	member, err := dao.Member.Ctx(ctx).Where("id", in.Id).One()
	if err != nil {
		return nil, err
	}
	if member.IsEmpty() {
		return nil, gerror.New("会员不存在")
	}

	// 获取分组名称
	groupName := ""
	group, _ := dao.MemberGroup.Ctx(ctx).Where("id", member["group_id"].Int64()).One()
	if !group.IsEmpty() {
		groupName = group["name"].String()
	}

	lastLoginAt := ""
	if member["last_login_at"].GTime() != nil {
		lastLoginAt = member["last_login_at"].GTime().Format("Y-m-d H:i:s")
	}

	createdAt := ""
	if member["created_at"].GTime() != nil {
		createdAt = member["created_at"].GTime().Format("Y-m-d H:i:s")
	}

	out = &adminin.MemberDetailModel{
		MemberItem: adminin.MemberItem{
			Id:          member["id"].Int64(),
			Username:    member["username"].String(),
			Nickname:    member["nickname"].String(),
			Mobile:      member["mobile"].String(),
			Email:       member["email"].String(),
			Avatar:      member["avatar"].String(),
			Gender:      member["gender"].Int(),
			Level:       member["level"].Int(),
			GroupId:     member["group_id"].Int64(),
			GroupName:   groupName,
			Score:       member["score"].Int(),
			Money:       member["money"].Float64(),
			Status:      member["status"].Int(),
			LoginCount:  member["login_count"].Int(),
			LastLoginAt: lastLoginAt,
			LastLoginIp: member["last_login_ip"].String(),
			CreatedAt:   createdAt,
		},
	}

	return out, nil
}

// Add 添加会员
func (s *sAdminMember) Add(ctx context.Context, in *adminin.MemberAddInp) (out *adminin.MemberAddModel, err error) {
	// 检查用户名是否已存在
	count, err := dao.Member.Ctx(ctx).Where("username", in.Username).Count()
	if err != nil {
		return nil, err
	}
	if count > 0 {
		return nil, gerror.New("用户名已存在")
	}

	// 检查手机号是否已存在
	if in.Mobile != "" {
		count, err = dao.Member.Ctx(ctx).Where("mobile", in.Mobile).Count()
		if err != nil {
			return nil, err
		}
		if count > 0 {
			return nil, gerror.New("手机号已被使用")
		}
	}

	// 密码加密（MD5 + salt）
	salt := grand.S(6)

	// 插入数据
	result, err := dao.Member.Ctx(ctx).Data(g.Map{
		"username":   in.Username,
		"password":   gmd5.MustEncryptString(in.Password + salt),
		"salt":       salt,
		"nickname":   in.Nickname,
		"mobile":     in.Mobile,
		"email":      in.Email,
		"avatar":     in.Avatar,
		"gender":     in.Gender,
		"group_id":   in.GroupId,
		"score":      in.Score,
		"money":      in.Money,
		"status":     in.Status,
		"level": 1,
	}).Insert()
	if err != nil {
		return nil, err
	}

	id, _ := result.LastInsertId()
	out = &adminin.MemberAddModel{Id: id}

	return out, nil
}

// Edit 编辑会员
func (s *sAdminMember) Edit(ctx context.Context, in *adminin.MemberEditInp) (err error) {
	// 检查会员是否存在
	member, err := dao.Member.Ctx(ctx).Where("id", in.Id).One()
	if err != nil {
		return err
	}
	if member.IsEmpty() {
		return gerror.New("会员不存在")
	}

	// 检查用户名是否被其他人使用
	if in.Username != "" && in.Username != member["username"].String() {
		count, err := dao.Member.Ctx(ctx).Where("username", in.Username).WhereNot("id", in.Id).Count()
		if err != nil {
			return err
		}
		if count > 0 {
			return gerror.New("用户名已存在")
		}
	}

	// 检查手机号是否被其他人使用
	if in.Mobile != "" && in.Mobile != member["mobile"].String() {
		count, err := dao.Member.Ctx(ctx).Where("mobile", in.Mobile).WhereNot("id", in.Id).Count()
		if err != nil {
			return err
		}
		if count > 0 {
			return gerror.New("手机号已被使用")
		}
	}

	// 准备更新数据
	data := g.Map{}
	if in.Username != "" {
		data["username"] = in.Username
	}
	if in.Password != "" {
		salt := grand.S(6)
		data["salt"] = salt
		data["password"] = gmd5.MustEncryptString(in.Password + salt)
	}
	if in.Nickname != "" {
		data["nickname"] = in.Nickname
	}
	data["mobile"] = in.Mobile
	data["email"] = in.Email
	data["avatar"] = in.Avatar
	data["gender"] = in.Gender
	data["group_id"] = in.GroupId
	data["score"] = in.Score
	data["money"] = in.Money
	data["status"] = in.Status

	_, err = dao.Member.Ctx(ctx).Where("id", in.Id).Data(data).Update()
	return err
}

// Delete 删除会员（软删除）
func (s *sAdminMember) Delete(ctx context.Context, in *adminin.MemberDeleteInp) (err error) {
	_, err = dao.Member.Ctx(ctx).WhereIn("id", in.Ids).Delete()
	return err
}

// Status 修改会员状态
func (s *sAdminMember) Status(ctx context.Context, in *adminin.MemberStatusInp) (err error) {
	_, err = dao.Member.Ctx(ctx).Where("id", in.Id).Data(g.Map{
		"status": in.Status,
	}).Update()
	return err
}

// ResetPassword 重置会员密码
func (s *sAdminMember) ResetPassword(ctx context.Context, in *adminin.MemberResetPasswordInp) (err error) {
	// 检查会员是否存在
	count, err := dao.Member.Ctx(ctx).Where("id", in.Id).Count()
	if err != nil {
		return err
	}
	if count == 0 {
		return gerror.New("会员不存在")
	}

	// 密码加密（MD5 + salt）
	salt := grand.S(6)

	_, err = dao.Member.Ctx(ctx).Where("id", in.Id).Data(g.Map{
		"password": gmd5.MustEncryptString(in.Password + salt),
		"salt":     salt,
	}).Update()
	return err
}

// GroupOptions 会员分组选项
func (s *sAdminMember) GroupOptions(ctx context.Context) (out *adminin.MemberGroupOptionsModel, err error) {
	out = &adminin.MemberGroupOptionsModel{
		List: make([]adminin.MemberGroupOption, 0),
	}

	var groups []gdb.Record
	err = dao.MemberGroup.Ctx(ctx).Where("status", 1).OrderAsc("sort").Scan(&groups)
	if err != nil {
		return nil, err
	}

	for _, group := range groups {
		out.List = append(out.List, adminin.MemberGroupOption{
			Id:   group["id"].Int64(),
			Name: group["name"].String(),
		})
	}

	return out, nil
}
