<p align="center">
  <img src="https://xygoupload.xingyunwangluo.com/gitee/%E5%8D%95%E7%8B%AClogo.png" width="200" />
</p>
<br />
<h1 align="center">XYGo Admin</h1>
<p align="center">An open-source full-stack admin framework built with Vue3 + GoFrame. Includes RBAC permissions, code generation, system monitoring and more — ready to use out of the box.</p>
<div align="center">English | <a href="./README.zh-CN.md">简体中文</a></div>

<br />
<p align="center">
  <a href="https://www.xygoadmin.com">Website</a> |
  <a href="https://www.xygoadmin.com">Demo</a> |
  <a href="https://qm.qq.com/q/dwSdPBjkhU">Join QQ Group</a> |
  <a href="https://gitee.com/a751300685a/xygo-admin">Gitee</a> |
  <a href="https://github.com/z312193608/xygo-admin">GitHub</a>
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

### Overview

XYGo Admin is a full-stack open-source admin framework. The frontend is based on [Art Design Pro](https://github.com/Daymychen/art-design-pro) (Vue3 + TypeScript + Element Plus), and the backend is powered by [GoFrame v2](https://goframe.org/). Free for commercial use without any authorization required.

### Key Features

**RBAC Permission System**: Roles, menus, buttons, data scope, and field-level permissions with visual management

**Visual Code Generator**: Design table structures visually, generate full CRUD code (Go API + Controller + Logic + Vue pages) with one click, saving 80% of development time

**Dual Database Support**: Compatible with both MySQL and PostgreSQL from a single codebase — switch databases by changing one config line

**Frontend-Backend Separation**: Vue3 SPA + GoFrame RESTful API, deployable independently or as a single binary

**Member Portal**: Built-in frontend portal with member center, registration, login, check-in, and profile management

**Document Center**: Built-in Markdown documentation with category tree, full-text search, and online preview

**System Monitoring**: Server status, slow query alerts, slow API alerts, operation logs, and login logs

**Message Queue**: Redis-based async task queue with scheduled task management and message push

**Modern UI**: Based on Art Design Pro with 6 layout modes, light/dark themes, and smooth animations

**Single Binary Deploy**: Bundle frontend into Go binary — deploy with just one file + one config, no Nginx needed

### Open vs Pro

Shared admin features (RBAC, code generator, member portal, docs, monitoring, Redis queue) exist in both editions. The table below lists **functional differences only**, verified against the two codebases.

| Feature | Open | Pro |
|---------|------|-----|
| Dameng DM8 | — | Yes (same codebase as MySQL / PostgreSQL) |
| Million-row async export | Browser-side small-table export only | Auto-async over 10k rows; batched Excel / ZIP with progress |
| Attachment document viewer | Image preview only | In-browser PDF / Word / Excel / text / audio / video |
| Frontend bundle / on-demand loading | Full icon sets on first paint; all locale JSON loaded up front | Build registers only used Iconify icons; icon sets and page locales lazy-load |
| Multi-tenant SaaS | — | Tenant-isolated data and plan-based menus |
| Platform + tenant consoles | — | Dual console; platform can impersonate a tenant |
| RabbitMQ | — | Optional (off by default) |
| Login captcha | Click-to-select | Basic, click, slide puzzle, drag, and rotate; switchable in security settings |
| Password strength | — | Low / medium / high; enforced for admin users, member registration, and password changes |
| Header shortcuts | Hardcoded | Pick from menus; icon and description are editable |

Pro demo: [tenant.xygoadmin.com](https://tenant.xygoadmin.com) · Details: [www.xygoadmin.com/pro](https://www.xygoadmin.com/pro)

### Changelog

Open tracks **1.x**, Pro tracks **2.x** — separate release lines. The same day can ship different notes. This table grows from the three versions already listed: when either side ships, add one entry on that side and leave the other side blank. Older rows stay, so the release cadence stays visible.

| Open | Pro |
|------|-----|
| — | **v2.1.0** · 2026-09-22 · Captcha, password strength, cloud sync, shortcuts<br>• Login captcha: basic, click, slide puzzle, drag, and rotate<br>• Password strength enforced for admin users, members, registration, and profile<br>• Local attachments can sync to cloud storage<br>• Header shortcuts are chosen from menus |
| **v1.5.1** · 2026-09-18 · Captcha required + docs page fixes<br>• Admin/member login captcha is mandatory (empty fields cannot skip)<br>• Doc dates render from second-level timestamps<br>• Root-category docs are clickable<br>• Doc/category status filter defaults to all | **v2.0.10** · 2026-09-18 · Dameng + captcha fix<br>• Dameng DM8 support<br>• Login click-captcha can no longer be skipped<br>• Docs timestamp and root-category click fixes<br>• No database migration in this release |
| **v1.5.0** · 2026-09-10 · Login-log status + upload log fix<br>• Successful member logins no longer show as failed<br>• Operation logs no longer persist uploaded file bodies | **v2.0.9** · 2026-09-14 · Export-task MySQL types<br>• Export progress/file-count types aligned so MySQL gen-dao builds |
| **v1.4.9** · 2026-08-16 · Object storage + CDN preview<br>• Qiniu / Aliyun OSS / Tencent COS<br>• Legacy attachment sync and unified CDN preview | **v2.0.8** · 2026-09-12 · Frontend bundle + tree-table relations<br>• On-demand icons and Markdown editor (smaller prod bundle)<br>• Tree-table remote selects generated from this table's FK |

Full history: [website changelog](https://www.xygoadmin.com/changelog).

### Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | Vue 3, TypeScript, Vite |
| UI Library | Element Plus, Tailwind CSS |
| State Management | Pinia |
| Backend | GoFrame v2 (Go 1.22+) |
| Database | MySQL 8.0+ / PostgreSQL 14+ |
| Cache/Queue | Redis |
| Auth | JWT (single sign-on support) |

### Preview

> Live Demo: [www.xygoadmin.com](https://www.xygoadmin.com)

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

### Quick Access

[Live Demo](https://www.xygoadmin.com) | [Gitee](https://gitee.com/a751300685a/xygo-admin) | [GitHub](https://github.com/z312193608/xygo-admin) | [📖 Documentation](https://www.xygoadmin.com/docs)

### Installation

For detailed installation instructions, please refer to the **[📖 Official Documentation](https://www.xygoadmin.com/docs)**.

**Local development (recommended)**

```bash
# 1. Import mysql_install.sql or pgsql_install.sql; configure server/manifest/config/config.yaml

# 2. Backend API (default :4096; starts in develop mode even without a frontend build)
cd server
go run main.go

# 3. Frontend dev server (separate terminal, default :3006, proxies API)
cd web
pnpm install
pnpm dev
```

Open the Vite dev URL (e.g. `http://localhost:3006`). Do not expect a full UI on `:4096` until you run `pnpm build`.

**Single-port deployment**

```bash
cd web && pnpm install && pnpm build   # output → server/resource/public/dist
cd ../server && go run main.go         # visit http://localhost:4096
```

> Built frontend assets are not committed; only `.gitkeep` is tracked under `dist/`. In `system.mode: product`, the server refuses to start without `index.html`.

**Default Account**

| Role | Username | Password |
|------|----------|----------|
| Super Admin | admin | 123456 |

### Project Structure

```
xygoadmin/
├── server/                    # Backend GoFrame project
│   ├── addons/                # Addon packages (*.zip)
│   ├── api/                   # API definitions
│   ├── internal/
│   │   ├── cmd/               # Main command entry
│   │   ├── cmdtools/          # Tool command logic (migrate, addon, updater)
│   │   ├── controller/        # Controllers (request handling)
│   │   ├── logic/             # Business logic (core code here)
│   │   ├── model/             # Data models (entity/do/input)
│   │   ├── dao/               # Data access (auto-generated by gf gen dao)
│   │   └── service/           # Service interfaces (auto-generated by gf gen service)
│   ├── cmd_tools/migrate/     # Migration SQL files
│   ├── manifest/config/       # Runtime config
│   ├── hack/config.yaml       # CLI tool config (build/gen)
│   ├── resource/              # Static assets, code gen templates
│   ├── main.go                # Server entry (gf run main.go)
│   └── tools.go               # Tools entry (go run tools.go)
├── web/                       # Frontend Vue3 project
│   ├── src/
│   │   ├── api/               # API request wrappers
│   │   ├── views/             # Page components (backend/frontend)
│   │   ├── router/            # Routes (static + dynamic loading)
│   │   ├── store/             # Pinia state management
│   │   └── components/        # Shared components
│   └── ...
├── mysql_install.sql           # MySQL init script
├── pgsql_install.sql           # PostgreSQL init script
└── version.json                # Version info (for online updates)
```

### Tools

All tools are accessed via `go run tools.go` in the `server/` directory:

| Command | Description |
|---------|-------------|
| `go run tools.go` | Interactive menu |
| `go run tools.go migrate up` | Run database migrations |
| `go run tools.go migrate status` | View migration status |
| `go run tools.go migrate history` | View migration history |
| `go run tools.go check-tpl` | Check template syntax |
| `go run tools.go update` | Online update |
| `go run tools.go addon install tenant` | Install addon |
| `go run tools.go addon uninstall tenant` | Uninstall addon |

### Contact

- Demo: [www.xygoadmin.com](https://www.xygoadmin.com)
- GitHub: [github.com/z312193608/xygo-admin](https://github.com/z312193608/xygo-admin)
- Gitee: [gitee.com/a751300685a/xygo-admin](https://gitee.com/a751300685a/xygo-admin)
- QQ: 751300685
- QQ Group: [963636900](https://qm.qq.com/q/dwSdPBjkhU)

### Browser Compatibility

Supports Chrome, Safari, Firefox, Edge, and other modern browsers.

### Acknowledgements

Thanks to these open-source projects:

- [GoFrame](https://goframe.org/) - Go web framework
- [Art Design Pro](https://github.com/Daymychen/art-design-pro) - Vue3 admin template
- [Vue](https://vuejs.org/) / [Element Plus](https://element-plus.org/) / [Vite](https://vitejs.dev/) / [Pinia](https://pinia.vuejs.org/)
- [Tailwind CSS](https://tailwindcss.com/) / [TypeScript](https://www.typescriptlang.org/)

### License

[MIT](./LICENSE) - Free for commercial use, no authorization required.

### Support

If you find this project helpful, please give us a Star on [GitHub](https://github.com/z312193608/xygo-admin) or [Gitee](https://gitee.com/a751300685a/xygo-admin). It means a lot to us.

### Sponsor

If XYGo Admin has been helpful to you, feel free to buy the author a coffee ☕. Your support keeps the project going!

<table>
  <tr>
    <td align="center"><b>Alipay</b></td>
  </tr>
  <tr>
    <td align="center"><img src="https://xygoupload.xingyunwangluo.com/gitee/alipay.jpg" width="200" /></td>
  </tr>
</table>
