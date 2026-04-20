// +----------------------------------------------------------------------
// | XYGo Admin [ Vue3 + GoFrame 企业级中后台管理系统 ]
// +----------------------------------------------------------------------
// | Copyright (c) 2026 大连星韵网络科技有限公司 All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( https://opensource.org/licenses/MIT )
// +----------------------------------------------------------------------
// | Author: 喜羊羊 <751300685@qq.com>
// +----------------------------------------------------------------------

package member

import (
	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/os/gtime"
)

// ==================== 获取会员信息 ====================

// GetInfoReq 获取当前会员信息请求
type GetInfoReq struct {
	g.Meta `path:"/user/info" method:"get" tags:"会员信息" summary:"获取当前会员信息"`
}

// GetInfoRes 获取当前会员信息响应
type GetInfoRes struct {
	Id          uint64  `json:"id"`
	Username    string  `json:"username"`
	Nickname    string  `json:"nickname"`
	Avatar      string  `json:"avatar"`
	Mobile      string  `json:"mobile"`
	Email       string  `json:"email"`
	Gender      int     `json:"gender"`
	Level       uint    `json:"level"`
	GroupId     uint64  `json:"groupId"`
	Score       int     `json:"score"`
	Money       float64 `json:"money"`
	LastLoginAt uint64  `json:"lastLoginAt"`
	LastLoginIp string  `json:"lastLoginIp"`
}

// ==================== 更新会员资料 ====================

// UpdateProfileReq 更新会员资料请求
type UpdateProfileReq struct {
	g.Meta   `path:"/user/profile" method:"put" tags:"会员信息" summary:"更新个人资料"`
	Nickname string      `json:"nickname"`
	Avatar   string      `json:"avatar"`
	Gender   int         `json:"gender"`
	Birthday *gtime.Time `json:"birthday"`
	Email    string      `json:"email" v:"email#邮箱格式不正确"`
	Mobile   string      `json:"mobile"`
}

// UpdateProfileRes 更新会员资料响应
type UpdateProfileRes struct{}

// ==================== 修改密码 ====================

// ChangePasswordReq 修改密码请求
type ChangePasswordReq struct {
	g.Meta      `path:"/user/password" method:"put" tags:"会员信息" summary:"修改密码"`
	OldPassword string `json:"oldPassword" v:"required#请输入原密码"`
	NewPassword string `json:"newPassword" v:"required|length:6,32#请输入新密码|新密码长度6-32位"`
}

// ChangePasswordRes 修改密码响应
type ChangePasswordRes struct{}

// ==================== 获取前台菜单 ====================

// GetMenusReq 获取当前会员可用菜单（按分组权限过滤）
type GetMenusReq struct {
	g.Meta `path:"/user/menus" method:"get" tags:"会员信息" summary:"获取会员菜单"`
}

// GetMenusRes 获取菜单响应
type GetMenusRes struct {
	Menus []MemberMenuItem `json:"menus"` // 会员中心菜单（menu_dir/menu）
	Nav   []MemberMenuItem `json:"nav"`   // 顶栏导航菜单（nav/nav_user_menu）
	Rules []MemberMenuItem `json:"rules"` // 普通路由（route）
}

// MemberMenuItem 前台菜单项
type MemberMenuItem struct {
	Id           uint64           `json:"id"`
	Pid          uint64           `json:"pid"`
	Title        string           `json:"title"`
	Name         string           `json:"name"`
	Path         string           `json:"path"`
	Component    string           `json:"component"`
	Icon         string           `json:"icon"`
	MenuType     string           `json:"menuType"`
	Url          string           `json:"url"`
	Type            string           `json:"type"`
	NavShowChildren int              `json:"navShowChildren"`
	NoLoginValid    int              `json:"noLoginValid"`
	Sort            int              `json:"sort"`
	Children     []MemberMenuItem `json:"children,omitempty"`
}

// ==================== 文件上传 ====================

// UploadFileReq 会员端文件上传
type UploadFileReq struct {
	g.Meta `path:"/user/upload" method:"post" mime:"multipart/form-data" tags:"会员上传" summary:"上传文件"`
}

// UploadFileRes 上传响应
type UploadFileRes struct {
	Url  string `json:"url"`
	Name string `json:"name"`
	Size int64  `json:"size"`
}

// ==================== 每日签到 ====================

// CheckinInfoReq 获取签到信息（7天日历+连续天数）
type CheckinInfoReq struct {
	g.Meta `path:"/user/checkin/info" method:"get" tags:"每日签到" summary:"获取签到信息"`
}

