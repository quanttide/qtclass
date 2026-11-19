import { describe, it, expect, afterEach } from 'vitest'
import { render, screen, cleanup } from '@testing-library/react'
import '@testing-library/jest-dom/vitest'
import App from '../App'

// 课时链路：理论页出入口 → 课时详情按 name 取到 → 未知名诚实提示
describe('课时详情', () => {
  afterEach(cleanup)

  it('理论页氛围编程卡挂出课时入口', () => {
    window.history.pushState({}, '', '/')
    render(<App />)
    const link = screen.getByRole('link', { name: /做出你的第一个游戏/ })
    expect(link).toHaveAttribute('href', '/lessons/hello-world')
  })

  it('课时详情渲染页眉与分步正文', () => {
    window.history.pushState({}, '', '/lessons/hello-world')
    render(<App />)
    expect(screen.getByText('氛围编程 · 第 1 课')).toBeInTheDocument()
    expect(screen.getByRole('heading', { level: 1, name: '做出你的第一个游戏' })).toBeInTheDocument()
    expect(screen.getByRole('heading', { level: 2, name: '打开 WorkBuddy' })).toBeInTheDocument()
    expect(screen.getByRole('heading', { level: 2, name: '发给朋友，玩两局' })).toBeInTheDocument()
    // 一键复制的指令原样可见（复制框与「做完你会看到」各出现一次），学员不手打
    expect(
      screen.getAllByText('tycoon.game.quanttide.com 照着这个做一遍并且上线').length,
    ).toBeGreaterThan(0)
    expect(screen.getByRole('button', { name: '复制这句话' })).toBeInTheDocument()
    // 对照图取自 public/lessons/
    expect(screen.getByRole('img', { name: '串串摊游戏首页对照图' })).toHaveAttribute(
      'src',
      '/lessons/hello-world/game-preview.png',
    )
  })

  it('未知课时回理论', () => {
    window.history.pushState({}, '', '/lessons/no-such')
    render(<App />)
    expect(screen.getByText('课时未找到')).toBeInTheDocument()
  })

  it('只有氛围编程卡出课时入口，其余四张不出', () => {
    window.history.pushState({}, '', '/')
    render(<App />)
    // 「课时」小标题只出现一次，即只有氛围编程挂了课时
    expect(screen.getAllByText('课时')).toHaveLength(1)
    expect(screen.getByRole('link', { name: /做出你的第一个游戏/ })).toBeInTheDocument()
  })

  it('第 1 课只有下一课入口，第 4 课只有上一课入口', () => {
    window.history.pushState({}, '', '/lessons/hello-world')
    render(<App />)
    expect(screen.getByRole('link', { name: /下一课/ })).toHaveAttribute(
      'href',
      '/lessons/lesson-2-coffee-shop',
    )
    expect(screen.queryByRole('link', { name: /上一课/ })).toBeNull()
    cleanup()

    window.history.pushState({}, '', '/lessons/lesson-4-publish')
    render(<App />)
    expect(screen.getByRole('link', { name: /上一课/ })).toHaveAttribute(
      'href',
      '/lessons/lesson-3-worker',
    )
    expect(screen.queryByRole('link', { name: /下一课/ })).toBeNull()
  })
})
