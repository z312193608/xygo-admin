// +----------------------------------------------------------------------
// | XYGo Admin [ Vue3 + GoFrame 企业级中后台管理系统 ]
// +----------------------------------------------------------------------
// | Copyright (c) 2026 大连星韵网络科技有限公司 All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( https://opensource.org/licenses/MIT )
// +----------------------------------------------------------------------
// | Author: 喜羊羊 <751300685@qq.com>
// +----------------------------------------------------------------------

package memberin

import "github.com/gogf/gf/v2/os/gtime"

// GetInfoInput 获取会员信息输入
type GetInfoInput struct{}

// GetInfoOutput 获取会员信息输出
type GetInfoOutput struct {
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

// UpdateProfileInput 更新会员资料输入
type UpdateProfileInput struct {
	Nickname string      `json:"nickname"`
	Avatar   string      `json:"avatar"`
	Mobile   string      `json:"mobile"`
	Gender   int         `json:"gender"`
	Birthday *gtime.Time `json:"birthday"`
	Email    string      `json:"email" v:"email#邮箱格式不正确"`
}

// UpdateProfileOutput 更新会员资料输出
type UpdateProfileOutput struct{}

// ChangePasswordInput 修改密码输入
type ChangePasswordInput struct {
	OldPassword string `json:"oldPassword" v:"required#请输入原密码"`
	NewPassword string `json:"newPassword" v:"required|length:6,32#请输入新密码|新密码长度6-32位"`
}

// ChangePasswordOutput 修改密码输出
type ChangePasswordOutput struct{}

// FrontendMenuItem 前台菜单项（给前端用的精简结构）
type FrontendMenuItem struct {
	Id           uint64             `json:"id"`
	Pid          uint64             `json:"pid"`
	Title        string             `json:"title"`
	Name         string             `json:"name"`
	Path         string             `json:"path"`
	Component    string             `json:"component"`
	Icon         string             `json:"icon"`
	MenuType     string             `json:"menuType"`
	Url          string             `json:"url"`
	Type            string             `json:"type"`
	NavShowChildren int                `json:"navShowChildren"`
	NoLoginValid    int                `json:"noLoginValid"`
	Sort            int                `json:"sort"`
	Children     []FrontendMenuItem `json:"children,omitempty"`
}

// ==================== 签到相关 ====================

// CheckinInfoOutput 签到信息输出
type CheckinInfoOutput struct {
	ContinuousDays int              `json:"continuousDays"`
	TodayChecked   bool             `json:"todayChecked"`
	TodayScore     int              `json:"todayScore"`
	WeekDays       []CheckinDayItem `json:"weekDays"`
}

// CheckinDayItem 签到日历天
type CheckinDayItem struct {
	Date    string `json:"date"`
	Checked bool   `json:"checked"`
	Score   int    `json:"score"`
}

// DoCheckinOutput 执行签到输出
type DoCheckinOutput struct {
	Score          int `json:"score"`
	ContinuousDays int `json:"continuousDays"`
}

// ==================== 积分记录 ====================

// ScoreLogListInput 积分记录输入
type ScoreLogListInput struct {
	Page     int `json:"page"`
	PageSize int `json:"pageSize"`
}

// ScoreLogListOutput 积分记录输出
type ScoreLogListOutput struct {
	List     []ScoreLogItem `json:"list"`
	Page     int            `json:"page"`
	PageSize int            `json:"pageSize"`
	Total    int            `json:"total"`
}

// ScoreLogItem 积分记录项
type ScoreLogItem struct {
	Id        uint64 `json:"id"`
	Score     int    `json:"score"`
	Before    int    `json:"before"`
	After     int    `json:"after"`
	Memo      string `json:"memo"`
	CreatedAt uint64 `json:"createdAt"`
}

// ==================== 余额记录 ====================

// MoneyLogListInput 余额记录输入
type MoneyLogListInput struct {
	Page     int `json:"page"`
	PageSize int `json:"pageSize"`
}

// MoneyLogListOutput 余额记录输出
type MoneyLogListOutput struct {
	List     []MoneyLogItem `json:"list"`
	Page     int            `json:"page"`
	PageSize int            `json:"pageSize"`
	Total    int            `json:"total"`
}

// MoneyLogItem 余额记录项
type MoneyLogItem struct {
	Id        uint64 `json:"id"`
	Money     int    `json:"money"`
	Before    int    `json:"before"`
	After     int    `json:"after"`
	Memo      string `json:"memo"`
	CreatedAt uint64 `json:"createdAt"`
}

// ==================== 系统通知 ====================

// NoticeListInput 通知列表输入
type NoticeListInput struct {
	Page     int `json:"page"`
	PageSize int `json:"pageSize"`
}

// NoticeListOutput 通知列表输出
type NoticeListOutput struct {
	List     []NoticeItem `json:"list"`
	Page     int          `json:"page"`
	PageSize int          `json:"pageSize"`
	Total    int          `json:"total"`
	Unread   int          `json:"unread"`
}

// NoticeItem 通知项
type NoticeItem struct {
	Id        uint64 `json:"id"`
	Title     string `json:"title"`
	Content   string `json:"content"`
	Type      string `json:"type"`
	Sender    string `json:"sender"`
	IsRead    bool   `json:"isRead"`
	CreatedAt uint64 `json:"createdAt"`
}
