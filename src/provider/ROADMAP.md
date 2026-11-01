# ROADMAP — qtclass-provider

> 定位：qtclass 的应用侧集成层。上游对接 qtcloud-course（课程云）与 qtcloud-learn（学习云），下游服务 Studio / Lite / Site。
> 不设独立存储——课程云是内容与标准的事实源，学习云按课时记账（设计见 `docs/dev-guide/provider.md`），应用层零关联表。三端分工总纲见仓库根 [ROADMAP.md](../../ROADMAP.md)。

## 已交付（v0.1）

1. **播放器数据组装**——把课程内容实体转换为 Studio 播放器契约（segments/pathSteps 与 criteria 关联组下发）
2. **完成回写**——验收判定落为学习云 Completion 记录（learner × criterion 幂等，白名单校验 criterion_id）
3. 服务骨架 + FC 部署管道（质量门禁前置）；学习云代理：`/completions`、`/progress`、`/proposals` 经本服务转发，客户端单依赖本服务

```
        课程云（内容+标准事实源）            本服务                学习云（记录面）
   Course/Lesson/Scene ─ 内容实体 → [播放器组装] → segments/pathSteps/criteria 下发
   Criterion 定义      ─ 交付判定语义 ↘        │
                                           ↓
Studio 验收达成 ─────────────────→ [完成回写] ────→ Completion（learner × criterion）
```

> 注：`/progress`、`/proposals` 上游已在学习云重构中移除，studio 对应功能已暂停，待任务链路立项时按新契约重建。

## 规划

### v0.2 — 任务链路（三端分工的首个新交付）

「studio 派任务 → lite 取任务 → 交付 → 回写」经本服务，客户端仍单依赖：

- [ ] 任务下发：studio 派发（班级/学员、截止、验收标准）→ lite 拉取（按 learner 投影今日任务卡）
- [ ] 交付提交：lite 提交交付物 → studio 批改面收取
- [ ] 任务状态回写：派发 / 提交 / 退回重做 / 通过，落学习云新任务模型

前置（跨仓，需对齐）：学习云任务模型重建——旧 `/proposals`、`/progress` 已移除，新模型的实体与契约待学习云定义。上游未就绪前，契约形状按 studio v0.2 的静态数据先行验证。

### v0.3（远期）— 统一聚合入口

Studio / Lite / Site 的所有上游调用收敛至本服务，缓存策略视流量引入；先有真实痛点再立项。

## 决策日志

| 日期 | 决策 | 理由 |
|------|------|------|
| 2026-08-26 | 不建关联表、不落库 | 见 `docs/dev-guide/provider.md`：id 同源直连，学习云不感知课程云内部结构 |
| 2026-08-28 | 学习云取消本地 Criterion 模型与 `/criteria` 接口，快照注册/审计整体移除 | 标准的定义面在课程云、执行面在播放器本地——中间注册一份归档副本没有独立消费者；`criterion_id` 字段名保留、直指课程域 Criterion.id，API 兼容 |
| 2026-08-28 | 接受完成历史的语义漂移 | 完成记录指向稳定 id 即可支撑聚合；删除重建课时才会断裂，风险可控。可追溯性需求出现时再引入版本化归档 |
| 2026-08-28 | 播放器数据组装自 qtcloud-course 迁入 | 课程云裁剪为纯内容实体接口，展示适配属应用侧职责 |
| 2026-11-01 | 下游加入 lite，v0.2 立项任务链路 | 三端分工：学员端只消费任务卡，任务的派发/收取/状态全部经本服务，客户端不直连学习云 |
