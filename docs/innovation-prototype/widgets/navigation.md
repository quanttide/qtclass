# Navigation — 导航组件

帮助用户在页面之间和页面内部移动的导航结构。

---

## 1. AppBar — 顶部导航栏

| 属性 | 值 |
|------|-----|
| 选择器 | `.appbar` |
| 高度 | 56px |
| 定位 | `position: sticky; top: 0; z-index: 100` |
| 背景 | `rgba(255,255,255,.85)` + `backdrop-filter: blur(12px)` |
| 内边距 | `padding: 0 32px` |

**子元素**：

| 子元素 | 选择器 | 说明 |
|--------|--------|------|
| Logo | `.appbar .logo` | 可点击：`.icon`（蓝渐变小方块 30px）+ 文字 "量潮课堂 · LMS" |
| 视图切换 | `#switch-btns` | 两个 button："🏠 学习前台" / "⚙ LMS 管理后台"，首尾相接 `.active` 蓝色高亮 |
| 元信息 | `.appbar .meta` | 版本号 `v0.12 · MD` + Avatar 头像 `Z` |

**行为**：Logo 点击 → `showCourseList()`，前台按钮 → `showCourseList()`，后台按钮 → `switchView('back')`

**使用位置**：所有页面全局置顶

---

## 2. SideNav — 侧边栏导航

| 属性 | 值 |
|------|-----|
| 选择器 | `.sidenav` |
| 宽度 | 220px |
| 背景 | `#f5f9fc` |
| 边框 | 右侧 `1px solid var(--line)` |

**子元素层级**：

```
.sidenav
  └── .nav-group (padding: 0 16px, margin-bottom: 16px)
       ├── .nav-label (分组标题，可点击折叠)
       │    └── .arr (箭头 ▼/▶，.folded 旋转 -90°)
       └── .nav-kids (子项容器，max-height 过渡)
            └── .nav-item (见 items/NavItem)
```

**三个分组**：

| 分组 | ID | 折叠态 |
|------|-----|--------|
| LMS · 学习管理 | `kids-lms` | 默认展开 `max-height:500px` |
| 表单配置 | `kids-form` | 默认展开 `max-height:300px` |
| 关联系统 | `kids-rel` | 默认展开 `max-height:200px` |

**折叠行为**：点击 `.nav-label` → `toggleNav(id)` → 切换 `.folded` 类 + 箭头旋转

**使用位置**：后台管理页面左侧

---

## 3. StepBar — 横向步骤条

| 属性 | 值 |
|------|-----|
| 选择器 | `.steps` / `.stepbar` |
| 布局 | `display: flex; align-items: center; justify-content: center` |
| 背景 | `#f5f9fc`，圆角 14px |
| 内边距 | `padding: 18px 32px` |

**子元素**：

| 子元素 | 选择器 | 说明 |
|--------|--------|------|
| 回退链接 | `.steps .bs` | "← 课程首页"，13px 灰色，hover 变蓝 |
| 步骤行 | `.steps .row` | flex 横向排列 `.step` 节点 |
| 步骤节点 | `.step` | 可点击，`.dot`（36px 圆）+ `.lbl`（13px 粗体标签） |
| 连接线 | `.conn` | 节点间 24px 横线 |

**两个实例**：

| 实例 | ID | 步骤数 | 步骤 ID 格式 |
|------|-----|--------|-------------|
| 生产实习 | `#stepbar` | 5 | `m1`-`m5` |
| 通用课程 | `#gen-stepbar` | 4 | `s1`-`s4`（动态生成） |

**显示/隐藏**：课程首页 `overview` 时隐藏，进入课时面板时显示

**使用位置**：课程详情页，Hero 下方

---

## 4. BackLink — 返回链接

| 属性 | 值 |
|------|-----|
| 选择器 | `.back-link` |
| 样式 | `display: inline-flex`，蓝色文字 13px，`padding: 7px 14px`，圆角 6px |
| 文字 | "← 返回课程列表" |

**行为**：点击 → `showCourseList()`

**状态**：hover 浅蓝背景

**使用位置**：课程详情页顶部

---

## 5. Pipeline — 横向流程条

| 属性 | 值 |
|------|-----|
| 选择器 | `.pipeline` |
| 布局 | `display: flex`，等宽分布，`gap: 0` |

**子元素**：`.stage`（见 items/PipelineStage），节点间 `::after` 渲染 `→`

**五阶段固定内容**：

| 顺序 | 图标 | 名称 | 说明 |
|------|------|------|------|
| 1 | 💡 | 发现盲区 | 学员基于课程上下文找到方向 |
| 2 | 📝 | 提交立项 | 填写申请表 |
| 3 | 🔍 | 总部审批 | 评估匹配度+分配资源 |
| 4 | 🚀 | 2 周执行 | 做出最小可行 demo |
| 5 | 🎤 | Sale 给总部 | 展示成果+标准打分 |

**使用位置**：后台双创项目管理卡片
