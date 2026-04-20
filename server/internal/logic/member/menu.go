// =================================================================================
// 会员菜单逻辑层
// =================================================================================

package member

import (
	"context"

	"github.com/gogf/gf/v2/errors/gerror"

	"xygo/internal/consts"
	"xygo/internal/dao"
	"xygo/internal/model"
	"xygo/internal/model/do"
	"xygo/internal/model/input/adminin"
)

type sAdminMemberMenu struct{}

// NewAdminMemberMenu 构造会员菜单服务
func NewAdminMemberMenu() *sAdminMemberMenu {
	return &sAdminMemberMenu{}
}

// Tree 获取会员菜单树
func (s *sAdminMemberMenu) Tree(ctx context.Context, in *adminin.MemberMenuTreeInp) ([]*adminin.MemberMenuTreeItem, error) {
	modelQuery := dao.MemberMenu.Ctx(ctx)

	// 状态过滤
	if in.Status == 0 || in.Status == 1 {
		modelQuery = modelQuery.Where("status", in.Status)
	}

	// 查询全部菜单
	var list []adminin.MemberMenuTreeItem
	err := modelQuery.
		OrderAsc("sort, id").
		Scan(&list)
	if err != nil {
		return nil, err
	}

	// 组装树结构
	nodes := make([]*adminin.MemberMenuTreeItem, 0, len(list))
	for i := range list {
		nodes = append(nodes, &list[i])
	}

	rootPtrs := model.BuildTree(
		nodes,
		func(n *adminin.MemberMenuTreeItem) uint { return uint(n.Id) },
		func(n *adminin.MemberMenuTreeItem) uint { return uint(n.Pid) },
		func(n *adminin.MemberMenuTreeItem, children []*adminin.MemberMenuTreeItem) { n.Children = children },
	)

	roots := make([]*adminin.MemberMenuTreeItem, 0, len(rootPtrs))
	for _, n := range rootPtrs {
		if n == nil {
			continue
		}
		roots = append(roots, n)
	}

	return roots, nil
}

// Save 保存会员菜单（新增/编辑）
// 对齐 BuildAdmin 类型约束：
// - menu_dir/menu/nav_user_menu → 强制 no_login_valid = 0
// - route → 强制 menu_type = "tab"
// - button → 清空 path/component/menu_type/url
func (s *sAdminMemberMenu) Save(ctx context.Context, in *adminin.MemberMenuSaveInp) (uint, error) {
	// 类型约束（对齐 BuildAdmin beforeSubmit 逻辑）
	switch in.Type {
	case "menu_dir", "menu", "nav_user_menu":
		in.NoLoginValid = 0
		in.NavShowChildren = 0
	case "route":
		in.MenuType = "tab"
	case "button":
		in.Path = ""
		in.Component = ""
		in.MenuType = "tab"
		in.Url = ""
		in.NavShowChildren = 0
	}
	if in.Type != "nav" {
		in.NavShowChildren = 0
	}
	if in.NavShowChildren != 0 && in.NavShowChildren != 1 {
		in.NavShowChildren = 0
	}

	// 校验路由名称唯一性（非按钮类型）
	if in.Type != "button" && in.Name != "" {
		count, err := dao.MemberMenu.Ctx(ctx).
			Where("name", in.Name).
			WhereNot("id", in.Id).
			Count()
		if err != nil {
			return 0, err
		}
		if count > 0 {
			return 0, gerror.NewCode(consts.CodeInvalidParam, "路由名称已存在")
		}
	}

	data := do.MemberMenu{
		Pid:          in.Pid,
		Title:        in.Title,
		Name:         in.Name,
		Path:         in.Path,
		Component:    in.Component,
		Icon:         in.Icon,
		MenuType:     in.MenuType,
		Url:          in.Url,
		NoLoginValid: in.NoLoginValid,
		Extend:       in.Extend,
		Remark:       in.Remark,
		Type:            in.Type,
		NavShowChildren: in.NavShowChildren,
		Permission:      in.Permission,
		Sort:         in.Sort,
		Status:       in.Status,
	}

	if in.Id == 0 {
		// 新增
		r, err := dao.MemberMenu.Ctx(ctx).Data(data).OmitNil().Insert()
		if err != nil {
			return 0, err
		}
		lastId, err := r.LastInsertId()
		if err != nil {
			return 0, err
		}
		return uint(lastId), nil
	}

	// 编辑
	_, err := dao.MemberMenu.Ctx(ctx).
		Data(data).
		OmitNil().
		Where("id", in.Id).
		Update()
	if err != nil {
		return 0, err
	}
	return uint(in.Id), nil
}

// Delete 删除会员菜单
func (s *sAdminMemberMenu) Delete(ctx context.Context, id uint64) error {
	// 检查是否有子菜单
	childCount, err := dao.MemberMenu.Ctx(ctx).
		Where("pid", id).
		Count()
	if err != nil {
		return err
	}
	if childCount > 0 {
		return gerror.NewCode(consts.CodeInvalidParam, "该菜单下还有子菜单，请先删除子菜单")
	}

	_, err = dao.MemberMenu.Ctx(ctx).
		Where("id", id).
		Delete()
	return err
}
