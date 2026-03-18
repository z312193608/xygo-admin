// =================================================================================
// Code generated and maintained by GoFrame CLI tool. DO NOT EDIT.
// =================================================================================

package entity

// SysCronLog is the golang structure for table sys_cron_log.
type SysCronLog struct {
	Id        uint64 `json:"id"        orm:"id"         description:"日志ID"`       // 日志ID
	CronId    uint64 `json:"cronId"    orm:"cron_id"    description:"任务ID"`       // 任务ID
	Name      string `json:"name"      orm:"name"       description:"任务标识"`       // 任务标识
	Title     string `json:"title"     orm:"title"      description:"任务标题"`       // 任务标题
	Params    string `json:"params"    orm:"params"     description:"执行参数"`       // 执行参数
	Status    int    `json:"status"    orm:"status"     description:"状态:1成功,2失败"` // 状态:1成功,2失败
	Output    string `json:"output"    orm:"output"     description:"执行输出"`       // 执行输出
	ErrMsg    string `json:"errMsg"    orm:"err_msg"    description:"错误信息"`       // 错误信息
	TakeMs    int    `json:"takeMs"    orm:"take_ms"    description:"耗时(毫秒)"`     // 耗时(毫秒)
	CreatedAt uint   `json:"createdAt" orm:"created_at" description:"执行时间"`       // 执行时间
}
