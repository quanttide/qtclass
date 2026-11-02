import { describe, it, expect } from 'vitest'
import { CURRENT_TASK, taskbooks, getTaskbook, statusLabel, TASK_STATUSES } from './task'

describe('任务契约与内容首迁', () => {
  it('10 篇任务书已迁入内容库且可解析标题', () => {
    expect(taskbooks.length).toBe(10)
    for (const book of taskbooks) {
      expect(book.title, book.slug).toBeTruthy()
      expect(book.content, book.slug).toBeTruthy()
    }
  })

  it('首任务 = 任务书修订，指派的题面素材存在', () => {
    expect(CURRENT_TASK.slug).toBe('revise-docs-bylaw')
    expect(CURRENT_TASK.taskbookSlug).toBe('docs-bylaw')
    expect(getTaskbook('docs-bylaw')?.content).toContain('#')
  })

  it('状态枚举五件套可显示', () => {
    expect(TASK_STATUSES.map((s) => s.key)).toEqual(['todo', 'doing', 'submitted', 'returned', 'passed'])
    expect(statusLabel('returned')).toBe('退回')
    expect(statusLabel('passed')).toBe('通过')
  })
})
