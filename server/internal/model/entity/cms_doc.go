// =================================================================================
// Code generated and maintained by GoFrame CLI tool. DO NOT EDIT.
// =================================================================================

package entity

// CmsDoc is the golang structure for table cms_doc.
type CmsDoc struct {
	Id         uint64 `json:"id"         orm:"id"          description:"文档ID"`               // 文档ID
	CategoryId uint64 `json:"categoryId" orm:"category_id" description:"分类ID"`               // 分类ID
	Title      string `json:"title"      orm:"title"       description:"文档标题"`               // 文档标题
	Slug       string `json:"slug"       orm:"slug"        description:"URL标识(唯一)"`          // URL标识(唯一)
	Cover      string `json:"cover"      orm:"cover"       description:"封面图"`                // 封面图
	Summary    string `json:"summary"    orm:"summary"     description:"摘要"`                 // 摘要
	Content    string `json:"content"    orm:"content"     description:"文档内容(Markdown)"`     // 文档内容(Markdown)
	Author     string `json:"author"     orm:"author"      description:"作者"`                 // 作者
	Views      uint   `json:"views"      orm:"views"       description:"浏览量"`                // 浏览量
	Sort       int    `json:"sort"       orm:"sort"        description:"排序(越大越靠前)"`          // 排序(越大越靠前)
	Status     int    `json:"status"     orm:"status"      description:"状态:1=已发布,2=草稿,3=下架"` // 状态:1=已发布,2=草稿,3=下架
	IsTop      int    `json:"isTop"      orm:"is_top"      description:"是否置顶:0=否,1=是"`       // 是否置顶:0=否,1=是
	Tags       string `json:"tags"       orm:"tags"        description:"标签(JSON数组)"`         // 标签(JSON数组)
	CreatedBy  uint64 `json:"createdBy"  orm:"created_by"  description:"创建人ID"`              // 创建人ID
	UpdatedBy  uint64 `json:"updatedBy"  orm:"updated_by"  description:"更新人ID"`              // 更新人ID
	CreatedAt  uint64 `json:"createdAt"  orm:"created_at"  description:"创建时间"`               // 创建时间
	UpdatedAt  uint64 `json:"updatedAt"  orm:"updated_at"  description:"更新时间"`               // 更新时间
	DeletedAt  uint64 `json:"deletedAt"  orm:"deleted_at"  description:"删除时间(软删除)"`          // 删除时间(软删除)
}
