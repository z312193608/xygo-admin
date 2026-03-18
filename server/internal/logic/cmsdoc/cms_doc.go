// +----------------------------------------------------------------------
// | XYGo Admin [ Vue3 + GoFrame 企业级中后台管理系统 ]
// +----------------------------------------------------------------------
// | Copyright (c) 2026 大连星韵网络科技有限公司 All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( https://opensource.org/licenses/MIT )
// +----------------------------------------------------------------------
// | Author: 喜羊羊 <751300685@qq.com>
// +----------------------------------------------------------------------

package cmsdoc

import (
	"context"
	"strings"
	"time"

	"github.com/gogf/gf/v2/errors/gerror"

	"xygo/internal/consts"
	"xygo/internal/dao"
	"xygo/internal/model"
	"xygo/internal/model/do"
	"xygo/internal/model/entity"
	"xygo/internal/model/input/adminin"
	"xygo/internal/model/input/form"
	"xygo/internal/service"
)

type sCmsDoc struct{}

func init() {
	service.RegisterCmsDoc(&sCmsDoc{})
}

// ==================== 文档分类 ====================

// CategoryList 文档分类列表（树形）
func (s *sCmsDoc) CategoryList(ctx context.Context, in *adminin.DocCategoryListInp) (*adminin.DocCategoryListModel, error) {
	m := dao.CmsDocCategory.Ctx(ctx)

	if in.Title != "" {
		m = m.WhereLike("title", "%"+in.Title+"%")
	}
	if in.Status >= 0 {
		m = m.Where("status", in.Status)
	}

	var list []entity.CmsDocCategory
	err := m.OrderDesc("sort").OrderAsc("id").Scan(&list)
	if err != nil {
		return nil, err
	}

	// 转换为列表项
	nodes := make([]*adminin.DocCategoryListItem, 0, len(list))
	for _, it := range list {
		nodes = append(nodes, &adminin.DocCategoryListItem{
			Id:        it.Id,
			Pid:       it.Pid,
			Title:     it.Title,
			Icon:      it.Icon,
			Sort:      it.Sort,
			Status:    it.Status,
			Remark:    it.Remark,
			CreatedAt: it.CreatedAt,
			UpdatedAt: it.UpdatedAt,
		})
	}

	// 构建树形结构
	tree := model.BuildTree(
		nodes,
		func(n *adminin.DocCategoryListItem) uint { return uint(n.Id) },
		func(n *adminin.DocCategoryListItem) uint { return uint(n.Pid) },
		func(n *adminin.DocCategoryListItem, children []*adminin.DocCategoryListItem) { n.Children = children },
	)

	roots := make([]*adminin.DocCategoryListItem, 0, len(tree))
	for _, n := range tree {
		if n != nil {
			roots = append(roots, n)
		}
	}

	return &adminin.DocCategoryListModel{List: roots}, nil
}

// CategorySave 新增/编辑文档分类
func (s *sCmsDoc) CategorySave(ctx context.Context, in *adminin.DocCategorySaveInp) (uint64, error) {
	now := uint64(time.Now().Unix())

	if in.Id > 0 {
		// 编辑
		_, err := dao.CmsDocCategory.Ctx(ctx).Where("id", in.Id).Data(do.CmsDocCategory{
			Pid:       in.Pid,
			Title:     in.Title,
			Icon:      in.Icon,
			Sort:      in.Sort,
			Status:    in.Status,
			Remark:    in.Remark,
			UpdatedAt: now,
		}).Update()
		if err != nil {
			return 0, err
		}
		return in.Id, nil
	}

	// 新增
	result, err := dao.CmsDocCategory.Ctx(ctx).Data(do.CmsDocCategory{
		Pid:       in.Pid,
		Title:     in.Title,
		Icon:      in.Icon,
		Sort:      in.Sort,
		Status:    in.Status,
		Remark:    in.Remark,
		CreatedAt: now,
		UpdatedAt: now,
	}).Insert()
	if err != nil {
		return 0, err
	}
	id, _ := result.LastInsertId()
	return uint64(id), nil
}

// CategoryDelete 删除文档分类
func (s *sCmsDoc) CategoryDelete(ctx context.Context, id uint64) error {
	// 检查是否有子分类
	childCount, err := dao.CmsDocCategory.Ctx(ctx).Where("pid", id).Count()
	if err != nil {
		return err
	}
	if childCount > 0 {
		return gerror.NewCode(consts.CodeInvalidParam, "该分类下还有子分类，无法删除")
	}

	// 检查是否有文档引用
	docCount, err := dao.CmsDoc.Ctx(ctx).Where("category_id", id).Where("deleted_at", 0).Count()
	if err != nil {
		return err
	}
	if docCount > 0 {
		return gerror.NewCode(consts.CodeInvalidParam, "该分类下还有文档，无法删除")
	}

	_, err = dao.CmsDocCategory.Ctx(ctx).Where("id", id).Delete()
	return err
}

