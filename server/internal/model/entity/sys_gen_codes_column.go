// =================================================================================
// Code generated and maintained by GoFrame CLI tool. DO NOT EDIT.
// =================================================================================

package entity

// SysGenCodesColumn is the golang structure for table sys_gen_codes_column.
type SysGenCodesColumn struct {
	Id         uint64 `json:"id"         orm:"id"          description:"主键"`                         // 主键
	GenId      uint64 `json:"genId"      orm:"gen_id"      description:"关联gen_codes.id"`             // 关联gen_codes.id
	Name       string `json:"name"       orm:"name"        description:"数据库字段名"`                     // 数据库字段名
	GoName     string `json:"goName"     orm:"go_name"     description:"Go字段名"`                      // Go字段名
	TsName     string `json:"tsName"     orm:"ts_name"     description:"TS字段名"`                      // TS字段名
	DbType     string `json:"dbType"     orm:"db_type"     description:"数据库类型"`                      // 数据库类型
	GoType     string `json:"goType"     orm:"go_type"     description:"Go类型"`                       // Go类型
	TsType     string `json:"tsType"     orm:"ts_type"     description:"TS类型"`                       // TS类型
	Comment    string `json:"comment"    orm:"comment"     description:"字段注释"`                       // 字段注释
	IsPk       uint   `json:"isPk"       orm:"is_pk"       description:"是否主键:0=否,1=是"`               // 是否主键:0=否,1=是
	IsRequired uint   `json:"isRequired" orm:"is_required" description:"是否必填:0=否,1=是"`               // 是否必填:0=否,1=是
	IsList     uint   `json:"isList"     orm:"is_list"     description:"表格列显示:0=否,1=是"`              // 表格列显示:0=否,1=是
	IsEdit     uint   `json:"isEdit"     orm:"is_edit"     description:"表单编辑显示:0=否,1=是"`             // 表单编辑显示:0=否,1=是
	IsQuery    uint   `json:"isQuery"    orm:"is_query"    description:"搜索条件:0=否,1=是"`               // 搜索条件:0=否,1=是
	QueryType  string `json:"queryType"  orm:"query_type"  description:"查询方式:eq/like/between/gt/in"` // 查询方式:eq/like/between/gt/in
	DesignType string `json:"designType" orm:"design_type" description:"设计类型(designType)"`           // 设计类型(designType)
	Extra      string `json:"extra"      orm:"extra"       description:"扩展配置JSON(关联表配置/表格属性/表单属性等)"` // 扩展配置JSON(关联表配置/表格属性/表单属性等)
	FormType   string `json:"formType"   orm:"form_type"   description:"表单组件类型"`                     // 表单组件类型
	DictType   string `json:"dictType"   orm:"dict_type"   description:"关联字典"`                       // 关联字典
	Sort       uint   `json:"sort"       orm:"sort"        description:"排序"`                         // 排序
}
