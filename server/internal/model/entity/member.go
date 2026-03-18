// =================================================================================
// Code generated and maintained by GoFrame CLI tool. DO NOT EDIT.
// =================================================================================

package entity

import (
	"github.com/gogf/gf/v2/os/gtime"
)

// Member is the golang structure for table member.
type Member struct {
	Id          uint64      `json:"id"          orm:"id"            description:"会员ID"`            // 会员ID
	Username    string      `json:"username"    orm:"username"      description:"用户名"`             // 用户名
	Password    string      `json:"password"    orm:"password"      description:"密码（bcrypt加密）"`    // 密码（bcrypt加密）
	Mobile      string      `json:"mobile"      orm:"mobile"        description:"手机号"`             // 手机号
	Email       string      `json:"email"       orm:"email"         description:"邮箱"`              // 邮箱
	Nickname    string      `json:"nickname"    orm:"nickname"      description:"昵称"`              // 昵称
	Avatar      string      `json:"avatar"      orm:"avatar"        description:"头像"`              // 头像
	Gender      int         `json:"gender"      orm:"gender"        description:"性别：0=未知 1=男 2=女"` // 性别：0=未知 1=男 2=女
	Birthday    *gtime.Time `json:"birthday"    orm:"birthday"      description:"生日"`              // 生日
	Money       float64     `json:"money"       orm:"money"         description:"余额"`              // 余额
	Score       int         `json:"score"       orm:"score"         description:"积分"`              // 积分
	Level       uint        `json:"level"       orm:"level"         description:"会员等级"`            // 会员等级
	GroupId     uint64      `json:"groupId"     orm:"group_id"      description:"会员分组ID"`          // 会员分组ID
	Status      int         `json:"status"      orm:"status"        description:"状态：0=禁用 1=正常"`    // 状态：0=禁用 1=正常
	LastLoginIp string      `json:"lastLoginIp" orm:"last_login_ip" description:"最后登录IP"`          // 最后登录IP
	LastLoginAt uint64      `json:"lastLoginAt" orm:"last_login_at" description:"last login time"` // last login time
	LoginCount  uint        `json:"loginCount"  orm:"login_count"   description:"登录次数"`            // 登录次数
	CreatedAt   uint64      `json:"createdAt"   orm:"created_at"    description:"创建时间"`            // 创建时间
	UpdatedAt   uint64      `json:"updatedAt"   orm:"updated_at"    description:"更新时间"`            // 更新时间
	DeletedAt   uint64      `json:"deletedAt"   orm:"deleted_at"    description:"deleted time"`    // deleted time
}
