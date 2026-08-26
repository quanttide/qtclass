# qtclass 调用课程云与学习云的关联信息存储设计

qtcloud-course（课程云）与 qtcloud-learn（学习云）是两个独立领域，各自实体不引用对方字段，应用层不建关联表。

职责切分一句话：**课程云定义内容与标准，学习云只记账**。

- 课程云：内容实体 Course / Lesson / Scene 三级树；Criterion 一等实体定义验收规则并挂载到 Lesson / Scene（`criteria []string` 引用列表）。接口见 qtcloud-course `docs/api-references/provider.md`。
- 学习云：核心模型 **Learner × Criterion → Completion**。不设本地验收标准实体，完成记录的 `criterion_id` 直指课程域 Criterion.id。
- qtclass provider：组装播放器契约、回写完成记录。

## 关联机制

唯一的关联是 **ID 同源直连**：

| 关联 | 约定 |
|------|------|
| `Completion.criterion_id` ↔ 课程云 `Criterion.id` | 服务端派发后跨域不变 |
| Lesson / Scene 的 `criteria` 列表 ↔ 本领域 Criterion | 标准的定义面在课程云内部 |

由此不需要任何注册、同步或映射表：学习云面对的是一套已经稳定的课程 id 空间，且 API 字段名与既往契约保持兼容。

已知代价：完成历史指向的内容对象可被课程侧编辑——旧记录仍指向同一 id，但当时的判定文案不再归档。若未来需要「通过当时规则」的可追溯性，再引入版本化归档，不预先建设。

## 播放器数据组装

学员端数据由 qtclass provider 聚合下发：

1. 读课程云四资源，按课时顺序展开为 pathSteps 与场景片段映射；
2. 随路径携带各课时/场景的 `criteria` 引用列表及标准详情；
3. 过程判定（每步提示、分支选择）由播放器本地消费，不产生持久化记录。

## 完成记录回写

一条验收标准达成后提交一条完成记录（一组则逐条提交）：

```http
POST /completions
Content-Type: application/json
Authorization: Bearer <token>

{
  "learner_id": "learner-001",
  "criterion_id": "cri-vibe-lesson1-zed",
  "status": "completed"
}
```

`learner_id` 来自认证态；`status` 取值为 `completed` 或 `not_completed`。学习云按 learner × criterion 幂等去重，重复提交只翻状态不堆记录。学习云按 `criterion_id` 关联标准引用、按 `learner_id` 聚合学员记录，不感知课程云内部结构。
