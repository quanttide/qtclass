# 量潮课堂课程展示站

量潮课堂课程体系展示站，基于 React + TypeScript + Vite 构建。

## 功能

- 课程体系展示
- 生产实习课程教案
- 学习资料（训练营 / 任务 / 价格）展示与详情

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
data/                    # 内容数据（markdown 原件，置于 src 之外）
├── learning/            # 学习资料：训练营（schedules）、任务（tasks）、价格（prices）
└── lessons/             # 生产实习课时教案
src/
├── App.tsx              # 路由装配
├── routes.ts            # 路由路径与链接地址
├── main.tsx             # 入口文件
├── App.css / index.css  # 样式
├── components/
│   └── Layout.tsx       # 站点外框（导航 + 页头 + 内容区）
├── models/              # 数据结构与装载
│   ├── courses.ts       # 课程结构
│   └── learning.ts      # 学习资料扫描、元数据解析、板块定义
├── pages/
│   ├── Home.tsx         # 首页（课程体系）
│   ├── Learn.tsx        # 学习页
│   ├── ProductionInternship.tsx  # 生产实习课程页
│   ├── courses/
│   │   └── ProductionInternshipCourse.tsx  # 课时详情
│   └── learning/
│       └── ItemDetail.tsx  # 学习资料详情
└── utils/
    └── markdown.ts      # markdown 渲染
```

## 内容数据

`data/` 下的 markdown 为上游内容的静态副本，页面经 `src/models/*.ts` 扫描文件（根锚定路径 `/data/...`）并解析 frontmatter。来源与同步方法的现状见 `TODO.md`、`ROADMAP.md`。
