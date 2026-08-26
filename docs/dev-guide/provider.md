# qtclass 调用课程云与学习云的关联信息存储设计

qtcloud-course（课程云）与 qtcloud-learn（学习云）是两个独立领域，各自实体不引用对方字段，关联关系由应用层关联表承载。关联表直接建立课程云场景与学习云标准的 ID 映射（`scene_id` ↔ `criterion_id`）。

## 关联表（应用层）

| 字段 | 说明 |
|------|------|
| `id` | 主键 |
| `scene_id` | 课程云场景 ID |
| `criterion_id` | 学习云标准 ID |
| `created_at` | 创建时间 |

```json
{
  "id": "rel-001",
  "scene_id": "scene-3",
  "criterion_id": "cri-001"
}
```

粒度到场景，一个场景对应一条验收标准。

## 读写流程

qtclass 播放器进入场景时，向应用层关联表按 `scene_id` 查询 `criterion_id`；完成时向学习云写 Completion（`learner_id` + `criterion_id`）。学习云按 `criterion_id` 关联标准、按 `learner_id` 聚合学员记录，不感知课程云。
