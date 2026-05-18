// +----------------------------------------------------------------------
// | XYGo Admin [ Vue3 + GoFrame 企业级中后台管理系统 ]
// +----------------------------------------------------------------------
// | Copyright (c) 2026 大连星韵网络科技有限公司 All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( https://opensource.org/licenses/MIT )
// +----------------------------------------------------------------------
// | Author: 喜羊羊 <751300685@qq.com>
// +----------------------------------------------------------------------

package notice

import (
	"context"
	"time"

	"github.com/gogf/gf/v2/frame/g"

	"xygo/internal/dao"
	"xygo/internal/model/entity"
	"xygo/internal/model/input/adminin"
	"xygo/internal/model/input/form"
	"xygo/internal/service"
	"xygo/internal/websocket"
)

type sNotice struct{}

func init() {
	service.RegisterNotice(&sNotice{})
}

// List 通知列表（管理端）
func (s *sNotice) List(ctx context.Context, in *adminin.NoticeListInp) (*adminin.NoticeListModel, error) {
	m := dao.AdminNotice.Ctx(ctx)
	if in.Type > 0 {
		m = m.Where("type", in.Type)
	}
	if in.Status > 0 {
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

	var list []entity.AdminNotice
	if count > 0 {
		err = m.Page(page, size).OrderDesc("id").Scan(&list)
		if err != nil {
			return nil, err
		}
	}

	items := make([]adminin.NoticeListItem, 0, len(list))
	for _, it := range list {
		items = append(items, adminin.NoticeListItem{
			Id:         it.Id,
			Title:      it.Title,
			Type:       it.Type,
			Content:    it.Content,
			Tag:        it.Tag,
			SenderId:   it.SenderId,
			ReceiverId: it.ReceiverId,
			Status:     it.Status,
			ReadCount:  uint(it.ReadCount),
			CreatedAt:  it.CreatedAt,
		})
	}

	return &adminin.NoticeListModel{
		List: items,
		PageRes: form.PageRes{
			Page: page, PageSize: size, Total: count,
		},
	}, nil
}

// Edit 创建/编辑通知
func (s *sNotice) Edit(ctx context.Context, in *adminin.NoticeEditInp, senderId uint64) (uint64, error) {
	now := uint64(time.Now().Unix())
	data := g.Map{
		"title":       in.Title,
		"type":        in.Type,
		"content":     in.Content,
		"tag":         in.Tag,
		"receiver_id": in.ReceiverId,
		"status":      in.Status,
		"sort":        in.Sort,
		"remark":      in.Remark,
		"updated_at":  now,
	}

	if in.Id == 0 {
		data["sender_id"] = senderId
		data["created_at"] = now
		result, err := dao.AdminNotice.Ctx(ctx).Data(data).Insert()
		if err != nil {
			return 0, err
		}
		id, _ := result.LastInsertId()

		// WebSocket 推送新消息通知
		go pushNotice(in.Type, uint64(id), in.Title, in.Tag, in.ReceiverId)

		return uint64(id), nil
	}

	_, err := dao.AdminNotice.Ctx(ctx).Where("id", in.Id).Data(data).Update()
	return in.Id, err
}

// Delete 删除通知
func (s *sNotice) Delete(ctx context.Context, id uint64) error {
	_, err := dao.AdminNotice.Ctx(ctx).Where("id", id).Delete()
	if err != nil {
		return err
	}
	// 同步删除已读记录
	_, _ = dao.AdminNoticeRead.Ctx(ctx).Where("notice_id", id).Delete()
	return nil
}

// PullMessages 拉取当前用户的消息
func (s *sNotice) PullMessages(ctx context.Context, userId uint64) (*adminin.PullMessagesModel, error) {
	// 查询用户可见的消息（全员 + 指定自己的）
	var notices []entity.AdminNotice
	err := dao.AdminNotice.Ctx(ctx).
		Where("status", 1).
		Where("receiver_id IN(?)", g.Slice{0, userId}).
		OrderDesc("id").
		Limit(50).
		Scan(&notices)
	if err != nil {
		return nil, err
	}

	// 查询已读记录
	readMap := make(map[uint64]bool)
	if len(notices) > 0 {
		ids := make([]uint64, 0, len(notices))
		for _, n := range notices {
			ids = append(ids, n.Id)
		}
		var reads []entity.AdminNoticeRead
		_ = dao.AdminNoticeRead.Ctx(ctx).
			Where("user_id", userId).
			Where("notice_id IN(?)", ids).
			Scan(&reads)
		for _, r := range reads {
			readMap[r.NoticeId] = true
		}
	}

	items := make([]adminin.MessageItem, 0, len(notices))
	for _, n := range notices {
		items = append(items, adminin.MessageItem{
			Id:        n.Id,
			Title:     n.Title,
			Type:      n.Type,
			Content:   n.Content,
			Tag:       n.Tag,
			IsRead:    readMap[n.Id],
			CreatedAt: n.CreatedAt,
		})
	}

	// 统计未读数
	unread := calcUnread(items)

	return &adminin.PullMessagesModel{
		List:   items,
		Unread: unread,
	}, nil
}

// UnreadCount 获取未读数
func (s *sNotice) UnreadCount(ctx context.Context, userId uint64) ([]adminin.UnreadCountItem, int, error) {
	result, err := s.PullMessages(ctx, userId)
	if err != nil {
		return nil, 0, err
	}

	total := 0
	for _, u := range result.Unread {
		total += u.Count
	}
	return result.Unread, total, nil
}

// Read 标记已读
func (s *sNotice) Read(ctx context.Context, noticeId, userId uint64) error {
	// 检查是否已存在
	count, err := dao.AdminNoticeRead.Ctx(ctx).
		Where("notice_id", noticeId).
		Where("user_id", userId).
		Count()
	if err != nil {
		return err
	}
	if count > 0 {
		return nil // 已读
	}

	_, err = dao.AdminNoticeRead.Ctx(ctx).Data(g.Map{
		"notice_id": noticeId,
		"user_id":   userId,
		"read_at":   time.Now().Unix(),
	}).Insert()
	if err != nil {
		return err
	}

	// 更新通知的已读计数
	_, _ = dao.AdminNotice.Ctx(ctx).Where("id", noticeId).Increment("read_count", 1)
	return nil
}

// ReadAll 标记全部已读
func (s *sNotice) ReadAll(ctx context.Context, noticeType int, userId uint64) error {
	m := dao.AdminNotice.Ctx(ctx).Where("status", 1).Where("receiver_id IN(?)", g.Slice{0, userId})
	if noticeType > 0 {
		m = m.Where("type", noticeType)
	}

	var notices []entity.AdminNotice
	if err := m.Fields("id").Scan(&notices); err != nil {
		return err
	}

	for _, n := range notices {
		_ = s.Read(ctx, n.Id, userId)
	}
	return nil
}

// ==================== 内部辅助 ====================

func calcUnread(items []adminin.MessageItem) []adminin.UnreadCountItem {
	counts := map[int]int{1: 0, 2: 0, 3: 0}
	for _, it := range items {
		if !it.IsRead {
			counts[it.Type]++
		}
	}
	result := make([]adminin.UnreadCountItem, 0, 3)
	for t, c := range counts {
		result = append(result, adminin.UnreadCountItem{Type: t, Count: c})
	}
	return result
}

// pushNotice 通过 WebSocket 推送通知
func pushNotice(noticeType int, noticeId uint64, title, tag string, receiverId uint64) {
	resp := &websocket.WsResponse{
		Event: "notice",
		Data: g.Map{
			"id":    noticeId,
			"title": title,
			"type":  noticeType,
			"tag":   tag,
		},
	}

	if receiverId > 0 {
		// 私信：发给指定用户
		websocket.SendToUser("admin", receiverId, resp)
	} else {
		// 通知/公告：全员广播
		websocket.SendToAll(resp)
	}
}
