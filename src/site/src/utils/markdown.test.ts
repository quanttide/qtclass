import { describe, it, expect } from 'vitest'
import { markdownToHtml } from './markdown'

describe('markdown 渲染', () => {
  it('表格包进 table/thead/tbody，首行作表头', () => {
    const html = markdownToHtml('| 职级 | 价格 |\n|---|---|\n| 首席 | 500 |')
    expect(html).toContain('<table>')
    expect(html).toContain('<thead>')
    expect(html).toContain('<th>职级</th>')
    expect(html).toContain('<tbody>')
    expect(html).toContain('<td>首席</td>')
  })

  it('无分隔行时全部作表体', () => {
    const html = markdownToHtml('| A | B |\n| C | D |')
    expect(html).not.toContain('<thead>')
    expect(html).toContain('<td>A</td>')
    expect(html).toContain('<td>C</td>')
  })

  it('表格前的列表正确收尾', () => {
    const html = markdownToHtml('- 甲\n- 乙\n\n| A |\n|---|\n| 1 |')
    expect(html).toContain('</ul>')
    expect(html.indexOf('</ul>')).toBeLessThan(html.indexOf('<table>'))
  })

  it('标题、列表、引用块、代码块', () => {
    const html = markdownToHtml('# 标题\n\n- 甲\n\n> 引用\n\n```ts\nconst a = 1\n```')
    expect(html).toContain('<h1>标题</h1>')
    expect(html).toContain('<li>甲</li>')
    expect(html).toContain('<blockquote>引用</blockquote>')
    expect(html).toContain('<code class="language-ts">const a = 1</code>')
  })
})
