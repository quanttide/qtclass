import type { Cohort } from '../src/models/cohort'

// 班级载荷：加一个班 = 加一条记录再发版（lite/v0.x.y）
// 现状：AI编程、AI创意已开班（在读，滚动插班仍可报名）；AI办公、AI教学未开班，无记录
// 限额与窗口只有 AI编程有事实（宣传册社会招生页），AI创意暂缺，不编
export const cohorts: Cohort[] = [
  {
    id: 'ai-programming-1',
    course: 'AI编程',
    name: '首期',
    status: 'running',
    schedule: '每周一个学习周期，可拖到 10 天再结算',
    quota: '免费 3~5 名 · 付费 15 名',
    window: '免费班 11 月 23 日起开放；付费班每月 20 日至次月 10 日',
    apply: '按第 1 课交成品：自己上线的游戏网址，附一段制作说明（怎么做出来的、卡在哪一步）',
    signup: { label: '发邮件报名', href: 'mailto:class@quanttide.cn' },
  },
  {
    id: 'ai-creative-1',
    course: 'AI创意',
    name: '首期',
    status: 'running',
    schedule: '每周一个学习周期，可拖到 10 天再结算',
    apply: '按第 1 课交成品：你生成的第一张图，附一段制作说明（怎么做出来的、卡在哪一步）',
    signup: { label: '发邮件报名', href: 'mailto:class@quanttide.cn' },
  },
]
