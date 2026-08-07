# Containers — 容器组件

承载和排列 items 的布局容器，控制内容的分组、间距和滚动。

---

## 1. Card — 内容卡片

| 属性 | 值 |
|------|-----|
| 选择器 | `.card` |
| 背景 | `#f5f9fc` |
| 圆角 | 14px |
| 内边距 | `36px 40px` |
| 边框 | `1px solid var(--line)` |
| 阴影 | `0 1px 3px rgba(0,0,0,.03)` |

**子元素**：`h2`（20px 粗体标题）、`.subtitle`（13px 灰色副标题）、任意内容

**状态**：hover 阴影加深（`0 2px 8px`）

**特殊用法**：含表格时 `padding: 0`，表格填满卡片

**使用位置**：课程内页模块面板、后台所有板块

---

## 2. Section — 内容分区

| 属性 | 值 |
|------|-----|
| 选择器 | `.section` |
| 下边距 | `margin-bottom: 24px` |

**子元素**：
| 子元素 | 选择器 | 说明 |
|--------|--------|------|
| 标题栏 | `.section-hd` | flex 横向：`h3` 标题（16px 粗体）+ 右侧说明文字（13px 灰色） |
| 内容区 | `.section-body` | 卡片或组件的直接父容器 |

**使用位置**：后台所有板块均用 Section 分区

---

## 3. TwoCol — 双栏布局

| 属性 | 值 |
|------|-----|
| 选择器 | `.twocol` |
| 布局 | `display: flex; gap: 24px`，子元素 `flex: 1` 均分 |

**变体**：
| 变体 | 选择器 | 说明 |
|------|--------|------|
| 均分双栏 | `.twocol > *` | flex:1 |
| 固定侧栏 | `.twocol .side` | `flex: 0 0 280px` |

**使用位置**：后台审批中心（左 → 时间线，右 `.side` → 审批表单）

---

## 4. CourseHero — 课程首页 Hero

| 属性 | 值 |
|------|-----|
| 选择器 | `.course-hero` |
| 背景 | `linear-gradient(135deg, #E3F2FD, #BBDEFB, #E8F5FF)` |
| 圆角 | 18px |
| 内边距 | `40px 48px` |

**子元素**：`.badge-course`（课程标签）、`h2`（标题）、`.hero-desc`（描述）、`.hero-meta`（元信息行）、`.progress-bar`（进度条）、CTA 按钮

**使用位置**：课程详情页 overview 面板

---

## 5. ModulePanel — 课时面板

| 属性 | 值 |
|------|-----|
| 选择器 | `.module-panel` |
| 默认 | `display: none` |
| 激活 | `.module-panel.show` → `display: block` |

**规则**：同一时刻只有一个 `.show`，切换通过 `showModule(id)` / `genShowModule(id)`

**面板清单**：

| 面板 | ID | 用途 |
|------|-----|------|
| 课程首页 | `#mod-overview` / `#gen-mod-overview` | Hero，步骤条隐藏 |
| 生产实习课时 | `#mod-m1` ~ `#mod-m5` | 5 个模块面板 |
| 通用课程课时 | `#gen-mod-s1` ~ `#gen-mod-s4` | JS 动态生成 |
| 咨询表单 | `#mod-consult` | 特殊面板，步骤条隐藏 |

**使用位置**：课程详情页

---

## 6. PageHeader — 页面标题

| 属性 | 值 |
|------|-----|
| 选择器 | `.page-header` |
| 布局 | `text-align: center`，`margin-bottom: 56px` |

**子元素**：`h1`（30px 粗体标题）、`.desc`（16px 灰色描述，`max-width: 560px` 居中）

**使用位置**：课程列表页顶部

---

## 7. Workspace — 工作区

| 属性 | 值 |
|------|-----|
| 选择器 | `#workspace` |
| 布局 | `display: flex`，`height: calc(100vh - 56px)` |

**子元素**：
- 前台：`.view.show`（全宽 flex:1）
- 后台：`.sidenav`（220px）+ `.main`（flex:1，overflow-y:auto）

**使用位置**：全局布局根容器

---

## 8. FormRow — 表单行

| 属性 | 值 |
|------|-----|
| 选择器 | `.form-row` |
| 布局 | `display: flex; gap: 16px`，子元素 `flex: 1` 均分 |

**使用位置**：后台立项申请表（方向类型 + 组队方式）、生产实习模块 5 表单
