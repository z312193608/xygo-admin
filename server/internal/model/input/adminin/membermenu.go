package adminin

// ===================== 会员菜单树 =====================

// MemberMenuTreeInp 会员菜单树查询入参
type MemberMenuTreeInp struct {
	Status int `p:"status" d:"-1" json:"status" dc:"状态过滤:1启用,0禁用,-1全部"`
}

// MemberMenuTreeItem 会员菜单树节点（对齐 BuildAdmin user_rule 结构）
type MemberMenuTreeItem struct {
	Id           uint64                `json:"id" dc:"菜单ID"`
	Pid          uint64                `json:"pid" dc:"父级ID"`
	Title        string                `json:"title" dc:"菜单名称"`
	Name         string                `json:"name" dc:"路由名称"`
	Path         string                `json:"path" dc:"路由路径"`
	Component    string                `json:"component" dc:"Vue组件路径"`
	Icon         string                `json:"icon" dc:"图标"`
	MenuType     string                `json:"menuType" dc:"菜单打开方式：tab/link/iframe"`
	Url          string                `json:"url" dc:"外链/iframe地址"`
	NoLoginValid int                   `json:"noLoginValid" dc:"未登录是否有效：0否1是"`
	Extend       string                `json:"extend" dc:"扩展属性"`
	Remark       string                `json:"remark" dc:"备注"`
	Type            string                `json:"type" dc:"类型：route/menu_dir/menu/nav/nav_user_menu/button"`
	NavShowChildren int                   `json:"navShowChildren" dc:"顶栏展示子菜单：0否1是（仅nav）"`
	Permission      string                `json:"permission" dc:"权限标识"`
	Sort         int                   `json:"sort" dc:"排序"`
	Status       int                   `json:"status" dc:"状态:0禁用,1启用"`
	CreatedAt    string                `json:"createdAt" dc:"创建时间"`
	UpdatedAt    string                `json:"updatedAt" dc:"更新时间"`
	Children     []*MemberMenuTreeItem `json:"children,omitempty" dc:"子菜单"`
}

// MemberMenuTreeModel 会员菜单树响应模型
type MemberMenuTreeModel struct {
	List []*MemberMenuTreeItem `json:"list" dc:"菜单树"`
}

// ===================== 会员菜单保存 =====================

// MemberMenuSaveInp 会员菜单新增/编辑入参
type MemberMenuSaveInp struct {
	Id           uint64 `p:"id" json:"id" dc:"菜单ID（为空表示新增）"`
	Pid          uint64 `p:"pid" d:"0" json:"pid" dc:"父级菜单ID"`
	Title        string `p:"title" v:"required#菜单名称不能为空" json:"title" dc:"菜单名称"`
	Name         string `p:"name" json:"name" dc:"路由名称"`
	Path         string `p:"path" json:"path" dc:"路由路径"`
	Component    string `p:"component" json:"component" dc:"Vue组件路径"`
	Icon         string `p:"icon" json:"icon" dc:"图标"`
	MenuType     string `p:"menuType" d:"tab" json:"menuType" dc:"菜单打开方式：tab/link/iframe"`
	Url          string `p:"url" json:"url" dc:"外链/iframe地址"`
	NoLoginValid int    `p:"noLoginValid" d:"0" json:"noLoginValid" dc:"未登录是否有效：0否1是"`
	Extend       string `p:"extend" d:"none" json:"extend" dc:"扩展属性"`
	Remark       string `p:"remark" json:"remark" dc:"备注"`
	Type            string `p:"type" v:"required#类型不能为空" json:"type" dc:"类型：route/menu_dir/menu/nav/nav_user_menu/button"`
	NavShowChildren int    `p:"navShowChildren" d:"0" json:"navShowChildren" dc:"顶栏展示子菜单：0否1是（仅nav）"`
	Permission      string `p:"permission" json:"permission" dc:"权限标识"`
	Sort         int    `p:"sort" d:"0" json:"sort" dc:"排序"`
	Status       int    `p:"status" d:"1" json:"status" dc:"状态:0禁用,1启用"`
}

// ===================== 会员菜单删除 =====================

// MemberMenuDeleteInp 会员菜单删除入参
type MemberMenuDeleteInp struct {
	Id uint64 `p:"id" v:"required#菜单ID不能为空" json:"id" dc:"菜单ID"`
}
