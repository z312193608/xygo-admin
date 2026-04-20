// +----------------------------------------------------------------------
// | XYGo Admin [ Vue3 + GoFrame 企业级中后台管理系统 ]
// +----------------------------------------------------------------------
// | Copyright (c) 2026 大连星韵网络科技有限公司 All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( https://opensource.org/licenses/MIT )
// +----------------------------------------------------------------------
// | Author: 喜羊羊 <751300685@qq.com>
// +----------------------------------------------------------------------

package admin

import (
	"context"
	"strings"

	"github.com/gogf/gf/v2/errors/gerror"
	"github.com/gogf/gf/v2/net/ghttp"
	"github.com/gogf/gf/v2/os/gtime"

	api "xygo/api/admin"
	"xygo/internal/consts"
	"xygo/internal/dao"
	"xygo/internal/library/token"
	"xygo/internal/model"
	"xygo/internal/model/do"
	"xygo/internal/model/entity"
	"xygo/internal/model/input/adminin"
)

// MenuTree 菜单树（后台管理用途）
// - 返回所有菜单（目录/菜单/按钮）按 parentId 组装成树结构。
// - 后续可在前端菜单管理页面、角色授权页面复用。
func (c *ControllerV1) MenuTree(ctx context.Context, req *api.MenuTreeReq) (res *api.MenuTreeRes, err error) {
	// 查询全部菜单
	var list []adminin.MenuTreeItem
	err = dao.AdminMenu.Ctx(ctx).
		Fields("id, parent_id as parentId, type, title, name, path, component, resource, icon, hidden, keep_alive as keepAlive, redirect, frame_src as frameSrc, perms, is_frame as isFrame, affix, show_badge as showBadge, badge_text as badgeText, active_path as activePath, hide_tab as hideTab, is_full_page as isFullPage, sort, status, remark, create_time, update_time").
		OrderAsc("sort,id").
		Scan(&list)
	if err != nil {
		return nil, err
	}

	// 使用通用树工具按 parentId 组装 children
	nodes := make([]*adminin.MenuTreeItem, 0, len(list))
	for i := range list {
		nodes = append(nodes, &list[i])
	}

	rootPtrs := model.BuildTree(
		nodes,
		func(n *adminin.MenuTreeItem) uint { return uint(n.Id) },
		func(n *adminin.MenuTreeItem) uint { return uint(n.ParentId) },
		func(n *adminin.MenuTreeItem, children []*adminin.MenuTreeItem) { n.Children = children },
	)

	roots := make([]*adminin.MenuTreeItem, 0, len(rootPtrs))
	for _, n := range rootPtrs {
		if n == nil {
			continue
		}
		roots = append(roots, n)
	}

	res = new(api.MenuTreeRes)
	res.MenuTreeModel = &adminin.MenuTreeModel{
		List: roots,
	}
	return
}

