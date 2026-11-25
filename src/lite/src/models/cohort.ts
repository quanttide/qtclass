// 班级：课程主页与课堂卡片共用。载荷在 data/cohorts.ts，一个记录一个班
import { cohorts as records } from '../../data/cohorts'

export type CohortStatus = 'recruiting' | 'running' | 'closed'

export interface Cohort {
  // 班级唯一标识，如 'ai-programming-1'
  id: string
  // 关联课程名，与 lesson.course 同款弱关联
  course: string
  // 期名，如「首期」
  name: string
  status: CohortStatus
  // 学习节奏，如「每周一个学习周期，可拖到 10 天再结算」
  schedule: string
  // 报名入口；在读班与已结课班没有招新，省略即可
  signup?: { label: string; href: string }
  // 补充说明，如淘汰标准的公告指针
  note?: string
}

export const cohorts: Cohort[] = records

export const COHORT_STATUS_LABEL: Record<CohortStatus, string> = {
  recruiting: '招生中',
  running: '进行中',
  closed: '已结课',
}

// 某门课程下的班级，按记录先后
export function cohortsOf(courseName: string): Cohort[] {
  return cohorts.filter((item) => item.course === courseName)
}
