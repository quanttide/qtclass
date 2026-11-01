# 量潮课堂课程展示站

量潮课堂课程体系展示站，基于 React + TypeScript + Vite 构建。

## 功能

- 课程体系展示，一级分类理论课 / 实践课；实践课并入训练营，训练营详情页独立
- 价格页：按付费对象分三档（G 校企合作 / B 企业 / C 个人），C 档明细内联

## 开发

```bash
# 安装依赖
npm install

# 启动开发服务器
npm run dev

# 构建生产版本
npm run build

# 运行测试
npm test

# 预览生产版本
npm run preview
```

## 技术栈

- React 19
- TypeScript
- Vite
- React Router
- Vitest

## 项目结构

```
data/                    # 内容数据（置于 src 之外）
├── home/                # 首页介绍（源自 quanttide-tech 数据仓 brochure）
└── learning/            # 内容数据：训练营（schedules）、任务（tasks，待迁 lite）、价格（prices）
src/
├── App.tsx              # 路由装配
├── routes.ts            # 路由路径与链接地址
├── main.tsx             # 入口文件
├── App.css / index.css  # 样式
├── components/
│   ├── Layout.tsx       # 站点外框（导航 + 页头 + 内容区）
│   └── Markdown.tsx     # markdown 渲染（react-markdown + remark-gfm）
├── models/              # 数据结构与装载
│   ├── home.ts          # 首页内容装载
│   └── learning.ts      # 学习资料扫描、元数据解析、板块定义
├── pages/
│   ├── Home.tsx         # 首页
│   ├── Course.tsx       # 课程页（理论课 / 实践课）
│   ├── Prices.tsx       # 价格页（三档 + C 档明细）
│   └── learning/
│       └── ItemDetail.tsx  # 训练营详情（/schedules/:slug）
└── utils/
    └── frontmatter.ts   # 元数据解析与剥离
```

## 内容数据

`data/` 下的 markdown 为上游内容的静态副本，页面经 `src/models/*.ts` 扫描文件（根锚定路径 `/data/...`）并解析 frontmatter。来源与同步方法的现状见 `TODO.md`、`ROADMAP.md`。
