import { describe, it, expect } from 'vitest'
import { parseFrontmatter, learningEntries, getLearningEntry, itemsIn } from './learning'

describe('frontmatter 解析', () => {
  it('无 frontmatter 返回 null', () => {
    expect(parseFrontmatter('# 标题\n\n正文')).toBeNull()
  })

  it('平铺键值', () => {
    expect(parseFrontmatter('---\ntitle: 训练营\ndescription: 说明\n---\n# 标题')).toEqual({
      title: '训练营',
      description: '说明',
    })
  })

  it('带引号的值', () => {
    expect(
      parseFrontmatter('---\ntitle: "训练营：入门"\ndescription: \'含「引号」的说明\'\n---\n'),
    ).toEqual({ title: '训练营：入门', description: '含「引号」的说明' })
  })

  it('值含冒号须加引号', () => {
    expect(parseFrontmatter('---\ntitle: 训练营: 入门\ndescription: 说明\n---\n')).toBeNull()
    expect(
      parseFrontmatter('---\ntitle: "训练营: 入门"\ndescription: 说明\n---\n')?.title,
    ).toBe('训练营: 入门')
  })

  it('多行块标量', () => {
    const md = '---\ntitle: 训练营\ndescription: |\n  第一行\n  第二行\n---\n'
    expect(parseFrontmatter(md)?.description).toBe('第一行\n第二行')
  })

  it('只有 title 时仍返回', () => {
    expect(parseFrontmatter('---\ntitle: 训练营\n---\n')).toEqual({
      title: '训练营',
      description: '',
    })
  })

  it('键值均为空返回 null', () => {
    expect(parseFrontmatter('---\ntitle: ""\n---\n')).toBeNull()
  })

  it('非法 YAML 返回 null', () => {
    expect(parseFrontmatter('---\ntitle: : :\n\tbad\n---\n')).toBeNull()
  })

  it('仓库内学习资料均可解析出标题与描述', () => {
    expect(learningEntries.length).toBeGreaterThan(0)
    for (const entry of learningEntries) {
      expect(entry.title, entry.slug).toBeTruthy()
      expect(entry.description, entry.slug).toBeTruthy()
    }
  })
})

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
})
