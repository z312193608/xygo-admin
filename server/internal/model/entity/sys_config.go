// =================================================================================
// Code generated and maintained by GoFrame CLI tool. DO NOT EDIT.
// =================================================================================

package entity

import (
	"github.com/gogf/gf/v2/encoding/gjson"
)

// SysConfig is the golang structure for table sys_config.
type SysConfig struct {
	Id         uint64      `json:"id"         orm:"id"          description:"主键"`                                                                                    // 主键
	Group      string      `json:"group"      orm:"group"       description:"分组标识，如 basics/mail/oss"`                                                                // 分组标识，如 basics/mail/oss
	GroupName  string      `json:"groupName"  orm:"group_name"  description:"分组名称"`                                                                                  // 分组名称
	Name       string      `json:"name"       orm:"name"        description:"配置项显示名"`                                                                                // 配置项显示名
	Key        string      `json:"key"        orm:"key"         description:"配置键（唯一）"`                                                                               // 配置键（唯一）
	Value      string      `json:"value"      orm:"value"       description:"配置值（字符串/JSON）"`                                                                         // 配置值（字符串/JSON）
	Type       string      `json:"type"       orm:"type"        description:"控件类型:text/textarea/number/switch/select/radio/checkbox/json/object/array/color/upload"` // 控件类型:text/textarea/number/switch/select/radio/checkbox/json/object/array/color/upload
	Options    *gjson.Json `json:"options"    orm:"options"     description:"组件参数/选项 JSON"`                                                                          // 组件参数/选项 JSON
	Rules      *gjson.Json `json:"rules"      orm:"rules"       description:"校验规则 JSON"`                                                                             // 校验规则 JSON
	Sort       int         `json:"sort"       orm:"sort"        description:"排序(大靠后)"`                                                                               // 排序(大靠后)
	Remark     string      `json:"remark"     orm:"remark"      description:"备注"`                                                                                    // 备注
	AllowDel   int         `json:"allowDel"   orm:"allow_del"   description:"允许删除:0=否,1=是"`                                                                          // 允许删除:0=否,1=是
	CreatedBy  uint64      `json:"createdBy"  orm:"created_by"  description:"创建人"`                                                                                   // 创建人
	UpdatedBy  uint64      `json:"updatedBy"  orm:"updated_by"  description:"更新人"`                                                                                   // 更新人
	CreateTime uint        `json:"createTime" orm:"create_time" description:"创建时间"`                                                                                  // 创建时间
	UpdateTime uint        `json:"updateTime" orm:"update_time" description:"更新时间"`                                                                                  // 更新时间
}
