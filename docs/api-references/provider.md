# Provider API 参考

qtclass provider 的 HTTP 接口清单。qtclass 是客户端唯一依赖的服务端：上游聚合课程云（qtcloud-course）内容实体与学习云（qtcloud-learn）完成记录与进度/立项，向 Studio / Site 交付展示契约与回写通道。本服务不设独立存储。

实现位于 `src/provider`，路由组装见 `cmd/server/main.go`；设计决策见 `docs/dev-guide/provider.md`。

## 通用约定

- 请求与响应均为 JSON；错误响应统一为 `{"error":"..."}`；
- 状态码：200 成功、400 参数非法或引用不存在、401 缺少认证、404 资源不存在、502 上游不可用；
- 认证：除健康检查与只读契约外均需 `Authorization: Bearer <token>`（qtcloud-auth 签发），回写与代理接口原样透传给学习云；
- 上游地址由环境变量 `QTCLASS_API_BASE_URL` 派生：课程云 = `<base>/qtcloud-course`，学习云 = `<base>/qtcloud-learn`；该变量仅服务端运行时使用，客户端直接以本服务为基址。

## 课程目录

```http
GET /courses
```

Studio 课程列表的数据源形态。聚合课程云课程实体，按 `sortOrder` 排列：

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

字段说明：

- `id`：课程 ID，后续播放器数据接口的路径参数；
- `status`：展示语义，`open` 可学习（对应课程侧 published），`locked` 暂未开放（draft）；
- 装饰字段（icon / badge 等）不下发，由客户端缺省兜底。

## 播放器数据

```http
GET /courses/{id}/player    # 指定课程的播放器数据
GET /player-data            # 兼容入口：首个已发布课程的播放器数据
```

结构对齐 Studio 播放器的 course.json 契约：

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
      "id": "scen-1",
      "sceneKey": "open",
      "duration": 15,
      "title": "开场",
      "caption": "确认 Zed 已启动",
      "chapter": "创立故事",
      "pathStepId": "less-1",
      "criteria": ["cri-vibe-lesson1-zed"],
      "video": "https://v/intro.mp4"
    }
  },
  "interactions": {},
  "interactionNodes": []
}
```

组装规则：

- `pathSteps` 按课时 `sortOrder` 排列，每条对应一个课时；`segmentId` 指向该课时第一个场景，供播放器直达入口；
- `segments` 以场景 ID 为键，同一课时的场景按派发顺序以 `next` 链接，末段置 `action: "finish"`；每个片段必带 `caption` 与 `chapter`（所属课时标题）；
- `criteria` 为该片段关联的标准 ID 组（场景级 + 所属课时级合并去重），是播放器验收判定后调用完成回写的依据；
- 场景无时长元数据，`duration` 统一取原型值 15 秒。

## 学习云代理

客户端对学习云的调用一律经本服务转发：认证头与请求体原样透传，响应透传上游状态码与 JSON。代理路径映射由服务端持有，客户端不感知学习云内部结构。

| 方法 | 本服务路径 | 上游路径 | 说明 |
|------|-----------|---------|------|
| POST | `/progress` | `/api/courses/prod/progress` | 进度上报 `{moduleId, name}` → `{max, last}` |
| POST | `/proposals` | `/api/proposals` | 提交立项（5 问 + 方向类型 + 组队信息） |

```http
POST /progress
Content-Type: application/json
Authorization: Bearer <token>

{ "moduleId": 2, "name": "立项" }
```

## 完成回写

一条验收标准达成即提交一条记录；一组则逐条提交。

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

1. **白名单**：`criterion_id` 必须存在于课程云标准全局清单——只接受播放器契约下发过的引用，防伪造；不在清单返回 400 `unknown criterion_id`；
2. **幂等**：learner × criterion 已有记录时翻状态（内部更新），否则创建；重复提交不会堆积新记录；
3. **认证必填**：缺失 Authorization 返回 401。

响应为学习云落库后的完成记录（含服务端派发的记录 ID）：

```json
{ "id": "com-new", "learner_id": "learner-001", "criterion_id": "cri-vibe-lesson1-zed", "status": "completed" }
```

`status` 取值 `completed` 或 `not_completed`。

## 辅助接口

```http
GET /healthz    # 健康检查，返回纯文本 ok
```
