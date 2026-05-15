# Lecture Schema

## Fixture 路径

`src/studio/assets/lectures.json`

## Lecture

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

## 数据约定

- 所有 `string[]` 字段在 JSON 中必须为数组，每个元素为字符串。
- `points` 是有序的，顺序即课时中讲解的顺序。
- `duration` 单位是分钟，JSON 中存整数。
- `level` 值为 `"初级"`、`"中级"`、`"高级"` 之一。
- 课时 ID 命名规则：`lec_` + 三位数字序号。课次 ID 为 `sess_` + 同一序号，两者通过序号松散关联。

## 设计说明

### 三段式结构

targets、objectives、points 三个 `string[]` 字段构成课时的核心内容框架：

- **targets**：给谁看的。允许多条，一个课时可面向多类人群。
- **objectives**：学完能干什么。每条都是可独立验收的声明，不应写成段落。
- **points**：讲什么。数组顺序即课时讲解顺序。

经验：最早只有标题 + 一段描述，用户不知道适不适合自己、学完能干什么。经过多轮迭代才定型为三段结构。

### 课时与课次分离

课时是内容，课次是现场。同一个课时内容可以在不同班级、由不同讲师反复使用。模型中不存 `sessionId`，课时无需知道自己被哪个课次引用。

经验：最初课时和课次混在一起，一份课件换班就得复制一份。拆开后内容可复用，讲师归属只在课次层记录。

### 时长单位

`duration` 以分钟为单位。JSON 中只存整数，Dart 层通过 `Duration(minutes:)` 构造。数据源中不允许出现小时或秒的表示。

经验：早期混用过「1.5小时」「90分钟」等不同表达，解析和显示反复出 bug。统一按分钟记后不再混淆。

### 难度体系

`Level` 枚举固定在三个值。不设过渡档（如"初中级"），也不设扩展档（如"专家级"以上）。

经验：曾经分过五档（入门/初级/中级/高级/专家），用户选课时花大量时间判断难度差异，反而降低了转化。砍到三档后用户决策更快。

### 交付形式不在此层

模型中没有 `format`。同一个课时的交付形式可能因场景变化（如夏季直播 vs 冬季录播），放在课时层会导致频繁修改。交付形式由 `LectureContent` 模型管理。

### 讲师归属不在此层

讲师是课次现场属性，不是课时内容属性。同一个课时换老师讲不需要复制。

### 职责边界

Lecture 只服务课时详情展示，不做以下事：

- **不服务搜索**：没有标签、分类、关键词。课时发现不属于这个模型的职责。
- **不服务统计**：没有完课率、播放量等字段。数据统计由上层模块负责。
- **不管理版本**：版本管理由 `LectureVersion` 模型负责。
- **不管理标签**：章节标签待定。

## 变更记录

| 版本 | 变更 |
|------|------|
| 初始版 | 字段包含 sessionId、format、targetAudience、learningObjectives、durationMinutes、difficulty、outline |
| 当前版 | 移除 sessionId、format；targetAudience→targets（List）、learningObjectives→objectives、durationMinutes→duration(Duration 类型)、difficulty→level(枚举)、outline→points |
