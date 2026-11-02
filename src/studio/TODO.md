# TODO — qtclass-studio

可直接动手的细节，包内改动，有类型检查、测试或视觉验证兜底。需与人对齐的事项见 [ROADMAP.md](ROADMAP.md)。

## Assignment 首版：大作业入档（创作空间第一块数据）

创作空间的骨架：**Assignment（题目）→ Solution（参考答案）→ SolutionStep（步骤单元，一层不嵌套，`after` 边组成 DAG）**——三件孪生同形；先立靶子，解体才有对象，答案先立、路随答案走。数据契约三字段由用户定：`id`(uuid) / `title` / `content`。**类已落 toolkit**（跨仓共享，BLoC 架构的 models 层），studio 侧只管接入与实例。

- [x] `Assignment` 类 → `quanttide-tech-toolkit` 仓 `packages/dart/lib/course/models/assignment.dart`——三字段 + `fromJson` / `toJson`，载荷演化位写在 doc 注释；`dart analyze` 无告警、7 测试全绿（BLoC 架构 models 层，states / events / bloc 随第一条工作流启用）
- [x] `Solution` / `SolutionStep` 类 → 同仓 `lib/course/models/`——孪生三字段 + `after` 前置边组 DAG，单元自足（判断标准与注解进 content）；含菱形组图与拓扑分层测试，analyze 无告警、17 测全绿（`states/` 装 bloc 与状态，不另设 bloc/）
- [ ] studio 接入：`pubspec.yaml` 引 `quanttide_tech` 包
- [ ] 实例两份（先手写模板口径的第一、二个实例，用真材料不空造）：`assets/assignments/` 下各一份 JSON——`id` 一次性生成 uuid 写死、`title` 取任务书一级标题、`content` 装任务书全文；源：`src/lite/data/tasks/quanttide-fiction-of-founder.md`（小说发行）、`src/lite/data/tasks/qtgame-tycoon.md`（游戏）；配 studio 侧解析测试
- [ ] 验收：`flutter analyze` 零告警、`flutter test` 全绿；不新增任何页面，不碰学员入口

边界：只动数据层——界面、步骤视图、脚手架、修订回环不随本条展开；学员交互功能已整体砍除（见 ROADMAP 精简理由），本条是单用户设计侧的纯数据改动。
