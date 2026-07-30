# 播放器 (player.html)

互动式课程播放器，是课程学习的核心交互界面。

## 页面定位

- **路由**: `/player.html`
- **状态**: 完整 SPA 体验，所有交互逻辑在页面内闭环
- **数据持久化**: `localStorage('qc-player-state')` 保存学习进度，`localStorage('qc-history')` 保存历史记录

## 页面结构总览

```
┌─ topbar (顶栏，sticky) ─────────────────────────────────────┐
│  [QC] 量潮课堂         [互动影游式课程原型]   [查看历史] [保存] [←返回] │
│       Python 基础 · 第1课                                    │
└─────────────────────────────────────────────────────────────┘

┌─ course-heading ─────────────────────────────────────────────┐
│  CHAPTER 01 · 第一次运行                                     │
│  完成你的第一次 Python 运行                     [● 等待播放]  │
│  副标题说明文案                                              │
└─────────────────────────────────────────────────────────────┘

┌─ workspace (grid: 1fr | 318px) ────────────────────────────┐
│  ┌─ player-shell ─────────┐  ┌─ sidebar ───────────────┐  │
│  │                        │  │                         │  │
│  │  ┌─ player-stage ──┐   │  │  [我的学习路径] ▼       │  │
│  │  │  [scene]        │   │  │  ● 开启学习任务 (当前)  │  │
│  │  │  [caption-box]  │   │  │  ○ 选择运行环境         │  │
│  │  │  [interaction]  │   │  │  ○ 第一次代码运行       │  │
│  │  │  [finish]       │   │  │  ○ 处理运行反馈         │  │
│  │  └─────────────────┘   │  │  ○ 解锁成功运行         │  │
│  │  ┌─ player-controls ─┐ │  │                         │  │
│  │  │  [▶] [00:00/00:50] │ │  │  [演示控制] ▼          │  │
│  │  │  [重播当前片段]    │ │  │  [跳至下一节点] [重置]  │  │
│  │  └───────────────────┘ │  │                         │  │
│  └────────────────────────┘  │  [互动节点] ▼           │  │
│                               │  01 选择运行环境 [已选择]│  │
│                               │  02 处理运行反馈 [待完成]│  │
│                               │                         │  │
│                               │  [课程脉络] ▼           │  │
│                               │  01 开启 Python 学习    │  │
│                               │  02 选择运行环境         │  │
│                               │  03 第一次代码运行       │  │
│                               │  04 运行反馈与排查       │  │
│                               └─────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## 组件清单

### 顶层布局

| 组件 | 选择器 | 说明 |
|------|--------|------|
| 应用容器 | `.app` | flex column, min-height: 100vh |
| 顶栏 | `.topbar` | sticky, backdrop-filter blur |
| 工作区 | `.workspace` | grid 2 列 (1fr + 318px) |
| 主列 | `.main-column` | 课程标题 + 播放器 |
| 侧边栏 | `aside.sidebar` | 4 个可折叠卡片 |

### 顶栏 (Topbar)

| 子组件 | 说明 |
|--------|------|
| `.brand-mark` | QC 圆形标识 |
| `.brand-name` | "量潮课堂" |
| `.brand-sub` | "Python 基础 · 第1课" |
| `.prototype-badge` | "互动影游式课程原型"标签 |
| `查看历史` | 打开 `#historyOverlay` |
| `保存记录` | 调用 `saveRecord()` |
| `← 返回首页` | 跳转 `home.html` |

### 播放舞台 (Player Stage)

| 子组件 | ID | 说明 |
|--------|-----|------|
| 场景容器 | `.scene` | 4 个场景 (intro / environment / first-program / run-state)，通过 `.active` 切换 |
| 字幕框 | `#captionBox` | 底部居中，显示当前片段说明文字 |
| 互动覆盖层 | `#interactionOverlay` | 决策节点弹层，包含选项卡片网格 |
| 完成覆盖层 | `#finishOverlay` | 学习完成后的结果弹层 |
| 历史覆盖层 | `#historyOverlay` | 学习历史记录列表 |
| 确认覆盖层 | `#confirmOverlay` | 跳转路径前的确认弹层 |
| 浮动按钮 | `.stage-float-btns` | 倍速切换 + 全屏按钮 |
| 网格背景 | `.stage-grid` | CSS 背景网格 |
| 渐晕 | `.stage-vignette` | 径向渐变背景 |

### 场景 (Scene)

| 场景 | data-scene | 说明 |
|------|------------|------|
| 介绍 | `intro` | Python 轨道动画，阶段：学习主线 |
| 环境选择 | `environment` | 系统设备卡片，阶段：个性化分支 |
| 第一个程序 | `first-program` | 代码卡片，阶段：学习主线 |
| 运行状态 | `run-state` | 终端模拟卡片，阶段：个性化分支 |

