# TODO — qtclass-site

可直接动手的细节，包内改动，有类型检查、测试或视觉验证兜底。需与人对齐的事项见 [ROADMAP.md](./ROADMAP.md)。

## 内容来源

- [x] 补齐漂移：从上游补入 `connect-cli.md`、`try-qtcloud-work-cli.md`，`data/learning/tasks/` 与 `schedules/` 已与上游逐文件一致
- [x] 核定 prices 出处：源在支付域 `quanttide-pay/data/profile/qtclass/`（职级档位表见 `spend/one-on-one-consultation.md`，代金券规则见 `voucher-pricing.json`），学习域无对应目录
- [ ] 追溯 lessons 来源：已确认 `qtclass-intro.md` ← `docs/tutorial/qtclass/index.md`、`qtclass-sales.md` ← `docs/tutorial/qtclass/sales.md`，其余六个待查
- [x] 删除 `src/models/courses.ts` 中未使用的 `courses` 导出

## 结构收敛

- [x] 学习板块定义合并为单一常量 `LEARNING_SECTIONS`，标题、英文副题与说明同源，判定与取用各有函数
- [x] 抽 `src/components/Layout.tsx`，`App.tsx` 只保留路由装配
- [x] 路由路径与链接地址集中到 `src/routes.ts`，页面不再写路由字面量
- [x] 学习页非法板块参数不再回退到「训练营」，改为渲染「内容未找到」

## 渲染

- [x] 表格渲染补 `<table>`、`<thead>`、`<tbody>` 包裹，并补 `th` 样式

## 工程化

- [x] 补测试：Vitest + jsdom + Testing Library，覆盖全部路由渲染与 markdown 渲染（13 例）
- [x] 更新 README「项目结构」，补 `data/`、`src/models/`、`src/components/`、`src/routes.ts` 与测试命令