// ==================== 文档内容 ====================

// List 文档列表（分页）
func (s *sCmsDoc) List(ctx context.Context, in *adminin.DocListInp) (*adminin.DocListModel, error) {
	m := dao.CmsDoc.Ctx(ctx).Where("deleted_at", 0)

	if in.CategoryId > 0 {
		m = m.Where("category_id", in.CategoryId)
	}
	if in.Title != "" {
		m = m.WhereLike("title", "%"+in.Title+"%")
	}
	if in.Status >= 0 {
		m = m.Where("status", in.Status)
	}

	count, err := m.Count()
	if err != nil {
		return nil, err
	}

	page, size := in.Page, in.PageSize
	if page <= 0 {
		page = 1
	}
	if size <= 0 {
		size = 20
	}

	var list []entity.CmsDoc
	if count > 0 {
		err = m.Page(page, size).OrderDesc("is_top").OrderDesc("sort").OrderDesc("id").Scan(&list)
		if err != nil {
			return nil, err
		}
	}

	// 批量查分类名称
	categoryMap := s.getCategoryMap(ctx)

	items := make([]adminin.DocListItem, 0, len(list))
	for _, it := range list {
		items = append(items, adminin.DocListItem{
			Id:           it.Id,
			CategoryId:   it.CategoryId,
			CategoryName: categoryMap[it.CategoryId],
			Title:        it.Title,
			Slug:         it.Slug,
			Cover:        it.Cover,
			Summary:      it.Summary,
			Author:       it.Author,
			Views:        int(it.Views),
			Sort:         it.Sort,
			Status:       it.Status,
			IsTop:        it.IsTop,
			Tags:         it.Tags,
			CreatedBy:    it.CreatedBy,
			CreatedAt:    it.CreatedAt,
			UpdatedAt:    it.UpdatedAt,
		})
	}

	return &adminin.DocListModel{
		List: items,
		PageRes: form.PageRes{
			Page: page, PageSize: size, Total: count,
		},
	}, nil
}

// Detail 文档详情（按ID）
func (s *sCmsDoc) Detail(ctx context.Context, id uint64) (*adminin.DocDetailModel, error) {
	var doc entity.CmsDoc
	err := dao.CmsDoc.Ctx(ctx).Where("id", id).Where("deleted_at", 0).Scan(&doc)
	if err != nil {
		return nil, err
	}
	if doc.Id == 0 {
		return nil, gerror.NewCode(consts.CodeInvalidParam, "文档不存在")
	}
	return s.entityToDetail(ctx, &doc), nil
}

// DetailBySlug 文档详情（按slug，前台用）
func (s *sCmsDoc) DetailBySlug(ctx context.Context, slug string) (*adminin.DocDetailModel, error) {
	var doc entity.CmsDoc
	err := dao.CmsDoc.Ctx(ctx).Where("slug", slug).Where("deleted_at", 0).Where("status", 1).Scan(&doc)
	if err != nil {
		return nil, err
	}
	if doc.Id == 0 {
		return nil, gerror.NewCode(consts.CodeInvalidParam, "文档不存在")
	}

	// 浏览量 +1
	_, _ = dao.CmsDoc.Ctx(ctx).Where("id", doc.Id).Increment("views", 1)

	return s.entityToDetail(ctx, &doc), nil
}

// Search 全文搜索文档（标题 + 内容，前台用）
func (s *sCmsDoc) Search(ctx context.Context, keyword string) ([]adminin.DocSearchItem, error) {
	keyword = strings.TrimSpace(keyword)
	if keyword == "" {
		return nil, nil
	}

	like := "%" + keyword + "%"
	var list []entity.CmsDoc
	err := dao.CmsDoc.Ctx(ctx).
		Where("deleted_at", 0).
		Where("status", 1).
		Where("(title LIKE ? OR content LIKE ?)", like, like).
		Fields("id, category_id, title, slug, summary, author, views, content").
		OrderDesc("is_top").OrderDesc("sort").OrderDesc("id").
		Limit(30).
		Scan(&list)
	if err != nil {
		return nil, err
	}

	categoryMap := s.getCategoryMap(ctx)
	items := make([]adminin.DocSearchItem, 0, len(list))
	for _, it := range list {
		matchType := "content"
		if strings.Contains(strings.ToLower(it.Title), strings.ToLower(keyword)) {
			matchType = "title"
		}
		items = append(items, adminin.DocSearchItem{
			Id:           it.Id,
			CategoryId:   it.CategoryId,
			CategoryName: categoryMap[it.CategoryId],
			Title:        it.Title,
			Slug:         it.Slug,
			Summary:      it.Summary,
			Author:       it.Author,
			Views:        int(it.Views),
			MatchType:    matchType,
		})
	}
	return items, nil
}

