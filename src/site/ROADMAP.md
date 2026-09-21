# ROADMAP — qtclass-site

需与人对齐的层：以下事项跨出 `src/site` 边界（跨仓取源、更换依赖、变更对外资源），先定方向再动手。可直接实施的细节见 [TODO.md](./TODO.md)。

## 一 内容来源

站点继续内嵌内容副本，还是构建期从上游取源。方向未定，以下两处改动均取决于此：

- [ ] 内容同步脚本：从 `domains/quanttide-learn/data/profile/` 生成 `data/learning/`，取代手工复制
- [ ] 文件定位去掉 `key.includes(...)` 字符串匹配，见 `src/models/learning.ts:101`、`src/pages/learning/ItemDetail.tsx:8,25`

约束与影响：

- CI 跨仓访问：`deploy-site.yml` 只有 `actions/checkout@v4`（单仓），构建期取源需改 workflow 并配跨仓权限
- `prices/` 源在别域：职级档位表在 `quanttide-pay/data/profile/qtclass/spend/one-on-one-consultation.md`，代金券规则在 `voucher-pricing.json`，学习域无对应目录；同步脚本需决定是纳入支付域还是另择源

达成标志：`data/learning/` 的内容可由一条命令从上游重建，重建结果与仓库内副本一致。

## 二 渲染

- [ ] 元数据解析改用 YAML 库，替换 `src/models/learning.ts` 的 `parseFrontmatter` 手写解析
- [ ] markdown 渲染改用成熟库，或对现有输出做 sanitize，两处 `dangerouslySetInnerHTML` 未过滤 HTML

约束与影响：`gray-matter` 依赖 Node 的 `Buffer`，浏览器端需另作选型；换渲染库会改变输出 HTML，`src/index.css` 的 `.lesson-body` 系列样式需同步重调。

达成标志：表格、引用块、代码块在现有样式下正常呈现，注入内容经 sanitize。

## 三 站点图标

- [ ] `index.html:5` 的 favicon 由 `images/course-hero.png` 换成专用图标

达成标志：图标资源文件产出并接入，站点标签页显示正常。