// MenuRoutes 菜单路由（前端使用，仅目录/菜单，过滤禁用）
func (c *ControllerV1) MenuRoutes(ctx context.Context, req *api.MenuRoutesReq) (res *api.MenuRoutesRes, err error) {
	// 解析当前用户，确定是否超管/角色
	r := ghttp.RequestFromCtx(ctx)
	if r == nil {
		return nil, gerror.NewCode(consts.CodeNotAuthorized, "非法请求")
	}
	authHeader := r.Header.Get("Authorization")
	tokenStr := strings.TrimPrefix(authHeader, "Bearer ")
	user, err := token.Parse(ctx, tokenStr)
	if err != nil || user == nil {
		return nil, gerror.NewCode(consts.CodeNotAuthorized, "未登录")
	}

	// ✅ 直接从上下文用户信息判断是否超管（基于 RoleKey）
	isSuper := consts.IsSuperRole(user.RoleKey)

	// 获取用户角色
	var roleRows []struct {
		RoleId uint `json:"roleId"`
	}
	if err = dao.AdminUserRole.Ctx(ctx).
		Fields("role_id AS roleId").
		Where("user_id", user.Id).
		Scan(&roleRows); err != nil {
		return nil, err
	}

	allowedRoleIds := make([]uint, 0, len(roleRows))
	for _, r := range roleRows {
		if r.RoleId > 0 {
			allowedRoleIds = append(allowedRoleIds, r.RoleId)
		}
	}

	// 非超管且无角色，直接返回空列表
	if !isSuper && len(allowedRoleIds) == 0 {
		res = new(api.MenuRoutesRes)
		res.MenuTreeModel = &adminin.MenuTreeModel{List: []*adminin.MenuTreeItem{}}
		return res, nil
	}

	// ✅ 计算允许的菜单ID（非超管）+ 递归继承父角色权限
	allowedMenuIds := map[uint]struct{}{}
	if !isSuper {
		// ✅ 递归获取所有父角色（实现权限继承）
		allRoleIds, err := getAllParentRoleIds(ctx, allowedRoleIds)
		if err != nil {
			return nil, err
		}

		var menuRows []struct {
			MenuId uint `json:"menuId"`
		}
		if err = dao.AdminRoleMenu.Ctx(ctx).
			Fields("menu_id AS menuId").
			WhereIn("role_id", allRoleIds). // ✅ 使用包含父角色的完整列表
			Scan(&menuRows); err != nil {
			return nil, err
		}
		for _, m := range menuRows {
			if m.MenuId > 0 {
				allowedMenuIds[m.MenuId] = struct{}{}
			}
		}
		// 无菜单绑定则返回空
		if len(allowedMenuIds) == 0 {
			res = new(api.MenuRoutesRes)
			res.MenuTreeModel = &adminin.MenuTreeModel{List: []*adminin.MenuTreeItem{}}
			return res, nil
		}
	}

	// 查询菜单
	builder := dao.AdminMenu.Ctx(ctx).
		Fields("id, parent_id as parentId, type, title, name, path, component, icon, hidden, keep_alive as keepAlive, redirect, frame_src as frameSrc, perms, is_frame as isFrame, affix, show_badge as showBadge, badge_text as badgeText, active_path as activePath, hide_tab as hideTab, is_full_page as isFullPage, sort, status, remark, create_time, update_time").
		WhereIn("type", []int{1, 2}). // 只要目录/菜单
		Where("status", 1)            // 仅启用

	// 非超管按菜单ID过滤
	if !isSuper {
		ids := make([]uint, 0, len(allowedMenuIds))
		for id := range allowedMenuIds {
			ids = append(ids, id)
		}
		builder = builder.WhereIn("id", ids)
	}

	var list []adminin.MenuTreeItem
	err = builder.
		OrderAsc("sort,id").
		Scan(&list)
	if err != nil {
		return nil, err
	}

	nodes := make([]*adminin.MenuTreeItem, 0, len(list))
	for i := range list {
		nodes = append(nodes, &list[i])
	}

	rootPtrs := model.BuildTree(
		nodes,
		func(n *adminin.MenuTreeItem) uint { return uint(n.Id) },
		func(n *adminin.MenuTreeItem) uint { return uint(n.ParentId) },
		func(n *adminin.MenuTreeItem, children []*adminin.MenuTreeItem) { n.Children = children },
	)

	// 过滤孤儿节点：parent_id != 0 但父节点被禁用/不在结果集中的菜单不应作为根节点
	idSet := make(map[uint]struct{}, len(list))
	for _, n := range list {
		idSet[uint(n.Id)] = struct{}{}
	}

	roots := make([]*adminin.MenuTreeItem, 0, len(rootPtrs))
	for _, n := range rootPtrs {
		if n == nil {
			continue
		}
		if n.ParentId != 0 {
			if _, ok := idSet[uint(n.ParentId)]; !ok {
				continue
			}
		}
		roots = append(roots, n)
	}

	res = new(api.MenuRoutesRes)
	res.MenuTreeModel = &adminin.MenuTreeModel{
		List: roots,
	}
	return
}