// Save 新增/编辑文档
func (s *sCmsDoc) Save(ctx context.Context, in *adminin.DocSaveInp, operatorId uint64) (uint64, error) {
	now := uint64(time.Now().Unix())

	// 自动生成 slug
	if in.Slug == "" {
		in.Slug = generateSlug(in.Title, now)
	}

	if in.Id > 0 {
		// 编辑
		_, err := dao.CmsDoc.Ctx(ctx).Where("id", in.Id).Data(do.CmsDoc{
			CategoryId: in.CategoryId,
			Title:      in.Title,
			Slug:       in.Slug,
			Cover:      in.Cover,
			Summary:    in.Summary,
			Content:    in.Content,
			Author:     in.Author,
			Sort:       in.Sort,
			Status:     in.Status,
			IsTop:      in.IsTop,
			Tags:       in.Tags,
			UpdatedBy:  operatorId,
			UpdatedAt:  now,
		}).Update()
		if err != nil {
			return 0, err
		}
		return in.Id, nil
	}

	// 新增
	result, err := dao.CmsDoc.Ctx(ctx).Data(do.CmsDoc{
		CategoryId: in.CategoryId,
		Title:      in.Title,
		Slug:       in.Slug,
		Cover:      in.Cover,
		Summary:    in.Summary,
		Content:    in.Content,
		Author:     in.Author,
		Sort:       in.Sort,
		Status:     in.Status,
		IsTop:      in.IsTop,
		Tags:       in.Tags,
		CreatedBy:  operatorId,
		UpdatedBy:  operatorId,
		CreatedAt:  now,
		UpdatedAt:  now,
	}).Insert()
	if err != nil {
		return 0, err
	}
	id, _ := result.LastInsertId()
	return uint64(id), nil
}

// Delete 删除文档（软删除）
func (s *sCmsDoc) Delete(ctx context.Context, id uint64) error {
	now := uint64(time.Now().Unix())
	_, err := dao.CmsDoc.Ctx(ctx).Where("id", id).Data(do.CmsDoc{
		DeletedAt: now,
	}).Update()
	return err
}

// ==================== 内部辅助方法 ====================

// getCategoryMap 获取分类ID->名称映射
func (s *sCmsDoc) getCategoryMap(ctx context.Context) map[uint64]string {
	var categories []entity.CmsDocCategory
	_ = dao.CmsDocCategory.Ctx(ctx).Scan(&categories)
	m := make(map[uint64]string, len(categories))
	for _, c := range categories {
		m[c.Id] = c.Title
	}
	return m
}

// entityToDetail 实体转详情模型
func (s *sCmsDoc) entityToDetail(ctx context.Context, doc *entity.CmsDoc) *adminin.DocDetailModel {
	categoryMap := s.getCategoryMap(ctx)
	return &adminin.DocDetailModel{
		Id:           doc.Id,
		CategoryId:   doc.CategoryId,
		CategoryName: categoryMap[doc.CategoryId],
		Title:        doc.Title,
		Slug:         doc.Slug,
		Cover:        doc.Cover,
		Summary:      doc.Summary,
		Content:      doc.Content,
		Author:       doc.Author,
		Views:        int(doc.Views),
		Sort:         doc.Sort,
		Status:       doc.Status,
		IsTop:        doc.IsTop,
		Tags:         doc.Tags,
		CreatedBy:    doc.CreatedBy,
		UpdatedBy:    doc.UpdatedBy,
		CreatedAt:    doc.CreatedAt,
		UpdatedAt:    doc.UpdatedAt,
	}
}

// generateSlug 根据标题生成 slug
func generateSlug(title string, ts uint64) string {
	slug := strings.ToLower(strings.TrimSpace(title))
	slug = strings.ReplaceAll(slug, " ", "-")
	// 追加时间戳保证唯一
	return slug + "-" + time.Unix(int64(ts), 0).Format("20060102150405")
}
