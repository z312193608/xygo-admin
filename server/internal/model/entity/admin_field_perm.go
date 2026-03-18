// =================================================================================
// Code generated and maintained by GoFrame CLI tool. DO NOT EDIT.
// =================================================================================

package entity

// AdminFieldPerm is the golang structure for table admin_field_perm.
type AdminFieldPerm struct {
	Id         uint64 `json:"id"         orm:"id"          description:"主键"`                                   // 主键
	RoleId     uint64 `json:"roleId"     orm:"role_id"     description:"角色ID"`                                 // 角色ID
	Module     string `json:"module"     orm:"module"      description:"模块名称（如：system、org）"`                   // 模块名称（如：system、org）
	Resource   string `json:"resource"   orm:"resource"    description:"资源标识（表名或页面标识，如：admin_user、user_list）"` // 资源标识（表名或页面标识，如：admin_user、user_list）
	FieldName  string `json:"fieldName"  orm:"field_name"  description:"字段名称（如：mobile、salary）"`                // 字段名称（如：mobile、salary）
	FieldLabel string `json:"fieldLabel" orm:"field_label" description:"字段显示名称（用于界面展示）"`                       // 字段显示名称（用于界面展示）
	PermType   int    `json:"permType"   orm:"perm_type"   description:"权限类型：0=不可见，1=只读，2=可编辑"`                // 权限类型：0=不可见，1=只读，2=可编辑
	Status     int    `json:"status"     orm:"status"      description:"状态：0=禁用，1=启用"`                         // 状态：0=禁用，1=启用
	Remark     string `json:"remark"     orm:"remark"      description:"备注"`                                   // 备注
	CreateTime uint   `json:"createTime" orm:"create_time" description:"创建时间"`                                 // 创建时间
	UpdateTime uint   `json:"updateTime" orm:"update_time" description:"更新时间"`                                 // 更新时间
}
