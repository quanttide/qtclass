# 课程列表页（展示 · course-list）

量潮课堂客户端的课程列表展示页，系统默认入口，展示五门课程的阶梯式导航。视觉形态对应实验室原型课程列表页（`view-courses`），去掉前台/后台切换，专注课程浏览入口。

## 页面定位

- **路由**: `/`（客户端首页）
- **状态**: 独立页面，点击课程卡片跳转 `course-detail.html`
- **数据依赖**: 课程数据来自 qtcloud-course 供给（本地 assets JSON 或服务端），生产实习卡片可根据 `localStorage('qt-progress-prod')` 显示进度
- **来源**: 实验室原型 [course-list.md](https://github.com/quanttide/quanttide-laboratory-of-course-development/blob/main/innovation-prototype/screens/course-list.md)，视觉原型见 [prototype.html](https://quanttide.github.io/quanttide-laboratory-of-course-development/innovation-prototype/prototype.html)

## 页面结构

```
+-- AppBar (sticky, 56px) ----------------------------------------------+
|  [~ 量潮课堂]                                           v0.12      Z |
+-----------------------------------------------------------------------+

                              +- page-header -+
                              |                |
                              |  量潮课堂·实训基地  |
                              |  从基础到实战，五门  |
                              |  课程形成一条完整的  |
                              |  成长阶梯           |
                              |       💬 一对一咨询  |
                              +----------------+

                    +- card-grid (max-width: 700px) -+
                    |                                 |
                    |  +- course-card --------------+  |
                    |  | ① | 知识工作    [入门] ->  |  |
                    |  |   从整理文档开始，建立...   |  |
                    |  +----------------------------+  |
                    |  ...（② 氛围编程 ③ 大数据导论    |
                    |       ④ 数据工程 ⑤ 生产实习）    |
                    +---------------------------------+
```

## 组件清单

### 顶层布局

| 组件 | 选择器/ID | 说明 |
|------|-----------|------|
| 应用导航栏 | `.appbar` | sticky top-0，56px，毛玻璃背景，品牌 Logo + 版本号 + 头像 |
| logo | `.appbar .logo` | "~ 量潮课堂"，点击回到课程列表 |
| 元信息 | `.appbar .meta` | 版本号 + 头像圆（qtcloud-learn 登录态头像） |
| 海浪背景 | `.bg-atmo` | 固定定位，径向发光 + SVG 波浪，纯装饰 |
| 工作区 | `#workspace` | flex 容器，`height: calc(100vh - 56px)` |

### 课程列表

| 组件 | 选择器/ID | 说明 |
|------|-----------|------|
| 页面容器 | `.courses-page` | `max-width: 900px`，居中，上下 60px 内边距 |
| 页面标题 | `.page-header` | 居中对齐，`h1` 标题 + `.desc` 描述文字 |
| 咨询入口 | `a[href]` | 蓝色文字链接 `💬 一对一咨询`，跳转到课程详情咨询区块 |
| 卡片网格 | `.card-grid` | 纵向排列，`max-width: 700px` 居中，`gap: 12px` |
| 课程卡片 | `.course-card` | 横向 flex，编号圆 + 课程信息 + 难度标签 + 入口箭头 |
| 编号圆 | `.cc-num` | 44px 圆，默认灰色，`.active-card` 下蓝色 |
| 难度标签 | `.badge` | 胶囊形，4 种变体：`.beginner` / `.intermediate` / `.advanced` / `.capstone` |

### 卡片状态

| 状态 | 触发条件 | 视觉 |
|------|---------|------|
| 默认 | 所有课程卡片 | 白色卡片，灰色编号圆，`box-shadow: 0 1px 3px` |
| `.active-card` | 当前可在学课程（课程 1-4） | 编号圆变蓝底白字 |
| `:hover` | 鼠标悬停 | 边框变蓝，`translateX(4px)`，`box-shadow` 加深 |

## 交互与导航

| 交互 | 触发条件 | 行为 |
|------|---------|------|
| 点击课程 1-4 | 知识工作 / 氛围编程 / 大数据导论 / 数据工程 | 跳转 `course-detail.html?course=<id>`（通用课程详情） |
| 点击课程 5 | 生产实习 | 跳转 `course-detail.html?course=prod`（生产实习详情） |
| 点击 Logo | AppBar 品牌区 | 回到课程列表（详情页返回入口之一） |
| 点击"一对一咨询" | 页面标题下方链接 | 跳转到对应课程的咨询表单区块 |

## 数据模型

课程数据由 qtcloud-course 制作、供给客户端展示（详见实验室 [course.md](https://github.com/quanttide/quanttide-laboratory-of-course-development/blob/main/innovation-prototype/models/course.md)）：

```javascript
// Course（展示字段）
{ id, name, icon, badge, badgeClass, desc, meta,
  stages: [{ name, lessons: [{ title, duration }] }] }
```

客户端按 `id` 路由到课程详情页，`qt-progress-<courseId>` 进度键由详情页读写。

## 设计原则

1. **阶梯感** — 编号 ①-⑤ 暗示从基础到进阶的学习路径，每门课是下一门的前置
2. **低门槛** — 五门课全部可点击进入，内容待建设的课程也保持入口可用
3. **进度感知** — 生产实习卡片蓝色高亮（`.active-card`），其余课程 hover 有反馈
4. **悬浮装饰** — 海浪 SVG + 径向发光背景，营造"海岸"品牌氛围但不干扰内容

## 状态机

```
[客户端启动] --> [课程列表]
                    |
                    +-- 点击课程 1-4 --> [course-detail · 通用]
                    +-- 点击课程 5 -----> [course-detail · 生产实习]
                    +-- 返回 <----------+
```
