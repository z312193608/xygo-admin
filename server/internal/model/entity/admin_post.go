// =================================================================================
// Code generated and maintained by GoFrame CLI tool. DO NOT EDIT.
// =================================================================================

package entity

// AdminPost is the golang structure for table admin_post.
type AdminPost struct {
	Id         uint64 `json:"id"         orm:"id"          description:"岗位ID"`         // 岗位ID
	Code       string `json:"code"       orm:"code"        description:"岗位编码"`         // 岗位编码
	Name       string `json:"name"       orm:"name"        description:"岗位名称"`         // 岗位名称
	Sort       int    `json:"sort"       orm:"sort"        description:"排序(越小越靠前)"`    // 排序(越小越靠前)
	Status     int    `json:"status"     orm:"status"      description:"状态:0=禁用,1=启用"` // 状态:0=禁用,1=启用
	Remark     string `json:"remark"     orm:"remark"      description:"备注"`           // 备注
	CreatedBy  uint64 `json:"createdBy"  orm:"created_by"  description:"创建人ID"`        // 创建人ID
	UpdatedBy  uint64 `json:"updatedBy"  orm:"updated_by"  description:"更新人ID"`        // 更新人ID
	CreateTime uint   `json:"createTime" orm:"create_time" description:"创建时间"`         // 创建时间
	UpdateTime uint   `json:"updateTime" orm:"update_time" description:"更新时间"`         // 更新时间
}
