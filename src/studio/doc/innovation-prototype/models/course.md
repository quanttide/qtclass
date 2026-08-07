# 核心数据模型

量潮课堂 LMS 的数据模型体系。所有模型定义来源于 `index-v0.12.html` 中的业务逻辑。

---

## 1. Course — 课程

一门完整的课程，包含阶段列表和元信息。课程 1-4 定义在 `COURSES` 对象中，课程 5 硬编码在 HTML。

| 字段 | 类型 | 说明 |
|------|------|------|
| `name` | `string` | 课程名称（如"知识工作"） |
| `icon` | `string` | 课程图标（emoji） |
| `badge` | `string` | 难度标签文字（"入门"/"进阶"/"实战"） |
| `badgeClass` | `string` | 难度标签 CSS 类（`beginner`/`intermediate`/`advanced`） |
| `next` | `string` | 下一门课程的 ID（用于跨课串联，`prod` 为空） |
| `nextName` | `string` | 下一门课程的显示名称 |
| `desc` | `string` | 课程描述（1-2 句） |
| `meta` | `string` | 元信息字符串（"📚 4 个阶段 · ⏱ 预计 1 周 · 👤 56 人在学"） |
| `lessons` | `Lesson[]` | 课时列表 |

### 课程阶梯

| ID | 课程名 | 课时数 | 下一门 |
|----|--------|--------|--------|
| `knowledge-work` | 知识工作 | 12 | `vibe-coding` |
| `vibe-coding` | 氛围编程 | 12 | `big-data` |
| `big-data` | 大数据导论 | 12 | `data-engineering` |
| `data-engineering` | 数据工程 | 12 | `prod` |
| `prod` | 生产实习 | 20 | - |

---

## 2. Lesson — 课时

课程中的直接子单元。步骤条上每个节点对应一个课时。

| 字段 | 类型 | 说明 |
|------|------|------|
| `t` | `string` | 课时标题（如"搜索引擎高级技巧"） |
| `d` | `string` | 资源类型 + 时长（如"阅读 10 min"） |
| `desc` | `string` | 课时描述（模块卡片副标题） |
| `done` | `boolean` | 是否已完成（当前全部为 `false`，内容待建设） |

---

## 3. Scene — 场景（嵌套在课时内）

互动式学习场景，是课时页面的核心播放单元。一个课时可包含多个场景，场景间通过分支选项串联。

| 字段 | 类型 | 说明 |
|------|------|------|
| `key` | `string` | 场景渲染标识（如 `intro` / `lecture` / `quiz` / `summary`） |
| `type` | `string` | 场景类型（主线 / 分支） |
| `duration` | `number` | 播放时长（秒） |
| `caption` | `string` | 底部字幕文案 |
| `nextScene` | `string\|null` | 下一场景 ID，`null` 表示课时结束 |

---

## 4. Progress — 学习进度

保存在 `localStorage` 中的进度记录。每次 `showModule()` 或 `genShowModule()` 调用时自动更新。

| 字段 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `max` | `number` | `0` | 已完成的最大课时序号 |
| `last` | `string` | `undefined` | 最后访问的课时 ID（如 `"m3"` 或 `"s2"`） |

### 存储键

| 课程 | 存储键 |
|------|--------|
| 生产实习 | `qt-progress-prod` |
| 知识工作 | `qt-progress-knowledge-work` |
| 氛围编程 | `qt-progress-vibe-coding` |
| 大数据导论 | `qt-progress-big-data` |
| 数据工程 | `qt-progress-data-engineering` |

**关键规则**：
- `last` 为 `undefined` 时认为用户是首次访问，显示课程首页
- `max` 只增不减——用户回到之前的课时不会降低 max
- 每门课独立存储，互不干扰

---

## 5. AppState — 运行时状态

全局运行时状态，驱动所有 UI 变化。未显式声明默认值的字段初始为 `undefined`/`false`。

