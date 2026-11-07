# ROADMAP — qtclass-site

招生门面：首页（课程特色）与价格。登录后功能一律不进——学员的进 lite，教师的进 studio；课程清单已迁 lite 理论页。

现状：首页上线（课程特色取材宣传册，`data/home/index.md` 静态副本）、`/prices` 三档服务模式卡（询价口径不标价格）、导航含 lite / studio 连接引用；`/courses` 与 `/schedules/:slug` 已下线，`models/learning.ts` 随详情页移除（`PRICES_TRACKS` 就地化入价格页）。

## 下一步待办

- [ ] 价目源同步：价格明细暂不展示，`data/learning/prices/` 副本与支付域（quanttide-pay `spend/`）的同步方案待明细页恢复时再定
- [ ] `data/learning/`（schedules、prices 副本）待归属：详情页已下线暂无消费方，保留待处置
