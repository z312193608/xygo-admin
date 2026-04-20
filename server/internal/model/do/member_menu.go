// =================================================================================
// Code generated and maintained by GoFrame CLI tool. DO NOT EDIT.
// =================================================================================

package do

import (
	"github.com/gogf/gf/v2/frame/g"
)

// MemberMenu is the golang structure of table xy_member_menu for DAO operations like Where/Data.
type MemberMenu struct {
	g.Meta       `orm:"table:xy_member_menu, do:true"`
	Id           any // 菜单ID
	Pid          any // 父级ID
	Title        any // 菜单名称
	Name         any // 路由名称
	Path         any // 路由路径
	Component    any // Vue组件路径（相对于views/frontend/）
	Icon         any // 图标
	MenuType     any // 菜单打开方式：tab=标签页, link=外链, iframe=内嵌
	Url          any // 外链/iframe地址
	NoLoginValid any // 未登录是否有效：0=否 1=是（公开路由）
	Extend       any // 扩展属性：none=无, add_rules_only=仅添加为路由, add_menu_only=仅添加为菜单
	Remark       any // 备注
	Type            any // 类型：route=普通路由, menu_dir=会员中心菜单目录, menu=会员中心菜单项, nav=顶栏菜单项, nav_user_menu=顶栏会员菜单下拉, button=页面按钮
	NavShowChildren any // 顶栏展示子菜单：0否 1是（仅nav）
	Permission      any // 权限标识
	Sort         any // 排序
	Status       any // 状态：0=禁用 1=正常
	CreatedAt    any // 创建时间
	UpdatedAt    any // 更新时间
}
