# 量潮课堂 Lite

学员任务端：微信式外壳——顶部 AppBar「量潮课堂」，底部三页签（课堂 / 实践 / 我的）；实践页以两把尺（需求的精确程度、验收标准的开放程度）筛选任务书。学员在做，不在看。课程与实训都是任务序列。

Web 形态（不发小程序），React + Vite + TypeScript，与 `src/site` 同构；部署走 `.github/workflows/deploy-lite.yml`（`lite/*` tag → OSS 桶 `qtclass-lite` + CDN `lite.class.quanttide.com`）。

## 开发

```bash
npm install
npm run dev      # 本地预览
npm run build    # tsc + vite 构建
npm run lint
npm test
```

## 结构

```
data/tasks/            # 任务书内容库（frontmatter tags 标注两把尺）
data/lessons/          # 课时内容库（一文件一课时，静态载荷，文字源自教程仓）
src/
├── models/task.ts     # 任务契约（Task 形状 + 五状态机）与两把尺枚举（单一事实源）
├── models/lesson.ts   # 课时契约（Lesson 形状 + 步骤块类型）与按课程取已发布课时
├── pages/             # 页签三页：Practice（任务书库 + 筛选）/ Classroom（课堂页课程清单，自 site 迁入）/ Mine（个人页骨架）
│                      # 压入三页：TaskDetail（题面 + 题面素材）/ LessonDetail（课时分步正文）/ Feedback（评语与状态），隐藏页签
├── components/        # AppBar / TabBar / Markdown 渲染（GFM）
└── utils/             # frontmatter 解析与剥离（含 tags）
```

## 数据面

契约静态先行：页面只认 `models/task.ts` 的 `Task` 形状，数据源当前为仓内静态载荷；provider v0.2 接通后换数据源，页面不动。提交通道未开放，任务详情只读。

两把尺写在任务书 frontmatter 的 `tags:` 下（`requirement: fuzzy|semi|precise`、`acceptance: closed|semi|open`），筛选器与卡片共用 `models/task.ts` 的枚举与显示名。

课时同理：`data/lessons/` 只放静态载荷，页面只认 `models/lesson.ts` 的 `Lesson` 形状；provider 接通后换数据源，页面不动。课时正文的文字与步骤以教程仓为准，这里只换载体、不改写。
