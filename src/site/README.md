# 量潮课堂课程展示站

量潮课堂招生门面站，基于 React + TypeScript + Vite 构建。

## 功能

- 首页 `/`：课程特色（取材宣传册，静态副本 `data/home/index.md`）
- 价格页 `/prices`：三种服务模式（G 校企合作 / B 企业 / C 个人），不标价格、无明细内容
- 连接引用：导航含 lite（学员练习端）与 studio（教学设计工作台）站外链接
- 课程清单已迁 `src/lite` 理论页；`/courses` 与 `/schedules/:slug` 已下线

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
├── home/                # 首页内容（课程特色，取材宣传册）
└── learning/            # 训练营与价格明细静态副本——详情页下线后暂无消费方，待归属
src/
├── App.tsx              # 路由装配（/ 与 /prices，未知回首页）
├── routes.ts            # 路由路径与站外连接（lite / studio）
├── main.tsx             # 入口文件
├── App.css / index.css  # 样式
├── components/
│   ├── Layout.tsx       # 站点外框（导航含 lite/studio 引用 + 页头 + 内容区）
│   └── Markdown.tsx     # markdown 渲染（react-markdown + remark-gfm）
├── pages/
│   ├── Home.tsx         # 首页（课程特色）
│   └── Prices.tsx       # 价格页（三档服务模式）
└── utils/
    └── frontmatter.ts   # 元数据解析与剥离
```

## 内容数据

`data/` 下的 markdown 为上游内容的静态副本，页面经 `import.meta.glob` 扫描文件（根锚定路径 `/data/...`）并剥离 frontmatter。来源与同步方法的现状见 `TODO.md`、`ROADMAP.md`。
