import { describe, it, expect, afterEach } from 'vitest'
import { render, screen, cleanup } from '@testing-library/react'
import '@testing-library/jest-dom/vitest'
import App from './App'

// 冒烟：三个路由必须渲染出内容，未知路由回今日任务
describe('页面渲染冒烟', () => {
  const routes = [
    { path: '/', text: '小说发行工作室任务' },
    { path: '/', text: '模拟经营游戏工作室任务' },
    { path: '/tasks/qtgame-tycoon', text: /题面素材/ },
    { path: '/tasks/quanttide-fiction-of-founder', text: /4399|晋江/ },
    { path: '/feedback', text: /尚无评语/ },
  ]

  for (const { path, text } of routes) {
    it(`渲染 ${path}（${text}）`, () => {
      window.history.pushState({}, '', path)
      render(<App />)
      expect(screen.getAllByText(text).length).toBeGreaterThan(0)
    })
  }

  it('未知任务回今日任务', () => {
    window.history.pushState({}, '', '/tasks/no-such')
    render(<App />)
    expect(screen.getByText('任务未找到')).toBeInTheDocument()
  })

  it('未知路径重定向到今日任务', () => {
    window.history.pushState({}, '', '/whatever')
    render(<App />)
    expect(screen.getAllByText('小说发行工作室任务').length).toBeGreaterThan(0)
  })

  it('无导航菜单与配置项', () => {
    window.history.pushState({}, '', '/')
    render(<App />)
    const navs = document.querySelectorAll('nav')
    expect(navs.length).toBe(0)
    expect(screen.queryByText(/设置|目录|选课|课表/)).toBeNull()
  })
})

afterEach(cleanup)
