# ROADMAP — qtclass-site

招生门面：课程列表与价格。无首页（`/` 重定向课程页）；登录后功能一律不进——学员的进 lite，教师的进 studio。

现状：v0.1.2 正式版——课程单一列表（不区分理论 / 实践，训练营不在课程页，详情 `/schedules/:slug` 深链可达）、`/prices` 三档服务模式卡（`PRICES_TRACKS`，询价口径不标价格）、`/learn` 已下线。

## 下一步待办

- [ ] 任务书迁出：10 篇迁 lite（清单与时机见 [lite ROADMAP](../lite/ROADMAP.md)）；迁出前 `data/learning/tasks/` 不新增
- [ ] 训练营正文「来源：tasks/xxx.md」为裸文本（任务页下线后不转链），随任务书迁出改指 lite
- [ ] 价目源同步：价格明细暂不展示，`data/learning/prices/` 副本与支付域（quanttide-pay `spend/`）的同步方案待明细页恢复时再定
