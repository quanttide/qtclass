# Provider API 参考

qtclass provider 的 HTTP 接口清单。应用侧集成层：上游聚合课程云（qtcloud-course）内容实体与学习云（qtcloud-learn）完成记录，面向 Studio / Site 交付展示契约。不设独立存储。

实现位于 `src/provider`，路由组装见 `cmd/server/main.go`；设计文档见 `docs/dev-guide/provider.md`。

## 通用约定

- 请求与响应均为 JSON；错误响应统一为 `{"error":"..."}`；
- 状态码含义：400 参数非法或引用不存在、401 缺少认证、404 资源不存在、502 上游不可用；
- 认证仅回写接口需要，透传至学习云；
- 环境变量：`QTCLASS_COURSE_API_URL`、`QTCLASS_LEARN_API_URL`、`LISTEN_ADDR`。

## 课程目录

```http
GET /courses
```

Studio `course_service` 的数据源形态。聚合课程云课程实体，按 `sortOrder` 排列：

```json
{
  "courses": [
    {
      "id": "prod",
      "name": "生产实习",
      "desc": "走进真实业务",
      "status": "open"
    }
  ]
}
```

`status` 为展示语义：`open` 可学习（对应课程侧 published），`locked` 暂未开放。`icon` / `badge` 等装饰字段未下发，由客户端缺省兜底。

## 播放器数据

```http
GET /courses/{id}/player    # 指定课程的播放器数据
GET /player-data            # 兼容入口：首个已发布课程的播放器数据
```

结构对齐 Studio 的 course.json：`segments` 以场景 ID 为键索引片段并按顺序以 `next` 串联（末段置 `action: "finish"`）；`pathSteps` 对应课时及入口片段；随路径携带 `criteria` 关联组供播放器判定与回写。

```json
{
  "title": "生产实习",
  "description": "走进真实业务",
  "objectives": [],
  "pathSteps": [
    { "id": "less-1", "label": "创立故事", "segmentId": "scen-1" }
  ],
  "segments": {
    "scen-1": {
      "id": "scen-1", "sceneKey": "open", "duration": 15,
      "title": "开场", "caption": "确认 Zed 已启动", "chapter": "创立故事",
      "pathStepId": "less-1", "criteria": ["cri-1"], "video": "https://v/intro.mp4"
    }
  },
  "interactions": {},
  "interactionNodes": []
}
```

## 完成回写

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

处理规则：

- **白名单**：`criterion_id` 必须存在于课程云标准全局清单中，否则返回 400 `unknown criterion_id`——只接受组装契约下发过的引用，防伪造；
- **幂等**：learner × criterion 已有记录时翻状态（内部 PUT），否则创建；重复提交不产生新记录；
- **认证透传**：缺失 Authorization 返回 401；
- 响应为学习云落库后的完成记录（含服务端派发的记录 ID）。

错误码：400 参数非法 / 引用不存在、401 未认证、502 课程云或学习云不可用。

## 辅助接口

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/healthz` | 健康检查 |
