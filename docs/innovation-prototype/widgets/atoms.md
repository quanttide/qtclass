# Atoms — 原子组件

最小不可拆的视觉单元，构成所有复杂组件的基础。

---

## 1. Button — 按钮

| 选择器 | 说明 |
|--------|------|
| `.btn` | 基础按钮，`padding: 10px 28px`，圆角 8px，`font-weight: 600` |
| `.btn-filled` | 主操作：蓝色渐变 `linear-gradient(135deg, #1677ff, #4096ff)`，白色文字，带阴影 |
| `.btn-outlined` | 次要操作：透明背景，1.5px 边框，蓝色文字 |
| `.btn-text` | 文字按钮：无背景无边框，蓝色文字，hover 浅蓝背景 |
| `.btn-sm` | 小尺寸：`padding: 6px 14px; font-size: 12px`（表格内操作） |
| `.btn-lg` | 大尺寸：`padding: 14px 32px; font-size: 16px`（Hero CTA） |

**状态**：hover（变浅/上浮 1px），active（加深），focus-visible（2px 蓝色 outline）

**组合使用**：`.btn-filled.btn-lg`、`.btn-text.btn-sm`

**使用位置**：课程列表页 → 箭头、课程内页 → 继续学习/下一模块、后台 → 审批/提交/详情

---

## 2. Badge — 状态标签

| 选择器 | 背景 | 文字色 | 用途 |
|--------|------|--------|------|
| `.badge` | — | — | 基础胶囊：`display:inline-block; padding:3px 12px; border-radius:9999px; font-size:11px` |
| `.badge.beginner` | `#e8f4ff` | `#1677ff` | 入门课程 |
| `.badge.intermediate` | `#ede9fe` | `#5b21b6` | 进阶课程 |
| `.badge.advanced` | `#fff3e0` | `#e65100` | 实战课程 |
| `.badge.capstone` | `#ffeaea` | `#c62828` | 微型创业 |
| `.badge.review` | `#e8f4ff` | `#1677ff` | 待审批 |
| `.badge.active-status` | `#f0fdf4` | `#22c55e` | 进行中/活跃 |
| `.badge.done` | `#f5f0ff` | `#6a1b9a` | 已完成/已结项 |
| `.badge.draft` | `#fff3e0` | `#e65100` | 草稿 |

**使用位置**：课程卡片（难度标签）、后台表格（状态标签）、成果仓库卡片

---

## 3. Dot — 圆点标记

| 选择器 | 说明 |
|--------|------|
| `.lesson-item .ldot` | 课时条目前置圆点，7px，蓝色半透明 `opacity: 0.5` |
| `.step .dot` | 步骤条圆点，36px，三种状态：默认灰/`.ok` 绿/`.on` 蓝 |
| `.status-dot` | 状态指示灯（qtclass 参考），7px，`animation: breathe` 呼吸动画 |

**使用位置**：课时条目、步骤条、状态标签

---

## 4. Icon — 图标

当前统一使用 emoji，未引入图标库。

| 使用位置 | 示例 |
|----------|------|
| 课程卡片编号 | `1` `2` `3` `4` `5`（数字） |
| 模块标题 | `📖` `🏢` `🔧` `💡` `📝` |
| 侧边栏导航项 | `📋` `🔍` `🎓` `📁` `👥` `📖` `👤` `📝` `📋` `✅` `📚` `💬` |
| 课程标签 | `🏭` `📝` `💻` `📊` `⚙️` |
| 统计卡片 | 纯数字（30px 粗体） |

---

## 5. Avatar — 头像

| 选择器 | 说明 |
|--------|------|
| `.appbar .avatar` | 32px 圆形，浅蓝背景 `#e8f4ff` + 蓝色文字 `Z`，`font-weight: 600` |

**使用位置**：AppBar 右侧

---

## 6. Connector — 连接线

| 选择器 | 说明 |
|--------|------|
| `.step .conn` | 步骤条节点间连接线，24px 宽 2px 高，默认灰 `#e8ecf2`，`.ok` 变绿 `#bbf7d0` |

**使用位置**：StepBar 步骤节点之间

---

## 7. Divider — 分割线

| 选择器 | 说明 |
|--------|------|
| `hr.divider` | `border-top: 1px solid var(--line-light)`，`margin: 20px 0` |

**使用位置**：后台双创项目管理卡片中，分隔说明文字和流程条
