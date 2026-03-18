// =================================================================================
// Code generated and maintained by GoFrame CLI tool. DO NOT EDIT.
// =================================================================================

package entity

// TestCode is the golang structure for table test_code.
type TestCode struct {
	Id       uint64 `json:"id"       orm:"id"        description:"主键"`   // 主键
	Name     string `json:"name"     orm:"name"      description:"名称"`   // 名称
	MemberId uint   `json:"memberId" orm:"member_id" description:"关联ID"` // 关联ID
}
