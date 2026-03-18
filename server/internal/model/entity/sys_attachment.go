// =================================================================================
// Code generated and maintained by GoFrame CLI tool. DO NOT EDIT.
// =================================================================================

package entity

// SysAttachment is the golang structure for table sys_attachment.
type SysAttachment struct {
	Id         uint64 `json:"id"         orm:"id"          description:"ID"`            // ID
	Topic      string `json:"topic"      orm:"topic"       description:"分组/主题标识"`       // 分组/主题标识
	UserId     uint64 `json:"userId"     orm:"user_id"     description:"上传用户ID（预留）"`    // 上传用户ID（预留）
	Url        string `json:"url"        orm:"url"         description:"物理路径（相对路径）"`    // 物理路径（相对路径）
	Width      uint   `json:"width"      orm:"width"       description:"宽度"`            // 宽度
	Height     uint   `json:"height"     orm:"height"      description:"高度"`            // 高度
	Name       string `json:"name"       orm:"name"        description:"原始名称"`          // 原始名称
	Size       uint64 `json:"size"       orm:"size"        description:"大小（字节）"`        // 大小（字节）
	Mimetype   string `json:"mimetype"   orm:"mimetype"    description:"MIME类型"`        // MIME类型
	Quote      uint   `json:"quote"      orm:"quote"       description:"上传(引用)次数"`      // 上传(引用)次数
	Storage    string `json:"storage"    orm:"storage"     description:"存储方式：local=本地"` // 存储方式：local=本地
	Sha1       string `json:"sha1"       orm:"sha1"        description:"sha1摘要"`        // sha1摘要
	CreateTime uint   `json:"createTime" orm:"create_time" description:"创建时间"`          // 创建时间
	UpdateTime uint   `json:"updateTime" orm:"update_time" description:"更新时间"`          // 更新时间
}
