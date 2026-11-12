# CHANGELOG

## [0.1.6] - 2026-11-12

### Added

- 按确认文本上架贸大招聘宣传合作实践任务，不含人名与报酬，通过 Issue 沟通领取和交付。正文与 profile 事实源一致。

## [0.1.4] - 2026-11-08

### Added

- 任务书 12 → 19 篇：qtcrowd 六篇业务线任务书迁入（`second-brain-init`、`legal-evidence`、`org-management-workflow`、`project-retrospective-system`、`critical-pr-workflow`、`strategic-management-workflow`，源 quanttide-crowd `data/profile`），补 academy 意图 `quanttide-founder-study`（源 `data/intention/quanttide-founder/study.md`）
- 正文与档案（事实源 `data/profile`）字节一致，frontmatter 补 title / description / 两把尺 tags，19/19 全量标注

## [0.1.3] - 2026-11-07

### Changed

- 筛选形态：底部弹层改为**两排常驻分段控件**（需求：全部 / 模糊 / 半精确 / 精确；验收：全部 / 封闭 / 半开放 / 开放）——选项不藏、选中态直接回显；`FilterSheet` 组件与弹层样式移除

## [0.1.2] - 2026-11-07

### Added

- 页签外壳（微信式）：顶部 AppBar「量潮课堂」+ 底部三页签（理论 / 实践 / 我的）；任务详情与反馈为压入页，隐藏页签、顶栏返回
- 两把尺筛选：实践页单入口 + 底部弹层（需求的精确程度：模糊 / 半精确 / 精确；验收标准的开放程度：封闭 / 半开放 / 开放，各带全部）；任务书 frontmatter `tags.requirement / acceptance` 全量标注 12/12，卡片回显、空结果诚实提示
- 理论页：课程清单自 site 课程页迁入（内容不改写）；我的页为个人页骨架（登录与学习记录接通后开放），反馈入口移此

## [0.1.1] - 2026-11-02

### Changed

- 当前任务换为小说发行与游戏两个工作室任务（原「任务书修订」下线）；任务书入仓源 academy intention `qtgame-tycoon` / `quanttide-fiction-of-founder` 两篇，与公众号发布稿同源（字节一致）
- 任务书标题解析补正文一级标题回退（无 frontmatter 的任务书不再显示 slug）；反馈页逐任务展示

## [0.1.0] - 2026-11-02

### Added

- v0.1 首切片（Web 形态，与 site 同构的 React + Vite 脚手架）：三页——今日任务卡首屏、任务详情（题面说明 + 题面素材渲染，只读）、反馈查看（状态与评语空态）
- 任务契约静态层：`Task` 形状 + 五状态机（待做 / 进行 / 已交 / 退回 / 通过），首任务 = 任务书修订（入场即教研）
- 内容首迁：site 任务书 10 篇迁入 `data/tasks/`，字节一致
- 部署工作流 `deploy-lite.yml`：`lite/*` tag 构建后上传 OSS 桶 `qtclass-lite` 并刷新 CDN `lite.class.quanttide.com`
