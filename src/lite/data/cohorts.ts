import type { Cohort } from '../src/models/cohort'

// 班级载荷：加一个班 = 加一条记录再发版（lite/v0.x.y）
// 现状：AI编程、AI创意已开班（在读）；AI办公、AI教学未开班，无记录
export const cohorts: Cohort[] = [
  {
    id: 'ai-programming-1',
    course: 'AI编程',
    name: '首期',
    status: 'running',
    schedule: '每周一个学习周期，可拖到 10 天再结算',
  },
  {
    id: 'ai-creative-1',
    course: 'AI创意',
    name: '首期',
    status: 'running',
    schedule: '每周一个学习周期，可拖到 10 天再结算',
  },
]
