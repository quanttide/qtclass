# qtclass 状态报告

> 更新日期：2026-08-26
> 仓库：quanttide/qtclass
> 最新 commit：0a60ac8 (2026-08-25)

## LMS 迁移状态

> 依据量潮课程云域的迁移计划（[qtcloud-learn/ROADMAP.md](../qtcloud-learn/ROADMAP.md)），
> 自 2026-08 起本仓库的 LMS 能力（课表 / 考勤 / 学习记录 / session 模型）已**全部移除并迁移至
> `qtcloud-learn`**（量潮学习云，迁移完成见其 ROADMAP v0.5）。
> 播放器（player / lecture）职责不受影响，继续在本仓库演进。

## 版本历史

| 组件 | 版本 | 日期 | 内容 |
|------|------|------|------|
| Studio | v0.1.9 | 2026-08-23 | 登录/进度/立项 API 默认地址回退生产网关 |
| Studio | v0.1.8 | 2026-08-23 | 学员端登录（qtcloud-auth）+ Bearer；播放器视频源支持网络 URL；部署域名 `learn.cloud.quanttide.com` |
| Studio | v0.1.7 | 2026-08-18 | `PathStep.fromJson` 容错（title/label 兼容） |
| Studio | v0.1.6 | 2026-08-17 | 学员端播放器接入生产实习内容；课程数据从 courses endpoint 加载 |
| Studio | v0.1.5 | 2026-08-16 | 学员端 MVP 闭环（立项表单 + 进度上报）；构建注入 `QTCLASS_LEARN_API_URL` |
| Studio | v0.1.4 | 2026-08-14 | 课程列表页 / 详情页 + 进度持久化 |
| Studio | v0.1.3 | 2026-08-14 | API 分支 catch 全捕获 + 请求超时 30s |
| Studio | v0.1.2 | 2026-08-13 | `load()` 全面异常捕获 + 网关超时 60s |
| Studio | v0.1.1 | 2026-08-12 | 移除本地课程资源（数据来自课程云 API） |
| Studio | v0.1.0 | 2026-08-12 | 课程数据改为 API 拉取（`QTCLASS_COURSE_API_URL`） |
| Site | v0.1.2-alpha.1 | 2026-08-25 | React 19 + TypeScript + Vite 重构，生产实习课程教案 |
| Site | v0.1.1 | 2026-08-23 | 学员端跳转地址改为 `studio.class.quanttide.com` |
| Site | v0.1.0 | 2026-08-23 | 初始版本（Vue 3 + Vite 课程展示站） |
| Studio | v0.1.0-beta.5 | 2026-08-08 | Web 品牌化（量潮课堂 / 量潮课堂工作台） |
| Studio | v0.1.0-beta.4 | 2026-08-08 | widgets 按粒度分组重构，测试镜像 lib 结构（36 项全过） |
| Studio | v0.1.0-beta.3 | 2026-08-07 | 手机端布局修复（Drawer 侧边栏、多尺寸矩阵测试） |
| Studio | v0.1.0-beta.2 | 2026-08-07 | 部署视频失效修复（LFS checkout）+ 入口文件 no-cache |
| Studio | v0.1.0-beta.1 | 2026-08-07 | 课时视频播放 + 课程内容数据驱动（Vibe Coding 课时1） |
| Studio | v0.1.0-alpha.4 | 2026-08-07 | Web 版上线 `class.quanttide.com`（CDN + OSS） |
| Studio | v0.1.0-alpha.3 | 2026-08-07 | 移除 LMS 能力（迁移 qtcloud-learn）；新增 deploy-studio CI + IaC |
| Studio | v0.1.0-alpha.2 | 2026-08-01 | 移除 LMS 能力（未单独发布，并入 alpha.3） |
| Studio | v0.1.0-alpha.1 | 2026-07-31 | 互动式课程播放器核心 |
| Studio | v0.0.2 | 2026-05-16 | 课时详情页和数据模型 |
| Studio | v0.0.1 | 2026-05-08 | 初始化项目结构，qtclass-studio 课堂管理原型 |

> 完整变更见 `src/studio/CHANGELOG.md`、`src/site/CHANGELOG.md`。

## 组件进度

| 组件 | 状态 | 说明 |
|------|------|------|
| Studio (`src/studio`) | v0.1.9 | Flutter 课堂管理 + 互动播放器；数据来自课程云 API（`QTCLASS_COURSE_API_URL`）；学员端登录接入 qtcloud-auth；部署 `learn.cloud.quanttide.com` |
| Site (`src/site`) | v0.1.2-alpha.1 | React 19 + TypeScript + Vite 课程展示站（生产实习教案）；部署 `class.quanttide.com` |
| CLI | 无 | — |
| Provider | 无 | — |

## 与 qtdata 对比

qtdata 具备 CLI + Provider + Studio 三件套，qtclass 目前仅 Studio 前端：

- **缺 CLI**：无命令行工具，无法通过 Markdown → 结构化输出驱动业务流程
- **缺 Provider**：无后端服务，Studio 数据来自课程云 API（跨仓库），学员端登录/进度经 qtcloud-auth / 学习云网关
- **缺 E2E 测试**：qtdata 有 xdotool + httpx 测试框架，qtclass 以 flutter test 为主（64 项全绿）

## 文档结构

| 目录 | 状态 | 说明 |
|------|------|------|
| docs/dev-guide/ | 有 | 开发者指南（产品定位、BRD、架构设计、原型） |
| docs/screenshots/ | 有 | 页面截图（课程列表/详情） |
| docs/prd/ | 无 | 产品需求文档缺失 |
| docs/user/ | 无 | 用户文档缺失 |

## 关键差距

1. **后端缺失**：无 Provider，课程数据依赖课程云 API 与本地 fallback
2. **无 CLI**：缺少从文档到结构化数据的自动化工具链
3. **文档不完整**：prd/user 文档缺失
