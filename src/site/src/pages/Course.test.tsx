import { describe, it, expect, afterEach } from 'vitest'
import { render, screen, cleanup, within } from '@testing-library/react'
import '@testing-library/jest-dom/vitest'
import App from '../App'

// 课程页两级分类：理论课 / 实践课，实践课并入训练营
describe('课程页两级分类', () => {
  it('理论课一节含体系课程，不含实践内容', () => {
    window.history.pushState({}, '', '/courses')
    render(<App />)
    const theory = screen.getByRole('heading', { name: '理论课' }).closest('section') as HTMLElement
    expect(within(theory).getByText('大数据导论')).toBeInTheDocument()
    expect(within(theory).getByText('知识工作')).toBeInTheDocument()
    expect(within(theory).queryByText('生产实习')).toBeNull()
    expect(within(theory).queryByText('智能体工程师训练营')).toBeNull()
  })

  it('实践课一节含生产实习与训练营', () => {
    window.history.pushState({}, '', '/courses')
    render(<App />)
    const practice = screen.getByRole('heading', { name: '实践课' }).closest('section') as HTMLElement
    expect(within(practice).getByText('生产实习')).toBeInTheDocument()
    expect(within(practice).getByText('智能体工程师训练营')).toBeInTheDocument()
    expect(within(practice).queryByText('数据工程')).toBeNull()
  })

  it('训练营卡片跳转训练营详情', () => {
    window.history.pushState({}, '', '/courses')
    render(<App />)
    const practice = screen.getByRole('heading', { name: '实践课' }).closest('section') as HTMLElement
    const link = within(practice).getByRole('link', { name: /智能体工程师训练营/ })
    expect(link).toHaveAttribute('href', '/learn/schedules/agent-engineer')
  })
})

afterEach(cleanup)
