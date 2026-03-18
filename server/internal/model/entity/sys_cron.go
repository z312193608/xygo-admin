// =================================================================================
// Code generated and maintained by GoFrame CLI tool. DO NOT EDIT.
// =================================================================================

package entity

// SysCron is the golang structure for table sys_cron.
type SysCron struct {
	Id        uint64 `json:"id"        orm:"id"         description:"任务ID"`                 // 任务ID
	GroupId   uint64 `json:"groupId"   orm:"group_id"   description:"分组ID"`                 // 分组ID
	Title     string `json:"title"     orm:"title"      description:"任务标题"`                 // 任务标题
	Name      string `json:"name"      orm:"name"       description:"任务标识（唯一，对应代码注册名）"`     // 任务标识（唯一，对应代码注册名）
	Params    string `json:"params"    orm:"params"     description:"任务参数（逗号分隔）"`           // 任务参数（逗号分隔）
	Pattern   string `json:"pattern"   orm:"pattern"    description:"Cron表达式"`              // Cron表达式
	Policy    int    `json:"policy"    orm:"policy"     description:"策略:1并行,2单例,3单次,4固定次数"` // 策略:1并行,2单例,3单次,4固定次数
	Count     int    `json:"count"     orm:"count"      description:"固定次数（policy=4时有效）"`    // 固定次数（policy=4时有效）
	Sort      int    `json:"sort"      orm:"sort"       description:"排序"`                   // 排序
	Remark    string `json:"remark"    orm:"remark"     description:"备注"`                   // 备注
	Status    int    `json:"status"    orm:"status"     description:"状态:0禁用,1启用"`           // 状态:0禁用,1启用
	CreatedAt uint   `json:"createdAt" orm:"created_at" description:"创建时间"`                 // 创建时间
	UpdatedAt uint   `json:"updatedAt" orm:"updated_at" description:"更新时间"`                 // 更新时间
}
