# ROADMAP — qtclass-lite

> 定位：**学员节拍器**——学员的被动端（WorkBuddy 模式）。首屏就是任务卡，无选择、无导航、无配置。三端分工总纲见仓库根 [ROADMAP.md](../../ROADMAP.md)。

## 定位

学员不该有"选课、逛课表"的自由度——淘汰赛的本质是被安排。lite 与 qtcloud lite 同构：打开首屏是一张任务卡（今天的作业、下一关交付物），交互只有交、看反馈、打卡。学员打开小程序不需要任何决策，做完推的就走。

一天实况：教师在 studio 派了需求卡 → 学员打开 lite，首屏"周五前交门店清洗 demo" → 交完，教师在 studio 批注"需求理解错，重做" → lite 首屏次日变成"重做：先交需求澄清文档"。

## 前置

- studio v0.2（教学现场最小闭环）：没有 studio 派任务，lite 首屏是空的
- [provider](../provider/ROADMAP.md) 任务链路（依赖学习云任务模型重建）

前置未就绪期间不立项。壳晚一步不伤筋骨。

## 首版范围（v0.1）

- [ ] 任务卡首屏：今日任务、截止、提交入口
- [ ] 反馈查看：教师评语、通过/退回状态
- [ ] 登录：复用 studio 已接的 qtcloud-auth
- [ ] 内容首迁：site `data/learning/tasks/` 10 篇任务书迁入本 scope，成为任务卡的首批载荷（分流决策见 [site ROADMAP](../site/ROADMAP.md)）

明确不做：选课、课表浏览、课程目录、任何配置项。学员的主动查询需求先不满足，全部以推送形态出现。

### v0.2 — 反馈单元序列（任务载荷扩展）

任务卡的载荷从"提交一个交付物"扩展到"走完一串反馈单元"。影游路线按此口径回收：它不是独立功能，是任务的一种货。

- 单元四件套：小需求、学员动作（选/说/写）、判定、反馈——判定和反馈当场给，学员每做一小步被纠一次
- lite 端播放器自建（Taro），不搬 studio 的 Flutter 代码——跨端共享的是数据契约与页面规格，不是代码；studio 侧保留预览能力，两端各持一份实现
- AI 工位：学员自由作答的判定与反馈由 AI 承担（预制反馈覆盖不了的部分）；单元的作答与反馈数据同时是淘汰赛与教学改进的凭据
- 数据归置：分解表（单元结构+反馈语）归课程云，学员单元轨迹归学习云，经 provider 的 criteria/completion 通道回写——每个单元挂一条 criterion，零新管道
- 素材源：qtdata 复现的卡掉项目拆成反馈单元，是分解表的第一批原料

## 素材与通道

- 学员向的互动交付形态：studio `doc/screens/` 页面规格随迁出转入本 scope
- 技术通道对齐 qtcloud lite（Taro 多端），不另行选型；发布链路复用 miniprogram-ci 模式

### studio 组件处置（v0.2 时执行）

- **studio 保留**：player 组（`widgets/stage/`、`services/player_state.dart`）与单元模型（`segment.dart`、`interaction.dart`、`choice_option.dart`）——预览与课堂现场能力，升级不移除
- **lite 自建**：按同一数据契约实现 Taro 播放器，页面规格 `doc/screens/` 为蓝本（代码不过端，契约过端）
- **复制**：`auth_api.dart`（同 qtcloud-auth 接口，两端各持一份）
- **简化实现**：课程/首页展示组（`widgets/course/`、`widgets/home/`）——任务卡首屏不需要 studio 那套完整课程展示层级，按任务卡形状重写
- **不迁不复制**：`learn_api.dart`、`progress_service.dart`、`learner_service.dart`——上游已断，随 provider 新契约重写

### 达成标志

学员每天只开 lite 就能完成全部学习动作，且不做过一次"我该干什么"的决策。
