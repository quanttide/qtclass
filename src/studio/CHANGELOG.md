# Changelog

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
