import { describe, it, expect } from 'vitest'
import { CURRENT_TASKS, TASK_STATUSES, getTaskbook, statusLabel, taskbooks } from './task'

describe('任务契约与内容', () => {
  it('货架上四本业务平台 Lite 测评任务书，标题与正文可解析', () => {
    expect(taskbooks.length).toBe(4)
    for (const book of taskbooks) {
      expect(book.title, book.slug).toBeTruthy()
      expect(book.title, book.slug).not.toBe(book.slug)
      expect(book.content, book.slug).toContain('## 立题')
      expect(book.content, book.slug).toContain('## 验收')
    }
    expect(getTaskbook('review-qtdata-lite')?.title).toBe('测评量潮数据 Lite')
    expect(getTaskbook('review-qtconsult-lite')?.title).toBe('测评量潮咨询 Lite')
  })

  it('当前任务与任务书一一对齐，题面指向六步模板', () => {
    expect(CURRENT_TASKS.map((t) => t.slug)).toEqual([
      'review-qtdata-lite',
      'review-qtclass-lite',
      'review-qtcloud-lite',
      'review-qtconsult-lite',
    ])
    for (const task of CURRENT_TASKS) {
      expect(task.taskbookSlug, task.slug).toBeTruthy()
      expect(getTaskbook(task.taskbookSlug!), task.slug).toBeDefined()
      expect(task.prompt, task.slug).toContain('六步')
    }
  })

  it('旧任务书已下架（不复活）', () => {
    expect(getTaskbook('qtgame-tycoon')).toBeUndefined()
    expect(getTaskbook('uibe-recruitment-pilot')).toBeUndefined()
  })

  it('状态枚举五件套可显示', () => {
    expect(TASK_STATUSES.map((s) => s.key)).toEqual(['todo', 'doing', 'submitted', 'returned', 'passed'])
    expect(statusLabel('returned')).toBe('退回')
    expect(statusLabel('passed')).toBe('通过')
  })
})
