# 量潮课堂课程展示站

量潮课堂课程体系展示站，基于 React + TypeScript + Vite 构建。

## 功能

- 课程体系展示
- 生产实习课程教案
- 课程详情页面

## 开发

```bash
# 安装依赖
npm install

# 启动开发服务器
npm run dev

# 构建生产版本
npm run build

# 预览生产版本
npm run preview
```

## 技术栈

- React 19
- TypeScript
- Vite
- React Router

## 项目结构

```
src/
├── App.tsx              # 主应用组件
├── App.css              # 应用样式
├── index.css            # 全局样式
├── main.tsx             # 入口文件
├── data/
│   └── courses.ts       # 课程数据
└── pages/
    ├── Home.tsx         # 首页
    ├── ProductionInternship.tsx  # 生产实习课程页面
    └── courses/
        └── ProductionInternshipCourse.tsx  # 课程详情页面
```
