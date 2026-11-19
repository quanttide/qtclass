# CHANGELOG

## [0.2.1] - 2026-11-19

### Changed

- 课程改名：氛围编程 → AI编程（课程名、5 个课时的 `course` 与 `kicker`、课堂页与契约注释、测试断言同步）
- 未上架课程暂下线：`courses` 加 `online` 字段，课堂页只渲染 `online: true`——知识工作、大数据导论、数据工程、生产实习数据保留但不展示，上架时翻回 `true` 即可；原以「大数据导论」为锚点的路由断言改指已上架课程

## [0.2.0] - 2026-11-19

### Added

- 课时上架：课堂页氛围编程卡挂课时入口，压入页 `/lessons/:name` 分步渲染（页眉 + 一步一动作 + 预期结果 + 课末提示），隐藏页签
- 课时契约 `models/lesson.ts`：`name`（兼 slug）/ `course` / `title` / `description` / `status` / `steps`，块类型收口为 note / copy / code / link / image；内容库 `data/lessons/` 一文件一课时，`publishedLessonsOf(course)` 出入口，draft 不对外
- 四课齐备：首课 `hello-world`（做出你的第一个游戏）与第 2-4 课 `lesson-2-coffee-shop`（换个壳，又是新游戏）/ `lesson-3-worker`（这回，你说了不算）/ `lesson-4-publish`（拿出去，给人玩），文字与步骤均源自教程仓 `assets/tutorials/vibe-coding/docs/intro/` 对应讲义，内容不改写只换载体；`lesson-N-` 前缀保证课序与字典序一致；对照图字节一致拷入 `public/lessons/hello-world/`
- 课时页上一课 / 下一课入口：按 `publishedLessonsOf(course)` 取前后课，首课无上一课、末课无下一课
- 测试：课时详情 5 例（入口、分步正文与复制指令、未知课时回理论、仅氛围编程卡出入口、首末课导航边界），路由与筛选断言随路径调整

### Changed

- 课堂页改为入口 `/`，实践页移到 `/practice`；未知路径重定向指向入口
- 氛围编程课程介绍改为四课主线（适用人群 / 简介 / 模块标签），文案源自教程仓 intro 讲义
- 底部导航页签「理论」改名「课堂」；课时未找到的返回文案、README 与页签断言同步改名

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
