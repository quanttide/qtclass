# TODO — qtclass-studio

可直接动手的细节，包内改动，有类型检查、测试或视觉验证兜底。需与人对齐的事项见 [ROADMAP.md](ROADMAP.md)。

## Brief 首版：任务书结构化（创作空间第一块数据）

创作空间四个对象里 Brief 是定义层——Brief 是节点的定义，分解树是节点的序列，教学动作是节点的注解。字段口径已在路线图与洞察仓对齐过，本条只做落地，不含设计判断。

- [ ] `lib/models/brief.dart`：Brief 数据类，字段按路线图四问——目标对象 / 真实场景 / 期望产出物 / 关联官网知识点；`fromJson` 入口，风格对齐 `lib/models/segment.dart`（doc 注释注明映射自 roadmap `product/studio.md → Brief`）
- [ ] 实例两份（先手写模板口径的第一、二个实例，用真材料不空造）：以仓内两份真实任务书为源——`src/lite/data/tasks/quanttide-fiction-of-founder.md`（小说发行）、`src/lite/data/tasks/qtgame-tycoon.md`（游戏），各结构化为一份 Brief JSON，入 `assets/`
- [ ] 测试 `test/models/brief_test.dart`：两份实例可解析、四字段齐、缺字段回退行为与现有模型一致；沿用 `test/models/` 既有写法
- [ ] 验收：`flutter analyze` 零告警、`flutter test` 全绿；不新增任何页面，不碰学员入口

边界：只动数据层——界面、分解树、教学动作、修订回环不随本条展开；学员交互功能已整体砍除（见 ROADMAP 精简理由），本条是单用户设计侧的纯数据改动。
