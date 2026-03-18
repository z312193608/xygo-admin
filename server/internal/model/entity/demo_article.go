// =================================================================================
// Code generated and maintained by GoFrame CLI tool. DO NOT EDIT.
// =================================================================================

package entity

// DemoArticle is the golang structure for table demo_article.
type DemoArticle struct {
	Id         uint64 `json:"id"         orm:"id"          description:"主键"`           // 主键
	CategoryId uint   `json:"categoryId" orm:"category_id" description:"分类ID"`         // 分类ID
	Title      string `json:"title"      orm:"title"       description:"标题"`           // 标题
	Cover      string `json:"cover"      orm:"cover"       description:"封面图"`          // 封面图
	Summary    string `json:"summary"    orm:"summary"     description:"摘要"`           // 摘要
	Content    string `json:"content"    orm:"content"     description:"内容"`           // 内容
	Author     string `json:"author"     orm:"author"      description:"作者"`           // 作者
	Views      uint   `json:"views"      orm:"views"       description:"浏览量"`          // 浏览量
	Sort       int    `json:"sort"       orm:"sort"        description:"排序"`           // 排序
	Status     int    `json:"status"     orm:"status"      description:"状态:1=启用,0=禁用"` // 状态:1=启用,0=禁用
	CreatedAt  uint64 `json:"createdAt"  orm:"created_at"  description:"创建时间"`         // 创建时间
	UpdatedAt  uint64 `json:"updatedAt"  orm:"updated_at"  description:"更新时间"`         // 更新时间
}
