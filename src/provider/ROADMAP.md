# ROADMAP — Provider

> Provider 定位：qtclass 的应用侧集成层。上游对接 qtcloud-course（课程云）与 qtcloud-learn（学习云），下游服务 Studio / Site。
> 不设独立存储——课程云是内容与标准的事实源，学习云按课时记账（设计见 `docs/dev-guide/provider.md`），应用层零关联表。

## 背景

学习云 v0.2 起取消 Criterion 模型：验收标准由课程云定义（Lesson/Scene 的 `criteria` 引用列表），学习云不再注册副本，完成记录直接使用课程域课时 ID。

由此本服务的两项核心职责：

1. **播放器数据组装**——把课程内容实体转换为 Studio 播放器契约（segments/pathSteps 与 criteria 关联组下发）；
2. **完成回写**——把 Studio 的验收判定落为学习云 Completion 记录（learner × criterion 幂等）。

原规划中的快照注册与审计两段随 Criterion 注册机制一并取消。

## Architecture

```
        课程云（内容+标准事实源）            本服务                学习云（记录面）
   Course/Lesson/Scene ─ 内容实体 → [播放器组装] → segments/pathSteps/criteria 下发
   Criterion 定义      ─ 交付判定语义 ↘        │
                                           ↓
Studio 验收达成 ─────────────────→ [完成回写] ────→ Completion（learner × criterion）
```

## 版本规划

### v0.1（规划中）— 骨架、组装与回写

| 前置 | 交付 |
|------|------|
| 课程云 `provider/v0.1.1-alpha.4`（纯内容实体接口已就绪）；学习云 Criterion 已移除 | 服务骨架 + 播放器数据组装 + 完成回写通道 |

#### Phase 1：服务骨架（进行中）

- [x] Go 标准库 + `/healthz`（技术栈对齐 qtcloud-course provider）
- [ ] FC 部署 manifests 与 CI 发布管道（测试门禁 CI 已就绪：`.github/workflows/test-provider.yml`）

#### Phase 2：播放器数据组装 ✅

- [x] 内容聚合：读课程云四资源，按课时顺序展开为 pathSteps 与场景片段映射；结构与 Studio 解析契约（`services/course_data.dart`、本地 assets/course.json）对齐
- [x] 契约下发：随路径携带各课时/场景的 criteria 关联组及标准详情（Studio 判定回写的依据）；原型期硬编码（时长、学员数、图标等展示值）不再迁入
- [x] 课程目录契约：`GET /courses` 输出 Studio course_service 所需形态（icon/badge 等由客户端缺省兜底）

#### Phase 3：完成回写通道 ✅

- [x] Completion 代理：透传认证 → 学习云 `POST /completions`；白名单校验 criterion_id（仅接受课程云定义过的标准）+ learner × criterion 幂等（已有记录走 PUT 翻状态）
- [x] status 枚举校验与错误响应归一

#### 质量门禁

- [x] 组装输出与播放器契约的结构测试
- [x] 回写分支的接口测试全覆盖（创建 / 幂等更新 / 白名单拒绝 / 认证缺失）
- [ ] Phase 1 完成后发布 v0.1.0 tag

### v0.2（远期）— 统一聚合入口

Studio / Site 的所有上游调用收敛至本服务，缓存策略视流量引入；先有真实痛点再立项。

## 决策日志

| 日期 | 决策 | 理由 |
|------|------|------|
| 2026-08-26 | 不建关联表、不落库 | 见 `docs/dev-guide/provider.md`：id 同源直连，学习云不感知课程云内部结构 |
| 2026-08-28 | 学习云取消本地 Criterion 模型与 `/criteria` 接口，快照注册/审计整体移除 | 标准的定义面在课程云、执行面在播放器本地——中间注册一份归档副本没有独立消费者；`criterion_id` 字段名保留、直指课程域 Criterion.id，API 兼容 |
| 2026-08-28 | 接受完成历史的语义漂移 | 完成记录指向稳定 id 即可支撑聚合；删除重建课时才会断裂，风险可控。可追溯性需求出现时再引入版本化归档 |
| 2026-08-28 | 播放器数据组装自 qtcloud-course 迁入 | 课程云裁剪为纯内容实体接口，展示适配属应用侧职责 |
