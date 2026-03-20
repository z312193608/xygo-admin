// =================================================================================
// Code generated and maintained by GoFrame CLI tool. DO NOT EDIT.
// =================================================================================

package do

import (
	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/os/gtime"
)

// Member is the golang structure of table xy_member for DAO operations like Where/Data.
type Member struct {
	g.Meta      `orm:"table:xy_member, do:true"`
	Id          any         // 会员ID
	Username    any         // 用户名
	Password    any         // 密码（bcrypt加密）
	Mobile      any         // 手机号
	Email       any         // 邮箱
	Nickname    any         // 昵称
	Avatar      any         // 头像
	Gender      any         // 性别：0=未知 1=男 2=女
	Birthday    *gtime.Time // 生日
	Money       any         // 余额
	Score       any         // 积分
	Level       any         // 会员等级
	GroupId     any         // 会员分组ID
	Status      any         // 状态：0=禁用 1=正常
	LastLoginIp any         // 最后登录IP
	LastLoginAt any         // last login time
	LoginCount  any         // 登录次数
	CreatedAt   any         // 创建时间
	UpdatedAt   any         // 更新时间
	DeletedAt   any         // deleted time
	Salt        any         // 密码盐
}
