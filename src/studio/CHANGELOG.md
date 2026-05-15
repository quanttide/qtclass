# Changelog

## studio/v0.0.2 - 2026-05-16

- feat: 新增 LectureScreen 课时详情页
- feat: 新增 Lecture 课时数据模型
- docs: 新增 Lecture DRD 文档
- refactor: Lecture 模型移除 duration、sessionId、format；字段重命名
- refactor: 移除本地 Lecture 模型，改用 `quanttide_course` 包

## studio/v0.0.1 - 2026-05-08

- feat: 初始化 qtclass-studio Flutter 项目
- feat: 实现课程和学生管理原型
- feat: 重构为以课程会话（Session）为核心的教学流程
- test: 添加单元测试、集成测试和测试脚本
