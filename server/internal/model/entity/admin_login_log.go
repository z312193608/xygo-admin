// =================================================================================
// Code generated and maintained by GoFrame CLI tool. DO NOT EDIT.
// =================================================================================

package entity

// AdminLoginLog is the golang structure for table admin_login_log.
type AdminLoginLog struct {
	Id        uint   `json:"id"        orm:"id"         description:"日志ID"`          // 日志ID
	UserId    uint   `json:"userId"    orm:"user_id"    description:"管理员ID（0=未知用户）"` // 管理员ID（0=未知用户）
	Username  string `json:"username"  orm:"username"   description:"登录账号"`          // 登录账号
	Ip        string `json:"ip"        orm:"ip"         description:"登录IP"`          // 登录IP
	Location  string `json:"location"  orm:"location"   description:"登录地点"`          // 登录地点
	UserAgent string `json:"userAgent" orm:"user_agent" description:"User-Agent"`    // User-Agent
	Browser   string `json:"browser"   orm:"browser"    description:"浏览器"`           // 浏览器
	Os        string `json:"os"        orm:"os"         description:"操作系统"`          // 操作系统
	Status    int    `json:"status"    orm:"status"     description:"状态：0=失败 1=成功"`  // 状态：0=失败 1=成功
	Message   string `json:"message"   orm:"message"    description:"提示消息"`          // 提示消息
	CreatedAt uint64 `json:"createdAt" orm:"created_at" description:"创建时间"`          // 创建时间
}
