import { describe, it, expect, afterEach } from 'vitest'
import { render, screen, cleanup } from '@testing-library/react'
import '@testing-library/jest-dom/vitest'
import App from './App'

// 冒烟测试：每个路由必须渲染出内容。白屏（坏 import、渲染期崩溃、内容定位失败）会在这里失败。
describe('页面渲染冒烟', () => {
  const routes = [
    { path: '/', text: '五门课' },
    { path: '/learn', text: '按学习路径推进的训练计划。' },
    { path: '/learn/schedules/agent-engineer', text: '智能体工程师训练营' },
    { path: '/learn/tasks/data-roadmap', text: '更新数据工程路线图' },
    { path: '/learn/prices/consultation', text: '一对一咨询定价' },
  ]

  for (const { path, text } of routes) {
    it(`渲染 ${path}`, () => {
      window.history.pushState({}, '', path)
      render(<App />)
      expect(screen.getAllByText(text).length).toBeGreaterThan(0)
    })
  }

  it('未知板块渲染未找到', () => {
    window.history.pushState({}, '', '/learn/unknown/whatever')
    render(<App />)
    expect(screen.getByText('内容未找到')).toBeInTheDocument()
  })
})

afterEach(cleanup)