| 字段 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `currentView` | `string` | `'courses'` | 当前显示的视图（`courses`/`front`/`generic`/`back`） |
| `currentCourse` | `string` | `null` | 课程 1-4 的 ID（`knowledge-work` 等），`null` 表示不在课程内页 |
| `currentLesson` | `string` | `null` | 当前课时 ID（`m1`-`m5` 或 `s1`-`s4`），`'overview'` 表示课程首页 |
| `genCourseId` | `string` | `null` | 通用课程视图的课程 ID，用于 `continueGen()` 和步骤条渲染 |
| `sidebarFolded` | `object` | `{lms:false,form:false,rel:false}` | 后台侧边栏各分组的折叠状态 |

### 视图流转

```
[课程列表] → 点击课程卡片
  ├── 课程1-4 → [课程首页 (generic)]
  │              └── 点击"开始学习" → [阶段1] → [阶段2] → [阶段3] → [阶段4]
  │                                      └── 点击"→ 进入下一课程" → [下一门课首页]
  │
  └── 课程5 → [课程首页 (front)]
               └── 点击"继续学习" → [模块1] → [模块2] → [模块3] → [模块4] → [模块5]
                                       └── 点击"✓ 提交申报" → [完成]

[任意前台页] ──点击"LMS 管理后台"──→ [后台概览]
[后台] ──点击"学习前台"──→ [课程列表]
[后台] ──点击侧边栏菜单──→ 滚动到对应卡片
```

**关键规则**：
- `currentView === 'generic'` 时 `genCourseId` 必须非空
- 切换到后台时清除所有菜单高亮，切换到前台时恢复
- 课时切换时自动调用 `saveProgress()`，下次进入时恢复进度
- 课程首页通过 `overview` 面板显示，此时步骤条隐藏

---

## 6. StepBar — 步骤条 (DOM)

横向步骤导航组件，显示课程课时列表和当前进度。两个实例：`#stepbar`（生产实习）和 `#gen-stepbar`（课程 1-4）。

| 属性 | 说明 |
|------|------|
| 容器 | `.steps`，`display:flex;justify-content:center`，含回退链接 `.bs` 和步骤行 `.row` |
| 步骤节点 | `.step`，含 `.dot`（圆点）和 `.lbl`（标签） |
| 连接线 | `.conn`，步骤节点之间的横线 |
| CSS `.ok` | 已完成步骤：绿底白勾 + 绿色标签 |
| CSS `.on` | 当前步骤：蓝底白字 + 外发光 + 蓝色标签 |
| 默认状态 | 灰底灰字，未激活 |

### 步骤状态对照

| 状态 | `.dot` 样式 | `.lbl` 样式 | `.conn` 样式 |
|------|-----------|-----------|------------|
| 已完成 (i < cur) | `.ok`：绿底 `✓` | `.ok`：绿色 | `.ok`：绿色 |
| 当前 (i === cur) | `.on`：蓝底白字，`box-shadow` 发光 | `.on`：蓝色 | 默认灰色 |
| 未完成 (i > cur) | 默认：灰底灰字 | 默认：灰色 | 默认灰色 |

### 步骤依赖关系

```
课程首页 (overview)
   └── 课时1 (m1/s1) ──conn──→ 课时2 (m2/s2) ──conn──→ ... ──→ 最后课时
```

每个节点可点击跳转，最后课时底部显示"→ 进入下一课程"（课程 1-4）或"✓ 提交申报"（生产实习）。

---

## 7. LessonPanel — 课时面板 (DOM)

课时内容容器，一次仅显示一个面板。通过 `.module-panel` + `.show` 切换。

| 属性 | 说明 |
|------|------|
| CSS `.module-panel` | `display:none`，默认隐藏 |
| CSS `.module-panel.show` | `display:block`，当前激活面板 |
| 课程首页 | `#mod-overview` / `#gen-mod-overview`，显示课程 Hero |
| 课时内容 | `#mod-m1` ~ `#mod-m5` / `#gen-mod-s1` ~ `#gen-mod-s4` |
| 咨询表单 | `#mod-consult`，特殊面板，不触发步骤条 |