### 播放控制 (Player Controls)

| 子组件 | ID | 说明 |
|--------|-----|------|
| 进度条 | `#timeline` | 可点击拖动，实时反馈位置 |
| 播放按钮 | `#playButton` | ▶ / ❚❚ 切换 |
| 时间码 | `#currentTime` / `#totalTime` | 00:00 格式 |
| 重播按钮 | `#restartScene` | 重置当前片段进度 |
| 章节标签 | `#chapterLabel` | 显示当前所属章节 |

### 互动覆盖层 (Interaction Overlay)

| 子组件 | ID | 说明 |
|--------|-----|------|
| 标签 | `#interactionTag` | "互动节点" |
| 计数 | `#interactionCount` | "1 / 1" |
| 标题 | `#interactionTitle` | 问题描述 |
| 描述 | `#interactionDesc` | 补充说明 |
| 选项网格 | `#optionGrid` | 动态生成 `.option-card` |
| 反馈 | `#decisionFeedback` | 选中后的即时反馈 |
| 确认按钮 | `#confirmChoice` | 未选中时 disabled |

### 侧边栏卡片

| 卡片 | ID | 可折叠 | 说明 |
|------|-----|--------|------|
| 我的学习路径 | `#pathCard` | ✅ | 5 步阶梯路径，带完成状态与分支芯片 |
| 演示控制 | `#demoCard` | ✅ | 调试用按钮：跳节点、重置 |
| 互动节点 | `#nodeStatusCard` | ✅ | 2 个关键节点的完成状态 |
| 课程脉络 | `#knowledgeCard` | ✅ | 4 步课程大纲 |

## 数据模型

### 核心状态 (state 对象)

```javascript
{
  currentSegment: string,     // 当前片段 ID (intro / windows / macos / linux / first-program / run-success / run-error / run-unknown)
  elapsed: number,            // 当前片段已播放秒数
  playing: boolean,           // 播放/暂停状态
  timer: number|null,         // setInterval 句柄
  env: string|null,          // 用户选择的环境 (windows / macos / linux)
  runState: string|null,     // 用户选择的运行状态 (success / error / unknown)
  interactionType: string|null,  // 当前互动类型 (env / runState)
  selectedChoice: string|null,   // 当前选中的选项 ID
  finished: boolean,         // 课程是否完成
  endHandled: boolean,       // 片段结束事件防重复
  playbackRate: number,      // 播放倍速 (1 / 1.25 / 1.5 / 2)
  triedRunStates: string[]   // 已尝试过的运行状态（排除后避免重复选择）
}
```

### 片段定义 (segments)

| 片段 ID | 时长 | 类型 | 下一跳 |
|---------|------|------|--------|
| intro | 14s | 共同主线 | → 互动节点 (选择环境) |
| windows/macos/linux | 10s | 分支内容 | → first-program |
| first-program | 12s | 共同主线 | → 互动节点 (选择运行状态) |
| run-success | 8s | 分支内容 | → 课程完成 |
| run-error / run-unknown | 8s | 分支内容 | → 互动节点 (重新选择) |

### 持久化

```
localStorage('qc-player-state') = {
  env, runState, finished, currentSegment
}

localStorage('qc-history') = [{
  time: string,          // 中文时间戳
  env: string|null,
  envLabel: string,
  runState: string|null,
  runStateLabel: string,
  finished: boolean
}, ...]                  // 最多 20 条
```

## 交互流程

```
[开始学习] → intro 播放 → 互动节点(选择环境) → 分支(windows/macos/linux) →
first-program 播放 → 互动节点(选择运行状态) →
  ├─ run-success → [课程完成] → 结果弹层
  ├─ run-error → 分支播放 → 互动节点(重新选择)
  └─ run-unknown → 分支播放 → 互动节点(重新选择)
```

## 关键交互

| 交互 | 触发 | 行为 |
|------|------|------|
| 播放/暂停 | 点击 ▶/❚❚ 或 Space 键 | 切换 `state.playing`，启动/停止 timer |
| 片段结束 | `elapsed >= duration` | 暂停播放 → `handleSegmentEnd()` |
| 选择选项 | 点击 `.option-card` | 高亮选中 → 启用确认按钮 |
| 确认选择 | 点击 `#confirmChoice` | 保存选择 → 关闭覆盖层 → 进入对应片段 |
| 跳转路径 | 点击 `.path-step` | 如果是回退 → 弹出确认框 |
| 保存记录 | 点击"保存记录" | 追加到 history → 存入 localStorage |
| 恢复进度 | 在历史弹层点击"恢复" | 读取 history 条目 → 恢复对应状态 |
| 重置 | 点击"重置全部状态" | 清空所有 state → 回到 intro |
| 倍速切换 | 点击倍速浮动按钮 | 1× → 1.25× → 1.5× → 2× 循环 |
