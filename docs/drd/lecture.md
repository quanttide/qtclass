# LectureData Schema

## Fixture 路径

`src/studio/assets/lectures.json`

## LectureData

| 字段 | 类型 | 必填 | 默认 | 说明 |
|------|------|------|------|------|
| `id` | string | 是 | — | 唯一标识，格式 `lec_001` |
| `title` | string | 是 | — | 课时标题 |
| `description` | string | 是 | — | 课时简介 |
| `targets` | string[] | 是 | — | 目标用户，允许多条 |
| `objectives` | string[] | 是 | — | 学习目标，每条独立可验收 |
| `points` | string[] | 是 | — | 要点提纲，有序 |
| `duration` | number | 是 | — | 时长，单位分钟 |
| `level` | string | 是 | — | 难度等级，见 Level 枚举 |

## Level 枚举

| 值 | 含义 |
|----|------|
| `"初级"` | 入门级 |
| `"中级"` | 进阶级 |
| `"高级"` | 专家级 |

## 数据关系

```
Session (N) ──松散关联──> Lecture (N)
```

课时与课次通过 ID 命名松散关联：课时 `lec_001` 对应课次 `sess_001`。不设外键约束。

## 设计说明

### 三段式结构

targets、objectives、points 三个 `string[]` 字段构成课时的核心内容框架：

- **targets**：给谁看的。允许多条，一个课时可面向多类人群。
- **objectives**：学完能干什么。每条都是可独立验收的声明，不应写成段落。
- **points**：讲什么。数组顺序即课时讲解顺序。

### 时长单位

`duration` 以分钟为单位。数据源中不允许出现小时或秒的表示。

### 难度体系

难度枚举固定在三个值。不设过渡档（如"初中级"），也不设扩展档（如"专家级"以上）。

### 交付形式不在此层

交付形式由 `LectureContent` 模型管理，`LectureData` 不记录。

### 讲师归属不在此层

讲师是课次（Session）的现场属性，`LectureData` 不记录。

### 职责边界

`LectureData` 只服务课时详情展示。搜索、统计、版本管理由各自模型负责：

- 版本管理 → `LectureVersion`
- 章节标签 → 待定
- 搜索索引 → 待定

## 变更记录

| 版本 | 变更 |
|------|------|
| 初始版 | 字段包含 sessionId、format、targetAudience、learningObjectives、durationMinutes、difficulty、outline |
| 当前版 | 移除 sessionId、format；targetAudience→targets（List）、learningObjectives→objectives、durationMinutes→duration(Duration 类型)、difficulty→level(枚举)、outline→points |
