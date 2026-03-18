// =================================================================================
// Code generated and maintained by GoFrame CLI tool. DO NOT EDIT.
// =================================================================================

package entity

// AdminUser is the golang structure for table admin_user.
type AdminUser struct {
	Id          uint64 `json:"id"          orm:"id"            description:"管理员ID"`           // 管理员ID
	Username    string `json:"username"    orm:"username"      description:"登录账号"`            // 登录账号
	Nickname    string `json:"nickname"    orm:"nickname"      description:"昵称"`              // 昵称
	RealName    string `json:"realName"    orm:"real_name"     description:"真实姓名"`            // 真实姓名
	Password    string `json:"password"    orm:"password"      description:"密码哈希"`            // 密码哈希
	Gender      int    `json:"gender"      orm:"gender"        description:"性别0保密 1男 2女"`     // 性别0保密 1男 2女
	Salt        string `json:"salt"        orm:"salt"          description:"密码盐"`             // 密码盐
	Mobile      string `json:"mobile"      orm:"mobile"        description:"手机号"`             // 手机号
	Address     string `json:"address"     orm:"address"       description:"地址"`              // 地址
	Remark      string `json:"remark"      orm:"remark"        description:"个人简介"`            // 个人简介
	Email       string `json:"email"       orm:"email"         description:"邮箱"`              // 邮箱
	Avatar      string `json:"avatar"      orm:"avatar"        description:"头像"`              // 头像
	DeptId      uint64 `json:"deptId"      orm:"dept_id"       description:"部门ID"`            // 部门ID
	Pid         uint64 `json:"pid"         orm:"pid"           description:"上级用户ID（直属上级）"`    // 上级用户ID（直属上级）
	IsSuper     int    `json:"isSuper"     orm:"is_super"      description:"是否超管:0=否,1=是"`    // 是否超管:0=否,1=是
	Status      int    `json:"status"      orm:"status"        description:"状态:0=禁用,1=启用"`    // 状态:0=禁用,1=启用
	LastLoginAt uint64 `json:"lastLoginAt" orm:"last_login_at" description:"last login time"` // last login time
	LastLoginIp string `json:"lastLoginIp" orm:"last_login_ip" description:"最后登录IP"`          // 最后登录IP
	CreatedBy   uint64 `json:"createdBy"   orm:"created_by"    description:"创建人ID"`           // 创建人ID
	UpdatedBy   uint64 `json:"updatedBy"   orm:"updated_by"    description:"更新人ID"`           // 更新人ID
	CreateTime  uint   `json:"createTime"  orm:"create_time"   description:"创建时间"`            // 创建时间
	UpdateTime  uint   `json:"updateTime"  orm:"update_time"   description:"更新时间"`            // 更新时间
}
