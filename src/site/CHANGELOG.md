# CHANGELOG

## [Unreleased]

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

## [0.1.0] - 2026-08-25

### Added

- 初始版本，基于 Vue 3 + Vite
- 课程体系展示
- 响应式设计
