# Item — 列表条目

通用列表条目组件，用于课程卡片、课时条目、侧边栏导航项等。

## 使用场景

| 场景 | 选择器 | 说明 |
|------|--------|------|
| 课程卡片 | `.course-card` | 课程列表页，含编号圆+课程名+描述+标签+箭头 |
| 课时条目 | `.lesson-item` | 课程内页，含圆点+标题+右侧时长标签 |
| 侧边栏导航项 | `.nav-item` | 后台侧边栏，含 emoji+文字，`.sub` 缩进变体 |
| 时间线节点 | `.timeline-item` | 审批中心，含 `::before` 圆点+时间戳+事件描述 |
| 路径步骤 | `.path-step` | 播放器侧边栏（qtclass 参考），含圆点+标签+连线 |

## 通用结构

```
+-- .item-container -----------------------------------+
|                                                       |
|  [icon / number / dot]  标题文字        [badge / tag]  |
|                          副标题/描述                   |
|                                                       |
+-------------------------------------------------------+
```

## 状态

| 状态 | 类名 | 视觉 |
|------|------|------|
| 默认 | — | 灰色圆点/编号，正常文字 |
| 当前 | `.on` / `.current` / `.active` | 蓝色圆点+发光，蓝色加粗文字 |
| 已完成 | `.ok` / `.done` | 绿色背景+白色✓，绿色文字 |
| 禁用 | `.placeholder` | 灰色半透明，不可点击 |
| hover | `:hover` | 浅蓝背景，右移 4px，阴影加深 |

## 关键 CSS

```css
.item { 
  display: flex; align-items: center; gap: 12px;
  padding: 12px 16px; border-radius: 8px;
  cursor: pointer; transition: all .15s;
}
.item:hover { background: var(--brand-soft); }
.item.current { background: var(--brand-soft); color: var(--brand); font-weight: 600; }
.item.done { color: var(--success); }
```
