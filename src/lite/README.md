# 量潮课堂 Lite

学员任务端：首屏今日任务卡，无选择、无导航、无配置——学员在做，不在看。课程与实训都是任务序列。

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
data/tasks/            # 任务书内容库（源自 site，迁出后不再回流）
src/
├── models/task.ts     # 任务契约（Task 形状 + 五状态机）与静态数据
├── pages/             # 三页：Today（今日任务卡）/ TaskDetail（题面 + 题面素材）/ Feedback（评语与状态）
├── components/        # Markdown 渲染（GFM）
└── utils/             # frontmatter 解析与剥离
```

## 数据面

契约静态先行：页面只认 `models/task.ts` 的 `Task` 形状，数据源当前为仓内静态载荷；provider v0.2 接通后换数据源，页面不动。提交通道未开放，任务详情只读。
