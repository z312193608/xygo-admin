package gencodes

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"text/template"
	"time"

	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/os/gfile"

	"xygo/internal/library/dbdialect"
	"xygo/internal/library/genconfig"
	"xygo/internal/model/input/adminin"
)

// ==================== 模板数据结构 ====================

// TplData 模板渲染的数据上下文
type TplData struct {
	VarName      string // PascalCase 实体名，如 BizArticle
	PkgName      string // 包名(小写)，如 bizarticle
	DaoName      string // DAO 名称(去前缀后PascalCase)，如 BizArticle
	RouteName    string // 路由名(kebab-case)，如 bizArticle
	ModulePath   string // 前端模块路径
	TableName    string // 表名
	TableComment string // 表注释
	CssClass     string // CSS 类名(kebab-case)
	FilePrefix   string // 文件前缀(kebab-case)
	PkColumn     string // 主键字段名(数据库)
	PkGoName     string // 主键 Go 名称
	PkTsName     string // 主键 TS 名称

	// 树表相关
	GenType           int
	TreePidColumn     string // 父ID数据库字段名
	TreePidTsColumn   string // 父ID TS 名称
	TreeTitleColumn   string // 标题字段名(数据库)
	TreeTitleTsColumn string // 标题字段 TS 名称

	// 菜单 SQL
	MenuPid      int
	MenuIcon     string
	MenuSort     int
	PermPrefix   string // 权限前缀
	ApiPrefix    string // API 路径前缀
	ResourceName string // 资源标识（去前缀表名，用于字段权限关联）

	// 时间字段标记
	HasCreatedAt  bool
	HasUpdatedAt  bool
	HasCreateTime bool
	HasUpdateTime bool

	// import 依赖标记（模板根据这些标记动态生成 import）
	NeedsGtime bool // 字段中包含 *gtime.Time
	NeedsGjson bool // 字段中包含 *gjson.Json

	// 字段分组
	AllColumns   []TplColumn
	ListColumns  []TplColumn
	EditColumns  []TplColumn
	QueryColumns []TplColumn

	// 关联表
	HasRelations     bool          // 是否有关联表
	HasRelSoftDelete bool          // 是否有关联表带软删除（需要 Unscoped）
	Relations        []TplRelation // 关联表列表

	// 生成步骤控制（从 HeadOps/ColumnOps/AutoOps 转换，模板用 if 条件渲染）
	HasAdd        bool // 新增按钮（HeadOps: add）
	HasBatchDel   bool // 批量删除按钮（HeadOps: batchDel + ColumnOps: check）
	HasExport     bool // 导出按钮（HeadOps: export）
	HasEdit       bool // 编辑操作（ColumnOps: edit）
	HasDel        bool // 删除操作（ColumnOps: del）
	HasView       bool // 详情弹窗（ColumnOps: view）
	HasCheck      bool // 勾选列（ColumnOps: check）
	HasStatus     bool // 状态切换（ColumnOps: status，且表有 status 字段）
	NotFilterAuth bool // 不过滤权限（ColumnOps: notFilterAuth）
	HasMenu       bool // 生成菜单权限（AutoOps: genMenuPermissions）
	ForcedCover   bool // 强制覆盖（AutoOps: forcedCover）

	// 查询能力标记（用于模板按需引入依赖）
	HasInQuery bool // 是否包含 queryType=in（逻辑模板需要 strings.Split）

	// 查看模式
	ViewMode string // drawer(抽屉) | page(新标签页)

	// 扩展包模式（AddonName 非空时启用）
	AddonName          string // 扩展名，如 "archive"
	WebApiImportPath   string // 前端 API import 路径: "@/api/backend/xxx" 或 "@/addons/{name}/api/xxx"
	MenuComponentPath  string // 菜单 component 前缀: "/xxx" 或 "@addons/{name}/views/xxx"
	MenuRemark         string // 菜单 remark 标记: "" 或 "addon:{name}"
	GoApiImport        string // Go API 包 import: "xygo/api/admin" 或 "xygo/addons/{name}/api"
	GoApiPkg           string // Go API 包别名: "admin" 或 "api"
	GoInputImport      string // Go Input 包 import: "xygo/internal/model/input/adminin" 或 "xygo/addons/{name}/model"
	GoInputPkg         string // Go Input 包名: "adminin" 或 "model"
	GoServiceImport    string // Go Service 包 import: "xygo/internal/service" 或 "xygo/addons/{name}/service"
	GoControllerPkg    string // Go Controller 包名: "admin" 或 "controller"
	ControllerReceiver string // Controller receiver: "ControllerV1" 或 "AdminControllerV1"（双控制器模式）
}

// TplColumn 模板用的字段数据
type TplColumn struct {
	Name          string
	GoName        string
	TsName        string
	GoType        string
	TsType        string
	DbType        string
	Comment       string
	Label         string // 显示标签(去掉冒号后的部分)
	FormType      string
	DesignType    string // 设计类型
	Render        string // 用户选择的列渲染: none|switch|image|images|tag|tags|url|datetime|color|icon
	Operator      string // 用户选择的搜索操作符: eq|like|between 等
	QueryType     string
	Required      bool
	MinWidth      int
	DefaultValue  string // TS 默认值
	IsTimeField   bool
	IsStatusField bool
	HasOptions    bool          // 是否有解析出的选项
	RadioOptions  []RadioOption // 兼容旧模板
	Options       []RadioOption // 通用选项（radio/select/checkbox 共用）

	// 关联表配置（remoteSelect/remoteSelects）
	IsRemoteSelect       bool             // 是否远程下拉
	IsRemoteSelects      bool             // 是否远程多选
	RemoteTable          string           // 关联数据表名
	RemotePk             string           // 关联表主键
	RemoteField          string           // 关联表显示字段
	RelationFields       string           // 表格展示的关联字段（逗号分隔）
	RelationSearchFields string           // 参与搜索的关联字段（逗号分隔，兼容）
	RelationExportFields string           // 参与导出的关联字段（逗号分隔，兼容）
	RelFieldConfigs      []RelFieldConfig // 完整关联字段配置（设计器）
	RelationName         string           // 关联方法名(PascalCase), 如 User
	RelationAlias        string           // 关联表别名(snake_case), 如 user
	RelationApiPath      string           // 关联接口路径(kebab-case), 如 demo-category
}

// RelFieldConfig 单个关联字段的完整配置（对应前端设计器）
type RelFieldConfig struct {
	Field           string `json:"field"`           // 字段名
	Label           string `json:"label"`           // 中文标签（从注释提取）
	InList          bool   `json:"inList"`          // 参与列表显示
	InSearch        bool   `json:"inSearch"`        // 参与搜索
	InExport        bool   `json:"inExport"`        // 参与导出
	SearchType      string `json:"searchType"`      // 搜索方式: like | eq | between
	SearchComponent string `json:"searchComponent"` // 搜索组件: input | select | number 等
	ListRender      string `json:"listRender"`      // 列表渲染: text | tag | image | link 等
	GoName          string `json:"-"`               // PascalCase 名（生成时填充）
}

// TplRelation 关联表信息（供模板使用）
type TplRelation struct {
	FieldName       string           // 外键字段名(数据库), 如 user_id
	FieldGoName     string           // 外键Go名, 如 UserId
	FieldTsName     string           // 外键TS名, 如 userId
	RelationName    string           // 关联名(PascalCase), 如 User
	RelationAlias   string           // 关联别名(snake_case), 如 user
	RelationApiPath string           // 关联接口路径(kebab-case), 如 demo-category
	RemoteTable     string           // 关联表名
	RemotePk        string           // 关联表主键
	RemoteField     string           // 关联表显示字段
	RelationFields  []string         // 要展示的关联字段列表（兼容旧逻辑）
	SearchFields    []string         // 参与搜索的关联字段列表（兼容旧逻辑）
	ExportFields    []string         // 参与导出的关联字段列表（兼容旧逻辑）
	FieldConfigs    []RelFieldConfig // 完整字段配置（方案C 设计器）
	IsMultiple      bool             // 是否多选关联
	HasSoftDelete   bool             // 关联表是否有软删除字段(deleted_at)
}

// RadioOption 单选项
type RadioOption struct {
	Value   string
	Label   string
	TagType string // Tag 颜色类型: success | warning | danger | info | primary
}

// Tag 颜色轮换表（对齐 Element Plus TagProps type）
var tagTypeColors = []string{"success", "danger", "warning", "info", "primary", ""}

// OptionsJson options JSON 解析
type OptionsJson struct {
	GenType   int               `json:"genType"`
	HeadOps   []string          `json:"headOps"`
	ColumnOps []string          `json:"columnOps"`
	AutoOps   []string          `json:"autoOps"`
	ApiPrefix string            `json:"apiPrefix"`
	GenPaths  map[string]string `json:"genPaths"`
	AddonName string            `json:"addonName"` // 非空时生成到扩展目录
	Menu      struct {
		Pid  int    `json:"pid"`
		Icon string `json:"icon"`
		Sort int    `json:"sort"`
	} `json:"menu"`
	ViewMode string `json:"viewMode"` // drawer | page
	Tree     struct {
		TitleColumn string `json:"titleColumn"`
		PidColumn   string `json:"pidColumn"`
	} `json:"tree"`
}

// ==================== 模板文件映射 ====================

type tplFile struct {
	TplName  string // 模板文件名
	OutPath  string // 输出路径(相对server或web根)
	Lang     string // 语法高亮标识
	IsTree   bool   // 仅树表生成
	IsList   bool   // 仅普通列表生成
	IsServer bool   // 后端文件
}

// ==================== 核心函数 ====================

