import { describe, it, expect, afterEach, vi } from 'vitest'
import { render, screen, cleanup } from '@testing-library/react'
import '@testing-library/jest-dom/vitest'
import App from '../App'

// 在真实载荷（AI编程、AI创意在读班）之上补一条招生中记录，覆盖报名入口分支
vi.mock('../../data/cohorts', async (importOriginal) => {
  const actual = await importOriginal<typeof import('../../data/cohorts')>()
  return {
    cohorts: [
      ...actual.cohorts,
      {
        id: 'ai-teaching-1',
        course: 'AI教学',
        name: '首期',
        status: 'recruiting',
        schedule: '每周一个学习周期，可拖到 10 天再结算',
        signup: { label: '报名入班', href: 'mailto:class@quanttide.cn' },
      },
    ],
  }
})

// 课程主页链路：卡片进得来 → 介绍/课时/班级三节都在 → 未开班不出班级节 → 未知名诚实提示
describe('课程主页', () => {
  afterEach(cleanup)

  it('在读班课程渲染介绍、课时与班级', () => {
    window.history.pushState({}, '', '/courses/ai-programming')
    render(<App />)
    expect(screen.getByRole('heading', { level: 1, name: 'AI编程' })).toBeInTheDocument()
    expect(screen.getByText('课程介绍')).toBeInTheDocument()
    expect(screen.getByText('课时')).toBeInTheDocument()
    expect(screen.getByText('班级')).toBeInTheDocument()
    // 课时入口从课堂卡片移来这里
    expect(screen.getByRole('link', { name: /做出你的第一个游戏/ })).toHaveAttribute(
      'href',
      '/lessons/hello-world',
    )
    // 在读班：状态、节奏、限额、窗口、报名条件与入口俱全
    expect(screen.getByRole('heading', { level: 2, name: '首期' })).toBeInTheDocument()
    expect(screen.getByText('进行中')).toBeInTheDocument()
    expect(screen.getByText('每周一个学习周期，可拖到 10 天再结算')).toBeInTheDocument()
    expect(screen.getByText(/免费 3~5 名/)).toBeInTheDocument()
    expect(screen.getByText(/11 月 23 日起开放/)).toBeInTheDocument()
    expect(screen.getByText(/按第 1 课交成品/)).toBeInTheDocument()
    expect(screen.getByRole('link', { name: /发邮件报名/ })).toHaveAttribute(
      'href',
      'mailto:class@quanttide.cn',
    )
  })

  it('未开班课程不出班级节', () => {
    window.history.pushState({}, '', '/courses/ai-office')
    render(<App />)
    expect(screen.getByRole('heading', { level: 1, name: 'AI办公' })).toBeInTheDocument()
    expect(screen.queryByText('班级')).toBeNull()
  })

  it('招生中班级带报名入口', () => {
    window.history.pushState({}, '', '/courses/ai-teaching')
    render(<App />)
    expect(screen.getByText('招生中')).toBeInTheDocument()
    const signup = screen.getByRole('link', { name: /报名入班/ })
    expect(signup).toHaveAttribute('href', 'mailto:class@quanttide.cn')
  })

  it('未知课程回课堂', () => {
    window.history.pushState({}, '', '/courses/no-such')
    render(<App />)
    expect(screen.getByText('课程未找到')).toBeInTheDocument()
  })
})
