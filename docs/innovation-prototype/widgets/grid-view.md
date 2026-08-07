# GridView — 网格容器

通用网格布局容器，以卡片网格形式展示内容。**（待建设）**

## 规划使用场景

| 场景 | 说明 |
|------|------|
| 成果仓库卡片 | 后台成果仓库，项目卡片网格 `display:flex;gap:16px;flex-wrap:wrap` |
| 课程研发卡片 | 后台课程研发，内容卡片并排展示 |
| 互动选项网格 | 3 列选项卡片（qtclass 参考 `.option-grid`） |

## 暂不实现

当前原型中网格布局通过简单的 `display:flex; flex-wrap:wrap` 实现，等后续场景复杂度提升后再抽象为独立 GridView 组件。
