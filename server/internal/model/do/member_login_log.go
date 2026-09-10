// =================================================================================
// Code generated and maintained by GoFrame CLI tool. DO NOT EDIT.
// =================================================================================

package do

import (
	"github.com/gogf/gf/v2/frame/g"
)

// MemberLoginLog is the golang structure of table xy_member_login_log for DAO operations like Where/Data.
type MemberLoginLog struct {
	g.Meta    `orm:"table:xy_member_login_log, do:true"`
	Id        any // ID
	MemberId  any // 会员ID
	Username  any // 用户名
	Ip        any // 登录IP
	UserAgent any // User-Agent
	Status    any // 状态：0=失败 1=成功
	Message   any // 提示信息
	CreatedAt any // 创建时间
}