// generateCode 生成代码（预览/写入通用入口）
func generateCode(ctx context.Context, in *adminin.GenCodesEditInp, writeToDisk bool) (*adminin.GenCodesPreviewModel, error) {
	// 解析 options
	opts := parseOptions(in.Options)
	if in.GenType > 0 {
		opts.GenType = in.GenType
	}

	// 写入磁盘时，先自动同步设计器新增字段到数据库
	if writeToDisk && in.TableName != "" && len(in.Columns) > 0 {
		if err := autoSyncFieldsToDb(ctx, in); err != nil {
			g.Log().Warningf(ctx, "[GenCodes] auto sync fields warning: %v", err)
			// 不中断生成，只是警告
		}
	}

	// 构建模板数据
	tplData := buildTplData(ctx, in, opts)

	// 确定生成哪些模板（从配置读取路径）
	tplFiles := getTplFiles(ctx, tplData, opts)

	// 加载并渲染全部模板
	type renderedFile struct {
		tf      tplFile
		content string
	}
	var allRendered []renderedFile
	files := make([]adminin.GenCodesPreviewFile, 0, len(tplFiles))

	for _, tf := range tplFiles {
		content, err := renderTemplate(ctx, tf.TplName, tplData)
		if err != nil {
			g.Log().Warningf(ctx, "render template %s error: %v", tf.TplName, err)
			continue
		}
		files = append(files, adminin.GenCodesPreviewFile{
			Path:    tf.OutPath,
			Content: content,
			Lang:    tf.Lang,
		})
		allRendered = append(allRendered, renderedFile{tf: tf, content: content})
	}

	// 写入磁盘
	if writeToDisk {
		writeToPath := func(absPath, content string) {
			dir := filepath.Dir(absPath)
			if !gfile.Exists(dir) {
				_ = os.MkdirAll(dir, 0755)
			}
			if err := os.WriteFile(absPath, []byte(content), 0644); err != nil {
				g.Log().Warningf(ctx, "write file %s error: %v", absPath, err)
			} else {
				g.Log().Infof(ctx, "generated: %s", absPath)
			}
		}

		// 临时暂存前端文件：用 JSON 映射文件记录 {目标路径: 内容}
		tempManifest := filepath.Join(gfile.Pwd(), "resource", "generate", "_frontend_pending.json")
		pendingFrontend := make(map[string]string) // absPath → content

		// 第一阶段：写后端文件到项目目录，前端文件到临时目录
		for _, rf := range allRendered {
			if rf.tf.IsServer {
				absPath := resolveOutputPath(ctx, rf.tf.OutPath, true)
				if absPath != "" {
					writeToPath(absPath, rf.content)
				}
				// SQL 文件仍然写入磁盘（供人可读参考），但运行时用 ORM 插入菜单
				// 标记待执行菜单（在文件写入循环结束后统一处理）
			} else {
				// 前端文件暂存到映射表，不直接写入（避免触发 Vite HMR）
				absPath := resolveOutputPath(ctx, rf.tf.OutPath, false)
				if absPath != "" {
					pendingFrontend[absPath] = rf.content
					g.Log().Infof(ctx, "pending frontend: %s", absPath)
				}
			}
		}

		// 第二阶段（前置）：使用 ORM 插入菜单（兼容 MySQL 和 PG）
		if tplData.HasMenu {
			if menuExists(ctx, tplData.VarName) {
				g.Log().Infof(ctx, "[GenCodes] menu '%s' already exists, skip ORM insert", tplData.VarName)
			} else if err := executeMenuORM(ctx, tplData); err != nil {
				g.Log().Warningf(ctx, "[GenCodes] ORM menu insert error: %v", err)
			} else {
				g.Log().Info(ctx, "[GenCodes] menu ORM insert completed successfully")
			}
		}

		// 第二阶段：gf gen dao/service（后端文件已就绪）
		runDao := strInArray(opts.AutoOps, "runDao")
		runSvc := strInArray(opts.AutoOps, "runService")
		if len(opts.AutoOps) == 0 {
			runDao = true
			runSvc = true
		}
		if runDao {
			if err := runGfGenDao(ctx); err != nil {
				return nil, fmt.Errorf("gf gen dao 失败: %w", err)
			}
		}
		if runSvc && opts.AddonName == "" {
			if err := runGfGenService(ctx); err != nil {
				return nil, fmt.Errorf("gf gen service 失败: %w", err)
			}
		}
		// 插件模式下 logic 由 module.go 的 init() 注册，不写入主包的 logic.go
		if opts.AddonName == "" {
			registerLogicImport(ctx, tplData.PkgName)
		} else {
			// 插件模式：自动生成 service 接口、controller 结构体、更新 module.go 和 addons.go
			generateAddonSupport(ctx, opts.AddonName, tplData)
		}

		// 将待发布的前端文件写入 JSON 映射文件（publishFrontend 时读取并写入正式目录）
		if len(pendingFrontend) > 0 {
			manifestData, _ := json.Marshal(pendingFrontend)
			_ = os.WriteFile(tempManifest, manifestData, 0644)
			g.Log().Infof(ctx, "[GenCodes] %d frontend files pending publish", len(pendingFrontend))
		}

		// 保存生成的文件路径到配置记录（供删除时使用，不再推导）
		saveGeneratedPaths(ctx, in, tplFiles, tplData.ModulePath)
	}

	return &adminin.GenCodesPreviewModel{Files: files}, nil
}

// saveGeneratedPaths 把生成的文件路径列表保存到配置记录的 options JSON 中
func saveGeneratedPaths(ctx context.Context, in *adminin.GenCodesEditInp, tplFiles []tplFile, modulePath string) {
	if in.Id == 0 {
		return // 新建的还没保存配置记录，跳过
	}
	// 收集所有生成的文件路径
	var serverFiles, frontendFiles []string
	for _, tf := range tplFiles {
		absPath := resolveOutputPath(ctx, tf.OutPath, tf.IsServer)
		if tf.IsServer {
			serverFiles = append(serverFiles, absPath)
		} else {
			frontendFiles = append(frontendFiles, absPath)
		}
	}

	// 更新 options JSON 中的 generatedFiles 和 modulePath
	record, err := g.DB().Ctx(ctx).Model("xy_sys_gen_codes").Where("id", in.Id).One()
	if err != nil || record.IsEmpty() {
		return
	}
	optStr := record["options"].String()
	var optMap map[string]interface{}
	if optStr != "" {
		_ = json.Unmarshal([]byte(optStr), &optMap)
	}
	if optMap == nil {
		optMap = make(map[string]interface{})
	}
	optMap["generatedFiles"] = map[string]interface{}{
		"server":   serverFiles,
		"frontend": frontendFiles,
	}
	optMap["modulePath"] = modulePath

	newOpt, _ := json.Marshal(optMap)
	_, _ = g.DB().Ctx(ctx).Model("xy_sys_gen_codes").Where("id", in.Id).Data(g.Map{"options": string(newOpt)}).Update()
	g.Log().Infof(ctx, "[GenCodes] saved %d generated file paths to options", len(serverFiles)+len(frontendFiles))
}

// PublishFrontend 读取 JSON 映射文件，一次性把前端文件写入正式目录
func (s *sGenCodes) PublishFrontend(ctx context.Context) error {
	manifestPath := filepath.Join(gfile.Pwd(), "resource", "generate", "_frontend_pending.json")
	if !gfile.Exists(manifestPath) {
		g.Log().Info(ctx, "[PublishFrontend] no pending files")
		return nil
	}

	data, err := os.ReadFile(manifestPath)
	if err != nil {
		return fmt.Errorf("读取映射文件失败: %w", err)
	}

	var pending map[string]string // absPath → content
	if err := json.Unmarshal(data, &pending); err != nil {
		return fmt.Errorf("解析映射文件失败: %w", err)
	}

	var count int
	for absPath, content := range pending {
		dir := filepath.Dir(absPath)
		if !gfile.Exists(dir) {
			_ = os.MkdirAll(dir, 0755)
		}
		if err := os.WriteFile(absPath, []byte(content), 0644); err != nil {
			g.Log().Warningf(ctx, "[PublishFrontend] write %s error: %v", absPath, err)
		} else {
			count++
			g.Log().Infof(ctx, "[PublishFrontend] published: %s", absPath)
		}
	}

	// 清理映射文件
	_ = os.Remove(manifestPath)

	g.Log().Infof(ctx, "[PublishFrontend] published %d frontend files", count)
	return nil
}

// ==================== gf gen 命令集成 ====================

// runGfGenDao 执行 gf gen dao 生成 DAO/Entity/DO 文件
func runGfGenDao(ctx context.Context) error {
	g.Log().Info(ctx, "[GenCodes] running: gf gen dao ...")
	cmd := exec.Command("gf", "gen", "dao")
	cmd.Dir = gfile.Pwd() // server 目录
	output, err := cmd.CombinedOutput()
	if err != nil {
		g.Log().Warningf(ctx, "[GenCodes] gf gen dao failed: %v\noutput: %s", err, string(output))
		return fmt.Errorf("gf gen dao: %w\n%s", err, string(output))
	}
	g.Log().Infof(ctx, "[GenCodes] gf gen dao completed:\n%s", string(output))
	return nil
}

// menuExists 检查菜单是否已存在（按 name 字段查重）
// getMenuPath 获取菜单的 path（用于推导子模块目录）
func getMenuPath(ctx context.Context, menuId int) string {
	val, err := g.DB().Ctx(ctx).Model("xy_admin_menu").Where("id", menuId).Value("path")
	if err != nil || val.IsEmpty() {
		return ""
	}
	// 清理 path：去掉前导斜杠
	p := strings.TrimPrefix(val.String(), "/")
	return p
}

func menuExists(ctx context.Context, varName string) bool {
	count, err := g.DB().Ctx(ctx).Model("xy_admin_menu").Where("name", varName).Count()
	if err != nil {
		g.Log().Warningf(ctx, "[GenCodes] check menu exists error: %v", err)
		return false
	}
	return count > 0
}

