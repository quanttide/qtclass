# 量潮课堂 · 创新系统原型 — 文档索引

> 版本 v0.12 | 最后更新 2026-08-07
>
> 线上原型：[zzz-qwq.github.io/innovation-system-prototype](https://zzz-qwq.github.io/innovation-system-prototype/)

---

## 内容层级

```
Course（课程）
  └── Stage（阶段）
       └── Lesson（课时）
```

| 层级 | 说明 | 示例 |
|------|------|------|
| Course | 一门完整课程，含阶段列表和元信息 | 知识工作 / 氛围编程 / 大数据导论 / 数据工程 / 生产实习 |
| Stage | 课程中的一个学习阶段，含课时列表 | "信息检索基础" / "文档整理规范" |
| Lesson | 阶段中的具体课时条目 | "搜索引擎高级技巧"（阅读 10 min） |

---

## 屏幕清单

| 顺序 | 屏幕 | 视图 ID | HTML 原型 | MD 文档 |
|------|------|---------|-----------|---------|
| 1 | 课程列表页 | `view-courses` | [course-list.html](screens/course-list.html) | [course-list.md](screens/course-list.md) |
| 2 | 课程首页 | `view-front` / `view-generic` (overview) | [course-home.html](screens/course-home.html) | [course-home.md](screens/course-home.md) |
| 3 | 课程内页 | `view-front` / `view-generic` (module) | [course-detail.html](screens/course-detail.html) | [course-detail.md](screens/course-detail.md) |
| 4 | LMS 管理后台 | `view-back` | [backend-lms.html](screens/backend-lms.html) | [backend-lms.md](screens/backend-lms.md) |

---

## 数据模型

| 模型 | 文件 |
|------|------|
| Course / Stage / Lesson / Progress / AppState / StepBar / ModulePanel / SideNav / Pipeline | [course.md](models/course.md) |

---

## 文档格式说明

仿照 [qtclass](https://github.com/quanttide/qtclass/tree/main/src/studio/doc) 文档体系，每屏两文件：

- **`.html`** — 纯静态视觉原型（HTML + CSS），展示界面长什么样
- **`.md`** — 结构化文档规格：页面定位 → ASCII 结构图 → 组件清单（含选择器）→ 交互表 → 数据模型 → 状态机 → 设计原则

---

## 相关链接

- 产品原型：[zzz-qwq.github.io/innovation-system-prototype](https://zzz-qwq.github.io/innovation-system-prototype/)
- GitHub 仓库：[github.com/Zzz-qwq/innovation-system-prototype](https://github.com/Zzz-qwq/innovation-system-prototype)
- 参考项目：[qtclass — quanttide/qtclass](https://github.com/quanttide/qtclass)
