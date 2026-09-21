# CONTRIBUTING

qtclass 站点包（`apps/qtclass/src/site`）的文件规范与维护规范。项目介绍见 [README.md](./README.md)，待办与路标见 [TODO.md](./TODO.md)、[ROADMAP.md](./ROADMAP.md)。

## 文件规范

### 目录职责

内容与代码分离：具体内容进包级 `data/`，`src/` 只放代码。

| 路径 | 放什么 |
|------|--------|
| `data/home/*.md` | 首页介绍，上游 brochure 的静态副本 |
| `data/learning/schedules/*.md` | 训练营，上游学习管理档案的静态副本 |
| `data/learning/tasks/*.md` | 任务，同上 |
| `data/learning/prices/*.md` | 价格，源在支付域 |
| `src/models/` | 数据结构、类型与装载，不含页面逻辑 |
| `src/pages/` | 页面组件，一条路由一个文件；同类多页面建子目录 |
| `src/components/` | 跨页面复用组件 |
| `src/utils/` | 与业务无关的通用处理 |
| `src/routes.ts` | 路由路径与链接地址 |

### 命名

页面与组件文件用 `PascalCase.tsx`，文件名与默认导出组件同名。模型与工具文件用 `camelCase.ts`。测试与被测文件同目录同名，后缀为 `.test.ts` 或 `.test.tsx`。CSS 类名用 `camelCase`。

内容文件的 slug 取自文件名（去掉扩展名），URL 由 slug 构成，**改名即改 URL，已发布的外链会失效**。内容文件名用 `kebab-case.md`。

### 内容文件格式

学习资料（`data/learning/` 下）首部必须带 frontmatter 的 `title` 与 `description`：列表卡片取这两项，缺失时回退到正文章节的标题与首个段落。frontmatter 用 `js-yaml` 解析（见 `src/models/learning.ts` 的 `parseFrontmatter`），值中含「: 」时必须加引号，否则整段解析失败并按无元数据处理。

正文标题用一级，章节用二级、三级，不支持四级及以下。段落之间空一行，列表、引用块、代码块各自独立成段，代码块标注语言。表格必须有分隔行，否则首行不会被识别为表头。

渲染器为自研（`src/utils/markdown.ts`），仅支持标题、无序与有序列表、引用块、代码块、表格、水平线，以及行内加粗、斜体、行内代码与链接。不支持嵌套列表、图片、脚注、任务列表。内容以渲染器实际支持的范围为准，需要新语法时先扩渲染器与测试，再写内容。

渲染输出交 `dangerouslySetInnerHTML` 前经 `DOMPurify` 清洗，脚本与事件属性会被去除；清洗不代替来源把关，`data/` 内容仍须来自可信来源。

### 内容装载

内容一律经 `src/models/` 装载，页面不直接读文件。`import.meta.glob` 使用根锚定路径（`/data/...`），相对路径在 CI 与本地容易不一致。

学习板块（训练营、任务、价格）在 `src/models/learning.ts` 的 `LEARNING_SECTIONS` 单一定义，标题、英文副题与说明同源；新增板块只改这一处，再建对应 `data/learning/<板块>/` 目录。

### 路由

新增或改动页面时同时改两处：`src/routes.ts` 的 `ROUTE_PATHS` 与链接构造函数、`src/App.tsx` 的 `AppRoutes`。页面内不写路由字面量，链接一律取 `routes.ts` 的构造函数。

### 测试

路由新增或变更时，在 `src/App.test.tsx` 的 routes 表增删对应行；渲染逻辑变更时补 `src/utils/markdown.test.ts`；元数据解析变更时补 `src/models/learning.test.ts`。测试环境为 jsdom 加 Testing Library，配置见 `vitest.config.ts`。

## 维护规范

### 内容同步

`data/learning/` 是学习管理档案（`domains/quanttide-learn/data/profile/`）的静态副本，人工同步：

1. 上游新增或修改后，复制对应 `*.md` 到 `data/learning/` 的相同子目录
2. 逐文件比对确认一致：`diff -rq <上游目录> data/learning`
3. 同步结果记入 CHANGELOG

站点与上游不得各改一份：内容改动先改上游，再回流站点。价格类内容的源在支付域（`quanttide-pay/data/profile/qtclass/`），学习域没有对应目录；首页介绍的源在 `quanttide-tech` 数据仓的 `data/brochure/qtclass/`。

### 验证

提交前三项本地全绿：

```bash
npm test        # Vitest，含路由冒烟与 markdown 渲染
npm run build   # tsc -b && vite build
npm run lint    # eslint
```

`tsconfig.app.json` 开启了 `strict`、`noUnusedLocals`、`noUnusedParameters`，未使用的导出与变量会直接导致构建失败。

### 提交

使用 Conventional Commits，范围取 `site`：

```text
feat(site): 学习页新增价格板块
fix(site): 表格未包 table 导致样式失效
docs(site): 更新 README 目录树
```

本包是 `quanttide-tech` 子模块 `apps/qtclass` 的一部分，分层提交：先在本仓库提交推送，再回父仓库同步指针。

```bash
git add apps/qtclass
git commit -m "chore: update qtclass submodule"
git push
```

禁止在父仓库直接修改本包文件。

### 版本与发布

版本记在 `src/site/CHANGELOG.md`，未发布的变更写进 `## [Unreleased]` 段。发布时把该段定版为 `## [X.Y.Z] - YYYY-MM-DD`，同步 `package.json` 的 `version`，打 `site/vX.Y.Z` 标签推送。标签触发 `.github/workflows/deploy-site.yml`：构建后上传 OSS 桶 `qtclass-site`，刷新 CDN `class.quanttide.com`。仓库根 `CHANGELOG.md` 只记仓库级大变更，不写本包细节。

### 待办与路标

`TODO.md` 写可直接动手的细节，`ROADMAP.md` 写需与人对齐的层（跨仓取源、更换依赖、变更对外资源）。条目完成后从 TODO 删除；结论若仍有价值，并入 ROADMAP 的约束或 README，不留在已勾选的条目里。

### 内容红线

站点为公开部署，`data/` 下的内容随构建产物公开发布，不放未脱敏的客户信息、经营敏感信息与内部链接。