// executeMenuSQL 自动执行菜单 SQL 插入数据库（旧版，仅 MySQL 兼容）
// 已被 executeMenuORM 取代，保留用于极端回退场景
func executeMenuSQL(ctx context.Context, sqlContent string) error {
	db := g.DB()
	lines := strings.Split(sqlContent, "\n")
	var currentSQL strings.Builder
	for _, line := range lines {
		trimmed := strings.TrimSpace(line)
		if trimmed == "" || strings.HasPrefix(trimmed, "--") {
			continue
		}
		currentSQL.WriteString(line)
		currentSQL.WriteString("\n")
		if strings.HasSuffix(trimmed, ";") {
			sql := strings.TrimSpace(currentSQL.String())
			if sql != "" {
				if _, err := db.Exec(ctx, sql); err != nil {
					g.Log().Warningf(ctx, "[GenCodes] exec menu sql error: %v\nsql: %s", err, sql)
				}
			}
			currentSQL.Reset()
		}
	}
	return nil
}

// executeMenuORM 使用 ORM 插入菜单（兼容 MySQL 和 PostgreSQL，无方言 SQL）
func executeMenuORM(ctx context.Context, data *TplData) error {
	db := g.DB()
	now := time.Now().Unix()
	menuTable := "xy_admin_menu"

	// resource 标识：去掉表前缀，用于字段权限关联
	resourceName := strings.TrimPrefix(data.TableName, "xy_")

	// 公共字段模板
	baseMenu := func(parentId int64, menuType int, title, name, path, component, icon, perms string, hidden, keepAlive, sort int) g.Map {
		res := ""
		if menuType == 2 {
			res = resourceName
		}
		return g.Map{
			"parent_id":    parentId,
			"type":         menuType,
			"title":        title,
			"name":         name,
			"path":         path,
			"component":    component,
			"resource":     res,
			"icon":         icon,
			"hidden":       hidden,
			"keep_alive":   keepAlive,
			"redirect":     "",
			"frame_src":    "",
			"perms":        perms,
			"is_frame":     0,
			"affix":        0,
			"show_badge":   0,
			"badge_text":   "",
			"active_path":  "",
			"hide_tab":     0,
			"is_full_page": 0,
			"sort":         sort,
			"status":       1,
			"remark":       data.MenuRemark,
			"created_by":   0,
			"updated_by":   0,
			"create_time":  now,
			"update_time":  now,
		}
	}

	var parentId int64
	var pageId int64

	if data.MenuPid == 0 {
		// ======= 顶级模式：创建目录(type=1) + 页面(type=2) + 按钮(type=3) =======

		// 1. 创建目录
		dirMenu := baseMenu(0, 1, data.TableComment, data.VarName+"Dir",
			"/"+data.RouteName, "", data.MenuIcon, "", 0, 0, data.MenuSort)
		dirId, err := db.Ctx(ctx).Model(menuTable).Data(dirMenu).InsertAndGetId()
		if err != nil {
			return fmt.Errorf("插入目录菜单失败: %w", err)
		}
		parentId = dirId

		// 2. 创建页面菜单
		pageMenu := baseMenu(parentId, 2, data.TableComment+"列表", data.VarName,
			data.RouteName, data.MenuComponentPath+"/index", "",
			fmt.Sprintf(`["GET %s/list"]`, data.ApiPrefix), 0, 1, 1)
		pid, err := db.Ctx(ctx).Model(menuTable).Data(pageMenu).InsertAndGetId()
		if err != nil {
			return fmt.Errorf("插入页面菜单失败: %w", err)
		}
		pageId = pid
	} else {
		// ======= 挂载模式：在已有目录下创建页面(type=2) + 按钮(type=3) =======
		parentId = int64(data.MenuPid)

		pageMenu := baseMenu(parentId, 2, data.TableComment, data.VarName,
			data.RouteName, data.MenuComponentPath+"/index", data.MenuIcon,
			fmt.Sprintf(`["GET %s/list"]`, data.ApiPrefix), 0, 1, data.MenuSort)
		pid, err := db.Ctx(ctx).Model(menuTable).Data(pageMenu).InsertAndGetId()
		if err != nil {
			return fmt.Errorf("插入页面菜单失败: %w", err)
		}
		pageId = pid
	}

	// 3. 创建按钮权限
	btnSort := 1

	if data.HasView {
		viewBtn := baseMenu(pageId, 3, "查看"+data.TableComment, data.VarName+"View",
			"", "", "", fmt.Sprintf(`["GET %s/view"]`, data.ApiPrefix), 0, 0, btnSort)
		if _, err := db.Ctx(ctx).Model(menuTable).Data(viewBtn).Insert(); err != nil {
			g.Log().Warningf(ctx, "[MenuORM] insert view btn error: %v", err)
		}
		btnSort++

		// 详情页路由（page 模式）
		if data.ViewMode == "page" {
			detailParentId := parentId
			if data.MenuPid != 0 {
				detailParentId = int64(data.MenuPid)
			}
			detailMenu := baseMenu(detailParentId, 2, data.TableComment+"详情", data.VarName+"Detail",
				data.RouteName+"/detail", data.MenuComponentPath+"/detail/index", "",
				fmt.Sprintf(`["GET %s/view"]`, data.ApiPrefix), 1, 0, 0)
			detailMenu["active_path"] = "/" + data.RouteName
			if _, err := db.Ctx(ctx).Model(menuTable).Data(detailMenu).Insert(); err != nil {
				g.Log().Warningf(ctx, "[MenuORM] insert detail page error: %v", err)
			}
		}
	}

	if data.HasAdd {
		addBtn := baseMenu(pageId, 3, "新增"+data.TableComment, data.VarName+"Add",
			"", "", "", fmt.Sprintf(`["POST %s/edit"]`, data.ApiPrefix), 0, 0, btnSort)
		if _, err := db.Ctx(ctx).Model(menuTable).Data(addBtn).Insert(); err != nil {
			g.Log().Warningf(ctx, "[MenuORM] insert add btn error: %v", err)
		}
		btnSort++
	}

	if data.HasEdit {
		editBtn := baseMenu(pageId, 3, "编辑"+data.TableComment, data.VarName+"Edit",
			"", "", "", fmt.Sprintf(`["POST %s/edit","GET %s/view"]`, data.ApiPrefix, data.ApiPrefix), 0, 0, btnSort)
		if _, err := db.Ctx(ctx).Model(menuTable).Data(editBtn).Insert(); err != nil {
			g.Log().Warningf(ctx, "[MenuORM] insert edit btn error: %v", err)
		}
		btnSort++
	}

	if data.HasDel || data.HasBatchDel {
		delBtn := baseMenu(pageId, 3, "删除"+data.TableComment, data.VarName+"Delete",
			"", "", "", fmt.Sprintf(`["POST %s/delete"]`, data.ApiPrefix), 0, 0, btnSort)
		if _, err := db.Ctx(ctx).Model(menuTable).Data(delBtn).Insert(); err != nil {
			g.Log().Warningf(ctx, "[MenuORM] insert delete btn error: %v", err)
		}
		btnSort++
	}

	if data.HasExport {
		exportBtn := baseMenu(pageId, 3, "导出"+data.TableComment, data.VarName+"Export",
			"", "", "", fmt.Sprintf(`["GET %s/export"]`, data.ApiPrefix), 0, 0, btnSort)
		if _, err := db.Ctx(ctx).Model(menuTable).Data(exportBtn).Insert(); err != nil {
			g.Log().Warningf(ctx, "[MenuORM] insert export btn error: %v", err)
		}
	}

	g.Log().Infof(ctx, "[MenuORM] menu created: parentId=%d, pageId=%d", parentId, pageId)
	return nil
}

// registerLogicImport 自动在 logic/logic.go 中注册新包的空导入
func registerLogicImport(ctx context.Context, pkgName string) {
	logicGoPath := filepath.Join(gfile.Pwd(), "internal", "logic", "logic.go")
	if !gfile.Exists(logicGoPath) {
		g.Log().Warning(ctx, "[GenCodes] logic.go not found, skip import registration")
		return
	}

	importLine := fmt.Sprintf(`_ "xygo/internal/logic/%s"`, pkgName)
	content := gfile.GetContents(logicGoPath)

	// 检查是否已存在
	if strings.Contains(content, importLine) {
		g.Log().Infof(ctx, "[GenCodes] logic import already registered: %s", pkgName)
		return
	}

	// 在 import 块的最后一个 _ 导入后面插入新行
	// 找到 import ( ... ) 块中最后一个 _ "xygo/internal/logic/ 行
	lines := strings.Split(content, "\n")
	var insertIdx int
	for i, line := range lines {
		if strings.Contains(line, `_ "xygo/internal/logic/`) {
			insertIdx = i + 1 // 在最后一个 logic import 后面
		}
	}

	if insertIdx > 0 {
		// 构建新导入行（保持缩进格式）
		newLine := fmt.Sprintf("\t%s", importLine)
		newLines := make([]string, 0, len(lines)+1)
		newLines = append(newLines, lines[:insertIdx]...)
		newLines = append(newLines, newLine)
		newLines = append(newLines, lines[insertIdx:]...)

		newContent := strings.Join(newLines, "\n")
		if err := os.WriteFile(logicGoPath, []byte(newContent), 0644); err != nil {
			g.Log().Warningf(ctx, "[GenCodes] write logic.go error: %v", err)
		} else {
			g.Log().Infof(ctx, "[GenCodes] registered logic import: %s", pkgName)
		}
	} else {
		g.Log().Warning(ctx, "[GenCodes] could not find import block in logic.go")
	}
}

// unregisterLogicImport 从 logic/logic.go 中移除指定包的空导入
func unregisterLogicImport(ctx context.Context, pkgName string) {
	logicGoPath := filepath.Join(gfile.Pwd(), "internal", "logic", "logic.go")
	if !gfile.Exists(logicGoPath) {
		return
	}

	importLine := fmt.Sprintf(`_ "xygo/internal/logic/%s"`, pkgName)
	content := gfile.GetContents(logicGoPath)

	if !strings.Contains(content, importLine) {
		return
	}

	// 按行过滤，移除包含该 import 的行
	lines := strings.Split(content, "\n")
	newLines := make([]string, 0, len(lines))
	for _, line := range lines {
		if strings.Contains(line, importLine) {
			continue // 跳过该行
		}
		newLines = append(newLines, line)
	}

	newContent := strings.Join(newLines, "\n")
	if err := os.WriteFile(logicGoPath, []byte(newContent), 0644); err != nil {
		g.Log().Warningf(ctx, "[Delete] remove logic import error: %v", err)
	} else {
		g.Log().Infof(ctx, "[Delete] removed logic import: %s", pkgName)
	}
}

