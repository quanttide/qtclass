# ListView — 列表容器

通用纵向列表容器，承载多个 Item，支持分隔线和滚动。

## 使用场景

| 场景 | 选择器 | 说明 |
|------|--------|------|
| 课程卡片列表 | `.card-grid` | 课程列表页，纵向排列，`max-width: 700px` 居中 |
| 课时列表 | `.card` > `.lesson-item` × N | 课程内页，每个 lesson-item 之间 `border-bottom` 分割 |
| 统计卡片行 | `.stat-row` | 后台概览，横向排列（非纵向），stat-card 均分 |
| 导航子项列表 | `.nav-kids` | 后台侧边栏，可折叠，`max-height` 过渡动画 |
| 选项网格 | `.option-grid` | 互动覆盖层，3 列 grid（qtclass 参考） |

## 通用结构

```
+-- .list-container --+
|                      |
|  [Item #1]           |
|  ───────── (分割线)   |
|  [Item #2]           |
|  ─────────            |
|  [Item #3]           |
|                      |
+----------------------+
```

## 变体

| 变体 | 方向 | 间距 | 滚动 |
|------|------|------|------|
| 纵向列表 | `flex-direction: column` | `gap: 12px` | 父容器 `overflow-y: auto` |
| 横向列表 | `flex-direction: row` | `gap: 16px` | 父容器 `overflow-x: auto` |
| 网格列表 | `display: grid; grid-template-columns: repeat(3, 1fr)` | `gap: 12px` | 响应式断点切换列数 |

## 关键 CSS

```css
.list-v {
  display: flex; flex-direction: column; gap: 8px;
}
.list-h {
  display: flex; flex-direction: row; gap: 16px;
  overflow-x: auto;
}
.list-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 12px;
}
```
