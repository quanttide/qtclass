# CHANGELOG

## [0.2.8] - 2026-11-21

### Changed

- 领域课程（知识工作、大数据导论、数据工程、生产实习）迁出到 qtcloud-course 的课程清单（`src/lite`），学员端只留通识课
- 课堂页按分级展示：「通识课程 · 大一」分组，卡片标「已上线」状态
- AI创意卡片文案随新课同步（提示词不用记）
- 测试：分级标题与状态断言、领域课程不再出现的断言，32 例全绿

## [0.2.7] - 2026-11-21

### Changed

- AI创意第 1 课的提示词按「不记清单、自然提问」重写：第 1 步改成「你当老师带我读懂…」一句式，第 2 步改成「你替我写一段能直接生图的提示词」，第 4 步改成「这张图你是怎么写出来的？用大白话教教我」——去掉要素清单（主体/场景/光线…）与编号式指令，tip、foot 同步改为「不用记，开口问就行」
- 课程改名：AI工作 → AI办公（课程名、课时 `course` 与 `kicker`、注释与测试断言同步）
- 上架顺序调整：AI创意 → AI办公 → AI编程 → AI教学

## [0.2.6] - 2026-11-21

### Changed

- AI创意第 3 步的复制内容改为一句指向第 2 步产出的生成指令（「用刚才那段提示词，直接生成一张图片。」），不再把提示词重抄一遍另起炉灶
- 测试：第 3 步生成指令与复制按钮断言随文案调整

## [0.2.5] - 2026-11-21

### Changed

- AI创意第 3 步改为一句可独立复制的生图提示词：一键复制后直接粘给元宝出图，不再依赖上一步的对话上下文
- 测试：AI创意课时第 3 步的提示词与复制按钮断言

## [0.2.4] - 2026-11-21

### Changed

- AI创意第 3 步改口径：生图不再换工具（原写即梦 / 通义万相 / Midjourney 贴提示词），改为直接让元宝在同一个对话里接着生成图片

## [0.2.3] - 2026-11-21

### Added

- 三门新课补上首课并上架：AI创意《用 AI 生成你的第一张图》、AI工作《总裁查岗：一句话摸清家底》、AI教学《把你熟的一件事，做成一门课》——课时载荷 `data/lessons/{creative,work,teaching}-hello-world.ts`，文字与步骤源自 `data/profile` 对应 hello-world 课件，不改写只换载体；四张上架卡各挂一个课时入口
- 测试：四张上架卡的课时入口断言、AI工作课时详情（页眉 + 一键复制指令）渲染断言

### Changed

- 课程改名：氛围创作 → AI创意、氛围工作 → AI工作、氛围教学 → AI教学（课堂页课程名、课时 `course` 与 `kicker`、注释与测试断言同步）——上架课程统一名为 AI 开头

## [0.2.2] - 2026-11-21

### Added

- 课堂页新增三门上架课程：氛围创作（四步把一段小说变成一张图）、氛围工作（一句话让 AI 采集公开网站、交可核对的现状报告）、氛围教学（把一件你熟的事拆成关卡做成课）；上架顺序为氛围创作 → AI编程 → 氛围工作 → 氛围教学，卡片文案与模块标签取自 `data/profile` 各课程的 hello-world 课件
- 测试：锁上架课程顺序的断言；「只有 AI编程卡出课时入口」的断言随上架张数改为其余三张不出

### Changed

- Theory → Classroom：页面文件 `Theory.tsx` 改名 `Classroom.tsx`，组件、路由键 `ROUTE_PATHS.theory`、页签图标键同步改为 `classroom`；「理论页」注释、测试标题与 README 统一改为「课堂页」（页签 0.2.0 已改名课堂，代码命名此前未跟上）

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