// runGfGenService 执行 gf gen service 生成 Service 接口 + 更新 logic.go
func runGfGenService(ctx context.Context) error {
	g.Log().Info(ctx, "[GenCodes] running: gf gen service ...")
	cmd := exec.Command("gf", "gen", "service")
	cmd.Dir = gfile.Pwd() // server 目录
	output, err := cmd.CombinedOutput()
	if err != nil {
		g.Log().Warningf(ctx, "[GenCodes] gf gen service failed: %v\noutput: %s", err, string(output))
		return fmt.Errorf("gf gen service: %w\n%s", err, string(output))
	}
	g.Log().Infof(ctx, "[GenCodes] gf gen service completed:\n%s", string(output))
	return nil
}

// ==================== 数据构建 ====================

func buildTplData(ctx context.Context, in *adminin.GenCodesEditInp, opts OptionsJson) *TplData {
	varName := in.VarName
	pkgName := strings.ToLower(varName)
	routeName := camelToKebab(lcFirst(varName))
	tablePrefix := "xy_"

	// DAO 名称：去掉表前缀，PascalCase
	daoName := snakeToPascal(strings.TrimPrefix(in.TableName, tablePrefix))

	// 模块路径：有上级菜单时嵌套到父菜单路径下
	modulePath := routeName
	if opts.Menu.Pid > 0 {
		parentPath := getMenuPath(ctx, opts.Menu.Pid)
		if parentPath != "" {
			modulePath = parentPath + "/" + routeName
		}
	}
	if opts.GenPaths != nil && opts.GenPaths["webApi"] != "" {
		// 用户手动配置的路径优先
		apiPath := opts.GenPaths["webApi"]
		apiPath = strings.TrimPrefix(apiPath, "api/backend/")
		apiPath = strings.TrimSuffix(apiPath, ".ts")
		modulePath = apiPath
	}

	// 找主键
	pkColumn := "id"
	pkGoName := "Id"
	pkTsName := "id"
	for _, col := range in.Columns {
		if col.IsPk == 1 {
			pkColumn = col.Name
			pkGoName = col.GoName
			pkTsName = col.TsName
			break
		}
	}

	data := &TplData{
		VarName:      varName,
		PkgName:      pkgName,
		DaoName:      daoName,
		RouteName:    routeName,
		ModulePath:   modulePath,
		TableName:    in.TableName,
		TableComment: in.TableComment,
		CssClass:     camelToKebab(lcFirst(varName)),
		FilePrefix:   camelToKebab(lcFirst(varName)),
		PkColumn:     pkColumn,
		PkGoName:     pkGoName,
		PkTsName:     pkTsName,
		GenType:      opts.GenType,
		MenuPid:      opts.Menu.Pid,
		MenuIcon:     opts.Menu.Icon,
		MenuSort:     opts.Menu.Sort,
		PermPrefix:   "/admin/" + routeName,
		ApiPrefix:    "/admin/" + routeName,
		ResourceName: strings.TrimPrefix(in.TableName, tablePrefix),

		// 默认主包模式路径
		GoApiImport:        "xygo/api/admin",
		GoApiPkg:           "admin",
		GoInputImport:      "xygo/internal/model/input/adminin",
		GoInputPkg:         "adminin",
		GoServiceImport:    "xygo/internal/service",
		GoControllerPkg:    "admin",
		ControllerReceiver: "ControllerV1",
	}

	// 扩展包模式：覆盖路径变量
	if opts.AddonName != "" {
		addonName := opts.AddonName
		data.AddonName = addonName
		data.WebApiImportPath = fmt.Sprintf("@/addons/%s/api/%s", addonName, modulePath)
		data.MenuComponentPath = fmt.Sprintf("@addons/%s/views/%s", addonName, modulePath)
		data.MenuRemark = "addon:" + addonName
		data.GoApiImport = fmt.Sprintf("xygo/addons/%s/api", addonName)
		data.GoApiPkg = "api"
		data.GoInputImport = fmt.Sprintf("xygo/addons/%s/model", addonName)
		data.GoInputPkg = "model"
		data.GoServiceImport = fmt.Sprintf("xygo/addons/%s/service", addonName)
		data.GoControllerPkg = "controller"
		data.ControllerReceiver = "ControllerV1"
		if isAddonDualController(addonName) {
			data.ControllerReceiver = "AdminControllerV1"
		}
	} else {
		data.WebApiImportPath = "@/api/backend/" + modulePath
		data.MenuComponentPath = "/" + modulePath
	}

	if data.MenuIcon == "" {
		data.MenuIcon = "ele-Document"
	}
	if data.MenuSort == 0 {
		data.MenuSort = 100
	}

	// 树表
	if opts.Tree.PidColumn != "" {
		data.TreePidColumn = opts.Tree.PidColumn
		data.TreePidTsColumn = snakeToCamel(opts.Tree.PidColumn)
	}
	if opts.Tree.TitleColumn != "" {
		data.TreeTitleColumn = opts.Tree.TitleColumn
		data.TreeTitleTsColumn = snakeToCamel(opts.Tree.TitleColumn)
	}

	// 构建字段
	for _, col := range in.Columns {
		tc := buildTplColumn(col)
		// 兜底推断关联表：当 remoteSelect 未指定 remote-table 时，
		// 按当前业务表前缀 + 字段名猜测，例如 xy_demo_article + category_id -> demo_category。
		if (tc.IsRemoteSelect || tc.IsRemoteSelects) && tc.RemoteTable == "" {
			if guessedTable := guessRemoteTable(in.TableName, col.Name); guessedTable != "" {
				tc.RemoteTable = guessedTable
				// 只更新 API 路径（从表名推导），别名保持从字段名推导（已在 buildTplColumn 中设置）
				if rn := tableToRelationName(guessedTable); rn != "" {
					tc.RelationApiPath = strings.ReplaceAll(rn, "_", "-")
				}
			}
		}

		data.AllColumns = append(data.AllColumns, tc)

		if col.IsList == 1 {
			data.ListColumns = append(data.ListColumns, tc)
		}
		if col.IsEdit == 1 || col.IsPk == 1 {
			data.EditColumns = append(data.EditColumns, tc)
		}
		if col.IsQuery == 1 {
			data.QueryColumns = append(data.QueryColumns, tc)
			if tc.QueryType == "in" {
				data.HasInQuery = true
			}
		}

		// 时间字段标记
		switch col.Name {
		case "created_at":
			data.HasCreatedAt = true
		case "updated_at":
			data.HasUpdatedAt = true
		case "create_time":
			data.HasCreateTime = true
		case "update_time":
			data.HasUpdateTime = true
		}

		// 关联表 API 路径：优先从数据库查已生成记录的实际路由，否则用推导值
		if (tc.IsRemoteSelect || tc.IsRemoteSelects) && tc.RemoteTable != "" {
			if actualRoute := lookupRouteNameByTable(ctx, tc.RemoteTable); actualRoute != "" {
				tc.RelationApiPath = actualRoute
			}
		}

		// 收集关联信息
		if tc.IsRemoteSelect && tc.RemoteTable != "" {
			fields := []string{}
			if tc.RelationFields != "" {
				for _, f := range strings.Split(tc.RelationFields, ",") {
					f = strings.TrimSpace(f)
					if f != "" {
						fields = append(fields, f)
					}
				}
			}
			data.Relations = append(data.Relations, TplRelation{
				FieldName:       col.Name,
				FieldGoName:     col.GoName,
				FieldTsName:     col.TsName,
				RelationName:    tc.RelationName,
				RelationAlias:   tc.RelationAlias,
				RelationApiPath: tc.RelationApiPath,
				RemoteTable:     tc.RemoteTable,
				RemotePk:        tc.RemotePk,
				RemoteField:     tc.RemoteField,
				RelationFields:  fields,
				SearchFields:    splitTrimFields(tc.RelationSearchFields),
				ExportFields:    splitTrimFields(tc.RelationExportFields),
				FieldConfigs:    tc.RelFieldConfigs,
				IsMultiple:      false,
				HasSoftDelete:   tableHasSoftDelete(ctx, tc.RemoteTable),
			})
		} else if tc.IsRemoteSelects && tc.RemoteTable != "" {
			data.Relations = append(data.Relations, TplRelation{
				FieldName:       col.Name,
				FieldGoName:     col.GoName,
				FieldTsName:     col.TsName,
				RelationName:    tc.RelationName,
				RelationAlias:   tc.RelationAlias,
				RelationApiPath: tc.RelationApiPath,
				RemoteTable:     tc.RemoteTable,
				RemotePk:        tc.RemotePk,
				RemoteField:     tc.RemoteField,
				RelationFields:  []string{tc.RemoteField},
				SearchFields:    splitTrimFields(tc.RelationSearchFields),
				ExportFields:    splitTrimFields(tc.RelationExportFields),
				FieldConfigs:    tc.RelFieldConfigs,
				IsMultiple:      true,
				HasSoftDelete:   tableHasSoftDelete(ctx, tc.RemoteTable),
			})
		}
	}

	data.HasRelations = len(data.Relations) > 0
	for _, rel := range data.Relations {
		if rel.HasSoftDelete {
			data.HasRelSoftDelete = true
			break
		}
	}

	// 扫描所有字段的 GoType，判断是否需要额外 import
	for _, col := range data.AllColumns {
		if strings.Contains(col.GoType, "gtime.") {
			data.NeedsGtime = true
		}
		if strings.Contains(col.GoType, "gjson.") {
			data.NeedsGjson = true
		}
	}

	// 初始化生成步骤控制标记（从 HeadOps/ColumnOps/AutoOps 转换）
	initStepFlags(data, opts)

	return data
}

