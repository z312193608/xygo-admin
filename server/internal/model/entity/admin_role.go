// =================================================================================
// Code generated and maintained by GoFrame CLI tool. DO NOT EDIT.
// =================================================================================

package entity

// AdminRole is the golang structure for table admin_role.
type AdminRole struct {
	Id          uint64 `json:"id"          orm:"id"           description:"角色ID"`                                  // 角色ID
	Name        string `json:"name"        orm:"name"         description:"角色名称"`                                  // 角色名称
	Key         string `json:"key"         orm:"key"          description:"角色标识(英文唯一)"`                            // 角色标识(英文唯一)
	DataScope   int    `json:"dataScope"   orm:"data_scope"   description:"数据范围:0=全部,1=本部门,2=本部门及子,3=仅本人,4=自定义部门"` // 数据范围:0=全部,1=本部门,2=本部门及子,3=仅本人,4=自定义部门
	CustomDepts string `json:"customDepts" orm:"custom_depts" description:"自定义数据范围部门ID列表(JSON数组)"`                 // 自定义数据范围部门ID列表(JSON数组)
	Pid         uint64 `json:"pid"         orm:"pid"          description:"上级角色ID"`                                // 上级角色ID
	Level       int64  `json:"level"       orm:"level"        description:"关系树等级（根为1）"`                            // 关系树等级（根为1）
	Tree        string `json:"tree"        orm:"tree"         description:"关系树路径，如 0,1,3"`                         // 关系树路径，如 0,1,3
	Sort        int    `json:"sort"        orm:"sort"         description:"排序（越小越靠前）"`                             // 排序（越小越靠前）
	Status      int    `json:"status"      orm:"status"       description:"状态:0=禁用,1=启用"`                          // 状态:0=禁用,1=启用
	Remark      string `json:"remark"      orm:"remark"       description:"备注"`                                    // 备注
	CreatedBy   uint64 `json:"createdBy"   orm:"created_by"   description:"创建人ID"`                                 // 创建人ID
	UpdatedBy   uint64 `json:"updatedBy"   orm:"updated_by"   description:"更新人ID"`                                 // 更新人ID
	CreateTime  uint   `json:"createTime"  orm:"create_time"  description:"创建时间"`                                  // 创建时间
	UpdateTime  uint   `json:"updateTime"  orm:"update_time"  description:"更新时间"`                                  // 更新时间
}
