// =================================================================================
// Code generated and maintained by GoFrame CLI tool. DO NOT EDIT.
// =================================================================================

package entity

// AdminDept is the golang structure for table admin_dept.
type AdminDept struct {
	Id         uint64 `json:"id"         orm:"id"          description:"部门ID"`       // 部门ID
	ParentId   uint64 `json:"parentId"   orm:"parent_id"   description:"上级部门ID"`     // 上级部门ID
	Name       string `json:"name"       orm:"name"        description:"部门名称"`       // 部门名称
	Sort       int    `json:"sort"       orm:"sort"        description:"排序"`         // 排序
	Status     int    `json:"status"     orm:"status"      description:"状态:0禁用,1启用"` // 状态:0禁用,1启用
	Remark     string `json:"remark"     orm:"remark"      description:"备注"`         // 备注
	CreateBy   uint64 `json:"createBy"   orm:"create_by"   description:"创建人"`        // 创建人
	CreateTime uint   `json:"createTime" orm:"create_time" description:"创建时间"`       // 创建时间
	UpdateTime uint   `json:"updateTime" orm:"update_time" description:"更新时间"`       // 更新时间
}