// strInArray 判断字符串是否在数组中
func strInArray(arr []string, s string) bool {
	for _, v := range arr {
		if v == s {
			return true
		}
	}
	return false
}

// initStepFlags 将前端传来的选项数组转换为布尔标记（对齐 HotGo CurdStep）
func initStepFlags(data *TplData, opts OptionsJson) {
	data.HasAdd = strInArray(opts.HeadOps, "add")
	data.HasBatchDel = strInArray(opts.HeadOps, "batchDel") && strInArray(opts.ColumnOps, "check")
	data.HasExport = strInArray(opts.HeadOps, "export")
	data.HasEdit = strInArray(opts.ColumnOps, "edit")
	data.HasDel = strInArray(opts.ColumnOps, "del")
	data.HasView = strInArray(opts.ColumnOps, "view")
	data.HasCheck = strInArray(opts.ColumnOps, "check")
	data.NotFilterAuth = strInArray(opts.ColumnOps, "notFilterAuth")

	// HasStatus: 需要 columnOps 包含 "status" 且表中确实有 status 字段
	if strInArray(opts.ColumnOps, "status") {
		for _, col := range data.AllColumns {
			if col.Name == "status" || col.Name == "state" {
				data.HasStatus = true
				break
			}
		}
	}

	// AutoOps
	data.HasMenu = strInArray(opts.AutoOps, "genMenuPermissions")
	data.ForcedCover = strInArray(opts.AutoOps, "forcedCover")

	// 查看模式
	data.ViewMode = opts.ViewMode
	if data.ViewMode == "" {
		data.ViewMode = "drawer"
	}

	// 兼容：如果 HeadOps/ColumnOps 为空（旧数据），默认全开
	if len(opts.HeadOps) == 0 && len(opts.ColumnOps) == 0 {
		data.HasAdd = true
		data.HasBatchDel = true
		data.HasExport = true
		data.HasEdit = true
		data.HasDel = true
		data.HasView = true
		data.HasCheck = true
		data.HasMenu = true
	}
}

// ColumnExtra 字段扩展配置 JSON 结构
type ColumnExtra struct {
	FormProps  map[string]interface{} `json:"_formProps"`
	TableProps map[string]interface{} `json:"_tableProps"`
}

func buildTplColumn(col adminin.GenCodesColumnItem) TplColumn {
	tc := TplColumn{
		Name:       col.Name,
		GoName:     col.GoName,
		TsName:     col.TsName,
		GoType:     col.GoType,
		TsType:     col.TsType,
		DbType:     col.DbType,
		Comment:    col.Comment,
		FormType:   col.FormType,
		DesignType: col.DesignType,
		QueryType:  col.QueryType,
		Required:   col.IsRequired == 1,
	}

	// Label: 提取注释中冒号前的部分
	tc.Label = extractLabel(col.Comment, col.GoName)

	// 默认值
	tc.DefaultValue = tsDefaultValue(col.TsType, col.FormType)

	// MinWidth
	tc.MinWidth = calcMinWidth(tc.Label, col.FormType)

	// 时间字段
	tc.IsTimeField = isTimeColumn(col.Name)

	// 状态字段
	tc.IsStatusField = (col.Name == "status" || col.Name == "state") && col.FormType == "radio"

	// 解析选项（radio/select/checkbox/switch 共用）
	// 优先级：1. 设计器手动配置(dict-options) > 2. 注释字典 > 3. enum/set 提取
	if col.DesignType == "radio" || col.DesignType == "select" || col.DesignType == "checkbox" || col.DesignType == "switch" ||
		col.FormType == "radio" || col.FormType == "select" || col.FormType == "checkbox" {
		var opts []RadioOption
		// 1. 先尝试从 extra._formProps.dict-options 读取（设计器手动配置）
		if col.Extra != "" {
			var tmpExtra ColumnExtra
			if err := json.Unmarshal([]byte(col.Extra), &tmpExtra); err == nil {
				if dictStr, ok := tmpExtra.FormProps["dict-options"].(string); ok && dictStr != "" {
					opts = parseDictOptionsStr(dictStr)
				}
			}
		}
		// 2. 注释字典
		if len(opts) == 0 {
			opts = parseRadioOptions(col.Comment)
		}
		// 3. enum/set
		if len(opts) == 0 {
			opts = parseEnumSetOptions(col.DbType, col.Comment)
		}
		if len(opts) > 0 {
			// 为每个选项分配 Tag 颜色（按索引轮换）
			for i := range opts {
				opts[i].TagType = tagTypeColors[i%len(tagTypeColors)]
			}
			tc.Options = opts
			tc.RadioOptions = opts // 兼容
			tc.HasOptions = true
		}
	}

	// 解析 extra JSON 中的关联配置
	if col.Extra != "" {
		var extra ColumnExtra
		if err := json.Unmarshal([]byte(col.Extra), &extra); err == nil {
			if fp := extra.FormProps; fp != nil {
				if v, ok := fp["remote-table"].(string); ok && v != "" {
					tc.RemoteTable = v
				}
				if v, ok := fp["remote-pk"].(string); ok && v != "" {
					tc.RemotePk = v
				}
				if v, ok := fp["remote-field"].(string); ok && v != "" {
					tc.RemoteField = v
				}
				if v, ok := fp["relation-fields"].(string); ok && v != "" {
					tc.RelationFields = v
				}
				if v, ok := fp["relation-search-fields"].(string); ok && v != "" {
					tc.RelationSearchFields = v
				}
				if v, ok := fp["relation-export-fields"].(string); ok && v != "" {
					tc.RelationExportFields = v
				}
				// 完整设计器配置
				if v, ok := fp["relation-fields-config"].(string); ok && v != "" {
					var configs []RelFieldConfig
					if err := json.Unmarshal([]byte(v), &configs); err == nil {
						for i := range configs {
							configs[i].GoName = snakeToPascal(configs[i].Field)
							// Label 兜底：前端未填时用 GoName
							if configs[i].Label == "" {
								configs[i].Label = configs[i].GoName
							}
						}
						tc.RelFieldConfigs = configs
					}
				}
			}
			// 读取 _tableProps（列渲染方式、搜索操作符等）
			if tp := extra.TableProps; tp != nil {
				if v, ok := tp["render"].(string); ok && v != "" && v != "none" {
					tc.Render = v
				}
				if v, ok := tp["operator"].(string); ok && v != "" {
					tc.Operator = v
				}
			}
		}
	}

	// 关联类型标记
	switch col.DesignType {
	case "remoteSelect":
		tc.IsRemoteSelect = true
		// 别名始终从字段名推导（去 _id 后缀），确保同表多关联时别名唯一
		// 例如: member_id → member, apply_id → apply（即使都关联 xy_member）
		rn := strings.TrimSuffix(col.Name, "_id")
		tc.RelationName = snakeToPascal(rn)
		tc.RelationAlias = snakeToCamel(rn)
		// API 路径仍从表名推导（用于前端下拉接口调用）
		if tc.RemoteTable != "" {
			if guessed := tableToRelationName(tc.RemoteTable); guessed != "" {
				tc.RelationApiPath = strings.ReplaceAll(guessed, "_", "-")
			} else {
				tc.RelationApiPath = strings.ReplaceAll(rn, "_", "-")
			}
		} else {
			tc.RelationApiPath = strings.ReplaceAll(rn, "_", "-")
		}
		if tc.RemotePk == "" {
			tc.RemotePk = "id"
		}
		if tc.RemoteField == "" {
			tc.RemoteField = "name"
		}
	case "remoteSelects":
		tc.IsRemoteSelects = true
		// 别名始终从字段名推导（去 _ids 后缀），确保同表多关联时别名唯一
		rn := strings.TrimSuffix(col.Name, "_ids")
		tc.RelationName = snakeToPascal(rn)
		tc.RelationAlias = snakeToCamel(rn)
		if tc.RemoteTable != "" {
			if guessed := tableToRelationName(tc.RemoteTable); guessed != "" {
				tc.RelationApiPath = strings.ReplaceAll(guessed, "_", "-")
			} else {
				tc.RelationApiPath = strings.ReplaceAll(rn, "_", "-")
			}
		} else {
			tc.RelationApiPath = strings.ReplaceAll(rn, "_", "-")
		}
		if tc.RemotePk == "" {
			tc.RemotePk = "id"
		}
		if tc.RemoteField == "" {
			tc.RemoteField = "name"
		}
	}

	return tc
}

// ==================== 模板渲染 ====================

// isNumericValue 检查字符串是否为纯数字（含负号和小数点）
func isNumericValue(s string) bool {
	if s == "" {
		return false
	}
	for i, c := range s {
		if c == '-' && i == 0 {
			continue
		}
		if c == '.' {
			continue
		}
		if c < '0' || c > '9' {
			return false
		}
	}
	return true
}

// tplFuncMap 模板自定义函数
var tplFuncMap = template.FuncMap{
	"lcFirst": func(s string) string {
		if len(s) == 0 {
			return s
		}
		return strings.ToLower(s[:1]) + s[1:]
	},
	"snakeCase":    toSnake,
	"kebabCase":    func(s string) string { return camelToKebab(lcFirst(s)) },
	"pascalCase":   snakeToPascal,
	"trimIdSuffix": func(s string) string { return strings.TrimSuffix(strings.TrimSuffix(s, "_ids"), "_id") },
	"contains":     strings.Contains,
	// jsValue: 数字裸输出，非数字加单引号 → 0 / 'opt0'
	"jsValue": func(s string) string {
		if isNumericValue(s) {
			return s
		}
		return "'" + s + "'"
	},
}

