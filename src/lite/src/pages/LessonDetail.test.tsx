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

  it('首课只有下一课入口，末课只有上一课入口', () => {
    window.history.pushState({}, '', '/lessons/hello-world')
    render(<App />)
    expect(screen.getByRole('link', { name: /下一课/ })).toHaveAttribute(
      'href',
      '/lessons/lesson-2-coffee-shop',
    )
    expect(screen.queryByRole('link', { name: /上一课/ })).toBeNull()
    cleanup()

    // 第一章收官接第二章开篇：lesson-4 的下一课是第二章第 1 课
    window.history.pushState({}, '', '/lessons/lesson-4-publish')
    render(<App />)
    expect(screen.getByRole('link', { name: /下一课/ })).toHaveAttribute(
      'href',
      '/lessons/lesson-5-store-dashboard',
    )
    cleanup()

    window.history.pushState({}, '', '/lessons/lesson-5-store-dashboard')
    render(<App />)
    expect(screen.getByRole('link', { name: /上一课/ })).toHaveAttribute(
      'href',
      '/lessons/lesson-4-publish',
    )
    expect(screen.queryByRole('link', { name: /下一课/ })).toBeNull()
  })

  it('第二章第 1 课渲染页眉与分步正文', () => {
    window.history.pushState({}, '', '/lessons/lesson-5-store-dashboard')
    render(<App />)
    expect(screen.getByText('氛围编程 · 第二章 · 第 1 课')).toBeInTheDocument()
    expect(
      screen.getByRole('heading', { level: 1, name: '从游戏出发，做一个真实的门店经营看板' }),
    ).toBeInTheDocument()
    expect(screen.getByRole('heading', { level: 2, name: '复制这句话，粘贴进去' })).toBeInTheDocument()
    // 一键复制的指令原样可见，学员不手打
    expect(
      screen.getAllByText(/把我做的咖啡店游戏，改成一个真实的门店经营看板/).length,
    ).toBeGreaterThan(0)
    expect(screen.getByRole('button', { name: '复制这句话' })).toBeInTheDocument()
  })
})
