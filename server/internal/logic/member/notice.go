package member

import (
	"context"

	"github.com/gogf/gf/v2/database/gdb"
	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/os/gtime"

	"xygo/internal/dao"
	"xygo/internal/model/input/memberin"
)

type sFrontendNotice struct{}

func NewFrontendNotice() *sFrontendNotice {
	return &sFrontendNotice{}
}

// List 通知列表（带已读状态，只返回已发布的通知）
func (s *sFrontendNotice) List(ctx context.Context, memberId uint64, in *memberin.NoticeListInput) (out *memberin.NoticeListOutput, err error) {
	if in.Page <= 0 {
		in.Page = 1
	}
	if in.PageSize <= 0 {
		in.PageSize = 20
	}

	// 只查已发布的通知 + 目标为 all 或当前会员所在分组
	model := dao.MemberNotice.Ctx(ctx).As("n").
		Where("n.status", 1).
		Where("n.target = 'all'") // 暂时只处理全员通知

	count, err := model.Clone().Count()
	if err != nil {
		return nil, err
	}

	// 使用子查询带出已读状态
	type noticeRow struct {
		memberin.NoticeItem
	}

	var rawList []noticeRow
	err = model.
		Fields("n.id, n.title, n.content, n.type, n.sender, n.created_at").
		Page(in.Page, in.PageSize).
		OrderDesc("n.id").
		Scan(&rawList)
	if err != nil {
		return nil, err
	}

	// 查询该会员已读的通知ID列表
	readIds := make(map[uint64]bool)
	if len(rawList) > 0 {
		noticeIds := make([]uint64, 0, len(rawList))
		for _, r := range rawList {
			noticeIds = append(noticeIds, r.Id)
		}
		var readRecords []struct {
			NoticeId uint64 `json:"noticeId"`
		}
		_ = dao.MemberNoticeRead.Ctx(ctx).
			Where("member_id", memberId).
			WhereIn("notice_id", noticeIds).
			Fields("notice_id").
			Scan(&readRecords)
		for _, r := range readRecords {
			readIds[r.NoticeId] = true
		}
	}

	// 组装结果
	list := make([]memberin.NoticeItem, 0, len(rawList))
	for _, r := range rawList {
		item := r.NoticeItem
		item.IsRead = readIds[item.Id]
		list = append(list, item)
	}

	// 统计未读数
	unread := 0
	for _, item := range list {
		if !item.IsRead {
			unread++
		}
	}

	return &memberin.NoticeListOutput{
		List:     list,
		Page:     in.Page,
		PageSize: in.PageSize,
		Total:    count,
		Unread:   unread,
	}, nil
}

// MarkRead 标记单条通知已读
func (s *sFrontendNotice) MarkRead(ctx context.Context, memberId uint64, noticeId uint64) error {
	// 检查是否已读
	count, err := dao.MemberNoticeRead.Ctx(ctx).
		Where("member_id", memberId).
		Where("notice_id", noticeId).
		Count()
	if err != nil {
		return err
	}
	if count > 0 {
		return nil // 已读，跳过
	}

	_, err = dao.MemberNoticeRead.Ctx(ctx).Data(g.Map{
		"notice_id": noticeId,
		"member_id": memberId,
		"read_at":   gtime.Now().Unix(),
	}).Insert()

	return err
}

// MarkAllRead 全部通知标记已读。只插入未读记录，按批写入。
func (s *sFrontendNotice) MarkAllRead(ctx context.Context, memberId uint64) error {
	vals, err := dao.MemberNotice.Ctx(ctx).
		Where("status", 1).
		Where("target = 'all'").
		WhereNotIn("id", dao.MemberNoticeRead.Ctx(ctx).Fields("notice_id").Where("member_id", memberId)).
		Fields("id").
		Array()
	if err != nil {
		return err
	}
	ids := memberNoticeIDs(vals)
	if len(ids) == 0 {
		return nil
	}

	now := gtime.Now().Unix()
	rows := make(g.List, 0, len(ids))
	for _, id := range ids {
		rows = append(rows, g.Map{
			"notice_id": id,
			"member_id": memberId,
			"read_at":   now,
		})
	}
	for i := 0; i < len(rows); i += memberNoticeReadBatch {
		end := i + memberNoticeReadBatch
		if end > len(rows) {
			end = len(rows)
		}
		if _, err = dao.MemberNoticeRead.Ctx(ctx).Data(rows[i:end]).Insert(); err != nil {
			return err
		}
	}
	return nil
}

const memberNoticeReadBatch = 200

func memberNoticeIDs(vals []gdb.Value) []uint64 {
	ids := make([]uint64, 0, len(vals))
	for _, v := range vals {
		if id := v.Uint64(); id > 0 {
			ids = append(ids, id)
		}
	}
	return ids
}
