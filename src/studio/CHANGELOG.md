# Changelog

## [0.1.0-beta.3] - 2026-08-07

### Fixed
- **手机端 / 小窗口布局严重错乱**：窄屏时侧边栏固定占底部 320px，挤压播放器导致标题+控制栏溢出（`RenderFlex overflowed`），横屏手机与小窗口尤甚——
  - 窄屏侧边栏改收进 **Drawer**（顶栏左侧新增菜单入口），播放器占满全屏高度
  - 播放舞台宽/窄布局判断增加高度条件（舞台过矮时回退可滚动窄布局），修复手机横屏溢出
  - 完成覆盖层改为可滚动，小屏不再溢出
- 新增**多尺寸矩阵测试**（`test/widgets/layout_matrix_test.dart`）：7 种尺寸 × 播放页各状态（intro/视频/分支/互动/完成/抽屉）+ 首页，覆盖手机竖屏/横屏、小窗口、平板、桌面

### Changed
- 手机端交互：侧边栏入口从底部常驻改为顶栏抽屉（汉堡菜单）

## [0.1.0-beta.2] - 2026-08-07

### Fixed
- **部署视频失效**：CI checkout 未拉取 LFS 内容，视频以 LFS 指针上传导致无法播放——`actions/checkout` 增加 `lfs: true`
- **发版后仍显示旧版本**：固定名入口文件（`main.dart.js` / `flutter_service_worker.js` / `flutter_bootstrap.js` 等）被一年长缓存，Service Worker 不更新——入口文件改为 `no-cache`，仅哈希资源长缓存

### Changed
- 移除 `deploy-studio` 的手动触发（`workflow_dispatch`）：部署问题一律通过发新版本解决

## [0.1.0-beta.1] - 2026-08-07

### Added
- 播放器支持**课时视频播放**（`video_player`，Web/移动端）：视频片段全区域播放、视频实际时长驱动进度、播放结束自动进入下一流程
- 视频 faststart 优化（moov 移至文件头），浏览器流式播放
- 课程首页数据驱动：标题 / 描述 / 学习目标 / 预计时长 / 节点数均来自课程数据
- 开发脚本：`scripts/serve-web.py`（支持 Range 的本地预览服务器）、`scripts/inspect-web.mjs`（CDP 浏览器调试）

### Changed
- 课程内容替换为 **Vibe Coding 课时1（开发环境搭建）**：8 个片段（含 3 个 E1 错误分支）+ 3 个互动节点 + 5 步学习路径
- 播放器流程**完全数据驱动**：片段结束动作（`next` / `interaction` / `finish`）与互动跳转（`option.next`）由 `assets/course.json` 定义
- 侧边栏路径 / 互动节点 / 课程脉络全部数据化（`CourseData.pathSteps` 等）
- 移除播放器与首页中全部 Python 课程硬编码文案

### Fixed
- 手机端布局：顶栏横向溢出、场景区垂直溢出、控制栏与互动弹层溢出（iPhone 尺寸测试覆盖）
- 视频加载失败：修复 Range 服务器支持（206 分片响应）与 moov 位置

## [0.1.0-alpha.4] - 2026-08-07

### Added
- Web 版部署上线：`class.quanttide.com`（CDN + OSS 静态网站托管 + HTTPS 强制跳转）
- 部署 CI 对齐手动流程：index.html no-cache、404 页、CDN 刷新（`deploy-studio.yml`）
- IaC 固化"阻止公共访问"关闭（`block_public_access = false`）

### Changed
- `deploy-studio` workflow 改为仅部署 Web（桌面 Linux 安装包暂缓上线，已从 OSS 移除）

### Fixed
- 修复 Web 版资源缺失（`assets/AssetManifest.bin` 等）导致的白屏

## [0.1.0-alpha.3] - 2026-08-07

> 自 alpha.1 以来的累计变更（alpha.2 未发布，合并计入本版本）。

### Removed
- 移除全部 LMS 能力（迁移至 `qtcloud-learn`，见其 ROADMAP v0.5）：
  - 课表 / 考勤：session 模型、schedule / classroom 页面、sessions.json、AppState 的 sessions 加载
  - 学习记录：learning_record 模型、history_service（localStorage）及播放器内历史记录弹层
  - lecture 页（依赖 session 数据）与对应测试
- 移除 integration_test（原测试课表 / 考勤流程）
- 删除遗留 result 页面文档（`doc/screens/result.html` / `result.md`）
- 删除未使用的 `assets/lectures.json`

### Changed
- 播放器不再本地保存学习记录（改为 `qtcloud-learn` 服务端进度数据）

### Added
- CI：`deploy-studio` workflow（推送 `studio/*` tag 触发，构建 Linux bundle 并上传 OSS 发布桶）
- IaC：OSS 发布桶 `qtclass-studio`（`manifests/terraform/`）
- `scripts/configure-class-cdn.sh`：`class.quanttide.com` CDN 证书与 DNS 配置

## [0.1.0-alpha.2] - 2026-08-01

### Removed
- 移除全部 LMS 能力（迁移至 `qtcloud-learn`，见其 ROADMAP v0.5）：
  - 课表 / 考勤：session 模型、schedule / classroom 页面、sessions.json、AppState 的 sessions 加载
  - 学习记录：learning_record 模型、history_service（localStorage）及播放器内历史记录弹层
  - lecture 页（依赖 session 数据）与对应测试
- 移除 integration_test（原测试课表 / 考勤流程）

### Changed
- 播放器不再本地保存学习记录（改为 `qtcloud-learn` 服务端进度数据）

## [0.1.0-alpha.1] - 2026-07-31

### Added
- 互动式课程播放器核心（PlayerScreen + PlayerState）
- 4 场景（intro → environment → first-program → run-state）依次切换
- 互动节点弹层（环境选择 + 运行状态选择）
- 课程完成覆盖层
- 侧边栏：学习路径、演示控制、互动节点、课程脉络
- 历史记录弹层（保存/恢复/删除）
- 演示控制：跳至下一节点、重置全部状态
- 倍速切换（1×/1.25×/1.5×/2×）

### Fixed
- seek(1.0) 未触发片段结束事件，跳转后场景不切换
- 跳至下一节点按钮仅对 intro/first-program 生效
- 测试完成后 PlayerState 定时器未暂停导致 pending timer 异常

### Docs
- player.md 页面结构图：course-heading 文案同步 HTML，player-stage 展开为 4 场景

## [0.0.2] - 2026-05-16

### Added

- 新增 LectureScreen 课时详情页
- 新增 Lecture 课时数据模型
- 新增 Lecture DRD 文档

### Changed

- Lecture 模型移除 duration、sessionId、format；字段重命名
- 移除本地 Lecture 模型，改用 `quanttide_course` 包

## [0.0.1] - 2026-05-08

### Added

- 初始化 qtclass-studio Flutter 项目
- 实现课程和学生管理原型
- 添加单元测试、集成测试和测试脚本

### Changed

- 重构为以课程会话（Session）为核心的教学流程
