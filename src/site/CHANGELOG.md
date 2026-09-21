# CHANGELOG

## [Unreleased]

### Fixed

- 元数据不再渲染进正文：渲染前剥离首部 YAML frontmatter，首页与学习详情页此前会显示 `title:`、`description:` 两行及多余分隔线

## [0.1.2-rc.1] - 2026-09-21

### Added

- 首页：量潮课堂介绍，内容源自 `quanttide-tech` 数据仓 `data/brochure/qtclass/`（新增 `data/home/index.md` 与 `src/models/home.ts`）
- 课程页：课程体系从首页独立为 `src/pages/Course.tsx` 与 `/courses` 路由，导航「课程」指向该页
- 测试：引入 Vitest（jsdom + Testing Library），覆盖路由渲染、markdown 渲染与 frontmatter 解析，25 例

### Changed

- 内容数据移出 `src/`：学习资料 markdown 归入包级 `data/`，`src/models/` 只放数据结构与装载
- 学习板块（训练营 / 任务 / 价格）的标题、英文副题与说明合并为单一常量，页面不再各自硬编码
- 站点外框（导航 + 页头）抽为 `src/components/Layout.tsx`；路由路径与链接地址集中到 `src/routes.ts`
- 学习资料索引改为解析路径得到板块与 slug，去掉按路径子串匹配
- frontmatter 解析改用 `js-yaml`，替换手写键值解析（值含「: 」时须加引号）
- markdown 渲染输出经 `DOMPurify` 清洗后再注入
- markdown 表格渲染补 `<table>`、`<thead>`、`<tbody>` 包裹并补 `<th>` 样式——此前只输出裸 `<tr>`，表格样式一直未生效
- 首页课程卡片取消跳转，五门课统一为纯展示卡片
- 站点图标改为 `public/favicon.svg`

### Fixed

- 学习页非法板块参数不再回退到「训练营」，改为渲染「内容未找到」

### Removed

- 移除生产实习课时教案链路：`data/lessons/`、课程结构契约、课程页与课时详情页、课时路由、专属样式与测试——教案数据已过时，不再维护
- 移除 `public/images/course-hero.png`（此前被当作 favicon，体积 2 MB）

## [0.1.2-beta.8] - 2026-09-18

### Added

- 学习任务书新增《摸底 lark-cli 与 wecom-cli》——从学习管理档案同步

## [0.1.2-beta.7] - 2026-09-11

### Added

- 学习任务书新增《试用量潮工作云命令行工具》——从学习管理档案同步


## [0.1.2-beta.6] - 2026-09-02

### Removed

- 移除「超额申请额度」条目——课题申请费用暂不属实训价格

## [0.1.2-beta.5] - 2026-09-02

### Added

- 学习页新增「价格」（Prices）板块：任务参与免费、一对一咨询职级定价（真实价格）

### Removed

- 移除「成长通道」（Careers）板块——数据质量不足，待充实后重新发布

## [0.1.2-beta.4] - 2026-09-02

### Added

- 学习页新增「成长通道」（Careers）板块：成长进度条（负数职级）、成长速度参考、考核环节与限额、甲方思维
- 学习页新增「价格」（Prices）板块：一对一咨询职级定价、超额申请额度与代金券挣取渠道

## [0.1.2-beta.3] - 2026-08-31

### Changed

- 学习页与课程页卡片改为整卡可点击，移除「查看」按钮；课程页统一为宽矮三列卡片格式

## [0.1.2-beta.2] - 2026-08-31

### Changed

- 学习页卡片格式调整：三列更宽、内边距收紧更矮

## [0.1.2-beta.1] - 2026-08-31

### Changed

- 学习页卡片补充描述：优先读取 frontmatter（title / description），无元数据时回退从 markdown 正文提取
- 训练营与任务 markdown 增加 YAML 元数据（title / description）

## [0.1.2-alpha.4] - 2026-08-31

### Changed

- 训练营详情页的任务引用（来源：tasks/*.md）变为可点击链接，跳转到对应任务详情
- 学习页训练营数据同步：数据工程师训练营合并入智能体工程师训练营（两营：智能体工程师 / 产品经理）

## [0.1.2-alpha.3] - 2026-08-31

### Changed

- 学习页训练营（schedules）数据同步：三营 Task 编排与归属调整（源自 data/profile）

## [0.1.2-alpha.2] - 2026-08-31

### Added

- 「学习」一级导航与 `/learn` 页面：列出学习档案的训练营（schedules）与任务（tasks），支持 markdown 详情查看
- markdown 渲染逻辑提取为共享模块（`src/utils/markdown.ts`）

### Changed

- 导航精简为「课程」「学习」两个页面，取消「生产实习」一级导航（课程内容仍可从课程体系进入）

## [0.1.2-alpha.1] - 2026-08-25

### Changed

- 重构为 React 19 + TypeScript + Vite 架构
- 参考 qtcrowd 和 qtrecurit 项目结构
- 添加生产实习课程教案功能（8篇文档）
- 按业务划分章节（量潮数据、量潮课堂、量潮云、量潮招聘）
- 改进 markdown 渲染逻辑，支持表格、引用块、代码块等
- 优化文章排版样式
- 删除学习资料区

### Added

- 课程详情页面路由 `/courses/<slug>/lessons/<lesson>`
- 章节导航和上下课切换
- ESLint 代码检查配置
- TypeScript 类型定义

### Removed

- 移除 Vue 3 相关依赖和文件
- 移除学习资料区模块

## [0.1.1] - 2026-08-23

### Fixed

- 学员端跳转地址改为 `studio.class.quanttide.com`（原误指 `learn.cloud`）

### Changed

- 部署工作流域名对齐（deploy-site / deploy-studio）

## [0.1.0] - 2026-08-23

### Added

- 初始版本，基于 Vue 3 + Vite
- 课程体系展示
- 响应式设计
