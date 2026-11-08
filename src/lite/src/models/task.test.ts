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
  it('19 篇任务书已入库且可解析标题（frontmatter 或正文一级标题）', () => {
    expect(taskbooks.length).toBe(19)
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

describe('任务书两把尺（frontmatter tags）', () => {
  it('19 篇全部标注且取值合法', () => {
    expect(taskbooks.length).toBe(19)
    for (const book of taskbooks) {
      if (book.tags.requirement) {
        expect(REQUIREMENTS.some((r) => r.value === book.tags.requirement), book.slug).toBe(true)
      }
      if (book.tags.acceptance) {
        expect(ACCEPTANCES.some((a) => a.value === book.tags.acceptance), book.slug).toBe(true)
      }
    }
  })

  it('两把尺的枚举与显示名', () => {
    expect(REQUIREMENTS.map((r) => r.value)).toEqual(['fuzzy', 'semi', 'precise'])
    expect(REQUIREMENTS.map((r) => r.label)).toEqual(['模糊', '半精确', '精确'])
    expect(ACCEPTANCES.map((a) => a.value)).toEqual(['closed', 'semi', 'open'])
    expect(ACCEPTANCES.map((a) => a.label)).toEqual(['封闭', '半开放', '开放'])
  })

  it('真题落档：试用 CLI = 精确/封闭，小说与游戏 = 半精确/半开放', () => {
    expect(getTaskbook('try-qtcloud-work-cli')?.tags).toEqual({
      requirement: 'precise',
      acceptance: 'closed',
    })
    expect(getTaskbook('quanttide-fiction-of-founder')?.tags).toEqual({
      requirement: 'semi',
      acceptance: 'semi',
    })
    expect(getTaskbook('qtgame-tycoon')?.tags).toEqual({
      requirement: 'semi',
      acceptance: 'semi',
    })
  })
})
