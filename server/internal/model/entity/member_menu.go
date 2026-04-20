// =================================================================================
// Code generated and maintained by GoFrame CLI tool. DO NOT EDIT.
// =================================================================================

package entity

// MemberMenu is the golang structure for table member_menu.
type MemberMenu struct {
	Id           uint64 `json:"id"           orm:"id"             description:"菜单ID"`                                                                                           // 菜单ID
	Pid          uint64 `json:"pid"          orm:"pid"            description:"父级ID"`                                                                                           // 父级ID
	Title        string `json:"title"        orm:"title"          description:"菜单名称"`                                                                                           // 菜单名称
	Name         string `json:"name"         orm:"name"           description:"路由名称"`                                                                                           // 路由名称
	Path         string `json:"path"         orm:"path"           description:"路由路径"`                                                                                           // 路由路径
	Component    string `json:"component"    orm:"component"      description:"Vue组件路径（相对于views/frontend/）"`                                                                    // Vue组件路径（相对于views/frontend/）
	Icon         string `json:"icon"         orm:"icon"           description:"图标"`                                                                                             // 图标
	MenuType     string `json:"menuType"     orm:"menu_type"      description:"菜单打开方式：tab=标签页, link=外链, iframe=内嵌"`                                                             // 菜单打开方式：tab=标签页, link=外链, iframe=内嵌
	Url          string `json:"url"          orm:"url"            description:"外链/iframe地址"`                                                                                    // 外链/iframe地址
	NoLoginValid int    `json:"noLoginValid" orm:"no_login_valid" description:"未登录是否有效：0=否 1=是（公开路由）"`                                                                          // 未登录是否有效：0=否 1=是（公开路由）
	Extend       string `json:"extend"       orm:"extend"         description:"扩展属性：none=无, add_rules_only=仅添加为路由, add_menu_only=仅添加为菜单"`                                       // 扩展属性：none=无, add_rules_only=仅添加为路由, add_menu_only=仅添加为菜单
	Remark       string `json:"remark"       orm:"remark"         description:"备注"`                                                                                             // 备注
	Type            string `json:"type"             orm:"type"               description:"类型：route=普通路由, menu_dir=会员中心菜单目录, menu=会员中心菜单项, nav=顶栏菜单项, nav_user_menu=顶栏会员菜单下拉, button=页面按钮"` // 类型：route=普通路由, menu_dir=会员中心菜单目录, menu=会员中心菜单项, nav=顶栏菜单项, nav_user_menu=顶栏会员菜单下拉, button=页面按钮
	NavShowChildren int    `json:"navShowChildren"  orm:"nav_show_children"  description:"顶栏展示子菜单：0否 1是（仅type=nav）"`
	Permission      string `json:"permission"       orm:"permission"         description:"权限标识"`                                                                                           // 权限标识
	Sort         int    `json:"sort"         orm:"sort"           description:"排序"`                                                                                             // 排序
	Status       int    `json:"status"       orm:"status"         description:"状态：0=禁用 1=正常"`                                                                                   // 状态：0=禁用 1=正常
	CreatedAt    uint64 `json:"createdAt"    orm:"created_at"     description:"创建时间"`                                                                                           // 创建时间
	UpdatedAt    uint64 `json:"updatedAt"    orm:"updated_at"     description:"更新时间"`                                                                                           // 更新时间
}
