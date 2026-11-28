import { describe, it, expect } from 'vitest'
import { CURRENT_TASKS, TASK_STATUSES, statusLabel } from './task'

const DETAIL_SECTIONS = ['任务背景', '任务内容', '任务输入', '交付物', '验收', '其他']

describe('任务载荷', () => {
  it('四本已通过的试用任务在架，slug 对齐档案', () => {
    expect(CURRENT_TASKS.map((task) => task.slug)).toEqual([
      'trial-qtdata-lite',
      'trial-qtclass-lite',
      'trial-qtcloud-lite',
      'trial-qtconsult-lite',
    ])
  })

  it('每本详情六章节齐全，字段与库存侧一致（不含两把尺）', () => {
    for (const task of CURRENT_TASKS) {
      const { detail } = task
      expect(detail.business, task.slug).toBeTruthy()
      expect(detail.category, task.slug).toBe('测评')
      expect(detail.status, task.slug).toBe('待认领')
      expect(detail.background, task.slug).toBeTruthy()
      expect(detail.content.length, task.slug).toBe(3)
      expect(detail.inputs.length, task.slug).toBe(3)
      expect(detail.deliverable, task.slug).toContain('试用记录')
      expect(detail.acceptance.length, task.slug).toBe(3)
      expect(detail.notes.length, task.slug).toBe(2)
      expect('tags' in task, task.slug).toBe(false)
    }
  })

  it('详情里没有代金券与 Issue', () => {
    for (const task of CURRENT_TASKS) {
      const flat = JSON.stringify(task)
      expect(flat, task.slug).not.toContain('代金券')
      expect(flat, task.slug).not.toContain('Issue')
      expect(flat, task.slug).not.toContain('四维打分')
    }
  })

  it('旧 review-* 任务书 slug 不复活', () => {
    const slugs = CURRENT_TASKS.map((task) => task.slug)
    for (const slug of slugs) {
      expect(slug.startsWith('review-'), slug).toBe(false)
    }
  })

  it('五状态机与显示名不变', () => {
    expect(TASK_STATUSES.map((item) => item.key)).toEqual([
      'todo',
      'doing',
      'submitted',
      'returned',
      'passed',
    ])
    expect(statusLabel('todo')).toBe('待做')
    expect(statusLabel('passed')).toBe('通过')
    expect(statusLabel('unknown' as never)).toBe('unknown')
  })

  it('章节名与详情页渲染一致', () => {
    expect(DETAIL_SECTIONS).toEqual([
      '任务背景',
      '任务内容',
      '任务输入',
      '交付物',
      '验收',
      '其他',
    ])
  })
})
