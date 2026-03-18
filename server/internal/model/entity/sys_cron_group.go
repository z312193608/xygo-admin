// =================================================================================
// Code generated and maintained by GoFrame CLI tool. DO NOT EDIT.
// =================================================================================

package entity

// SysCronGroup is the golang structure for table sys_cron_group.
type SysCronGroup struct {
	Id        uint64 `json:"id"        orm:"id"         description:"分组ID"`       // 分组ID
	Name      string `json:"name"      orm:"name"       description:"分组名称"`       // 分组名称
	Sort      int    `json:"sort"      orm:"sort"       description:"排序（越小越靠前）"`  // 排序（越小越靠前）
	Remark    string `json:"remark"    orm:"remark"     description:"备注"`         // 备注
	Status    int    `json:"status"    orm:"status"     description:"状态:0禁用,1启用"` // 状态:0禁用,1启用
	CreatedAt uint   `json:"createdAt" orm:"created_at" description:"创建时间"`       // 创建时间
	UpdatedAt uint   `json:"updatedAt" orm:"updated_at" description:"更新时间"`       // 更新时间
}
