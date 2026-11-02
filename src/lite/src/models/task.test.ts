import { describe, it, expect } from 'vitest'
import { CURRENT_TASKS, taskbooks, getTaskbook, statusLabel, TASK_STATUSES } from './task'

describe('任务契约与内容', () => {
  it('12 篇任务书已入库且可解析标题（frontmatter 或正文一级标题）', () => {
    expect(taskbooks.length).toBe(12)
    for (const book of taskbooks) {
      expect(book.title, book.slug).toBeTruthy()
      expect(book.title, book.slug).not.toBe(book.slug)
      expect(book.content, book.slug).toBeTruthy()
    }
    expect(getTaskbook('qtgame-tycoon')?.title).toBe('量潮模拟经营游戏任务书')
    expect(getTaskbook('quanttide-fiction-of-founder')?.title).toBe('量潮小说发行任务书')
  })

  it('当前任务 = 小说与游戏两个工作室任务，题面素材均在库', () => {
    expect(CURRENT_TASKS.map((t) => t.slug)).toEqual([
      'quanttide-fiction-of-founder',
      'qtgame-tycoon',
    ])
    for (const task of CURRENT_TASKS) {
      expect(task.taskbookSlug, task.slug).toBeTruthy()
      expect(getTaskbook(task.taskbookSlug!), task.slug).toBeDefined()
      expect(task.prompt, task.slug).toContain('题面素材')
    }
  })

  it('状态枚举五件套可显示', () => {
    expect(TASK_STATUSES.map((s) => s.key)).toEqual(['todo', 'doing', 'submitted', 'returned', 'passed'])
    expect(statusLabel('returned')).toBe('退回')
    expect(statusLabel('passed')).toBe('通过')
  })
})