// CheckinInfoRes 签到信息响应
type CheckinInfoRes struct {
	ContinuousDays int              `json:"continuousDays"` // 连续签到天数
	TodayChecked   bool             `json:"todayChecked"`   // 今日是否已签到
	TodayScore     int              `json:"todayScore"`     // 今日获得积分（已签到时返回）
	WeekDays       []CheckinDayItem `json:"weekDays"`       // 最近7天签到情况
}

// CheckinDayItem 签到日历中的一天
type CheckinDayItem struct {
	Date    string `json:"date"`    // 日期 YYYY-MM-DD
	Checked bool   `json:"checked"` // 是否已签到
	Score   int    `json:"score"`   // 获得积分（已签到时）
}

// DoCheckinReq 执行签到
type DoCheckinReq struct {
	g.Meta `path:"/user/checkin" method:"post" tags:"每日签到" summary:"执行签到"`
}

// DoCheckinRes 签到响应
type DoCheckinRes struct {
	Score          int `json:"score"`          // 本次获得积分
	ContinuousDays int `json:"continuousDays"` // 当前连续签到天数
}

// ==================== 积分记录 ====================

// ScoreLogListReq 积分记录列表
type ScoreLogListReq struct {
	g.Meta   `path:"/user/score/log" method:"get" tags:"积分记录" summary:"积分变动记录"`
	Page     int `p:"page"     d:"1"  json:"page"`
	PageSize int `p:"pageSize" d:"20" json:"pageSize"`
}

// ScoreLogListRes 积分记录响应
type ScoreLogListRes struct {
	List     []ScoreLogItem `json:"list"`
	Page     int            `json:"page"`
	PageSize int            `json:"pageSize"`
	Total    int            `json:"total"`
}

// ScoreLogItem 积分记录项
type ScoreLogItem struct {
	Id        uint64      `json:"id"`
	Score     int         `json:"score"`     // 变动积分
	Before    int         `json:"before"`    // 变动前
	After     int         `json:"after"`     // 变动后
	Memo      string      `json:"memo"`      // 变动原因
	CreatedAt uint64 `json:"createdAt"` // 变动时间
}

// ==================== 余额记录 ====================

// MoneyLogListReq 余额记录列表
type MoneyLogListReq struct {
	g.Meta   `path:"/user/money/log" method:"get" tags:"余额记录" summary:"余额变动记录"`
	Page     int `p:"page"     d:"1"  json:"page"`
	PageSize int `p:"pageSize" d:"20" json:"pageSize"`
}

// MoneyLogListRes 余额记录响应
type MoneyLogListRes struct {
	List     []MoneyLogItem `json:"list"`
	Page     int            `json:"page"`
	PageSize int            `json:"pageSize"`
	Total    int            `json:"total"`
}

// MoneyLogItem 余额记录项
type MoneyLogItem struct {
	Id        uint64      `json:"id"`
	Money     int         `json:"money"`     // 变动金额（分）
	Before    int         `json:"before"`    // 变动前（分）
	After     int         `json:"after"`     // 变动后（分）
	Memo      string      `json:"memo"`      // 变动原因
	CreatedAt uint64 `json:"createdAt"` // 变动时间
}

// ==================== 系统通知 ====================

// NoticeListReq 通知列表
type NoticeListReq struct {
	g.Meta   `path:"/user/notice/list" method:"get" tags:"系统通知" summary:"获取通知列表"`
	Page     int `p:"page"     d:"1"  json:"page"`
	PageSize int `p:"pageSize" d:"20" json:"pageSize"`
}

// NoticeListRes 通知列表响应
type NoticeListRes struct {
	List     []NoticeItem `json:"list"`
	Page     int          `json:"page"`
	PageSize int          `json:"pageSize"`
	Total    int          `json:"total"`
	Unread   int          `json:"unread"` // 未读数量
}

// NoticeItem 通知项
type NoticeItem struct {
	Id        uint64      `json:"id"`
	Title     string      `json:"title"`
	Content   string      `json:"content"`
	Type      string      `json:"type"`      // system/announce/feature/maintain
	Sender    string      `json:"sender"`
	IsRead    bool        `json:"isRead"`    // 是否已读
	CreatedAt uint64 `json:"createdAt"`
}

// NoticeReadReq 标记通知已读
type NoticeReadReq struct {
	g.Meta   `path:"/user/notice/read" method:"post" tags:"系统通知" summary:"标记通知已读"`
	NoticeId uint64 `json:"noticeId" v:"required#通知ID不能为空"`
}

// NoticeReadRes 标记已读响应
type NoticeReadRes struct{}

// NoticeReadAllReq 全部已读
type NoticeReadAllReq struct {
	g.Meta `path:"/user/notice/read-all" method:"post" tags:"系统通知" summary:"全部已读"`
}

// NoticeReadAllRes 全部已读响应
type NoticeReadAllRes struct{}
