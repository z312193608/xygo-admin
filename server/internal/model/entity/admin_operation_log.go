// =================================================================================
// Code generated and maintained by GoFrame CLI tool. DO NOT EDIT.
// =================================================================================

package entity

// AdminOperationLog is the golang structure for table admin_operation_log.
type AdminOperationLog struct {
	Id           uint   `json:"id"           orm:"id"            description:"日志ID"`                        // 日志ID
	UserId       uint   `json:"userId"       orm:"user_id"       description:"操作人ID"`                       // 操作人ID
	Username     string `json:"username"     orm:"username"      description:"操作人账号"`                       // 操作人账号
	Module       string `json:"module"       orm:"module"        description:"模块名称（如：用户管理、角色管理）"`           // 模块名称（如：用户管理、角色管理）
	Title        string `json:"title"        orm:"title"         description:"操作标题/接口描述"`                   // 操作标题/接口描述
	Method       string `json:"method"       orm:"method"        description:"HTTP方法（GET/POST/PUT/DELETE）"` // HTTP方法（GET/POST/PUT/DELETE）
	Url          string `json:"url"          orm:"url"           description:"请求URL"`                       // 请求URL
	Ip           string `json:"ip"           orm:"ip"            description:"操作IP"`                        // 操作IP
	Location     string `json:"location"     orm:"location"      description:"操作地点"`                        // 操作地点
	UserAgent    string `json:"userAgent"    orm:"user_agent"    description:"User-Agent"`                  // User-Agent
	RequestBody  string `json:"requestBody"  orm:"request_body"  description:"请求参数（JSON）"`                  // 请求参数（JSON）
	ResponseBody string `json:"responseBody" orm:"response_body" description:"响应结果（JSON，可选截断存储）"`           // 响应结果（JSON，可选截断存储）
	ErrorMessage string `json:"errorMessage" orm:"error_message" description:"错误信息"`                        // 错误信息
	Status       int    `json:"status"       orm:"status"        description:"状态：0=失败 1=成功"`                // 状态：0=失败 1=成功
	Elapsed      uint   `json:"elapsed"      orm:"elapsed"       description:"耗时（毫秒）"`                      // 耗时（毫秒）
	CreatedAt    uint64 `json:"createdAt"    orm:"created_at"    description:"创建时间"`                        // 创建时间
}
