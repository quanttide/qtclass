import { describe, it, expect } from 'vitest'
import {
  ACCEPTANCES,
  CURRENT_TASKS,
  REQUIREMENTS,
  TASK_STATUSES,
  getTaskbook,
  statusLabel,
  taskbooks,
} from './task'

describe('任务契约与内容', () => {
  it('货架当前为空：旧任务书已整体下架，待标准化小任务重新上架', () => {
    expect(taskbooks).toEqual([])
    expect(CURRENT_TASKS).toEqual([])
    expect(getTaskbook('qtgame-tycoon')).toBeUndefined()
  })

  it('状态枚举五件套可显示', () => {
    expect(TASK_STATUSES.map((s) => s.key)).toEqual(['todo', 'doing', 'submitted', 'returned', 'passed'])
    expect(statusLabel('returned')).toBe('退回')
    expect(statusLabel('passed')).toBe('通过')
  })
})

describe('任务书两把尺（frontmatter tags）', () => {
  it('两把尺的枚举与显示名', () => {
    expect(REQUIREMENTS.map((r) => r.value)).toEqual(['fuzzy', 'semi', 'precise'])
    expect(REQUIREMENTS.map((r) => r.label)).toEqual(['模糊', '半精确', '精确'])
    expect(ACCEPTANCES.map((a) => a.value)).toEqual(['closed', 'semi', 'open'])
    expect(ACCEPTANCES.map((a) => a.label)).toEqual(['封闭', '半开放', '开放'])
  })
})
