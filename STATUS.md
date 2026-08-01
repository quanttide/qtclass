# qtclass 状态报告

> 更新日期：2026-07-20
> 仓库：quanttide/qtclass
> 最新 commit：9eae6f7 (2026-07-11)

## LMS 冻结声明

> 依据量潮课程云域的迁移计划（[qtcloud-learn/ROADMAP.md](../qtcloud-learn/ROADMAP.md)），
> 自 2026-08 起本仓库**冻结 LMS 能力迭代**（课表 / 考勤 / 学习记录 / session 模型等），仅做缺陷修复；
> 上述能力统一收拢到 `qtcloud-learn`（量潮学习云），迁移完成后从本仓库移除。
> 播放器（player / lecture）职责不受影响，继续在本仓库演进。

## 版本历史

| 版本 | 日期 | 内容 |
|------|------|------|
| v0.0.2 | 2026-05-16 | 课时详情页和数据模型 |
| v0.0.1 | 2026-05-08 | 初始化项目结构，qtclass-studio 课堂管理原型 |

## 组件进度

| 组件 | 状态 | 说明 |
|------|------|------|
| Studio (`src/studio`) | v0.0.2 | Flutter 课堂管理，课节详情页 + Lecture 模型；依赖 `quanttide_course` 包 |
| CLI | 无 | — |
| Provider | 无 | — |

## 与 qtdata 对比

qtdata 具备 CLI + Provider + Studio 三件套，qtclass 目前仅 Studio 前端：

- **缺 CLI**：无命令行工具，无法通过 Markdown → 结构化输出驱动业务流程
- **缺 Provider**：无后端服务，Studio 数据来自本地 JSON（`assets/lectures.json`、`assets/sessions.json`）
- **缺 E2E 测试**：qtdata 有 xdotool + httpx 测试框架，qtclass 仅有 integration_test

## 文档结构

| 目录 | 状态 | 说明 |
|------|------|------|
| docs/brd/ | 有 | 业务需求文档 |
| docs/drd/ | 有 | 数据需求文档（课节模型） |
| docs/ixd/ | 有 | 交互设计文档 |
| docs/qa/ | 有 | 质量保障文档 |
| docs/add/ | 有 | 架构设计文档 |
| docs/prd/ | 无 | 产品需求文档缺失 |
| docs/dev/ | 无 | 开发者文档缺失 |
| docs/user/ | 无 | 用户文档缺失 |

## 关键差距

1. **后端缺失**：没有 Provider，课程数据管理完全依赖前端本地文件
2. **无 CLI**：缺少从文档到结构化数据的自动化工具链
3. **无 ROADMAP**：空 ROADMAP.md 已被删除，缺少公开的规划文档
4. **文档不完整**：prd/dev/user 目录在 README 中列出但实际不存在
