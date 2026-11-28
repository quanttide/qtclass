import { describe, it, expect } from 'vitest'
import { CURRENT_TASKS, TASK_STATUSES, getTaskbook, statusLabel, taskbooks } from './task'

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
