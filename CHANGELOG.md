# Changelog

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

## v0.0.2 - 2026-05-16

- 课时详情页和数据模型

## v0.0.1 - 2026-05-08

- 初始化项目结构和文档
- 实现 qtclass-studio 课堂管理原型
