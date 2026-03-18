// =================================================================================
// Code generated and maintained by GoFrame CLI tool. DO NOT EDIT.
// =================================================================================

package entity

// AdminNotice is the golang structure for table admin_notice.
type AdminNotice struct {
	Id         uint64 `json:"id"         orm:"id"          description:"主键"`                              // 主键
	Title      string `json:"title"      orm:"title"       description:"标题"`                              // 标题
	Type       int    `json:"type"       orm:"type"        description:"类型:1=通知,2=公告,3=私信"`               // 类型:1=通知,2=公告,3=私信
	Content    string `json:"content"    orm:"content"     description:"内容(HTML)"`                        // 内容(HTML)
	Tag        string `json:"tag"        orm:"tag"         description:"标签(info/success/warning/danger)"` // 标签(info/success/warning/danger)
	SenderId   uint64 `json:"senderId"   orm:"sender_id"   description:"发送人ID(0=系统)"`                     // 发送人ID(0=系统)
	ReceiverId uint64 `json:"receiverId" orm:"receiver_id" description:"接收人ID(0=全员)"`                     // 接收人ID(0=全员)
	Status     int    `json:"status"     orm:"status"      description:"状态:1=正常,2=关闭"`                    // 状态:1=正常,2=关闭
	Sort       int    `json:"sort"       orm:"sort"        description:"排序"`                              // 排序
	Remark     string `json:"remark"     orm:"remark"      description:"备注"`                              // 备注
	ReadCount  uint   `json:"readCount"  orm:"read_count"  description:"已读人数"`                            // 已读人数
	CreatedAt  uint64 `json:"createdAt"  orm:"created_at"  description:"创建时间"`                            // 创建时间
	UpdatedAt  uint64 `json:"updatedAt"  orm:"updated_at"  description:"更新时间"`                            // 更新时间
}
