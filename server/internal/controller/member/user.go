// +----------------------------------------------------------------------
// | XYGo Admin [ Vue3 + GoFrame 企业级中后台管理系统 ]
// +----------------------------------------------------------------------
// | Copyright (c) 2026 大连星韵网络科技有限公司 All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( https://opensource.org/licenses/MIT )
// +----------------------------------------------------------------------
// | Author: 喜羊羊 <751300685@qq.com>
// +----------------------------------------------------------------------

package member

import (
	"context"
	"path/filepath"
	"sort"
	"strings"

	"github.com/gogf/gf/v2/errors/gerror"
	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/os/gfile"
	"github.com/gogf/gf/v2/os/gtime"
	"github.com/google/uuid"

	"xygo/api/member"
	"xygo/internal/consts"
	"xygo/internal/dao"
	"xygo/internal/library/contexts"
	"xygo/internal/model/input/memberin"
	"xygo/internal/service"
)

// UploadFile 会员端文件上传（简化版，仅支持图片，存本地）
func (c *ControllerV1) UploadFile(ctx context.Context, req *member.UploadFileReq) (res *member.UploadFileRes, err error) {
	memberId := contexts.GetMemberId(ctx)
	if memberId == 0 {
		return nil, gerror.NewCode(consts.CodeNotAuthorized, "请先登录")
	}

	r := g.RequestFromCtx(ctx)
	upFile := r.GetUploadFile("file")
	if upFile == nil {
		return nil, gerror.New("未选择文件")
	}

	// 限制 2MB + 仅图片
	if upFile.Size > 2*1024*1024 {
		return nil, gerror.New("文件大小不能超过 2MB")
	}
	ext := strings.ToLower(filepath.Ext(upFile.Filename))
	if ext == "" {
		ext = ".jpg"
	}
	allowed := map[string]bool{".jpg": true, ".jpeg": true, ".png": true, ".gif": true, ".webp": true}
	if !allowed[ext] {
		return nil, gerror.New("仅支持 jpg/png/gif/webp 格式")
	}

	// 保存到本地 resource/public/attachment/upload/日期/uuid.ext
	subdir := gtime.Now().Format("Ymd")
	name := uuid.New().String() + ext
	savePath := filepath.Join("resource", "public", "attachment", "upload", subdir, name)
	saveDir := filepath.Dir(savePath)
	if !gfile.Exists(saveDir) {
		_ = gfile.Mkdir(saveDir)
	}

	upFile.Filename = name
	_, err = upFile.Save(saveDir)
	if err != nil {
		return nil, gerror.Newf("保存文件失败: %v", err)
	}

	url := "/attachment/upload/" + subdir + "/" + name
	return &member.UploadFileRes{
		Url:  url,
		Name: upFile.Filename,
		Size: upFile.Size,
	}, nil
}

// ==================== 签到 ====================

// GetCheckinInfo 获取签到信息
func (c *ControllerV1) GetCheckinInfo(ctx context.Context, req *member.CheckinInfoReq) (res *member.CheckinInfoRes, err error) {
	memberId := contexts.GetMemberId(ctx)
	if memberId == 0 {
		return nil, gerror.NewCode(consts.CodeNotAuthorized, "请先登录")
	}

	out, err := service.MemberCheckin().GetCheckinInfo(ctx, memberId)
	if err != nil {
		return nil, err
	}

	res = &member.CheckinInfoRes{
		ContinuousDays: out.ContinuousDays,
		TodayChecked:   out.TodayChecked,
		TodayScore:     out.TodayScore,
	}
	res.WeekDays = make([]member.CheckinDayItem, len(out.WeekDays))
	for i, d := range out.WeekDays {
		res.WeekDays[i] = member.CheckinDayItem{
			Date:    d.Date,
			Checked: d.Checked,
			Score:   d.Score,
		}
	}
	return res, nil
}

// DoCheckin 执行签到
func (c *ControllerV1) DoCheckin(ctx context.Context, req *member.DoCheckinReq) (res *member.DoCheckinRes, err error) {
	memberId := contexts.GetMemberId(ctx)
	if memberId == 0 {
		return nil, gerror.NewCode(consts.CodeNotAuthorized, "请先登录")
	}

	out, err := service.MemberCheckin().DoCheckin(ctx, memberId)
	if err != nil {
		return nil, err
	}

	return &member.DoCheckinRes{
		Score:          out.Score,
		ContinuousDays: out.ContinuousDays,
	}, nil
}

// ==================== 积分记录 ====================

