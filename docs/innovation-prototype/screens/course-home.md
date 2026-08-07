# 课程首页 (view-front / view-generic · overview)

课程首页，用户从课程列表点击进入课程后首先看到的页面。展示课程名称、描述、元信息和进度，作为模块学习的起点。

## 页面定位

- **路由**: 从课程列表点击课程进入，无独立 URL
- **状态**:
  - `view-front`：生产实习专用，`currentModule = 'overview'`，步骤条隐藏
  - `view-generic`：课程 1-4 通用，`genShowModule('overview')`，步骤条隐藏
- **数据依赖**:
  - 生产实习：硬编码 HTML，进度读取 `localStorage('qt-progress-prod')`
  - 课程 1-4：`COURSES` JS 对象 + `localStorage('qt-progress-{courseId}')`

## 页面结构

```
+-- AppBar (sticky, 56px) ----------------------------------------------+
|  [~ 量潮课堂 · LMS]          [🏠 学习前台] [⚙ LMS 管理后台]   v0.12  Z |
+-----------------------------------------------------------------------+

+-- .main (overflow-y:auto) --------------------------------------------+
|  +-- .main-inner (max-width:860px, 居中) ---------------------------+ |
|  |                                                                   | |
|  |  <- 返回课程列表  (.back-link)                                    | |
|  |                                                                   | |
|  |  +-- 课程首页 (.course-hero) -----------------------------------+ | |
|  |  |                                                               | | |
|  |  |  🏭 生产实习 · 微型创业  (.badge-course)                      | | |
|  |  |                                                               | | |
|  |  |  量潮课堂 · 实训基地  (h2)                                    | | |
|  |  |                                                               | | |
|  |  |  量潮是"总部"，你是"分公司"——我们不给你出题，                 | | |
|  |  |  你自己给自己出题。用前 4 个模块了解公司，找到盲区，           | | |
|  |  |  做一个微型创业 demo sale 给总部。                  (.desc)    | | |
|  |  |                                                               | | |
|  |  |  📚 5 个模块 · ⏱ 预计 2 周 · 👤 38 人在学  (.hero-meta)      | | |
|  |  |                                                               | | |
|  |  |  [====>                    ] 20%  (.progress-bar)             | | |
|  |  |                                                               | | |
|  |  |  [▶ 继续学习]  [👥 组队广场]  (CTA 按钮)                      | | |
|  |  +---------------------------------------------------------------+ | |
|  |                                                                   | |
|  +-------------------------------------------------------------------+ |
+-----------------------------------------------------------------------+
```

## 组件清单

### 顶层布局

| 组件 | 选择器/ID | 说明 |
|------|-----------|------|
| 视图容器 | `#view-front` / `#view-generic` | `display:none` 默认隐藏，`.show` 显示 |
| 主滚动区 | `.main` | `flex:1; overflow-y:auto`，内边距 `0 32px 60px` |
| 内容约束 | `.main-inner` | `max-width: 860px; margin: 0 auto` |

### 导航

| 组件 | 选择器/ID | 说明 |
|------|-----------|------|
| 返回链接 | `.back-link` | "← 返回课程列表"，调用 `showCourseList()`，hover 浅蓝背景 |
| 步骤条 | `.steps` / `#stepbar` / `#gen-stepbar` | 课程首页时 **隐藏**（`display:none`），进入模块后才显示 |

### 课程 Hero

| 组件 | 选择器/ID | 说明 |
|------|-----------|------|
| Hero 容器 | `.course-hero` | 蓝色渐变背景 `linear-gradient(135deg, #E3F2FD, #BBDEFB, #E8F5FF)`，圆角 18px，`padding: 40px 48px` |
| 课程标签 | `.badge-course` | 半透明蓝底胶囊，`{icon} {name} · {badge}` |
| 标题 | `h2` / `#gen-title` | 28px 粗体 |
| 描述 | `.hero-desc` / `#gen-desc` | 14px 二级文字，`max-width: 680px` |
| 元信息行 | `.hero-meta` / `#gen-meta` | flex 横向，12px 三级文字，含模块数、预计时间、在学人数 |
| 进度条 | `.progress-bar > .fill` | 5px 高，浅蓝底色 + 蓝色填充，`max-width: 400px` |
| 主按钮 | `.btn-filled.btn-lg` | "▶ 继续学习"，调用 `continueProd()` / `continueGen()` |
| 次按钮 | `.btn-outlined` | "👥 组队广场"（生产实习专属），当前预留 |

### 生产实习 vs 课程 1-4

| 属性 | 生产实习 (view-front) | 课程 1-4 (view-generic) |
|------|----------------------|------------------------|
| 面板 ID | `#mod-overview` | `#gen-mod-overview` |
| 标签文字 | "🏭 生产实习 · 微型创业" | `{icon} {name} · {badge}` |
| 标题 | "量潮课堂 · 实训基地" | `{name}` |
| 描述 | 硬编码 HTML | `#gen-desc` 动态注入 |
| 元信息 | 硬编码 | `#gen-meta` 动态注入 |
| 进度条 | 20% 起 | 0% 起，由 `getProgress()` 计算 |
| 按钮 | 继续学习 + 组队广场 | 仅继续学习 |

## 交互与导航

| 交互 | 触发条件 | 行为 |
|------|---------|------|
| 点击"▶ 继续学习" | 用户有进度 | `continueProd()` → 跳到 `m{p.max+1}`；`continueGen()` → 跳到 `s{p.max+1}` |
| 点击"▶ 继续学习" | 用户无进度 | `continueProd()` → 跳到 `m2`；`continueGen()` → 跳到 `s1` |
| 点击"← 返回课程列表" | 顶部 `.back-link` | `showCourseList()` → 回到课程列表页 |
| 点击"👥 组队广场" | 生产实习 Hero | 预留按钮，当前无绑定事件 |

## 进度持久化

| 课程 | 存储键 | 示例值 |
|------|--------|--------|
| 生产实习 | `qt-progress-prod` | `{"max":3,"last":"m3"}` |
| 知识工作 | `qt-progress-knowledge-work` | `{"max":2,"last":"s2"}` |
| 氛围编程 | `qt-progress-vibe-coding` | `{"max":1,"last":"s1"}` |
| 大数据导论 | `qt-progress-big-data` | `{"max":0}` |
| 数据工程 | `qt-progress-data-engineering` | `{"max":4,"last":"s4"}` |

`last` 为 `undefined` 时用户首次访问 → 显示课程首页；`max` 只增不减。

## 数据模型

详见 [`course.md`](../models/course.md)，课程首页依赖的核心结构：

```javascript
// Course
{ name, icon, badge, badgeClass, desc, meta, stages: Stage[] }

// Progress (localStorage)
{ max: number,   // 已完成的最大模块/阶段序号
  last: string } // 最后访问的模块 ID
```

## 设计原则

1. **一屏概览** — Hero 卡片控制在一屏内，信息密度适中，不让用户滚动
2. **进度感知** — 进度条 + "继续学习"按钮文案根据 `localStorage` 自动切换
3. **低门槛进入** — 无论有无进度，点击主按钮即可进入学习，不需要额外选择
4. **双轨渲染** — 生产实习硬编码，课程 1-4 动态渲染，共享同一套 CSS

## 状态机

```
[课程列表] --点击课程卡片--> [课程首页 · overview]
                                  |
                        +---------+---------+
                        |                   |
                  有进度 (max>0)       无进度 (首次)
                        |                   |
                        v                   v
                  [模块 max+1]          [模块 1]
                                            |
                                     (课程1-4: s1)
                                     (生产实习: m2)
```
