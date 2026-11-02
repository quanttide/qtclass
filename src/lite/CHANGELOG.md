# CHANGELOG

## [Unreleased]

### Changed

- 当前任务换为小说发行与游戏两个工作室任务（原「任务书修订」下线）；任务书入仓源 academy intention `qtgame-tycoon` / `quanttide-fiction-of-founder` 两篇，与公众号发布稿同源（字节一致）
- 任务书标题解析补正文一级标题回退（无 frontmatter 的任务书不再显示 slug）；反馈页逐任务展示

## [0.1.0] - 2026-11-02

### Added

- v0.1 首切片（Web 形态，与 site 同构的 React + Vite 脚手架）：三页——今日任务卡首屏、任务详情（题面说明 + 题面素材渲染，只读）、反馈查看（状态与评语空态）
- 任务契约静态层：`Task` 形状 + 五状态机（待做 / 进行 / 已交 / 退回 / 通过），首任务 = 任务书修订（入场即教研）
- 内容首迁：site 任务书 10 篇迁入 `data/tasks/`，字节一致
- 部署工作流 `deploy-lite.yml`：`lite/*` tag 构建后上传 OSS 桶 `qtclass-lite` 并刷新 CDN `lite.class.quanttide.com`
