import { describe, it, expect, afterEach } from 'vitest'
import { render, screen, cleanup } from '@testing-library/react'
import '@testing-library/jest-dom/vitest'
import App from '../App'

// 课程主页链路：卡片进得来 → 介绍/课时/班级三节都在 → 未开班不出班级节 → 未知名诚实提示
describe('课程主页', () => {
  afterEach(cleanup)

  it('招生中班级渲染介绍、课时与五件套', () => {
    window.history.pushState({}, '', '/courses/vibe-coding')
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
    // 招生中（AI编程）：状态、节奏、限额、窗口、报名条件与入口俱全
    expect(screen.getByRole('heading', { level: 2, name: '首期' })).toBeInTheDocument()
    expect(screen.getByText('招生中')).toBeInTheDocument()
    expect(screen.getByText('每周一个学习周期，可拖到 10 天再结算')).toBeInTheDocument()
    expect(screen.getByText(/免费 3~5 名/)).toBeInTheDocument()
    expect(screen.getByText(/11 月 23 日起开放/)).toBeInTheDocument()
    expect(screen.getByText(/按第 1 课交成品/)).toBeInTheDocument()
    expect(screen.getByRole('link', { name: /发邮件报名/ })).toHaveAttribute(
      'href',
      'mailto:class@quanttide.cn',
    )
  })

  it('已下线课程落到未找到', () => {
    window.history.pushState({}, '', '/courses/vibe-teaching')
    render(<App />)
    expect(screen.getByText('课程未找到')).toBeInTheDocument()
  })

  it('招生中班级无事实字段时只出状态与入口', () => {
    window.history.pushState({}, '', '/courses/vibe-working')
    render(<App />)
    expect(screen.getByRole('heading', { level: 1, name: 'AI办公' })).toBeInTheDocument()
    expect(screen.getByText('招生中')).toBeInTheDocument()
    const signup = screen.getByRole('link', { name: /发邮件报名/ })
    expect(signup).toHaveAttribute('href', 'mailto:class@quanttide.cn')
    expect(screen.queryByText('示例')).toBeNull()
  })

  it('官方示例两条只在有示例的课程出现', () => {
    window.history.pushState({}, '', '/courses/vibe-coding')
    render(<App />)
    expect(screen.getByText('示例')).toBeInTheDocument()
    expect(screen.getByRole('link', { name: /试玩游戏/ })).toHaveAttribute(
      'href',
      'https://tycoon.game.quanttide.com',
    )
    expect(screen.getByRole('link', { name: /查看宣传册/ })).toHaveAttribute(
      'href',
      'https://game.quanttide.com/tycoon',
    )
  })

  it('未知课程回课堂', () => {
    window.history.pushState({}, '', '/courses/no-such')
    render(<App />)
    expect(screen.getByText('课程未找到')).toBeInTheDocument()
  })
})
