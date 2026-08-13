# ROADMAP — qtclass-studio

> 从"教学管理工具"到"互动影游式课程引擎"的转型路线图。

---

## 背景：新旧方案对析

本项目现有两套架构方案并存：

### 旧实现 (`lib/`) — Flutter + 教学管理

| 维度 | 详情 |
|------|------|
| **技术栈** | Flutter (Dart) + Material Design 3 + Provider |
| **架构范式** | 企业级 CRUD：列表 → 详情 → 操作 |
| **核心模型** | `Session`（课程会话）、`Student`（学员）、`Teacher`（教师）、`AttendanceStatus`（出勤） |
| **页面** | `ScheduleScreen`（课表）、`LectureScreen`（课时详情）、`ClassroomScreen`（课堂教学） |
| **状态管理** | `ChangeNotifier` + `Provider` |
| **数据持久化** | `assets/*.json` 静态文件加载 |
| **目标用户** | 教师/教务管理者 |
| **业务域** | 课堂管理 — 排课、点名、出勤统计 |

### 新方案 (`doc/`) — HTML/CSS/JS + 互动影游

| 维度 | 详情 |
|------|------|
| **技术栈** | Vanilla HTML/CSS/JS（3 页面 SPA） |
| **架构范式** | 互动媒体播放器：时序播放 + 分支选择 + 状态机 |
| **核心模型** | `Segment`（播放片段）、`State`（运行时状态机）、`ChoiceOption`（互动选项）、`Scene`（场景容器）、`LearningRecord`（学习记录） |
| **页面** | 课程首页 / 互动播放器 / 结果总结（HTML 原型：`docs/dev-guide/prototype/`，页面规格：`doc/screens/`） |
| **状态管理** | 纯 JS 对象 + `localStorage` |
| **数据持久化** | `localStorage('qc-player-state')` + `localStorage('qc-history')` |
| **目标用户** | 学生/学习者 |
| **业务域** | 互动课程交付 — 分支叙事、学习路径、进度追踪 |

### 关键差异矩阵

```
├─ 平台选择：Flutter (全平台) ─────────────── vs ── Vanilla HTML/JS (Web 优先)
├─ 交互范式：CRUD 列表 → 详情/操作 ────── vs ── 时序播放器 + 分支选择
├─ 状态模型：Session/Student 实体 ──────── vs ── Segment/Choice 状态机
├─ 业务焦点：教务管理（排课/点名） ────── vs ── 学习体验（互动/分支/路径）
└─ 用户角色：教师 ──────────────────────── vs ── 学生
```

### 转型核心命题

旧方案解决的是"教师如何管理课堂"，新方案解决的是"学生如何体验课程"。两者不是替代关系，而是上下游关系：

```
[教师] 排课/备课 ──→ [系统] 生成课程 ──→ [学生] 互动学习
          ↑                               ↓
       旧实现 (lib/)                 新方案 (doc/)
```

ROADMAP 的核心任务是：**将 `doc/` 中的互动影游方案实现为可运行代码，并规划与 `lib/` 旧实现的融合路径**。

---

## 版本规划

### v0.1 — 互动播放器核心（当前阶段）

**目标**：将 `doc/` 中的设计方案实现为结构化的 Flutter/Dart 代码，替代 `lib/` 中的旧教学管理界面。

| 模块 | 输出 | 说明 |
|------|------|------|
| **数据模型** | `models/segment.dart`, `models/scene.dart`, `models/choice_option.dart`, `models/learning_record.dart` | 从互动播放器原型（`docs/dev-guide/prototype/`）映射 |
| **状态机** | `services/player_state.dart` | 纯 JS `state` 对象的 Dart 实现，含播放计时器、片段流转、防重复 |
| **播放舞台** | `screens/player_stage.dart` | 场景切换、字幕框、互动覆盖层、完成覆盖层 |
| **播放控制栏** | `widgets/player_controls.dart` | 进度条（可拖动）、播放/暂停、倍速切换、重播 |
| **侧边栏** | `widgets/sidebar.dart` | 学习路径（5 步阶梯）、演示控制、互动节点状态、课程脉络 |
| **互动节点** | `widgets/interaction_overlay.dart` | 选项卡片网格、选择逻辑、反馈展示、确认按钮 |
| **学习记录** | `services/history_service.dart` | localStorage 读写、历史记录恢复/删除 |
| **首页** | `screens/home_screen.dart` | 从课程详情页面规格（`doc/screens/course-detail.md` Hero 部分）映射 |
| **结果页** | `screens/result_screen.dart` | 从播放器完成覆盖层（原型 `docs/dev-guide/prototype/`）映射 |
| **数据流** | 播放器原型（`docs/dev-guide/prototype/`）→ `services/` | 片段表、状态流转图、持久化方案 |

**关键指标**：
- 播放器核心功能覆盖率 ≥ 90%（播放/暂停/进度/分支/完成）
- 所有 `doc/` 中的模型定义在代码中均有对应
- 移除旧 `sessions.json` 依赖

### v0.2 — 课程内容抽象与编辑器

**目标**：将硬编码的片段数据和互动选项抽象为可配置的 DSL/数据格式。

| 模块 | 输出 | 说明 |
|------|------|------|
| **课程定义格式** | `packages/course_definition/` | YAML/JSON Schema 描述课程结构（片段、选项、场景、分支规则） |
| **内容加载器** | `services/course_loader.dart` | 从本地/远程加载课程定义，替代 `segments` 常量 |
| **课程编辑器原型** | `screens/editor_screen.dart` | 可视化编辑片段时长、选项文案、分支规则 |
| **场景插件系统** | `widgets/scene_renderer.dart` | 场景渲染抽象，支持自定义场景组件（代码卡片、终端模拟器等） |

