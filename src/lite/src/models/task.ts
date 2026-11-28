// 任务契约：与 qtcloud-crowd lite 结构一致——列表放摘要，详情放结构化章节，按字段渲染不落 Markdown。
// 差别只有一处：本仓不带两把尺 tags（分类与方法归库存侧 qtcloud-crowd lite）。
// 静态数据先行，页面只认本形状；provider v0.2 就绪后换数据源，页面不动
export interface TaskDetail {
  business: string
  category: string
  status: string
  background: string
  content: string[]
  inputs: string[]
  deliverable: string
  acceptance: string[]
  notes: string[]
}

export interface Task {
  slug: string
  title: string
  // 列表页一行摘要
  description: string
  // 学员端五状态机（进度），与档案元数据的 status 是两回事
  status: TaskStatus
  // 详情页结构化内容：档案 data/profile/quanttide-tech/tasks/trial-*.md 的结构化副本
  detail: TaskDetail
}

export type TaskStatus = 'todo' | 'doing' | 'submitted' | 'returned' | 'passed'

export const TASK_STATUSES: { key: TaskStatus; label: string }[] = [
  { key: 'todo', label: '待做' },
  { key: 'doing', label: '进行' },
  { key: 'submitted', label: '已交' },
  { key: 'returned', label: '退回' },
  { key: 'passed', label: '通过' },
]

export function statusLabel(status: TaskStatus): string {
  return TASK_STATUSES.find((item) => item.key === status)?.label ?? status
}

// 试用任务载荷：与库存侧 qtcloud-crowd lite 同源（档案 data/profile/quanttide-tech/tasks/trial-*.md），
// 正文不改写只换载体；换对象不换方法，方法细则在档案的类别模板里
const trial = (
  slug: string,
  title: string,
  description: string,
  business: string,
  url: string,
  materials: string,
  path: string,
): Task => ({
  slug,
  title,
  description,
  status: 'todo',
  detail: {
    business,
    category: '测评',
    status: '待认领',
    background: `${business} Lite（${url}）已上线公测。请试用它，帮我们发现它有什么用。`,
    content: [
      `照主路径走一遍（${path}），记下每一步做了什么、在哪卡住；`,
      '三类问题分开记：打不开、走不通、说不清（看不出给谁用、能干嘛）；',
      '回答三问：我拿它干成了什么？有没有我没料到有用的地方？我还想让它替我干什么？',
    ],
    inputs: [
      `站点地址：${url}（公开可访问，无需后台账号）`,
      `对照材料：${materials}`,
      '自理：截图工具、浏览器窄屏调试',
    ],
    deliverable: '一份试用记录（Markdown），含走查路径、卡点清单、发现清单。',
    acceptance: [
      '走查路径完整，卡点落到具体步骤',
      '三类问题分开记，没有混在一起',
      '每条发现落到具体场景（我本来想做 X，它做到了 / 没做到 Y）',
    ],
    notes: [
      '发现比打分值钱：我们想知道它对你有什么用，不是它能得几分。',
      '每条判断落到具体场景，不收「体验流畅」「设计美观」这类无据表述。',
    ],
  },
})

// 静态任务数据：四个业务平台 Lite 的试用任务，已通过验收上架
export const CURRENT_TASKS: Task[] = [
  trial(
    'trial-qtdata-lite',
    '测评量潮数据 Lite',
    '试用 lite.data.cloud.quanttide.com，帮我们发现它有什么用。',
    '量潮数据',
    'lite.data.cloud.quanttide.com',
    '仓内 README 与 CHANGELOG',
    '首页 → 数据功能页 → 返回',
  ),
  trial(
    'trial-qtclass-lite',
    '测评量潮课堂 Lite',
    '试用 lite.class.quanttide.com，帮我们发现它有什么用。',
    '量潮课堂',
    'lite.class.quanttide.com',
    '课程三页签结构与仓内 README',
    '首页 → 课程主页 → 课时页 → 返回',
  ),
  trial(
    'trial-qtcloud-lite',
    '测评量潮云 Lite',
    '试用 lite.cloud.quanttide.com，帮我们发现它有什么用。',
    '量潮云',
    'lite.cloud.quanttide.com',
    '功能列表与仓内 README',
    '首页 → 功能详情 → 返回',
  ),
  trial(
    'trial-qtconsult-lite',
    '测评量潮咨询 Lite',
    '试用 lite.consult.cloud.quanttide.com，帮我们发现它有什么用。',
    '量潮咨询',
    'lite.consult.cloud.quanttide.com',
    '咨询方案清单与仓内 README',
    '首页 → 方案详情 → 返回',
  ),
]
