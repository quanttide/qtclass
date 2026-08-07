# Feedback — 反馈组件

向用户传达状态、进度和操作结果。

---

## 1. Toast — 轻提示

| 属性 | 值 |
|------|-----|
| 选择器 | `.toast` |
| 定位 | `position: fixed; left: 50%; bottom: 28px; transform: translateX(-50%)` |
| 样式 | `padding: 10px 14px`，黑色背景 `#171717`，白色文字 12px，圆角 999px |

**状态**：
| 状态 | 触发 | 视觉 |
|------|------|------|
| 隐藏 | 默认 | `opacity: 0`，`transform: translate(-50%, 18px)` |
| 显示 | `.toast.visible` | `opacity: 1`，`transform: translate(-50%, 0)`，自动 1.8s 后隐藏 |

**函数**：`showToast(message)` → 设置文字 → 添加 `.visible` → `setTimeout` 移除

**使用场景**：保存记录成功、重置进度、跳转提示、课程待上线提醒

---

## 2. ProgressBar — 进度条

| 属性 | 值 |
|------|-----|
| 选择器 | `.progress-bar` |
| 轨道 | `height: 5px`，`border-radius: 3px`，`background: rgba(22,119,255,.12)` |
| 填充 | `.progress-bar .fill`，`height: 100%`，蓝色背景，`border-radius: 3px` |

**宽度动态更新**：`fill.style.width = pct + '%'`

| 课程 | 进度来源 | 示例值 |
|------|---------|--------|
| 生产实习 | `localStorage.progress-prod.last` → m1=20%, m2=40%, m3=60%, m4=80%, m5=100% | `width: 20%` |
| 通用课程 | `localStorage.progress-{id}.max / stages.length` | `width: 50%` |

**使用位置**：课程详情页 Hero 卡片内

---

## 3. Overlay — 覆盖层（qtclass 参考）

当前产品中尚未独立实现，但在 qtclass 播放器中有完整参考（互动覆盖层、完成覆盖层、确认覆盖层）。

| 覆盖层 | 选择器 | 说明 |
|--------|--------|------|
| 互动覆盖层 | `#interactionOverlay` | 毛玻璃背景 + 选项卡片 + 确认按钮 |
| 完成覆盖层 | `#finishOverlay` | 半透明白色 + 完成动画 + 结果卡片 |
| 历史覆盖层 | `#historyOverlay` | 历史记录列表 |
| 确认覆盖层 | `#confirmOverlay` | 保存进度确认弹窗 |

**待实现**：LMS 原型中模块 5 提交、审批通过/驳回、删除确认等场景可用

---

## 4. Dialog — 对话框（qtclass 参考）

通过 `alert()` 实现简单的提示弹窗（当前原型中课时条目点击时使用）。

**待实现**：Modal 组件，用于审批确认、删除确认、保存草稿提示等场景。
