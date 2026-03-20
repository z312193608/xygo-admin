// ==========================================================================
// Code generated and maintained by GoFrame CLI tool. DO NOT EDIT.
// ==========================================================================

package internal

import (
	"context"

	"github.com/gogf/gf/v2/database/gdb"
	"github.com/gogf/gf/v2/frame/g"
)

// MemberDao is the data access object for the table xy_member.
type MemberDao struct {
	table    string             // table is the underlying table name of the DAO.
	group    string             // group is the database configuration group name of the current DAO.
	columns  MemberColumns      // columns contains all the column names of Table for convenient usage.
	handlers []gdb.ModelHandler // handlers for customized model modification.
}

// MemberColumns defines and stores column names for the table xy_member.
type MemberColumns struct {
	Id          string // 会员ID
	Username    string // 用户名
	Password    string // 密码（bcrypt加密）
	Mobile      string // 手机号
	Email       string // 邮箱
	Nickname    string // 昵称
	Avatar      string // 头像
	Gender      string // 性别：0=未知 1=男 2=女
	Birthday    string // 生日
	Money       string // 余额
	Score       string // 积分
	Level       string // 会员等级
	GroupId     string // 会员分组ID
	Status      string // 状态：0=禁用 1=正常
	LastLoginIp string // 最后登录IP
	LastLoginAt string // last login time
	LoginCount  string // 登录次数
	CreatedAt   string // 创建时间
	UpdatedAt   string // 更新时间
	DeletedAt   string // deleted time
	Salt        string // 密码盐
}

// memberColumns holds the columns for the table xy_member.
var memberColumns = MemberColumns{
	Id:          "id",
	Username:    "username",
	Password:    "password",
	Mobile:      "mobile",
	Email:       "email",
	Nickname:    "nickname",
	Avatar:      "avatar",
	Gender:      "gender",
	Birthday:    "birthday",
	Money:       "money",
	Score:       "score",
	Level:       "level",
	GroupId:     "group_id",
	Status:      "status",
	LastLoginIp: "last_login_ip",
	LastLoginAt: "last_login_at",
	LoginCount:  "login_count",
	CreatedAt:   "created_at",
	UpdatedAt:   "updated_at",
	DeletedAt:   "deleted_at",
	Salt:        "salt",
}

// NewMemberDao creates and returns a new DAO object for table data access.
func NewMemberDao(handlers ...gdb.ModelHandler) *MemberDao {
	return &MemberDao{
		group:    "default",
		table:    "xy_member",
		columns:  memberColumns,
		handlers: handlers,
	}
}

// DB retrieves and returns the underlying raw database management object of the current DAO.
func (dao *MemberDao) DB() gdb.DB {
	return g.DB(dao.group)
}

// Table returns the table name of the current DAO.
func (dao *MemberDao) Table() string {
	return dao.table
}

// Columns returns all column names of the current DAO.
func (dao *MemberDao) Columns() MemberColumns {
	return dao.columns
}

// Group returns the database configuration group name of the current DAO.
func (dao *MemberDao) Group() string {
	return dao.group
}

// Ctx creates and returns a Model for the current DAO. It automatically sets the context for the current operation.
func (dao *MemberDao) Ctx(ctx context.Context) *gdb.Model {
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
func (dao *MemberDao) Transaction(ctx context.Context, f func(ctx context.Context, tx gdb.TX) error) (err error) {
	return dao.Ctx(ctx).Transaction(ctx, f)
}
