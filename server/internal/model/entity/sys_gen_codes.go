// =================================================================================
// Code generated and maintained by GoFrame CLI tool. DO NOT EDIT.
// =================================================================================

package entity

import (
	"github.com/gogf/gf/v2/encoding/gjson"
)

// SysGenCodes is the golang structure for table sys_gen_codes.
type SysGenCodes struct {
	Id           uint64      `json:"id"           orm:"id"            description:"主键"`                 // 主键
	GenType      uint        `json:"genType"      orm:"gen_type"      description:"生成类型:10=普通列表,11=树表"` // 生成类型:10=普通列表,11=树表
	DbName       string      `json:"dbName"       orm:"db_name"       description:"数据库名"`               // 数据库名
	TableName    string      `json:"tableName"    orm:"table_name"    description:"数据表名"`               // 数据表名
	TableComment string      `json:"tableComment" orm:"table_comment" description:"表注释(菜单名)"`           // 表注释(菜单名)
	VarName      string      `json:"varName"      orm:"var_name"      description:"实体名(PascalCase)"`    // 实体名(PascalCase)
	Options      *gjson.Json `json:"options"      orm:"options"       description:"生成选项(JSON)"`         // 生成选项(JSON)
	Status       uint        `json:"status"       orm:"status"        description:"状态:1=已生成,2=未生成"`     // 状态:1=已生成,2=未生成
	CreatedAt    uint64      `json:"createdAt"    orm:"created_at"    description:"创建时间戳"`              // 创建时间戳
	UpdatedAt    uint64      `json:"updatedAt"    orm:"updated_at"    description:"更新时间戳"`              // 更新时间戳
}
