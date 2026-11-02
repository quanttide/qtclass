# ROADMAP — qtclass

量潮课堂的仓库路线总纲，只记工程待办；状态快照见 [STATUS.md](STATUS.md)。商业化与付费归意图库 `data/intention/qtclass/business.md`，领域蓝图归 `data/roadmap/qtclass/`——本文件只管工程。

## 分工

| 端 | 角色 | 下一步 |
|----|------|--------|
| [Site](src/site/ROADMAP.md) | 招生门面：课程体系、价格（询价） | 任务书来源行改指、价目源同步待定 |
| [Studio](src/studio/ROADMAP.md) | 教学设计工作台（**单用户**：你设计教学方案） | 创作空间四对象 + 任务书生产线 |
| [Lite](src/lite/ROADMAP.md) | 学员任务系统：首屏任务卡，被动端 | 数据面待 provider v0.2 |
| [Provider](src/provider/ROADMAP.md) | 数据面：仓内自持，契约不变留回归缝 | v0.2：任务链路 |
| [CLI](src/cli/ROADMAP.md) | 骨架 | 无规划，有真实命令再长 |

边界规则：「我」字开头的功能按角色分流——学员的进 Lite，教师的进 Studio，公开的进 Site，找不到主的不做。**客户面已随 studio 单用户化整体退场**（2026-11-02，理由见 [studio](src/studio/ROADMAP.md)），开班或接客时按需要回补。

studio 与 lite 的关系改写：studio 不派发（单用户设计工作台），任务实例的下发来源待定、通道归 provider——lite 的载荷此前已静态先行，不受影响。

## 下一步待办

- [ ] **Studio 教学设计工作台**：创作空间（Brief / 分解树 / 脚手架库 / 教学动作元数据）+ 修订回环（清单见 [studio](src/studio/ROADMAP.md)）
- [ ] **Provider v0.2 任务链路**：下发 / 提交 / 回写、任务书与实例分离、仓内自持三线（清单见 [provider](src/provider/ROADMAP.md)）
- [ ] **Lite 数据面**：v0.1 已上线（小说 / 游戏双任务）；v0.2 状态机与 AI 判定待 provider（清单见 [lite](src/lite/ROADMAP.md)）
- [ ] **Site 清尾**：训练营来源行改指 lite、价目源同步待明细页恢复时再定（清单见 [site](src/site/ROADMAP.md)）
- CLI：无待办