**关键规则**：
- 同一时刻只有一个 `.module-panel.show`
- 切换到 `overview` 或 `consult` 时隐藏步骤条
- 切换到课时面板时显示步骤条并调用 `updateStepBar()` / `genUpdateStepBar()`

---

## 8. SideNav — 侧边栏导航 (DOM)

后台 LMS 管理页面的左侧导航，三个可折叠分组。

| 属性 | 说明 |
|------|------|
| 容器 | `.sidenav`，220px 宽，白色背景 |
| 分组 | `.nav-group`，含 `.nav-label`（标题，可点击折叠）和 `.nav-kids`（子项容器） |
| 箭头 | `.arr`，`▼` 展开态，`.folded` 旋转 -90° 变 `▶` |
| 子项容器 | `.nav-kids`，通过 `max-height` 过渡动画折叠 |
| CSS `.folded` | `max-height:0!important`，完全折叠 |
| 导航项 | `.nav-item`，含 `.sub`（32px 缩进）和 `.placeholder`（灰色不可点击）变体 |
| CSS `.active` | 当前选中项，蓝色背景 + 蓝色文字 |

### 分组结构

```
▼ LMS · 学习管理
  📋 课题管理        (.nav-item，可点击跳转)
  🔍 审批中心
  🎓 双创项目管理
  📁 成果仓库
  👥 成员管理
  📖 课程管理
  👤 学员管理

▼ 表单配置
  📝 立项申请表      (.nav-item.sub，缩进 32px)
  📋 阶段报告模板
  ✅ 验收评审表

▼ 关联系统
  📚 课程研发        (.nav-item.sub)
  💬 咨询/工单
```

### 点击行为

所有非 `.placeholder` 的 `.nav-item` 点击时调用 `scrollToCard(id)`：切换到 `view-back` → 高亮当前项 → 平滑滚动到目标卡片。

---

## 9. Pipeline — 流程条 (DOM)

双创项目管理卡片中的五阶段微型创业流程。

| 属性 | 说明 |
|------|------|
| 容器 | `.pipeline`，`display:flex`，等宽分布 |
| 阶段节点 | `.stage`，`flex:1`，节点之间用 `::after` 伪元素渲染 `→` |
| 图标圆 | `.icon`，44px 圆形，浅灰背景 |
| 名称 | `.name`，12px 粗体 |
| 说明 | `.hint`，11px 灰色，1.5 行高 |

### 五阶段

| 顺序 | 图标 | 名称 | 说明 |
|------|------|------|------|
| 1 | 💡 | 发现盲区 | 学员基于课程上下文找到公司可能感兴趣但还没做的方向 |
| 2 | 📝 | 提交立项 | 填写立项申请表，说清楚发现了什么、打算怎么做 |
| 3 | 🔍 | 总部审批 | 评估方向匹配度，分配资源支持等级 |
| 4 | 🚀 | 2 周执行 | 自由组队或个人，做出最小可行 demo |
| 5 | 🎤 | Sale 给总部 | 向管理层展示成果，同一套标准打分 |

---

## 10. 数据持久化方案

| 存储键 | 存储内容 | 生命周期 |
|--------|----------|----------|
| `qt-progress-prod` | 生产实习进度（max, last） | 持久保留，用户可手动清除 |
| `qt-progress-knowledge-work` | 知识工作进度 | 持久保留 |
| `qt-progress-vibe-coding` | 氛围编程进度 | 持久保留 |
| `qt-progress-big-data` | 大数据导论进度 | 持久保留 |
| `qt-progress-data-engineering` | 数据工程进度 | 持久保留 |

所有进度数据通过 `saveProgress(courseId, moduleId)` 写入，`getProgress(courseId)` 读取。最多保留 5 条记录（每门课一条），无上限限制。