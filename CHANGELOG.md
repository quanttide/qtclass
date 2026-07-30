# Changelog

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