**关键指标**：
- 至少 1 门非原型课程可配置
- 编辑器可编辑分支逻辑并预览
- 场景渲染支持扩展

### v0.3 — 教师管理后台融合

**目标**：将新互动播放器接入旧教学管理流程，形成完整闭环。

| 模块 | 输出 | 说明 |
|------|------|------|
| **课表集成** | 改造 `ScheduleScreen` | 课表入口指向互动课程播放器 |
| **数据桥接** | `services/bridge_service.dart` | `Session` → 课程定义映射，出勤数据与学习记录关联 |
| **课堂仪表盘** | 改造 `ClassroomScreen` | 教师端实时查看学生互动进度（节点的完成率/分支分布） |
| **学习分析** | `services/analytics_service.dart` | 收集学生选择数据、耗时统计、路径偏好 |

**关键指标**：
- 教师可像以前一样排课，学生打开后进入互动播放器
- 教师可查看每次互动的学生分布数据
- 学习记录与出勤体系打通

### v0.4 — 平台化与多课程

**目标**：支持多课程、多教师、多学期，成为可部署的互动课程平台。

| 模块 | 输出 | 说明 |
|------|------|------|
| **课程目录** | `screens/catalog_screen.dart` | 课程浏览、搜索、筛选 |
| **用户系统** | `services/auth_service.dart` | 登录/注册、角色切换（教师/学生） |
| **服务端对接** | `services/api_service.dart` | 从 localStorage 升级为 RESTful API |
| **课程发布** | `screens/publish_screen.dart` | 编辑器 → 发布 → 学生可见 |

**关键指标**：
- 支持 ≥ 3 门独立课程
- 多用户数据隔离
- 服务端部署

---

## 里程碑

| 里程碑 | 版本 | 预计完成 | 交付物 |
|--------|------|----------|--------|
| M1: 互动播放器就绪 | v0.1 | 当前阶段 | 可运行的互动播放器，包含完整的播放/分支/完成闭环 |
| M2: 课程可配置 | v0.2 | 下一阶段 | 课程定义 DSL + 编辑器原型，非技术人员可配置课程 |
| M3: 教学流程打通 | v0.3 | — | 教师端与学生端数据互通，课堂仪表盘可用 |
| M4: 平台发布 | v0.4 | — | 多租户多课程平台，远程数据服务 |

---

## 代码迁移策略

`doc/` 新方案向 `lib/` 迁移时遵循以下原则：

### 新增优先，逐步替代

```
step 1: lib/ 中新增 player/ 目录，与旧 screens/ 并存
step 2: 旧界面入口指向新播放器（先路由跳转）
step 3: 旧数据模型逐步废弃，统一到新模型
step 4: 旧 screens/ 代码归档到 archive/ 目录
```

### 正交保留

旧 `lib/` 中的教学管理功能（排课、点名）**不删除**，与新播放器保持正交。两者通过桥接服务打通数据，但 UI 层各自独立。

### 目录结构规划

```
lib/
├── main.dart                        # App 入口（Provider + 路由）
├── models/                          # 数据模型
│   ├── segment.dart                 # [新] 播放片段
│   ├── scene.dart                   # [新] 场景定义
│   ├── choice_option.dart           # [新] 互动选项
│   ├── learning_record.dart         # [新] 学习记录
│   ├── session.dart                 # [旧] 课程会话（保留）
│   └── ...                          # [旧] 其他模型
├── services/                        # 业务服务
│   ├── player_state.dart            # [新] 播放器状态机
│   ├── history_service.dart         # [新] 学习记录持久化
│   ├── course_loader.dart           # [新] 课程定义加载
│   ├── bridge_service.dart          # [新] 新旧数据桥接
│   ├── app_state.dart               # [旧] Provider 状态（保留）
│   ├── data_service.dart            # [旧] JSON 加载（保留）
│   └── ...
├── screens/
│   ├── home_screen.dart             # [新] 课程首页
│   ├── player_screen.dart           # [新] 互动播放器
│   ├── result_screen.dart           # [新] 结果页
│   ├── schedule_screen.dart         # [旧] 课表（保留）
│   ├── lecture_screen.dart          # [旧] 课时详情（保留）
│   ├── classroom_screen.dart        # [旧] 课堂管理（保留）
│   └── ...
├── widgets/                         # 可复用组件
│   ├── player_controls.dart         # [新] 播放控制栏
│   ├── sidebar.dart                 # [新] 侧边栏
│   ├── interaction_overlay.dart     # [新] 互动覆盖层
│   ├── scene_renderer.dart          # [新] 场景渲染器
│   └── ...
└── archive/                         # [未来] 归档旧代码
    └── ...
```

---

## 决策日志

| 日期 | 决策 | 理由 |
|------|------|------|
| 当前 | `doc/` 方案优先实现，`lib/` 保留不动 | 正交分解原则：新交互范式不与旧管理范式耦合 |
| 当前 | 播放器先实现为独立页面，不嵌入旧界面 | 减少迁移风险，先验证播放器体验 |
| 当前 | 状态机使用 `ChangeNotifier` 而非 `Bloc` | 与旧 `Provider` 体系保持一致，降低学习成本 |
| 当前 | 场景渲染使用组合模式（`Widget` 树）而非 `CustomPainter` | 需要频繁调整文案和结构，组合模式更易维护 |
