// ==========================================================================
// Code generated and maintained by GoFrame CLI tool. DO NOT EDIT.
// ==========================================================================

package internal

import (
	"context"

	"github.com/gogf/gf/v2/database/gdb"
	"github.com/gogf/gf/v2/frame/g"
)

// MemberMenuDao is the data access object for the table xy_member_menu.
type MemberMenuDao struct {
	table    string             // table is the underlying table name of the DAO.
	group    string             // group is the database configuration group name of the current DAO.
	columns  MemberMenuColumns  // columns contains all the column names of Table for convenient usage.
	handlers []gdb.ModelHandler // handlers for customized model modification.
}

// MemberMenuColumns defines and stores column names for the table xy_member_menu.
type MemberMenuColumns struct {
	Id           string // 菜单ID
	Pid          string // 父级ID
	Title        string // 菜单名称
	Name         string // 路由名称
	Path         string // 路由路径
	Component    string // Vue组件路径（相对于views/frontend/）
	Icon         string // 图标
	MenuType     string // 菜单打开方式：tab=标签页, link=外链, iframe=内嵌
	Url          string // 外链/iframe地址
	NoLoginValid string // 未登录是否有效：0=否 1=是（公开路由）
	Extend       string // 扩展属性：none=无, add_rules_only=仅添加为路由, add_menu_only=仅添加为菜单
	Remark       string // 备注
	Type            string // 类型：route=普通路由, menu_dir=会员中心菜单目录, menu=会员中心菜单项, nav=顶栏菜单项, nav_user_menu=顶栏会员菜单下拉, button=页面按钮
	NavShowChildren string // 顶栏展示子菜单：0否 1是（仅nav）
	Permission      string // 权限标识
	Sort         string // 排序
	Status       string // 状态：0=禁用 1=正常
	CreatedAt    string // 创建时间
	UpdatedAt    string // 更新时间
}

// memberMenuColumns holds the columns for the table xy_member_menu.
var memberMenuColumns = MemberMenuColumns{
	Id:           "id",
	Pid:          "pid",
	Title:        "title",
	Name:         "name",
	Path:         "path",
	Component:    "component",
	Icon:         "icon",
	MenuType:     "menu_type",
	Url:          "url",
	NoLoginValid: "no_login_valid",
	Extend:       "extend",
	Remark:       "remark",
	Type:            "type",
	NavShowChildren: "nav_show_children",
	Permission:      "permission",
	Sort:         "sort",
	Status:       "status",
	CreatedAt:    "created_at",
	UpdatedAt:    "updated_at",
}

// NewMemberMenuDao creates and returns a new DAO object for table data access.
func NewMemberMenuDao(handlers ...gdb.ModelHandler) *MemberMenuDao {
	return &MemberMenuDao{
		group:    "default",
		table:    "xy_member_menu",
		columns:  memberMenuColumns,
		handlers: handlers,
	}
}

// DB retrieves and returns the underlying raw database management object of the current DAO.
func (dao *MemberMenuDao) DB() gdb.DB {
	return g.DB(dao.group)
}

// Table returns the table name of the current DAO.
func (dao *MemberMenuDao) Table() string {
	return dao.table
}

// Columns returns all column names of the current DAO.
func (dao *MemberMenuDao) Columns() MemberMenuColumns {
	return dao.columns
}

// Group returns the database configuration group name of the current DAO.
func (dao *MemberMenuDao) Group() string {
	return dao.group
}

// Ctx creates and returns a Model for the current DAO. It automatically sets the context for the current operation.
func (dao *MemberMenuDao) Ctx(ctx context.Context) *gdb.Model {
	model := dao.DB().Model(dao.table)
	for _, handler := range dao.handlers {
		model = handler(model)
	}
	return model.Safe().Ctx(ctx)
}

// Transaction wraps the transaction logic using function f.
// It rolls back the transaction and returns the error if function f returns a non-nil error.
// It commits the transaction and returns nil if function f returns nil.
//
// Note: Do not commit or roll back the transaction in function f,
// as it is automatically handled by this function.
func (dao *MemberMenuDao) Transaction(ctx context.Context, f func(ctx context.Context, tx gdb.TX) error) (err error) {
	return dao.Ctx(ctx).Transaction(ctx, f)
}