// ScoreLogList 积分记录列表（直接调 DAO，避免与 admin CRUD 命名冲突）
func (c *ControllerV1) ScoreLogList(ctx context.Context, req *member.ScoreLogListReq) (res *member.ScoreLogListRes, err error) {
	memberId := contexts.GetMemberId(ctx)
	if memberId == 0 {
		return nil, gerror.NewCode(consts.CodeNotAuthorized, "请先登录")
	}

	page, pageSize := req.Page, req.PageSize
	if page <= 0 {
		page = 1
	}
	if pageSize <= 0 {
		pageSize = 20
	}

	model := dao.MemberScoreLog.Ctx(ctx).Where("member_id", memberId)
	count, err := model.Count()
	if err != nil {
		return nil, err
	}

	var list []member.ScoreLogItem
	err = model.Page(page, pageSize).OrderDesc("id").Scan(&list)
	if err != nil {
		return nil, err
	}
	if list == nil {
		list = []member.ScoreLogItem{}
	}

	return &member.ScoreLogListRes{
		List:     list,
		Page:     page,
		PageSize: pageSize,
		Total:    count,
	}, nil
}

// ==================== 余额记录 ====================

// MoneyLogList 余额记录列表（直接调 DAO，避免与 admin CRUD 命名冲突）
func (c *ControllerV1) MoneyLogList(ctx context.Context, req *member.MoneyLogListReq) (res *member.MoneyLogListRes, err error) {
	memberId := contexts.GetMemberId(ctx)
	if memberId == 0 {
		return nil, gerror.NewCode(consts.CodeNotAuthorized, "请先登录")
	}

	page, pageSize := req.Page, req.PageSize
	if page <= 0 {
		page = 1
	}
	if pageSize <= 0 {
		pageSize = 20
	}

	model := dao.MemberMoneyLog.Ctx(ctx).Where("member_id", memberId)
	count, err := model.Count()
	if err != nil {
		return nil, err
	}

	var list []member.MoneyLogItem
	err = model.Page(page, pageSize).OrderDesc("id").Scan(&list)
	if err != nil {
		return nil, err
	}
	if list == nil {
		list = []member.MoneyLogItem{}
	}

	return &member.MoneyLogListRes{
		List:     list,
		Page:     page,
		PageSize: pageSize,
		Total:    count,
	}, nil
}

// ==================== 系统通知 ====================

// NoticeList 通知列表
func (c *ControllerV1) NoticeList(ctx context.Context, req *member.NoticeListReq) (res *member.NoticeListRes, err error) {
	memberId := contexts.GetMemberId(ctx)
	if memberId == 0 {
		return nil, gerror.NewCode(consts.CodeNotAuthorized, "请先登录")
	}

	out, err := service.FrontendNotice().List(ctx, memberId, &memberin.NoticeListInput{
		Page:     req.Page,
		PageSize: req.PageSize,
	})
	if err != nil {
		return nil, err
	}

	res = &member.NoticeListRes{
		Page:     out.Page,
		PageSize: out.PageSize,
		Total:    out.Total,
		Unread:   out.Unread,
	}
	res.List = make([]member.NoticeItem, len(out.List))
	for i, item := range out.List {
		res.List[i] = member.NoticeItem{
			Id:        item.Id,
			Title:     item.Title,
			Content:   item.Content,
			Type:      item.Type,
			Sender:    item.Sender,
			IsRead:    item.IsRead,
			CreatedAt: item.CreatedAt,
		}
	}
	return res, nil
}

// NoticeRead 标记通知已读
func (c *ControllerV1) NoticeRead(ctx context.Context, req *member.NoticeReadReq) (res *member.NoticeReadRes, err error) {
	memberId := contexts.GetMemberId(ctx)
	if memberId == 0 {
		return nil, gerror.NewCode(consts.CodeNotAuthorized, "请先登录")
	}

	err = service.FrontendNotice().MarkRead(ctx, memberId, req.NoticeId)
	if err != nil {
		return nil, err
	}
	return &member.NoticeReadRes{}, nil
}

// NoticeReadAll 全部通知已读
func (c *ControllerV1) NoticeReadAll(ctx context.Context, req *member.NoticeReadAllReq) (res *member.NoticeReadAllRes, err error) {
	memberId := contexts.GetMemberId(ctx)
	if memberId == 0 {
		return nil, gerror.NewCode(consts.CodeNotAuthorized, "请先登录")
	}

	err = service.FrontendNotice().MarkAllRead(ctx, memberId)
	if err != nil {
		return nil, err
	}
	return &member.NoticeReadAllRes{}, nil
}

