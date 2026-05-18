// +----------------------------------------------------------------------
// | XYGo Admin [ Vue3 + GoFrame 企业级中后台管理系统 ]
// +----------------------------------------------------------------------
// | Copyright (c) 2026 大连星韵网络科技有限公司 All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( https://opensource.org/licenses/MIT )
// +----------------------------------------------------------------------
// | Author: 喜羊羊 <751300685@qq.com>
// +----------------------------------------------------------------------

package adminin

import "xygo/internal/model/input/form"

// ==================== 通知消息 ====================

// NoticeListInp 通知列表入参
type NoticeListInp struct {
	form.PageReq
	Type   int `json:"type"   dc:"类型:1=通知,2=公告,3=私信"`
	Status int `json:"status" dc:"状态:1=正常,2=关闭"`
}

// NoticeListItem 通知列表项
type NoticeListItem struct {
	Id         uint64 `json:"id"`
	Title      string `json:"title"`
	Type       int    `json:"type"`
	Content    string `json:"content"`
	Tag        string `json:"tag"`
	SenderId   uint64 `json:"senderId"`
	SenderName string `json:"senderName"` // 关联查询
	ReceiverId uint64 `json:"receiverId"`
	Status     int    `json:"status"`
	ReadCount  uint   `json:"readCount"`
	CreatedAt  uint64 `json:"createdAt"`
}

// NoticeListModel 通知列表出参
type NoticeListModel struct {
	List []NoticeListItem `json:"list"`
	form.PageRes
}

// NoticeEditInp 编辑通知入参
type NoticeEditInp struct {
	Id         uint64 `json:"id"         dc:"ID"`
	Title      string `json:"title"      v:"required#标题不能为空" dc:"标题"`
	Type       int    `json:"type"       v:"required|in:1,2,3#类型不能为空|类型值无效" dc:"类型"`
	Content    string `json:"content"    dc:"内容"`
	Tag        string `json:"tag"        dc:"标签"`
	ReceiverId uint64 `json:"receiverId" dc:"接收人ID(0=全员)"`
	Status     int    `json:"status"     d:"1" dc:"状态"`
	Sort       int    `json:"sort"       dc:"排序"`
	Remark     string `json:"remark"     dc:"备注"`
}

// NoticeDeleteInp 删除通知入参
type NoticeDeleteInp struct {
	Id uint64 `json:"id" v:"required#ID不能为空" dc:"ID"`
}

// ==================== 用户端消息 ====================

// MessageItem 用户端消息项（含已读状态）
type MessageItem struct {
	Id        uint64 `json:"id"`
	Title     string `json:"title"`
	Type      int    `json:"type"`
	Content   string `json:"content"`
	Tag       string `json:"tag"`
	IsRead    bool   `json:"isRead"`
	CreatedAt uint64 `json:"createdAt"`
}

// UnreadCountItem 未读数
type UnreadCountItem struct {
	Type  int `json:"type"`
	Count int `json:"count"`
}

// PullMessagesModel 拉取消息出参
type PullMessagesModel struct {
	List    []MessageItem     `json:"list"`
	Unread []UnreadCountItem  `json:"unread"`
}

// ReadNoticeInp 标记已读入参
type ReadNoticeInp struct {
	Id uint64 `json:"id" v:"required#通知ID不能为空" dc:"通知ID"`
}

// ReadAllNoticeInp 全部已读入参
type ReadAllNoticeInp struct {
	Type int `json:"type" dc:"类型(0=全部)"`
}
