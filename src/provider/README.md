# qtclass-provider

qtclass 的应用侧集成层：对接课程云内容实体与学习云完成记录，为 Studio / Site 提供统一数据通道。不设独立存储。

## 运行

```bash
LISTEN_ADDR=:8080 \
QTCLASS_API_BASE_URL=https://api.quanttide.com \
go run ./cmd/server
```

## 接口

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/courses` | 课程目录契约（Studio 课程列表） |
| GET | `/courses/{id}/player` | 播放器数据（segments/pathSteps/criteria 下发） |
| GET | `/player-data` | 兼容入口：首个 published 课程 |
| POST | `/completions` | 完成回写代理：白名单校验 + learner × criterion 幂等 |
| GET | `/healthz` | 健康检查 |

设计文档见 `../../docs/dev-guide/provider.md`，路线图见 `ROADMAP.md`。