func renderTemplate(ctx context.Context, tplName string, data *TplData) (string, error) {
	// 从配置读取模板路径
	tpl := genconfig.GetDefaultTemplate(ctx)
	tplPath := filepath.Join(tpl.TemplatePath, tplName)
	content := gfile.GetContents(tplPath)
	if content == "" {
		return "", fmt.Errorf("template not found: %s", tplPath)
	}

	tmpl, err := template.New(tplName).Funcs(tplFuncMap).Parse(content)
	if err != nil {
		return "", fmt.Errorf("parse template %s: %w", tplName, err)
	}

	var buf bytes.Buffer
	if err := tmpl.Execute(&buf, data); err != nil {
		return "", fmt.Errorf("execute template %s: %w", tplName, err)
	}

	return buf.String(), nil
}

// ==================== 模板文件列表 ====================

func getTplFiles(ctx context.Context, data *TplData, opts OptionsJson) []tplFile {
	isTree := data.GenType == 11

	// 从配置读取默认路径
	tpl := genconfig.GetDefaultTemplate(ctx)

	// 扩展目标：覆盖所有路径到扩展目录
	if opts.AddonName != "" {
		addonName := opts.AddonName
		tpl.ApiPath = fmt.Sprintf("addons/%s/api", addonName)
		tpl.ControllerPath = fmt.Sprintf("addons/%s/controller", addonName)
		tpl.LogicPath = fmt.Sprintf("addons/%s/logic", addonName)
		tpl.InputPath = fmt.Sprintf("addons/%s/model", addonName)
		tpl.SqlPath = fmt.Sprintf("addons/%s/install", addonName)
		tpl.WebApiPath = fmt.Sprintf("../web/src/addons/%s/api", addonName)
		tpl.WebViewsPath = fmt.Sprintf("../web/src/addons/%s/views", addonName)
	}

	varLower := strings.ToLower(data.VarName[:1]) + data.VarName[1:]
	snakeName := toSnake(varLower)
	pkgName := data.PkgName

	// controller 文件名：双控制器模式下加 admin_ 前缀
	ctrlFileName := fmt.Sprintf("%s/%s.go", tpl.ControllerPath, snakeName)
	if opts.AddonName != "" && isAddonDualController(opts.AddonName) {
		ctrlFileName = fmt.Sprintf("%s/admin_%s.go", tpl.ControllerPath, snakeName)
	}

	// 公共模板（API + Controller + 前端API + 菜单SQL）
	files := []tplFile{
		{TplName: "api.go.tpl", OutPath: fmt.Sprintf("%s/admin_%s.go", tpl.ApiPath, snakeName), Lang: "go", IsServer: true},
		{TplName: "controller.go.tpl", OutPath: ctrlFileName, Lang: "go", IsServer: true},
		{TplName: "web_api.ts.tpl", OutPath: fmt.Sprintf("%s/%s.ts", tpl.WebApiPath, data.ModulePath), Lang: "typescript", IsServer: false},
		{TplName: "menu.sql.tpl", OutPath: fmt.Sprintf("%s/menu_%s.sql", tpl.SqlPath, snakeName), Lang: "sql", IsServer: true},
	}

	// 根据类型分发不同模板集
	if isTree {
		// 树表模板
		files = append(files,
			tplFile{TplName: "input_tree.go.tpl", OutPath: fmt.Sprintf("%s/%s.go", tpl.InputPath, snakeName), Lang: "go", IsServer: true},
			tplFile{TplName: "logic_tree.go.tpl", OutPath: fmt.Sprintf("%s/%s/%s.go", tpl.LogicPath, pkgName, snakeName), Lang: "go", IsServer: true},
			tplFile{TplName: "web_tree_index.vue.tpl", OutPath: fmt.Sprintf("%s/%s/index.vue", tpl.WebViewsPath, data.ModulePath), Lang: "vue", IsTree: true, IsServer: false},
			tplFile{TplName: "web_dialog_tree.vue.tpl", OutPath: fmt.Sprintf("%s/%s/modules/%s-dialog.vue", tpl.WebViewsPath, data.ModulePath, data.FilePrefix), Lang: "vue", IsTree: true, IsServer: false},
		)
		// 树表也需要搜索栏（如果有搜索字段）
		if len(data.QueryColumns) > 0 {
			files = append(files, tplFile{TplName: "web_search.vue.tpl", OutPath: fmt.Sprintf("%s/%s/modules/%s-search.vue", tpl.WebViewsPath, data.ModulePath, data.FilePrefix), Lang: "vue", IsServer: false})
		}
	} else {
		// 普通列表模板
		files = append(files,
			tplFile{TplName: "input.go.tpl", OutPath: fmt.Sprintf("%s/%s.go", tpl.InputPath, snakeName), Lang: "go", IsServer: true},
			tplFile{TplName: "logic.go.tpl", OutPath: fmt.Sprintf("%s/%s/%s.go", tpl.LogicPath, pkgName, snakeName), Lang: "go", IsServer: true},
			tplFile{TplName: "web_index.vue.tpl", OutPath: fmt.Sprintf("%s/%s/index.vue", tpl.WebViewsPath, data.ModulePath), Lang: "vue", IsList: true, IsServer: false},
		)
		// 有新增/编辑时生成 dialog
		if data.HasAdd || data.HasEdit {
			files = append(files,
				tplFile{TplName: "web_dialog.vue.tpl", OutPath: fmt.Sprintf("%s/%s/modules/%s-dialog.vue", tpl.WebViewsPath, data.ModulePath, data.FilePrefix), Lang: "vue", IsServer: false},
			)
		}
		// 有查看时生成详情组件
		if data.HasView {
			if data.ViewMode == "page" {
				files = append(files,
					tplFile{TplName: "web_detail_page.vue.tpl", OutPath: fmt.Sprintf("%s/%s/detail/index.vue", tpl.WebViewsPath, data.ModulePath), Lang: "vue", IsServer: false},
				)
			} else {
				files = append(files,
					tplFile{TplName: "web_detail_drawer.vue.tpl", OutPath: fmt.Sprintf("%s/%s/modules/%s-detail-drawer.vue", tpl.WebViewsPath, data.ModulePath, data.FilePrefix), Lang: "vue", IsServer: false},
				)
			}
		}
		// 搜索栏
		files = append(files,
			tplFile{TplName: "web_search.vue.tpl", OutPath: fmt.Sprintf("%s/%s/modules/%s-search.vue", tpl.WebViewsPath, data.ModulePath, data.FilePrefix), Lang: "vue", IsServer: false},
		)
	}

	// 前端传入的 genPaths 可覆盖配置默认路径
	if opts.GenPaths != nil {
		for i, f := range files {
			switch f.TplName {
			case "api.go.tpl":
				if p := opts.GenPaths["api"]; p != "" {
					files[i].OutPath = p
				}
			case "controller.go.tpl":
				if p := opts.GenPaths["controller"]; p != "" {
					files[i].OutPath = p
				}
			case "logic.go.tpl", "logic_tree.go.tpl":
				if p := opts.GenPaths["logic"]; p != "" {
					files[i].OutPath = p
				}
			case "input.go.tpl", "input_tree.go.tpl":
				if p := opts.GenPaths["input"]; p != "" {
					files[i].OutPath = p
				}
			case "web_index.vue.tpl", "web_tree_index.vue.tpl":
				if p := opts.GenPaths["webIndex"]; p != "" {
					files[i].OutPath = p
				}
			case "web_search.vue.tpl":
				if p := opts.GenPaths["webSearch"]; p != "" {
					files[i].OutPath = p
				}
			case "web_dialog.vue.tpl", "web_dialog_tree.vue.tpl":
				if p := opts.GenPaths["webDialog"]; p != "" {
					files[i].OutPath = p
				}
			case "web_api.ts.tpl":
				if p := opts.GenPaths["webApi"]; p != "" {
					files[i].OutPath = p
				}
			}
		}
	}

	return files
}

// ==================== 工具函数 ====================

func parseOptions(optStr string) OptionsJson {
	var opts OptionsJson
	if optStr != "" {
		_ = json.Unmarshal([]byte(optStr), &opts)
	}
	if opts.GenType == 0 {
		opts.GenType = 10
	}
	return opts
}

// splitTrimFields 将逗号分隔的字符串拆为 []string，过滤空值
func splitTrimFields(s string) []string {
	if s == "" {
		return nil
	}
	parts := strings.Split(s, ",")
	result := make([]string, 0, len(parts))
	for _, p := range parts {
		p = strings.TrimSpace(p)
		if p != "" {
			result = append(result, p)
		}
	}
	if len(result) == 0 {
		return nil
	}
	return result
}

func resolveOutputPath(_ context.Context, relPath string, isServer bool) string {
	serverRoot := gfile.Pwd()
	if isServer {
		return filepath.Join(serverRoot, relPath)
	}
	// 前端路径：配置中已用 ../web/ 前缀，直接拼接 server 根目录
	return filepath.Join(serverRoot, relPath)
}

// lookupRouteNameByTable 扫描 api/admin/ 下所有 Go 文件，找到关联表的 /list 接口路由前缀
// 不依赖生成器记录和文件名，直接匹配 path 内容，手写和生成的都能找到
func lookupRouteNameByTable(ctx context.Context, tableName string) string {
	if tableName == "" {
		return ""
	}
	name := relationTableBase(tableName)
	// 构建匹配模式：member_group → 可能的路径形式
	// /admin/member-group/list 或 /admin/member/group/list
	kebab := strings.ReplaceAll(name, "_", "-")   // member-group
	slashed := strings.ReplaceAll(name, "_", "/") // member/group
	candidates := map[string]struct{}{
		kebab:   {},
		slashed: {},
	}
	if coreRoute := coreRelationApiPath(tableName); coreRoute != "" {
		candidates[coreRoute] = struct{}{}
	}

	apiDir := filepath.Join(gfile.Pwd(), "api", "admin")
	entries, err := os.ReadDir(apiDir)
	if err != nil {
		return ""
	}

	for _, e := range entries {
		if !strings.HasSuffix(e.Name(), ".go") {
			continue
		}
		data, err := os.ReadFile(filepath.Join(apiDir, e.Name()))
		if err != nil {
			continue
		}
		content := string(data)
		// 搜索所有 path:"/admin/...list" 模式
		searchPrefix := `path:"/admin/`
		offset := 0
		for {
			idx := strings.Index(content[offset:], searchPrefix)
			if idx < 0 {
				break
			}
			start := offset + idx + len(searchPrefix)
			endIdx := strings.Index(content[start:], `"`)
			if endIdx < 0 {
				break
			}
			fullPath := content[start : start+endIdx] // 如 "member/group/list" 或 "member-group/list"
			offset = start + endIdx

			// 只匹配 /list 结尾的路径
			if !strings.HasSuffix(fullPath, "/list") {
				continue
			}
			routePrefix := fullPath[:len(fullPath)-5] // 去掉 /list

			// 匹配：精确比较 kebab、slashed 或核心表真实路由形式
			if _, ok := candidates[routePrefix]; ok {
				return routePrefix
			}
		}
	}
	return ""
}

