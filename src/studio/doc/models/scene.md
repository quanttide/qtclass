# 核心数据模型

互动影游式课程原型的数据模型体系。所有模型定义来源于 `screens/player.html` 中的业务逻辑。

---

## 1. Segment — 播放片段

播放器的最小播放单元。每个片段有固定时长，播放结束时触发下一跳逻辑。

| 字段 | 类型 | 说明 |
|------|------|------|
| `key` | `string` | 场景渲染标识，对应 `data-scene` |
| `duration` | `number` | 播放时长（秒） |
| `caption` | `string` | 底部字幕文案 |
| `chapter` | `string` | 章节标签，显示在控制栏右侧 |
| `path` | `string` | 关联的侧边栏路径步骤 ID |

### 片段表

| ID | 时长 | 类型 | 场景 key | 下一跳 |
|----|------|------|----------|--------|
| `intro` | 14s | 共同主线 | `intro` | → 互动节点（选择环境） |
| `windows` | 10s | 分支内容 | `environment` | → `first-program` |
| `macos` | 10s | 分支内容 | `environment` | → `first-program` |
| `linux` | 10s | 分支内容 | `environment` | → `first-program` |
| `first-program` | 12s | 共同主线 | `first-program` | → 互动节点（选择运行状态） |
| `run-success` | 8s | 分支内容 | `run-state` | → 课程完成 |
| `run-error` | 8s | 分支内容 | `run-state` | → 互动节点（重新选择） |
| `run-unknown` | 8s | 分支内容 | `run-state` | → 互动节点（重新选择） |

### 类型说明

- **共同主线**：所有学员必经的通用内容
- **分支内容**：根据互动节点选择结果而定制的个性化内容

---

## 2. State — 运行时状态

播放器的核心状态对象，驱动所有 UI 变化。

| 字段 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `currentSegment` | `string` | `'intro'` | 当前播放片段 ID |
| `elapsed` | `number` | `0` | 当前片段已播放秒数 |
| `playing` | `boolean` | `false` | 是否正在播放 |
| `timer` | `number\|null` | `null` | `setInterval` 句柄 |
| `playbackRate` | `number` | `1` | 播放倍速（1 / 1.25 / 1.5 / 2） |
| `endHandled` | `boolean` | `false` | 片段结束事件是否已消费（防重复） |
| `env` | `string\|null` | `null` | 用户选择的环境（`'windows'` / `'macos'` / `'linux'`） |
| `runState` | `string\|null` | `null` | 用户选择的运行状态（`'success'` / `'error'` / `'unknown'`） |
| `interactionType` | `string\|null` | `null` | 当前互动类型（`'env'` / `'runState'`） |
| `selectedChoice` | `string\|null` | `null` | 当前互动中选中的选项 ID |
| `finished` | `boolean` | `false` | 课程是否完成 |
| `triedRunStates` | `string[]` | `[]` | 已尝试过的运行状态 ID 列表 |

### 状态流转

```
[initial] → intro → 互动(env) → branch(windows|macos|linux) →
first-program → 互动(runState) →
  ├── run-success → [完成]
  ├── run-error → 互动(runState) [再次选择]
  └── run-unknown → 互动(runState) [再次选择]
```

**关键规则**：
- `finished=true` 时禁止播放和互动
- `interactionType` 非空时暂停播放
- `triedRunStates` 用于在二次选择时过滤已尝试的选项

---

## 3. ChoiceOption — 互动选项

互动节点中的可选卡片。

| 字段 | 类型 | 说明 |
|------|------|------|
| `id` | `string` | 选项唯一标识 |
| `symbol` | `string` | 卡片左上角符号（如 ✓, ✕, ▣） |
| `title` | `string` | 选项标题 |
| `note` | `string` | 选项辅助说明 |
| `feedback` | `string` | 选中后显示的即时反馈文案（当前为空） |

### 环境选择选项

| id | symbol | title | note |
|----|--------|-------|------|
| `windows` | ▣ | Windows 电脑 | 使用 VS Code 与运行按钮完成第一次执行 |
| `macos` | ◉ | Mac 电脑 | 确认 Python 命令与终端运行方式 |
| `linux` | ◆ | Linux 环境 | 通过终端确认环境并运行 .py 文件 |

### 运行状态选择选项

| id | symbol | title | note |
|----|--------|-------|------|
| `success` | ✓ | 程序成功运行 | 已经看到 Hello, Python! 输出 |
| `error` | ✕ | 运行出现问题 | 程序没有按照预期运行，需要进一步排查 |
| `unknown` | ？ | 不确定下一步操作 | 代码已经完成，但不知道如何执行 |

---

## 4. LearningRecord — 学习记录

保存在 localStorage 中的历史记录条目。

| 字段 | 类型 | 说明 |
|------|------|------|
| `time` | `string` | 保存时间（`toLocaleString('zh-CN')`） |
| `env` | `string\|null` | 选择的环境 ID |
| `envLabel` | `string` | 环境中文名（Windows / macOS / Linux / 未选择） |
| `runState` | `string\|null` | 选择的运行状态 ID |
| `runStateLabel` | `string` | 运行状态中文名 |
| `finished` | `boolean` | 是否已完成课程 |

持久化路径：`localStorage('qc-history')`，最多保留 20 条。

---

## 5. Scene — 场景 (DOM)

播放舞台层的视觉容器，4 个场景共用 `.scene` CSS 类，通过 `data-scene` 属性和 `.active` 类切换。

| data-scene | 视觉组件 | 说明 |
|------------|----------|------|
| `intro` | Python 轨道动画 + 说明文字 | 主线开场，14s |
| `environment` | 系统设备卡片（.system-card） | 分支场景，展示对应系统信息 |
| `first-program` | 代码卡片（.code-card） | 主线场景，展示 print 代码 |
| `run-state` | 终端模拟卡片（.terminal-card） | 分支场景，展示终端输出 |

每个场景的文案内容在 `updateSegmentContent()` 中动态注入。

---

## 6. PathStep — 路径步骤 (DOM)

侧边栏"我的学习路径"中的每一步，反映学习进度。

| 属性 | 说明 |
|------|------|
| `id` | `pathIntro` / `pathEnvironment` / `pathProgram` / `pathRunState` / `pathSyntax` |
| CSS `.hidden-step` | 未解锁时隐藏 |
| CSS `.done` | 已完成 |
| CSS `.current` | 正在播放 |
| `.path-bullet` ✓ | 步骤状态图标 |
| `.branch-chip` | 分支选择标签（环境芯片 / 运行状态芯片） |

### 步骤依赖关系

```
pathIntro (始终可见)
   └── pathEnvironment (state.env 非空时显示)
        └── pathProgram (进入 first-program 或之后显示)
             └── pathRunState (state.runState 非空时显示)
                  └── pathSyntax (state.finished 时显示)
```

---

## 7. 数据持久化方案

| 存储键 | 存储内容 | 生命周期 |
|--------|----------|----------|
| `qc-player-state` | 当前进度（env, runState, finished, currentSegment） | 单次学习周期，重置或完成时清除 |
| `qc-history` | 历史记录数组（最多 20 条） | 持久保留，用户可手动删除 |
