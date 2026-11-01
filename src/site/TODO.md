# TODO — qtclass-site

可直接动手的细节，包内改动，有类型检查、测试或视觉验证兜底。需与人对齐的事项见 [ROADMAP.md](ROADMAP.md)。

## 实践课改版（课程列表两级分类）

现状：`/courses` 是 `src/pages/Course.tsx` 里硬编码的 5 门课扁平数组（level 字段：入门/入门/进阶/高阶/实训），无分类结构；训练营在 `/learn` 的 schedules 板块。

- [ ] `Course.tsx` 数组加 `track: 'theory' | 'practice'` 字段：知识工作、氛围编程、大数据导论、数据工程归 theory；生产实习归 practice
- [ ] 页面按一级分类渲染两节：「理论课」「实践课」，节标题样式复用现有 `courseSection`
- [ ] 实践课节追加训练营卡片：复用 `src/models/learning.ts` 已有的 `loadLearningEntries` 加载 schedules 板块，卡片跳转 `learnItemPath('schedules', slug)`；卡面用现有 `renderCard` 形状（名称 + 训练营标签 + description）
- [ ] `Home.tsx` 若引用课程列表或数量，同步两级分类表述
- [ ] 补/改测试：`Course` 页渲染两节、实践课含训练营；沿用 `App.test.tsx`、`learning.test.ts` 的既有写法

## 价格页按付费对象分档

现状：价格在 `/learn` 的 prices 板块，两篇静态副本（`data/learning/prices/consultation.md` 按职级一对一、`free-participation.md` 任务免费+代金券）。口径：定价跟对象走，不跟课程走。

- [ ] `src/models/learning.ts` 增加三档常量（名称 + 一句话 + 询价/详情去向）：
  - G 端·校企合作：为高校定制课程方案，合同与教研合作——询价（文案给"经量潮课堂联系"，不写价格）
  - B 端·企业培训与人才交付：培训与经淘汰赛验证的人才交付——报价洽谈
  - C 端·个人学习：课时包与一对一，群内提问免费——指向现有 prices 两篇
- [ ] `Learn.tsx` 的 prices 板块改为三档卡片在上；C 档下保留现有两篇列表（`itemsIn('prices', entries)` 照旧）
- [ ] 补测试：prices 板块渲染三档、C 档下两篇可达

## 边界（本次不做）

- `data/learning/` 下的上游静态副本内容一个字不动——prices 的内容改写、价目价源同步随同步方案定案后另做
- `tasks/` 板块不动：不新增、不删改、不迁出；训练营正文里的来源链接指向不改（迁出时一并处理）

## 验收

1. `npm run build`、`npm run lint`、`npm test` 三绿（新逻辑必须带测试）
2. `/courses`：两级分类正确，实践课 = 生产实习 + 2 个训练营，训练营卡片可跳详情
3. `/learn`：prices 区三档在上、C 档下两篇原页可达；schedules、tasks 板块原样
4. 合并后 CI 部署，确认最终 URL 返回 200、页面渲染正常
