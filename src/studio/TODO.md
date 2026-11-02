# TODO — qtclass-studio

可直接动手的细节，包内改动，有类型检查、测试或视觉验证兜底。需与人对齐的事项见 [ROADMAP.md](ROADMAP.md)。

## Assignment 首版：大作业入档（创作空间第一块数据）

创作空间四个对象里 Assignment（大作业）是定义层——Assignment 是节点的定义，分解树（解体思路）是节点的序列，教学动作是节点的注解；先立靶子，解体才有对象。数据契约三字段由用户定：`id` / `title` / `content`。

- [ ] `lib/models/assignment.dart`：三字段——`id`（uuid 字符串）、`title`（String）、`content`（String，Markdown 长文本；未来拓展视频等格式时在此引入格式判别，`id` / `title` 不动）；`fromJson` 入口，风格对齐 `lib/models/segment.dart`（doc 注释注明映射自 roadmap `product/studio.md → Assignment（大作业）`）
- [ ] 实例两份（先手写模板口径的第一、二个实例，用真材料不空造）：`assets/assignments/` 下各一份 JSON——`id` 一次性生成 uuid 写死（不引依赖）、`title` 取任务书一级标题、`content` 装任务书全文；源：`src/lite/data/tasks/quanttide-fiction-of-founder.md`（小说发行）、`src/lite/data/tasks/qtgame-tycoon.md`（游戏）
- [ ] 测试 `test/models/assignment_test.dart`：两份实例可解析、三字段齐、`id` 为 uuid 形态、`content` 含任务书正文标记（晋江 / 4399）；沿用 `test/models/` 既有写法
- [ ] 验收：`flutter analyze` 零告警、`flutter test` 全绿；不新增任何页面，不碰学员入口

边界：只动数据层——界面、分解树、教学动作、修订回环不随本条展开；学员交互功能已整体砍除（见 ROADMAP 精简理由），本条是单用户设计侧的纯数据改动。
