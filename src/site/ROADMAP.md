# ROADMAP — qtclass-site

需与人对齐的层：以下事项跨出 `src/site` 边界（跨仓取源、更换依赖、变更对外资源），先定方向再动手。可直接实施的细节见 [TODO.md](./TODO.md)。

## 一 内容来源

站点继续内嵌内容副本，还是构建期从上游取源。方向未定，以下三处改动均取决于此：

- [ ] 内容同步脚本：从 `domains/quanttide-learn/data/profile/` 生成 `data/learning/`，取代手工复制
- [ ] 课程章节与课时标题改为从 markdown 元数据生成，删除 `src/models/courses.ts:21-92` 的硬编码副本
- [ ] 文件定位去掉 `key.includes(...)` 字符串匹配，见 `src/models/learning.ts:101`、`src/pages/learning/ItemDetail.tsx:8,25`、`src/pages/courses/ProductionInternshipCourse.tsx:45`

约束与影响：

- CI 跨仓访问：`deploy-site.yml` 只有 `actions/checkout@v4`（单仓），构建期取源需改 workflow 并配跨仓权限
- `prices/` 源在别域：职级档位表在 `quanttide-pay/data/profile/qtclass/spend/one-on-one-consultation.md`，代金券规则在 `voucher-pricing.json`，学习域无对应目录；同步脚本需决定是纳入支付域还是另择源
- 章节归属无出处：`chapter → lesson` 映射只存在于 `models/courses.ts`，markdown 内没有章节信息
- lessons 生成源不全：8 个课时文件中仅 2 个可对应 `docs/tutorial/qtclass/`（文件名还不同），其余无出处

达成标志：`data/learning/` 与 `data/lessons/` 的内容可由一条命令从上游重建，重建结果与仓库内副本一致。

## 二 渲染

- [ ] 元数据解析改用 YAML 库，替换 `src/models/learning.ts` 的 `parseFrontmatter` 手写解析
- [ ] markdown 渲染改用成熟库，或对现有输出做 sanitize，两处 `dangerouslySetInnerHTML` 未过滤 HTML

约束与影响：`gray-matter` 依赖 Node 的 `Buffer`，浏览器端需另作选型；换渲染库会改变输出 HTML，`src/index.css` 的 `.lesson-body` 系列样式需同步重调。

达成标志：表格、引用块、代码块在现有样式下正常呈现，注入内容经 sanitize。

## 三 详情页合并

- [ ] 抽公共组件，合并 `src/pages/learning/ItemDetail.tsx` 与 `src/pages/courses/ProductionInternshipCourse.tsx`

约束与影响：两页行为已分叉——课时页有「第 N 课 / 章节 badge / 上一课下一课」，学习页有 `badgeLabels` 与 `enrichTaskRefs`。属重构而非去重，回归面在 markdown 详情页。

达成标志：合并后两页交互与合并前逐项一致。

## 四 站点图标

- [ ] `index.html:5` 的 favicon 由 `images/course-hero.png` 换成专用图标

达成标志：图标资源文件产出并接入，站点标签页显示正常。
