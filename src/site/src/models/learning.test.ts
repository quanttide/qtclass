import { describe, it, expect } from 'vitest'
import { learningEntries, getLearningEntry, itemsIn } from './learning'

describe('学习资料索引', () => {
  it('按板块与 slug 取到条目', () => {
    expect(getLearningEntry('tasks', 'data-roadmap')?.title).toBe('更新数据工程路线图')
    expect(getLearningEntry('schedules', 'agent-engineer')?.title).toBe('智能体工程师训练营')
    expect(getLearningEntry('prices', 'consultation')?.title).toBe('一对一咨询定价')
  })

  it('未知 slug 返回 undefined', () => {
    expect(getLearningEntry('tasks', 'no-such-task')).toBeUndefined()
  })

  it('每条索引都归属自己的板块列表', () => {
    for (const entry of learningEntries) {
      expect(itemsIn(entry.section).some((item) => item.slug === entry.slug), entry.slug).toBe(true)
    }
  })

  it('仓库内学习资料均可解析出标题与描述', () => {
    expect(learningEntries.length).toBeGreaterThan(0)
    for (const entry of learningEntries) {
      expect(entry.title, entry.slug).toBeTruthy()
      expect(entry.description, entry.slug).toBeTruthy()
    }
  })

  it('条目正文不含 frontmatter', () => {
    expect(learningEntries.length).toBeGreaterThan(0)
    for (const entry of learningEntries) {
      expect(entry.content.startsWith('---'), entry.slug).toBe(false)
      expect(entry.content).not.toContain('description:')
    }
  })
})
