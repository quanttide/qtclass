# qtclass 状态报告

> 更新日期：2026-08-26
> 仓库：quanttide/qtclass
> 最新 commit：e09e744 (2026-08-26)
> 版本记录：`src/studio/CHANGELOG.md`、`src/site/CHANGELOG.md`

## Scope 状态

| Scope | 最新版本 | 状态 |
|------|---------|------|
| Studio (`src/studio`) | v0.1.9 | 已发布（正式版） |
| Site (`src/site`) | v0.1.2-alpha.1 | 已发布（预发布版） |
| CLI | — | 无 |
| Provider (`src/provider`) | — | 规划中（学员端集成层，路线见 `src/provider/ROADMAP.md`） |

### Studio

Flutter 课堂管理 + 互动播放器。课程数据 API 拉取（`QTCLASS_COURSE_API_URL`），学员端接入 qtcloud-auth 登录（Bearer token），进度/立项经学习云网关（`QTCLASS_LEARN_API_URL`）；部署 `studio.class.quanttide.com`。

### Site

课程展示站。v0.1.0 为 Vue 3 + Vite 初始版本，v0.1.2-alpha.1 重构为 React 19 + TypeScript + Vite（生产实习教案）；部署 `class.quanttide.com`。

### Provider

学员端集成层。对接 qtcloud-course（课程云）与 qtcloud-learn（学习云），为 Studio / Site 提供统一数据通道；不设独立存储，验收标准同源直连（设计见 `docs/dev-guide/provider.md`）。尚未立项，路线图见 `src/provider/ROADMAP.md`。