// MenuDetail 菜单详情
func (c *ControllerV1) MenuDetail(ctx context.Context, req *api.MenuDetailReq) (res *api.MenuDetailRes, err error) {
	var menu *entity.AdminMenu

	if err = dao.AdminMenu.Ctx(ctx).
		Where("id", req.MenuDetailInp.Id).
		Scan(&menu); err != nil {
		return nil, err
	}

	if menu == nil {
		return nil, gerror.NewCode(consts.CodeDataNotFound, "菜单不存在")
	}

	res = new(api.MenuDetailRes)
	res.MenuTreeItem = &adminin.MenuTreeItem{
		Id:         menu.Id,
		ParentId:   menu.ParentId,
		Type:       menu.Type,
		Title:      menu.Title,
		Name:       menu.Name,
		Path:       menu.Path,
		Component:  menu.Component,
		Icon:       menu.Icon,
		Hidden:     menu.Hidden,
		KeepAlive:  menu.KeepAlive,
		Redirect:   menu.Redirect,
		FrameSrc:   menu.FrameSrc,
		Perms:      menu.Perms,
		IsFrame:    menu.IsFrame,
		Affix:      menu.Affix,
		ShowBadge:  menu.ShowBadge,
		BadgeText:  menu.BadgeText,
		ActivePath: menu.ActivePath,
		HideTab:    menu.HideTab,
		IsFullPage: menu.IsFullPage,
		Sort:       menu.Sort,
		Status:     menu.Status,
		Remark:     menu.Remark,
		CreateTime: menu.CreateTime,
		UpdateTime: menu.UpdateTime,
	}
	return
}

// MenuSave 菜单保存（新增/编辑）
func (c *ControllerV1) MenuSave(ctx context.Context, req *api.MenuSaveReq) (res *api.MenuSaveRes, err error) {
	// 基本校验：父节点、类型必填校验、同级唯一性校验
	if err = c.validateMenuSave(ctx, &req.MenuSaveInp); err != nil {
		return nil, err
	}

	now := gtime.Now().Timestamp()
	data := do.AdminMenu{
		ParentId:   req.MenuSaveInp.ParentId,
		Type:       req.MenuSaveInp.Type,
		Title:      req.MenuSaveInp.Title,
		Name:       req.MenuSaveInp.Name,
		Path:       req.MenuSaveInp.Path,
		Component:  req.MenuSaveInp.Component,
		Icon:       req.MenuSaveInp.Icon,
		Hidden:     req.MenuSaveInp.Hidden,
		KeepAlive:  req.MenuSaveInp.KeepAlive,
		Redirect:   req.MenuSaveInp.Redirect,
		FrameSrc:   req.MenuSaveInp.FrameSrc,
		Perms:      req.MenuSaveInp.Perms,
		IsFrame:    req.MenuSaveInp.IsFrame,
		Affix:      req.MenuSaveInp.Affix,
		ShowBadge:  req.MenuSaveInp.ShowBadge,
		BadgeText:  req.MenuSaveInp.BadgeText,
		ActivePath: req.MenuSaveInp.ActivePath,
		HideTab:    req.MenuSaveInp.HideTab,
		IsFullPage: req.MenuSaveInp.IsFullPage,
		Sort:       req.MenuSaveInp.Sort,
		Status:     req.MenuSaveInp.Status,
		Remark:     req.MenuSaveInp.Remark,
		UpdateTime: now,
	}

	if req.MenuSaveInp.Id == 0 {
		// 新增
		data.CreateTime = now
		r, err := dao.AdminMenu.Ctx(ctx).Data(data).OmitNil().Insert()
		if err != nil {
			return nil, err
		}
		lastId, err := r.LastInsertId()
		if err != nil {
			return nil, err
		}
		res = &api.MenuSaveRes{Id: uint(lastId)}
	} else {
		// 编辑
		_, err = dao.AdminMenu.Ctx(ctx).
			Data(data).
			OmitNil().
			Where("id", req.MenuSaveInp.Id).
			Update()
		if err != nil {
			return nil, err
		}
		res = &api.MenuSaveRes{Id: uint(req.MenuSaveInp.Id)}
	}
	return
}

// MenuDelete 菜单删除
func (c *ControllerV1) MenuDelete(ctx context.Context, req *api.MenuDeleteReq) (res *api.MenuDeleteRes, err error) {
	// 有子节点禁止删除
	childCount, err := dao.AdminMenu.Ctx(ctx).
		Where("parent_id", req.MenuDeleteInp.Id).
		Count()
	if err != nil {
		return nil, err
	}
	if childCount > 0 {
		return nil, gerror.NewCode(consts.CodeInvalidParam, "存在子菜单，无法删除，请先删除子节点")
	}

	_, err = dao.AdminMenu.Ctx(ctx).
		Where("id", req.MenuDeleteInp.Id).
		Delete()
	if err != nil {
		return nil, err
	}
	return &api.MenuDeleteRes{}, nil
}