// camelToKebab CamelCase -> kebab-case
func camelToKebab(s string) string {
	var result []rune
	for i, r := range s {
		if r >= 'A' && r <= 'Z' {
			if i > 0 {
				result = append(result, '-')
			}
			result = append(result, r+32)
		} else {
			result = append(result, r)
		}
	}
	return string(result)
}

// toSnake CamelCase -> snake_case
func toSnake(s string) string {
	var result []rune
	for i, r := range s {
		if r >= 'A' && r <= 'Z' {
			if i > 0 {
				result = append(result, '_')
			}
			result = append(result, r+32)
		} else {
			result = append(result, r)
		}
	}
	return string(result)
}

// lcFirst 首字母小写
func lcFirst(s string) string {
	if len(s) == 0 {
		return s
	}
	return strings.ToLower(s[:1]) + s[1:]
}

func extractLabel(comment, goName string) string {
	if comment == "" {
		return goName
	}
	// "状态:0=禁用,1=启用" -> "状态"
	if idx := strings.IndexAny(comment, ":："); idx > 0 {
		comment = comment[:idx]
	}
	// 截断括号及之后的内容: "周期标签（如...）" -> "周期标签"
	if idx := strings.IndexAny(comment, "(（"); idx > 0 {
		comment = comment[:idx]
	}
	// 截断逗号/顿号之后: "排序，值越大越靠前" -> "排序"
	if idx := strings.IndexAny(comment, ",，、"); idx > 0 {
		comment = comment[:idx]
	}
	return comment
}

func tsDefaultValue(tsType, formType string) string {
	switch formType {
	case "switch":
		return "0"
	case "inputNumber":
		return "0"
	}
	switch tsType {
	case "number":
		return "0"
	default:
		return "''"
	}
}

func calcMinWidth(label string, formType string) int {
	l := len([]rune(label))
	if formType == "richEditor" || formType == "textarea" {
		return 200
	}
	if l <= 2 {
		return 100
	}
	if l <= 4 {
		return 120
	}
	return 160
}

func isTimeColumn(name string) bool {
	n := strings.ToLower(name)
	return n == "created_at" || n == "updated_at" || n == "create_time" || n == "update_time" ||
		n == "deleted_at" || n == "delete_time" || strings.HasSuffix(n, "_time") || strings.HasSuffix(n, "_at")
}

// parseRadioOptions 解析注释中的选项字典（对齐 BuildAdmin Helper::getDictData）
// 格式: "状态:0=禁用,1=启用" 或 "下拉框:opt0=选项一,opt1=选项二"
// 要求注释中同时出现 ':'、','、'=' 三种分隔符才视为字典。
func parseRadioOptions(comment string) []RadioOption {
	comment = strings.TrimSpace(comment)
	if comment == "" {
		return nil
	}
	// 统一中文标点 -> 英文标点（对齐 BuildAdmin）
	comment = strings.ReplaceAll(comment, "，", ",")
	comment = strings.ReplaceAll(comment, "：", ":")
	comment = strings.ReplaceAll(comment, "；", ";")

	// 兼容空格分隔："状态:0=失败 1=成功" -> "状态:0=失败,1=成功"
	// 规则：在冒号后的部分，将 "空格+数字/字母=" 前的空格替换为逗号
	if ci := strings.Index(comment, ":"); ci >= 0 && ci+1 < len(comment) {
		before := comment[:ci+1]
		after := comment[ci+1:]
		// 把 " X=" 模式（X 是选项键）中的空格替换为逗号
		var normalized []byte
		afterBytes := []byte(after)
		for i := 0; i < len(afterBytes); i++ {
			if afterBytes[i] == ' ' {
				// 向前看：跳过连续空格后是否跟着 key=value 模式
				j := i + 1
				for j < len(afterBytes) && afterBytes[j] == ' ' {
					j++
				}
				if j < len(afterBytes) && afterBytes[j] != '=' {
					// 可能是新选项的开头，替换为逗号
					normalized = append(normalized, ',')
					i = j - 1
					continue
				}
			}
			normalized = append(normalized, afterBytes[i])
		}
		comment = before + string(normalized)
	}

	// 必须同时包含 : , = 才按字典解析
	if !strings.Contains(comment, ":") || !strings.Contains(comment, ",") || !strings.Contains(comment, "=") {
		return nil
	}

	// 按第一个 ':' 分割 -> [标题, 选项列表]
	idx := strings.Index(comment, ":")
	if idx < 0 || idx+1 >= len(comment) {
		return nil
	}
	itemsPart := comment[idx+1:]

	// 按 ',' 分割每个选项
	items := strings.Split(itemsPart, ",")
	opts := make([]RadioOption, 0, len(items))
	for _, item := range items {
		item = strings.TrimSpace(item)
		if item == "" {
			continue
		}
		parts := strings.SplitN(item, "=", 2)
		if len(parts) != 2 {
			continue
		}
		key := strings.TrimSpace(parts[0])
		val := strings.TrimSpace(parts[1])
		if key == "" || val == "" {
			continue
		}
		opts = append(opts, RadioOption{Value: key, Label: val})
	}
	return opts
}

// parseDictOptionsStr 解析设计器手动配置的选项："0=禁用,1=启用"
func parseDictOptionsStr(s string) []RadioOption {
	if s == "" {
		return nil
	}
	items := strings.Split(s, ",")
	opts := make([]RadioOption, 0, len(items))
	for _, item := range items {
		item = strings.TrimSpace(item)
		if item == "" {
			continue
		}
		parts := strings.SplitN(item, "=", 2)
		if len(parts) != 2 {
			continue
		}
		key := strings.TrimSpace(parts[0])
		val := strings.TrimSpace(parts[1])
		if key != "" && val != "" {
			opts = append(opts, RadioOption{Value: key, Label: val})
		}
	}
	return opts
}

// parseEnumSetOptions 从 COLUMN_TYPE 提取 enum/set 的可选值
// 例: enum('opt0','opt1') -> [{opt0, opt0}, {opt1, opt1}]
func parseEnumSetOptions(columnType, comment string) []RadioOption {
	ct := strings.ToLower(strings.TrimSpace(columnType))
	if !strings.HasPrefix(ct, "enum(") && !strings.HasPrefix(ct, "set(") {
		return nil
	}
	start := strings.Index(columnType, "(")
	end := strings.LastIndex(columnType, ")")
	if start < 0 || end <= start+1 {
		return nil
	}
	inner := columnType[start+1 : end]
	inner = strings.ReplaceAll(inner, "'", "")
	inner = strings.ReplaceAll(inner, "\"", "")
	inner = strings.ReplaceAll(inner, " ", "")
	vals := strings.Split(inner, ",")
	if len(vals) == 0 {
		return nil
	}

	// 从注释获取标签映射
	labelMap := make(map[string]string)
	normalized := strings.ReplaceAll(strings.ReplaceAll(comment, "，", ","), "：", ":")
	if ci := strings.Index(normalized, ":"); ci >= 0 && ci+1 < len(normalized) {
		for _, seg := range strings.Split(normalized[ci+1:], ",") {
			kv := strings.SplitN(strings.TrimSpace(seg), "=", 2)
			if len(kv) == 2 {
				labelMap[strings.TrimSpace(kv[0])] = strings.TrimSpace(kv[1])
			}
		}
	}

	opts := make([]RadioOption, 0, len(vals))
	for _, v := range vals {
		v = strings.TrimSpace(v)
		if v == "" {
			continue
		}
		label := v
		if l, ok := labelMap[v]; ok && l != "" {
			label = l
		}
		opts = append(opts, RadioOption{Value: v, Label: label})
	}
	return opts
}

// tableToRelationName 将 remote-table 转为关联名称基底（snake_case）
// 例如：xy_demo_category -> demo_category，demo.category -> category
func tableToRelationName(remoteTable string) string {
	if coreRoute := coreRelationApiPath(remoteTable); coreRoute != "" {
		return strings.ReplaceAll(coreRoute, "-", "_")
	}
	return relationTableBase(remoteTable)
}

func relationTableBase(remoteTable string) string {
	name := strings.TrimSpace(remoteTable)
	if name == "" {
		return ""
	}
	if idx := strings.LastIndex(name, "."); idx >= 0 && idx+1 < len(name) {
		name = name[idx+1:]
	}
	name = strings.TrimPrefix(name, "xy_")
	return strings.TrimSpace(name)
}

func coreRelationApiPath(remoteTable string) string {
	switch relationTableBase(remoteTable) {
	case "admin_user":
		return "user"
	case "admin_role":
		return "role"
	case "admin_menu":
		return "menu"
	case "admin_dept":
		return "dept"
	case "admin_post":
		return "post"
	case "sys_attachment":
		return "attachment"
	case "sys_config":
		return "config"
	}
	return ""
}

