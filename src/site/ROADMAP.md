# ROADMAP — qtclass-site

招生门面：课程体系、价格、报名入口。登录后功能一律不进——学员的进 lite，教师的进 studio。

## 下一步待办

- [ ] 实践课改版：训练营并入课程列表，按理论课 / 实践课一级分类展示（分类本就存在，落到页面结构）
- [ ] 价格页按付费对象分档：G 端校企合作（询价）、B 端企业（报价）、C 端个人（课时包）——定价跟对象与商业模式走，不跟课程走；理论课 / 实践课只管展示，不挂价格
- [ ] 价目源同步：`prices/` 与支付域（quanttide-pay `spend/`）的同步方案，随价格页改版一并设计。约束：`deploy-site.yml` 单仓 checkout，构建期跨仓取源需改 workflow 并配权限——方向定后动手
- [ ] 训练营正文「来源：tasks/xxx.md」链接随任务书迁出改指 lite
- [ ] `data/learning/tasks/` 迁出前不再新增，新任务书直接写 lite 侧

任务书迁出（10 篇）的时机与接收方见 [lite ROADMAP](../lite/ROADMAP.md)。
