import { describe, it, expect, afterEach } from 'vitest'
import { render, screen, cleanup } from '@testing-library/react'
import '@testing-library/jest-dom/vitest'
import App from '../App'

// 课程页：单一课程列表，不分类，训练营不在本页
describe('课程页课程列表', () => {
  it('列举全部课程', () => {
    window.history.pushState({}, '', '/courses')
    render(<App />)
    for (const name of ['知识工作', '氛围编程', '大数据导论', '数据工程', '生产实习']) {
      expect(screen.getByText(name), name).toBeInTheDocument()
    }
  })

  it('不渲染理论 / 实践分类与训练营', () => {
    window.history.pushState({}, '', '/courses')
    render(<App />)
    expect(screen.queryByRole('heading', { name: '理论课' })).toBeNull()
    expect(screen.queryByRole('heading', { name: '实践课' })).toBeNull()
    expect(screen.queryByText('智能体工程师训练营')).toBeNull()
    expect(screen.queryByText('产品经理训练营')).toBeNull()
  })
})

afterEach(cleanup)
