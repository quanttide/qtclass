# ROADMAP — qtclass-site

> 定位：**招生门面**——只做门外的事。课程体系、训练营、价格、报名入口。受众是没进门的人（学员、家长、企业客户）。三端分工总纲见仓库根 [ROADMAP.md](../../ROADMAP.md)。

## 边界

任何登录后的功能（我的课程、我的作业、我的成绩）不属于 site——学员的进 lite，教师的进 studio。site 的成功指标只有一个：看的人报不报名。

## 内容分流（2026-11-01 决策，同日修订）

`data/learning/` 按三端边界拆分：

- **具体任务书归 lite**：`data/learning/tasks/` 10 篇（connect-cli、data-intention、data-roadmap 等）是学员拿到手要做的交付物，随 lite v0.1 立项迁出，成为任务卡的首批载荷
- **训练营并入课程，列实践课**：`schedules/` 不再是独立板块——课程体系本有理论课/实践课之分（微专业、班级属理论，实训基地、训练营属实践），site 把这个分类落到页面结构：课程列表按理论课 / 实践课一级分类，训练营作为实践课条目入列
- **定价按对象与商业模式分档，不按课程**：价格的第一级分类是付费对象与商业模式——G 端校企合作（合同制，询价）、B 端企业（采购制，报价）、C 端个人（课时包 / 课程购买），与意图库三个付费端对齐；理论课 / 实践课是内容分类，只管展示，不挂价格。价目源仍在 quanttide-pay（`spend/` 下），同步方案随结构调整一并设计
- 连带修正：训练营正文的「来源：tasks/xxx.md」指向随迁出改指 lite（或跨仓链接）

迁出前 `data/learning/tasks/` 不再新增，新任务书直接写到 lite 侧。

## 需与人对齐的层

以下事项跨出 `src/site` 边界（跨仓取源），先定方向再动手。可直接实施的细节见 [TODO.md](TODO.md)。

### 内容来源

站点继续内嵌内容副本，还是构建期从上游取源。方向未定：

- [ ] 内容同步脚本：从 `domains/quanttide-learn/data/profile/` 生成 `data/learning/`，取代手工复制

约束与影响：

- CI 跨仓访问：`deploy-site.yml` 只有 `actions/checkout@v4`（单仓），构建期取源需改 workflow 并配跨仓权限
- `prices/` 源在别域：职级档位表在 `quanttide-pay/data/profile/qtclass/spend/one-on-one-consultation.md`，代金券规则在 `voucher-pricing.json`，学习域无对应目录；同步脚本需决定是纳入支付域还是另择源

达成标志：`data/learning/` 的内容可由一条命令从上游重建，重建结果与仓库内副本一致。
