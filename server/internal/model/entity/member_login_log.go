// =================================================================================
// Code generated and maintained by GoFrame CLI tool. DO NOT EDIT.
// =================================================================================

package entity

// MemberLoginLog is the golang structure for table member_login_log.
type MemberLoginLog struct {
	Id        uint64 `json:"id"        orm:"id"         description:"ID"`           // ID
	MemberId  uint64 `json:"memberId"  orm:"member_id"  description:"会员ID"`         // 会员ID
	Username  string `json:"username"  orm:"username"   description:"用户名"`          // 用户名
	Ip        string `json:"ip"        orm:"ip"         description:"登录IP"`         // 登录IP
	UserAgent string `json:"userAgent" orm:"user_agent" description:"User-Agent"`   // User-Agent
	Status    int    `json:"status"    orm:"status"     description:"状态：0=失败 1=成功"` // 状态：0=失败 1=成功
	Message   string `json:"message"   orm:"message"    description:"提示信息"`         // 提示信息
	CreatedAt uint64 `json:"createdAt" orm:"created_at" description:"创建时间"`         // 创建时间
}