// guessRemoteTable 在未配置 remote-table 时尝试推断关联表名。
// 规则：xy_demo_article + category_id -> demo_category
func guessRemoteTable(currentTable, fieldName string) string {
	base := strings.TrimSuffix(strings.TrimSuffix(fieldName, "_ids"), "_id")
	base = strings.TrimSpace(base)
	if base == "" {
		return ""
	}
	table := strings.TrimPrefix(strings.TrimSpace(currentTable), "xy_")
	parts := strings.Split(table, "_")
	if len(parts) == 0 || parts[0] == "" {
		return base
	}
	prefix := parts[0]
	if strings.HasPrefix(base, prefix+"_") {
		return base
	}
	return prefix + "_" + base
}

// tableHasSoftDelete 检测指定表是否有 deleted_at 字段（用于生成 LEFT JOIN 时决定是否处理软删除）
// tableName 可能带前缀(xy_member)也可能不带(member)，函数自动处理
func tableHasSoftDelete(ctx context.Context, tableName string) bool {
	dl := dbdialect.Get()
	dbName, err := dl.GetDbName(ctx)
	if err != nil {
		return false
	}
	// RemoteTable 可能已带前缀(xy_member)或不带(member)，确保带前缀
	prefix := g.DB().GetPrefix()
	fullTable := tableName
	if prefix != "" && !strings.HasPrefix(tableName, prefix) {
		fullTable = prefix + tableName
	}
	sql := dl.ListColumnsSimpleSQL(dbName, fullTable)
	result, err := g.DB().GetAll(ctx, sql)
	if err != nil {
		return false
	}
	for _, row := range result {
		colName := row["columnName"].String()
		if colName == "" {
			colName = row["COLUMN_NAME"].String()
		}
		if colName == "deleted_at" {
			return true
		}
	}
	return false
}

// ==================== 插件模式自动化 ====================

// isAddonDualController 检测插件是否采用双控制器模式（含 AdminControllerV1）
func isAddonDualController(addonName string) bool {
	baseFile := filepath.Join(gfile.Pwd(), "addons", addonName, "controller", "controller.go")
	if !gfile.Exists(baseFile) {
		return false
	}
	return strings.Contains(gfile.GetContents(baseFile), "AdminControllerV1")
}

// generateAddonSupport 插件模式下自动生成 service 接口、controller 结构体、更新 module.go 和 addons.go
func generateAddonSupport(ctx context.Context, addonName string, data *TplData) {
	addonDir := filepath.Join(gfile.Pwd(), "addons", addonName)

	generateAddonService(ctx, addonDir, addonName, data)
	generateAddonControllerBase(ctx, addonDir)
	updateAddonModule(ctx, addonDir, addonName, data)
	updateAddonsGo(ctx, addonName)
}

// generateAddonService 自动生成插件的 service 接口文件
func generateAddonService(ctx context.Context, addonDir, addonName string, data *TplData) {
	svcDir := filepath.Join(addonDir, "service")
	_ = os.MkdirAll(svcDir, 0755)

	varName := data.VarName
	varLower := strings.ToLower(varName[:1]) + varName[1:]
	snakeName := toSnake(varLower)
	svcFile := filepath.Join(svcDir, snakeName+".go")

	if gfile.Exists(svcFile) {
		g.Log().Infof(ctx, "[AddonSupport] service file already exists: %s", svcFile)
		return
	}

	importPath := fmt.Sprintf("xygo/addons/%s/model", addonName)

	var methods []string
	methods = append(methods, fmt.Sprintf(
		"\tList(ctx context.Context, in *adminin.%sListInp) (*adminin.%sListModel, error)", varName, varName))
	if data.HasView {
		methods = append(methods, fmt.Sprintf(
			"\tView(ctx context.Context, id uint64) (*adminin.%sViewModel, error)", varName))
	}
	if data.HasAdd || data.HasEdit {
		methods = append(methods, fmt.Sprintf(
			"\tEdit(ctx context.Context, in *adminin.%sEditInp) error", varName))
	}
	if data.HasDel || data.HasBatchDel {
		methods = append(methods, "\tDelete(ctx context.Context, id uint64) error")
	}

	content := fmt.Sprintf(`package service

import (
	"context"

	adminin "%s"
)

type I%s interface {
%s
}

var local%s I%s

func %s() I%s {
	if local%s == nil {
		panic("service %s not registered")
	}
	return local%s
}

func Register%s(s I%s) {
	local%s = s
}
`, importPath, varName, strings.Join(methods, "\n"),
		varName, varName,
		varName, varName,
		varName, varName, varName,
		varName, varName, varName)

	if err := os.WriteFile(svcFile, []byte(content), 0644); err != nil {
		g.Log().Warningf(ctx, "[AddonSupport] write service file error: %v", err)
	} else {
		g.Log().Infof(ctx, "[AddonSupport] generated service interface: %s", svcFile)
	}
}

// generateAddonControllerBase 确保插件有 controller/controller.go
// 普通 addon: ControllerV1 + NewV1
// 双控制器 addon: 还包含 AdminControllerV1 + NewAdminV1
func generateAddonControllerBase(ctx context.Context, addonDir string) {
	ctrlDir := filepath.Join(addonDir, "controller")
	baseFile := filepath.Join(ctrlDir, "controller.go")
	if gfile.Exists(baseFile) {
		return
	}
	_ = os.MkdirAll(ctrlDir, 0755)

	hasMw := gfile.Exists(filepath.Join(addonDir, "middleware.go"))
	var content string
	if hasMw {
		content = `package controller

type AdminControllerV1 struct{}

func NewAdminV1() *AdminControllerV1 { return &AdminControllerV1{} }

type ControllerV1 struct{}

func NewV1() *ControllerV1 { return &ControllerV1{} }
`
	} else {
		content = `package controller

type ControllerV1 struct{}

func NewV1() *ControllerV1 {
	return &ControllerV1{}
}
`
	}
	if err := os.WriteFile(baseFile, []byte(content), 0644); err != nil {
		g.Log().Warningf(ctx, "[AddonSupport] write controller base error: %v", err)
	} else {
		g.Log().Infof(ctx, "[AddonSupport] generated controller base: %s", baseFile)
	}
}

// updateAddonModule 更新插件的 module.go：添加 logic 包空导入、启用 controller 绑定
func updateAddonModule(ctx context.Context, addonDir, addonName string, data *TplData) {
	moduleFile := filepath.Join(addonDir, "module.go")
	if !gfile.Exists(moduleFile) {
		g.Log().Warning(ctx, "[AddonSupport] module.go not found, skip")
		return
	}

	content := gfile.GetContents(moduleFile)
	changed := false

	// 添加 logic 包空导入
	logicImport := fmt.Sprintf(`_ "xygo/addons/%s/logic/%s"`, addonName, data.PkgName)
	if !strings.Contains(content, logicImport) {
		lines := strings.Split(content, "\n")
		var insertIdx int
		for i, line := range lines {
			trimmed := strings.TrimSpace(line)
			if strings.HasPrefix(trimmed, `_ "`) {
				insertIdx = i + 1
			}
		}
		if insertIdx > 0 {
			newLine := "\t" + logicImport
			newLines := make([]string, 0, len(lines)+1)
			newLines = append(newLines, lines[:insertIdx]...)
			newLines = append(newLines, newLine)
			newLines = append(newLines, lines[insertIdx:]...)
			content = strings.Join(newLines, "\n")
			changed = true
		}
	}

	// 添加 controller 包导入
	ctrlImport := fmt.Sprintf(`"xygo/addons/%s/controller"`, addonName)
	if !strings.Contains(content, ctrlImport) {
		lines := strings.Split(content, "\n")
		for i, line := range lines {
			if strings.TrimSpace(line) == "import (" {
				newLine := "\t" + ctrlImport
				newLines := make([]string, 0, len(lines)+1)
				newLines = append(newLines, lines[:i+1]...)
				newLines = append(newLines, newLine)
				newLines = append(newLines, lines[i+1:]...)
				content = strings.Join(newLines, "\n")
				changed = true
				break
			}
		}
	}

	// 启用 controller 绑定（取消注释，兼容 group/ag 两种变量名）
	bindPatterns := [][2]string{
		{"// group.Bind(controller.NewV1())", "group.Bind(controller.NewV1())"},
		{"// ag.Bind(controller.NewV1())", "ag.Bind(controller.NewV1())"},
		{"// group.Bind(controller.NewAdminV1())", "group.Bind(controller.NewAdminV1())"},
		{"// ag.Bind(controller.NewAdminV1())", "ag.Bind(controller.NewAdminV1())"},
	}
	for _, p := range bindPatterns {
		if strings.Contains(content, p[0]) {
			content = strings.Replace(content, p[0], p[1], 1)
			changed = true
		}
	}

	if changed {
		if err := os.WriteFile(moduleFile, []byte(content), 0644); err != nil {
			g.Log().Warningf(ctx, "[AddonSupport] write module.go error: %v", err)
		} else {
			g.Log().Info(ctx, "[AddonSupport] updated module.go with logic import and controller binding")
		}
	}
}

// updateAddonsGo 确保 addons/addons.go 包含此插件的空导入
func updateAddonsGo(ctx context.Context, addonName string) {
	addonsFile := filepath.Join(gfile.Pwd(), "addons", "addons.go")
	if !gfile.Exists(addonsFile) {
		return
	}

	importLine := fmt.Sprintf(`_ "xygo/addons/%s"`, addonName)
	content := gfile.GetContents(addonsFile)
	if strings.Contains(content, importLine) {
		return
	}

	if !strings.Contains(content, "import (") {
		content = fmt.Sprintf("// Code generated and maintained by addon installer. DO NOT EDIT.\n\npackage addons\n\nimport (\n\t%s\n)\n", importLine)
	} else {
		content = strings.Replace(content, "import (", "import (\n\t"+importLine, 1)
	}

	if err := os.WriteFile(addonsFile, []byte(content), 0644); err != nil {
		g.Log().Warningf(ctx, "[AddonSupport] write addons.go error: %v", err)
	} else {
		g.Log().Infof(ctx, "[AddonSupport] registered addon import in addons.go: %s", addonName)
	}
}
