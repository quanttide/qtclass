# 量潮课堂 · 创新系统原型 — 文档索引

> 版本 v0.12 | 最后更新 2026-08-07

---

## 内容层级

```
Course（课程）
  └── Lesson（课时）
       └── Scene（场景，嵌套在课时页面内）
```

| 层级 | 说明 | 示例 |
|------|------|------|
| Course | 一门完整课程，含课时列表和元信息 | 知识工作 / 氛围编程 / 大数据导论 / 数据工程 / 生产实习 |
| Lesson | 课程中的直接课时单元 | "搜索引擎高级技巧"（阅读 10 min） |
| Scene | 课时内的互动场景，通过分支选项串联 | intro / lecture / quiz / summary |

---

## 屏幕清单（3 屏）

| 顺序 | 屏幕 | 视图 ID | HTML 原型 | MD 文档 |
|------|------|---------|-----------|---------|
| 1 | 课程列表页 | `view-courses` | [course-list.html](screens/course-list.html) | [course-list.md](screens/course-list.md) |
| 2 | 课程详情页 | `view-front` / `view-generic` | [course-detail.html](screens/course-detail.html) | [course-detail.md](screens/course-detail.md) |
| 3 | LMS 管理后台 | `view-back` | [backend-lms.html](screens/backend-lms.html) | [backend-lms.md](screens/backend-lms.md) |

> 课程详情页包含**课程首页（Hero）**和**课时列表**两个区域，合为一个页面。

---

## 数据模型

| 模型 | 文件 |
|------|------|
| Course / Lesson / Scene / Progress / AppState / StepBar / LessonPanel / SideNav / Pipeline | [course.md](models/course.md) |

---

## 组件规格（Widgets）— 6 类 30 组件

| 分类 | 文件 | 包含组件 |
|------|------|----------|
| 🔹 Atoms 原子 | [atoms.md](widgets/atoms.md) | Button、Badge、Dot、Icon、Avatar、Connector、Divider |
| 🔸 Items 条目 | [items.md](widgets/items.md) | CourseCard、LessonItem、NavItem、StatCard、TimelineItem、PipelineStage |
| 🔷 Containers 容器 | [containers.md](widgets/containers.md) | Card、Section、TwoCol、CourseHero、ModulePanel、PageHeader、Workspace、FormRow |
| 🧭 Navigation 导航 | [navigation.md](widgets/navigation.md) | AppBar、SideNav、StepBar、BackLink、Pipeline |
| 📝 Forms 表单 | [forms.md](widgets/forms.md) | FormGroup、Input、Textarea、Select、Radio |
| 🔔 Feedback 反馈 | [feedback.md](widgets/feedback.md) | Toast、ProgressBar、Overlay（待实现）、Dialog（待实现） |

---

## 文档格式说明

仿照 [qtclass](https://github.com/quanttide/qtclass/tree/main/src/studio/doc) 文档体系，每屏两文件：

- **`.html`** — 纯静态视觉原型（HTML + CSS），展示界面长什么样
- **`.md`** — 结构化文档规格：页面定位 → ASCII 结构图 → 组件清单（含选择器）→ 交互表 → 数据模型 → 状态机 → 设计原则

---

## 相关链接

- GitHub 仓库：[quanttide/qtclass](https://github.com/quanttide/qtclass)
- 参考项目：[qtclass/studio/doc](https://github.com/quanttide/qtclass/tree/main/src/studio/doc)
