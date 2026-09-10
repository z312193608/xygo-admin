// ==========================================================================
// Code generated and maintained by GoFrame CLI tool. DO NOT EDIT.
// ==========================================================================

package internal

import (
	"context"

	"github.com/gogf/gf/v2/database/gdb"
	"github.com/gogf/gf/v2/frame/g"
)

// MemberLoginLogDao is the data access object for the table xy_member_login_log.
type MemberLoginLogDao struct {
	table    string                // table is the underlying table name of the DAO.
	group    string                // group is the database configuration group name of the current DAO.
	columns  MemberLoginLogColumns // columns contains all the column names of Table for convenient usage.
	handlers []gdb.ModelHandler    // handlers for customized model modification.
}

// MemberLoginLogColumns defines and stores column names for the table xy_member_login_log.
type MemberLoginLogColumns struct {
	Id        string // ID
	MemberId  string // 会员ID
	Username  string // 用户名
	Ip        string // 登录IP
	UserAgent string // User-Agent
	Status    string // 状态：0=失败 1=成功
	Message   string // 提示信息
	CreatedAt string // 创建时间
}

// memberLoginLogColumns holds the columns for the table xy_member_login_log.
var memberLoginLogColumns = MemberLoginLogColumns{
	Id:        "id",
	MemberId:  "member_id",
	Username:  "username",
	Ip:        "ip",
	UserAgent: "user_agent",
	Status:    "status",
	Message:   "message",
	CreatedAt: "created_at",
}

// NewMemberLoginLogDao creates and returns a new DAO object for table data access.
func NewMemberLoginLogDao(handlers ...gdb.ModelHandler) *MemberLoginLogDao {
	return &MemberLoginLogDao{
		group:    "default",
		table:    "xy_member_login_log",
		columns:  memberLoginLogColumns,
		handlers: handlers,
	}
}

// DB retrieves and returns the underlying raw database management object of the current DAO.
func (dao *MemberLoginLogDao) DB() gdb.DB {
	return g.DB(dao.group)
}

// Table returns the table name of the current DAO.
func (dao *MemberLoginLogDao) Table() string {
	return dao.table
}

// Columns returns all column names of the current DAO.
func (dao *MemberLoginLogDao) Columns() MemberLoginLogColumns {
	return dao.columns
}

// Group returns the database configuration group name of the current DAO.
func (dao *MemberLoginLogDao) Group() string {
	return dao.group
}

// Ctx creates and returns a Model for the current DAO. It automatically sets the context for the current operation.
func (dao *MemberLoginLogDao) Ctx(ctx context.Context) *gdb.Model {
	model := dao.DB().Model(dao.table)
	for _, handler := range dao.handlers {
		model = handler(model)
	}
	return model.Safe().Ctx(ctx)
}

// Transaction wraps the transaction logic using function f.
// It rolls back the transaction and returns the error if function f returns a non-nil error.
// It commits the transaction and returns nil if function f returns nil.
//
// Note: Do not commit or roll back the transaction in function f,
// as it is automatically handled by this function.
func (dao *MemberLoginLogDao) Transaction(ctx context.Context, f func(ctx context.Context, tx gdb.TX) error) (err error) {
	return dao.Ctx(ctx).Transaction(ctx, f)
}
