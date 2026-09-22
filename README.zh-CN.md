<p align="center">
  <img src="https://xygoupload.xingyunwangluo.com/gitee/%E5%8D%95%E7%8B%AClogo.png" width="200" />
</p>
<br />
<h1 align="center">XYGo Admin</h1>
<p align="center">基于 Vue3 + GoFrame 构建的通用开源中后台管理框架，内置权限管理、代码生成、系统监控等核心模块，开箱即用，快速启动你的业务开发。</p>
<div align="center">简体中文 | <a href="./README.md">English</a></div>

<br />
<p align="center">
  <a href="https://www.xygoadmin.com">官网</a> |
  <a href="https://www.xygoadmin.com">演示</a> |
  <a href="https://qm.qq.com/q/dwSdPBjkhU">加群</a> |
  <a href="https://gitee.com/a751300685a/xygo-admin">Gitee仓库</a> |
  <a href="https://github.com/z312193608/xygo-admin">GitHub仓库</a>
</p>

<div align="center">

[![license](https://img.shields.io/badge/license-MIT-green.svg)](./LICENSE)
[![Vue](https://img.shields.io/badge/Vue-3.x-42b883.svg)](https://vuejs.org/)
[![GoFrame](https://img.shields.io/badge/GoFrame-v2-00ADD8.svg)](https://goframe.org/)
[![Go](https://img.shields.io/badge/Go-1.22+-00ADD8.svg)](https://golang.org/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.x-3178C6.svg)](https://www.typescriptlang.org/)
[![Vite](https://img.shields.io/badge/Vite-6.x-646CFF.svg)](https://vitejs.dev/)
[![Element Plus](https://img.shields.io/badge/Element_Plus-2.x-409EFF.svg)](https://element-plus.org/)
[![Pinia](https://img.shields.io/badge/Pinia-2.x-F7D336.svg)](https://pinia.vuejs.org/)
[![Tailwind CSS](https://img.shields.io/badge/Tailwind_CSS-3.x-06B6D4.svg)](https://tailwindcss.com/)
[![Art Design Pro](https://img.shields.io/badge/Art_Design_Pro-UI-FF6B6B.svg)](https://github.com/Daymychen/art-design-pro)
[![Gitee star](https://gitee.com/a751300685a/xygo-admin/badge/star.svg?theme=gvp)](https://gitee.com/a751300685a/xygo-admin/stargazers)
[![Gitee fork](https://gitee.com/a751300685a/xygo-admin/badge/fork.svg?theme=gvp)](https://gitee.com/a751300685a/xygo-admin/members)

</div>
<br />

### 介绍

XYGo Admin 是一款全栈开源中后台管理框架，前端基于 [Art Design Pro](https://github.com/Daymychen/art-design-pro)（Vue3 + TypeScript + Element Plus），后端基于 [GoFrame v2](https://goframe.org/)。无需授权即可免费商用，希望能帮助开发者快速搭建企业级管理系统。

### 主要特性

**RBAC 权限体系**：角色、菜单、按钮、数据权限、字段权限，精细到列级控制，可视化管理权限分配

**可视化代码生成**：可视化设计表结构，一键生成前后端 CRUD 代码（Go API + Controller + Logic + Vue 页面），支持主子表关联，节省 80% 开发时间

**双数据库支持**：同时兼容 MySQL 和 PostgreSQL，一套代码双库运行，切换数据库只需改一行配置

**前后端分离**：前端 Vue3 SPA + 后端 GoFrame RESTful API，可独立部署，也可打包为单体二进制一键部署

**会员门户系统**：内置前台门户 + 会员中心，支持注册登录、积分签到、个人中心，门户菜单后台可视化管理

**文档中心**：内置 Markdown 文档管理，支持分类树、全文搜索、在线预览

**系统监控**：服务器状态监控、慢查询告警、慢接口告警、操作日志、登录日志全覆盖

**消息队列**：基于 Redis 的异步任务队列，支持定时任务管理和消息推送

**现代 UI**：基于 Art Design Pro，六种布局模式、明暗主题、丝滑动画交互，按钮点击、主题切换、页面过渡体验媲美商业产品

**单体部署**：支持将前端打包进 Go 二进制，一个文件 + 一个配置即可部署，无需 Nginx

### 开源版与商业版功能对照

权限、代码生成、会员门户、文档中心、系统监控、Redis 队列这些通用后台两边都有。下表只列**功能差异**（按仓库代码核对，不是宣传口径）。

| 功能 | 开源版 | 商业版 Pro |
|------|--------|------------|
| 达梦 DM8 | — | 支持（与 MySQL / PostgreSQL 同一套代码） |
| 百万级数据异步导出 | 仅浏览器端小表导出 | 超 1 万条自动异步，分批写 Excel / ZIP，后台可查进度 |
| 附件文档阅读器 | 仅图片预览 | 浏览器内预览 PDF / Word / Excel / 文本 / 音视频 |
| 前端体积 / 按需加载 | 图标选择器整包进首屏，语言包一次全量加载 | 构建只注册实际用到的 Iconify 图标；图标集与页面语言包按需懒加载 |
| 多租户 SaaS | — | 数据按租户隔离，套餐授权菜单能力 |
| 平台端 + 租户端 | — | 双后台；平台可代登进租户 |
| RabbitMQ | — | 可选（默认关，与现有队列互补） |
| 登录验证码 | 点选 | 基础、点选、滑动拼图、拖拽、旋转，可在安全设置切换 |
| 密码强度 | — | 低 / 中 / 高；后台用户、会员注册与改密按等级校验 |
| 顶部快捷入口 | 写在代码里 | 从菜单选择，可改图标和说明 |

商业版演示：[tenant.xygoadmin.com](https://tenant.xygoadmin.com) · 说明：[www.xygoadmin.com/pro](https://www.xygoadmin.com/pro)

### 更新日志

开源走 **1.x**，商业版走 **2.x**，版本线独立。同一天也会发不同内容。下表从既有三版起累积：哪一侧发了新版，就在该侧加一条，另一侧留空，旧条目保留，用来看出两边的更新频率。

| 开源版 | 商业版 Pro |
|--------|------------|
| — | **v2.1.0** · 2026-09-22 · 验证码、密码强度、云存储同步与快捷入口<br>• 登录验证码支持基础、点选、滑动拼图、拖拽和旋转<br>• 后台用户、会员、注册和个人中心按密码强度校验<br>• 本地附件可同步到云存储<br>• 顶部快捷入口改为从菜单配置 |
| **v1.5.1** · 2026-09-18 · 登录验证码必验与文档页修复<br>• 后台和会员登录验证码改为必验，禁止空字段绕过<br>• 文档日期按秒级时间戳正确显示<br>• 一级分类下的文档可以点击打开<br>• 文档 / 分类状态筛选默认显示全部 | **v2.0.10** · 2026-09-18 · 达梦支持与登录验证码修复<br>• 新增达梦 DM8 数据库支持<br>• 修复登录可跳过点选验证码<br>• 文档站时间戳与根分类点击修复<br>• 本版不含数据库迁移 |
| **v1.5.0** · 2026-09-10 · 登录日志状态与操作日志上传修复<br>• 会员登录成功却显示失败（按 1=成功、0=失败）<br>• 操作日志不再把上传文件写入数据库 | **v2.0.9** · 2026-09-14 · 导出任务 MySQL 类型兼容<br>• 导出进度 / 文件数类型对齐，避免 MySQL 环境编译失败 |
| **v1.4.9** · 2026-08-16 · 对象存储与 CDN 预览<br>• 完善七牛 / 阿里云 OSS / 腾讯云 COS<br>• 历史附件云同步与统一 CDN 预览 | **v2.0.8** · 2026-09-12 · 前端体积优化与生成器树表关联<br>• 图标与 Markdown 编辑器按需加载，减小生产包体积<br>• 树表远程下拉按本表外键生成关联查询 |

完整列表见 [官网更新日志](https://www.xygoadmin.com/changelog)。

### 技术栈

| 层级 | 技术 |
|------|------|
| 前端框架 | Vue 3、TypeScript、Vite |
| UI 组件库 | Element Plus、Tailwind CSS |
| 状态管理 | Pinia |
| 后端框架 | GoFrame v2（Go 1.22+） |
| 数据库 | MySQL 8.0+ / PostgreSQL 14+ |
| 缓存/队列 | Redis |
| 认证 | JWT（支持单点登录） |

### 项目预览

> 演示站：[www.xygoadmin.com](https://www.xygoadmin.com)

<table>
  <tr>
    <td><img src="https://xygoupload.xingyunwangluo.com/gitee/1.png" /></td>
    <td><img src="https://xygoupload.xingyunwangluo.com/gitee/2.png" /></td>
    <td><img src="https://xygoupload.xingyunwangluo.com/gitee/3.png" /></td>
  </tr>
  <tr>
    <td><img src="https://xygoupload.xingyunwangluo.com/gitee/4.png" /></td>
    <td><img src="https://xygoupload.xingyunwangluo.com/gitee/5.png" /></td>
    <td><img src="https://xygoupload.xingyunwangluo.com/gitee/6.png" /></td>
  </tr>
  <tr>
    <td><img src="https://xygoupload.xingyunwangluo.com/gitee/7.png" /></td>
    <td><img src="https://xygoupload.xingyunwangluo.com/gitee/8.png" /></td>
    <td><img src="https://xygoupload.xingyunwangluo.com/gitee/9.png" /></td>
  </tr>
</table>

### 快速访问

[演示站](https://www.xygoadmin.com) | [Gitee 仓库](https://gitee.com/a751300685a/xygo-admin) | [GitHub 仓库](https://github.com/z312193608/xygo-admin) | [📖 完整文档](https://www.xygoadmin.com/docs)

### 安装使用

详细安装步骤请查阅 **[📖 官方文档](https://www.xygoadmin.com/docs)**。

**克隆后本地开发（推荐）**

```bash
# 1. 数据库：导入 mysql_install.sql 或 pgsql_install.sql，配置 server/manifest/config/config.yaml

# 2. 后端 API（默认 :4096；develop 模式下 dist 未构建也可启动）
cd server
go run main.go

# 3. 前端 dev 服务（另开终端，默认 :3006，代理 API）
cd web
pnpm install
pnpm dev
```

浏览器访问前端 dev 地址（如 `http://localhost:3006`）。**不要**在未执行 `pnpm build` 的情况下指望 `:4096` 直接打开完整页面。

**单体部署（前后端同一端口）**

```bash
cd web && pnpm install && pnpm build   # 产物输出到 server/resource/public/dist
cd ../server && go run main.go         # 访问 http://localhost:4096
```

> `server/resource/public/dist/` 构建产物不入库，目录内仅有 `.gitkeep` 占位；生产模式（`system.mode: product`）缺少 `index.html` 时会拒绝启动并提示先 build。

**默认账号**

| 角色 | 账号 | 密码 |
|------|------|------|
| 超级管理员 | admin | 123456 |

### 项目结构

```
xygoadmin/
├── server/                    # 后端 GoFrame 项目
│   ├── addons/                # 扩展包目录（*.zip）
│   ├── api/                   # API 接口定义
│   ├── internal/
│   │   ├── cmd/               # 主命令入口
│   │   ├── cmdtools/          # 工具命令逻辑（迁移、扩展、在线更新）
│   │   ├── controller/        # 控制器（请求处理）
│   │   ├── logic/             # 业务逻辑（核心代码在这里）
│   │   ├── model/             # 数据模型（entity/do/input）
│   │   ├── dao/               # 数据访问层（gf gen dao 自动生成）
│   │   └── service/           # 服务接口（gf gen service 自动生成）
│   ├── cmd_tools/migrate/     # 迁移 SQL 文件
│   ├── manifest/config/       # 运行时配置文件
│   ├── hack/config.yaml       # CLI 工具配置（build/gen）
│   ├── resource/              # 静态资源、代码生成模板
│   ├── main.go                # 服务启动入口（gf run main.go）
│   └── tools.go               # 工具命令入口（go run tools.go）
├── web/                       # 前端 Vue3 项目
│   ├── src/
│   │   ├── api/               # API 请求封装
│   │   ├── views/             # 页面组件（backend/frontend）
│   │   ├── router/            # 路由（静态 + 动态加载）
│   │   ├── store/             # Pinia 状态管理
│   │   └── components/        # 通用组件
│   └── ...
├── mysql_install.sql           # MySQL 初始化脚本
├── pgsql_install.sql           # PostgreSQL 初始化脚本
└── version.json                # 版本信息（用于在线更新）
```

### 工具命令

在 `server/` 目录下通过 `go run tools.go` 使用：

| 命令 | 说明 |
|------|------|
| `go run tools.go` | 交互式菜单 |
| `go run tools.go migrate up` | 执行数据库迁移 |
| `go run tools.go migrate status` | 查看迁移状态 |
| `go run tools.go migrate history` | 查看迁移历史 |
| `go run tools.go check-tpl` | 检查模板语法 |
| `go run tools.go update` | 在线更新 |
| `go run tools.go addon install tenant` | 安装扩展 |
| `go run tools.go addon uninstall tenant` | 卸载扩展 |

### 联系我们

- 演示站：[www.xygoadmin.com](https://www.xygoadmin.com)
- GitHub：[github.com/z312193608/xygo-admin](https://github.com/z312193608/xygo-admin)
- Gitee：[gitee.com/a751300685a/xygo-admin](https://gitee.com/a751300685a/xygo-admin)
- QQ：751300685
- QQ群：[963636900](https://qm.qq.com/q/dwSdPBjkhU)

### 浏览器兼容性

支持 Chrome、Safari、Firefox、Edge 等现代主流浏览器。

### 特别鸣谢

感谢以下开源项目提供的基础支持：

- [GoFrame](https://goframe.org/) - Go 语言 Web 框架
- [Art Design Pro](https://github.com/Daymychen/art-design-pro) - Vue3 后台模板
- [Vue](https://vuejs.org/) / [Element Plus](https://element-plus.org/) / [Vite](https://vitejs.dev/) / [Pinia](https://pinia.vuejs.org/)
- [Tailwind CSS](https://tailwindcss.com/) / [TypeScript](https://www.typescriptlang.org/)

### 开源协议

[MIT](./LICENSE) - 无需授权，免费商用。

### 支持项目

如果觉得项目不错，请到 [GitHub](https://github.com/z312193608/xygo-admin) 或 [Gitee](https://gitee.com/a751300685a/xygo-admin) 点个 Star，这是对我们最大的鼓励。

### 赞助支持

如果 XYGo Admin 对你有帮助，欢迎请作者喝杯咖啡 ☕，你的支持是项目持续迭代的最大动力！

<table>
  <tr>
    <td align="center"><b>支付宝</b></td>
  </tr>
  <tr>
    <td align="center"><img src="https://xygoupload.xingyunwangluo.com/gitee/alipay.jpg" width="200" /></td>
  </tr>
</table>
