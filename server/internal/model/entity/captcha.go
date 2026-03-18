// =================================================================================
// Code generated and maintained by GoFrame CLI tool. DO NOT EDIT.
// =================================================================================

package entity

// Captcha is the golang structure for table captcha.
type Captcha struct {
	Id         uint64 `json:"id"         orm:"id"          description:""`                    //
	Key        string `json:"key"        orm:"key"         description:"验证码key（MD5）"`         // 验证码key（MD5）
	Code       string `json:"code"       orm:"code"        description:"验证码code（MD5）"`        // 验证码code（MD5）
	Captcha    string `json:"captcha"    orm:"captcha"     description:"验证码数据（JSON，包含点位坐标等）"` // 验证码数据（JSON，包含点位坐标等）
	CreateTime uint   `json:"createTime" orm:"create_time" description:"创建时间（unix秒）"`         // 创建时间（unix秒）
	ExpireTime uint   `json:"expireTime" orm:"expire_time" description:"过期时间（unix秒）"`         // 过期时间（unix秒）
}
