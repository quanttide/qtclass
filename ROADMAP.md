# ROADMAP — qtclass

量潮课堂的仓库路线总纲，只记工程待办；状态快照见 [STATUS.md](STATUS.md)。商业化与付费归意图库 `data/intention/qtclass/business.md`，领域蓝图归 `data/roadmap/qtclass/`——本文件只管工程。

## 分工

| 端 | 角色 | 下一步 |
|----|------|--------|
| [Site](src/site/ROADMAP.md) | 招生门面：课程体系、价格、报名；登录后功能不进 | 实践课改版 + 价格页按对象分档 |
| [Studio](src/studio/ROADMAP.md) | 教学与客户面：教师派任务批改，客户看交付 | v0.2：派任务 → 批改闭环 |
| [Lite](src/lite/ROADMAP.md) | 学员任务系统：首屏任务卡，被动端 | 待 studio / provider v0.2 就绪后立项 |
| [Provider](src/provider/ROADMAP.md) | 数据面：仓内自持，契约不变留回归缝 | v0.2：任务链路 |
| [CLI](src/cli/ROADMAP.md) | 骨架 | 无规划，有真实命令再长 |

边界规则：「我」字开头的功能按角色分流——学员的进 Lite，教师与客户的进 Studio（我的任务 / 反馈 → Lite；我的方案 / 课时 / 交付 → Studio，付费个人跨两端），公开的进 Site，找不到主的不做。

优先级：**Studio 先于 Lite**——Studio 不派任务，Lite 首屏就是空的。

## 下一步待办

- [ ] **Studio v0.2 教学闭环**：派任务 / 批改、任务流预览、客户面只读、修订回环合稿、学员侧收敛（清单见 [studio](src/studio/ROADMAP.md)）
- [ ] **Provider v0.2 任务链路**：下发 / 提交 / 回写、任务书与实例分离、仓内自持三线（清单见 [provider](src/provider/ROADMAP.md)）
- [ ] **Site 实践课改版**：训练营并入课程列表、价格页 G/B/C 分档、价目源同步（清单见 [site](src/site/ROADMAP.md)）
- [ ] **Lite 立项**：前置 studio / provider v0.2，就绪前不立项（清单见 [lite](src/lite/ROADMAP.md)）
- [ ] **Studio v0.3 淘汰赛**：班级进度视图、淘汰流程
- CLI：无待办