// validateMenuSave 业务校验
// getAllParentRoleIds 递归获取角色及其所有父角色的ID（实现菜单权限继承）
func getAllParentRoleIds(ctx context.Context, roleIds []uint) ([]uint, error) {
	if len(roleIds) == 0 {
		return roleIds, nil
	}

	allIds := make(map[uint]struct{})
	for _, id := range roleIds {
		allIds[id] = struct{}{}
	}

	// 查询这些角色的详细信息（包含pid）
	var roles []entity.AdminRole
	if err := dao.AdminRole.Ctx(ctx).
		WhereIn("id", roleIds).
		Scan(&roles); err != nil {
		return nil, err
	}

	// 收集父角色ID
	parentIds := make([]uint, 0)
	for _, role := range roles {
		if role.Pid > 0 {
			if _, exists := allIds[uint(role.Pid)]; !exists {
				parentIds = append(parentIds, uint(role.Pid))
				allIds[uint(role.Pid)] = struct{}{}
			}
		}
	}

	// 递归查询父角色的父角色
	if len(parentIds) > 0 {
		ancestorIds, err := getAllParentRoleIds(ctx, parentIds)
		if err != nil {
			return nil, err
		}
		for _, id := range ancestorIds {
			allIds[id] = struct{}{}
		}
	}

	// 转换为切片
	result := make([]uint, 0, len(allIds))
	for id := range allIds {
		result = append(result, id)
	}
	return result, nil
}

func (c *ControllerV1) validateMenuSave(ctx context.Context, inp *adminin.MenuSaveInp) error {
	// 状态校验
	if inp.Status != 0 && inp.Status != 1 {
		return gerror.NewCode(consts.CodeInvalidParam, "状态仅支持 0/1")
	}

	// 类型约束
	switch inp.Type {
	case 1: // 目录
		if strings.TrimSpace(inp.Path) == "" {
			return gerror.NewCode(consts.CodeInvalidParam, "目录必须填写 path")
		}
		// 目录不需要 component
		inp.Component = ""
	case 2: // 菜单
		if strings.TrimSpace(inp.Path) == "" {
			return gerror.NewCode(consts.CodeInvalidParam, "菜单必须填写 path")
		}
		if strings.TrimSpace(inp.Component) == "" {
			return gerror.NewCode(consts.CodeInvalidParam, "菜单必须填写 component")
		}
	case 3: // 按钮
		// 按钮不需要 path/component
		inp.Path = ""
		inp.Component = ""
	default:
		return gerror.NewCode(consts.CodeInvalidParam, "类型只能为 1/2/3")
	}

	// 父节点校验
	if inp.ParentId != 0 {
		var parent *entity.AdminMenu
		if err := dao.AdminMenu.Ctx(ctx).
			Where("id", inp.ParentId).
			Scan(&parent); err != nil {
			return err
		}
		if parent == nil {
			return gerror.NewCode(consts.CodeDataNotFound, "父级菜单不存在")
		}
		if parent.Type == 3 {
			return gerror.NewCode(consts.CodeInvalidParam, "按钮类型不可作为父级")
		}
		if inp.Id != 0 && inp.Id == inp.ParentId {
			return gerror.NewCode(consts.CodeInvalidParam, "父级菜单不能选择自身")
		}
	}

	// 同级唯一：name、path
	if strings.TrimSpace(inp.Name) != "" {
		count, err := dao.AdminMenu.Ctx(ctx).
			Where("parent_id", inp.ParentId).
			Where("name", inp.Name).
			WhereNot("id", inp.Id).
			Count()
		if err != nil {
			return err
		}
		if count > 0 {
			return gerror.NewCode(consts.CodeInvalidParam, "同级已存在相同 name")
		}
	}
	if strings.TrimSpace(inp.Path) != "" {
		count, err := dao.AdminMenu.Ctx(ctx).
			Where("parent_id", inp.ParentId).
			Where("path", inp.Path).
			WhereNot("id", inp.Id).
			Count()
		if err != nil {
			return err
		}
		if count > 0 {
			return gerror.NewCode(consts.CodeInvalidParam, "同级已存在相同 path")
		}
	}

	return nil
}
