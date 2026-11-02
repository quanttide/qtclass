# TODO — qtclass-studio

可直接动手的细节，包内改动，有类型检查、测试或视觉验证兜底。需与人对齐的事项见 [ROADMAP.md](ROADMAP.md)。

## Assignment 首版：大作业入档（创作空间第一块数据）

创作空间的骨架：**Assignment（题目）→ Solution（参考答案）→ SolutionStep（步骤单元，一层不嵌套，`after` 边组成 DAG）**——三件孪生同形；先立靶子，解体才有对象，答案先立、路随答案走。数据契约三字段由用户定：`id`(uuid) / `title` / `content`。**独立实现于 studio `lib/models/`**——toolkit 暂不引入（业务迭代期自由改，稳定后固定回 `quanttide-tech-toolkit` 的 `dart/course`）；**实例已落本地 XDG 目录**（不进仓不进 assets）；余项 = 从 XDG 读取的加载器（留环境变量覆盖缝）与验收复跑。

- [x] `Assignment` 类 → studio `lib/models/assignment.dart`（独立实现）——三字段 + `fromJson` / `toJson`，载荷演化位写在 doc 注释
- [x] `Solution` / `SolutionStep` 类 → studio `lib/models/` 同目录（独立实现）——孪生三字段 + `after` 前置边组 DAG，单元自足（判断标准与注解进 content）；含菱形组图与拓扑分层测试，`flutter analyze` 无告警、全量 81 测全绿
- [x] 实例两份 → **本地 XDG 目录** `~/.local/share/qtclass_studio/assignments/<任务书 slug>/assignment.json`——`id` 用测试同款 uuid 写死、`title` 取任务书一级标题、`content` 装任务书全文（1660B / 1064B，回读校验通过）；源：lite 的小说与游戏两份任务书；**不进仓不进 assets**——实例是本机设计数据，随迭代就地改
- [ ] 验收：`flutter analyze` 零告警、`flutter test` 全绿；不新增任何页面，不碰学员入口

边界：只动数据层——界面、步骤视图、脚手架、修订回环不随本条展开；学员交互功能已整体砍除（见 ROADMAP 精简理由），本条是单用户设计侧的纯数据改动。