// GetInfo 获取当前会员信息
func (c *ControllerV1) GetInfo(ctx context.Context, req *member.GetInfoReq) (res *member.GetInfoRes, err error) {
	memberId := contexts.GetMemberId(ctx)
	if memberId == 0 {
		return nil, gerror.NewCode(consts.CodeNotAuthorized, "请先登录")
	}

	output, err := service.MemberUser().GetInfo(ctx, memberId)
	if err != nil {
		return nil, err
	}

	return &member.GetInfoRes{
		Id:       output.Id,
		Username: output.Username,
		Nickname: output.Nickname,
		Avatar:   output.Avatar,
		Mobile:   output.Mobile,
		Email:    output.Email,
		Gender:   output.Gender,
		Level:    output.Level,
		GroupId:  output.GroupId,
		Score:       output.Score,
		Money:       output.Money,
		LastLoginAt: output.LastLoginAt,
		LastLoginIp: output.LastLoginIp,
	}, nil
}

// UpdateProfile 更新会员资料
func (c *ControllerV1) UpdateProfile(ctx context.Context, req *member.UpdateProfileReq) (res *member.UpdateProfileRes, err error) {
	memberId := contexts.GetMemberId(ctx)
	if memberId == 0 {
		return nil, gerror.NewCode(consts.CodeNotAuthorized, "请先登录")
	}

	input := &memberin.UpdateProfileInput{
		Nickname: req.Nickname,
		Avatar:   req.Avatar,
		Mobile:   req.Mobile,
		Gender:   req.Gender,
		Birthday: req.Birthday,
		Email:    req.Email,
	}

	err = service.MemberUser().UpdateProfile(ctx, memberId, input)
	if err != nil {
		return nil, err
	}

	return &member.UpdateProfileRes{}, nil
}

// ChangePassword 修改密码
func (c *ControllerV1) ChangePassword(ctx context.Context, req *member.ChangePasswordReq) (res *member.ChangePasswordRes, err error) {
	memberId := contexts.GetMemberId(ctx)
	if memberId == 0 {
		return nil, gerror.NewCode(consts.CodeNotAuthorized, "请先登录")
	}

	input := &memberin.ChangePasswordInput{
		OldPassword: req.OldPassword,
		NewPassword: req.NewPassword,
	}

	err = service.MemberUser().ChangePassword(ctx, memberId, input)
	if err != nil {
		return nil, err
	}

	return &member.ChangePasswordRes{}, nil
}

// GetMenus 获取当前会员可用菜单（按分组权限过滤）
func (c *ControllerV1) GetMenus(ctx context.Context, req *member.GetMenusReq) (res *member.GetMenusRes, err error) {
	// 获取当前会员的分组ID
	groupId := contexts.GetMemberGroupId(ctx)

	// 获取菜单列表
	allMenus, err := service.MemberUser().GetMenusByGroupId(ctx, groupId)
	if err != nil {
		return nil, err
	}

	res = &member.GetMenusRes{
		Menus: make([]member.MemberMenuItem, 0),
		Nav:   make([]member.MemberMenuItem, 0),
		Rules: make([]member.MemberMenuItem, 0),
	}

	// 按类型分类
	for _, m := range allMenus {
		item := member.MemberMenuItem{
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
		}
		switch m.Type {
		case "menu_dir", "menu":
			res.Menus = append(res.Menus, item)
		case "nav", "nav_user_menu":
			res.Nav = append(res.Nav, item)
		case "route":
			res.Rules = append(res.Rules, item)
		case "button":
			res.Rules = append(res.Rules, item)
		}
	}

	attachNavDropdownChildren(res.Nav, allMenus)

	return res, nil
}

func attachNavDropdownChildren(nav []member.MemberMenuItem, flat []memberin.FrontendMenuItem) {
	byPid := make(map[uint64][]memberin.FrontendMenuItem)
	for _, m := range flat {
		if m.Type == "menu" {
			byPid[m.Pid] = append(byPid[m.Pid], m)
		}
	}
	for i := range nav {
		if nav[i].Type != "nav" || nav[i].NavShowChildren != 1 {
			continue
		}
		kids := byPid[nav[i].Id]
		if len(kids) == 0 {
			continue
		}
		sort.Slice(kids, func(a, b int) bool {
			if kids[a].Sort != kids[b].Sort {
				return kids[a].Sort < kids[b].Sort
			}
			return kids[a].Id < kids[b].Id
		})
		ch := make([]member.MemberMenuItem, 0, len(kids))
		for _, k := range kids {
			ch = append(ch, frontendMenuItemFromFlat(k))
		}
		nav[i].Children = ch
	}
}

func frontendMenuItemFromFlat(m memberin.FrontendMenuItem) member.MemberMenuItem {
	return member.MemberMenuItem{
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
	}
}
