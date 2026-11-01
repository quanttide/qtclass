import { describe, it, expect, afterEach } from 'vitest'
import { render, screen, cleanup } from '@testing-library/react'
import '@testing-library/jest-dom/vitest'
import App from './App'

// 冒烟测试：每个路由必须渲染出内容。白屏（坏 import、渲染期崩溃、内容定位失败）会在这里失败。
describe('页面渲染冒烟', () => {
  const routes = [
    { path: '/', text: '课程体系' },
    { path: '/courses', text: '理论课' },
    { path: '/courses', text: '实践课' },
    { path: '/prices', text: 'G 端 · 校企合作' },
    { path: '/prices', text: '一对一咨询定价' },
    { path: '/schedules/agent-engineer', text: '智能体工程师训练营' },
  ]

  for (const { path, text } of routes) {
    it(`渲染 ${path}`, () => {
      window.history.pushState({}, '', path)
      render(<App />)
      expect(screen.getAllByText(text).length).toBeGreaterThan(0)
    })
  }

  it('未知训练营渲染未找到', () => {
    window.history.pushState({}, '', '/schedules/no-such-such')
    render(<App />)
    expect(screen.getByText('内容未找到')).toBeInTheDocument()
  })

  it('首页与训练营详情不渲染元数据', () => {
    for (const path of ['/', '/schedules/agent-engineer']) {
      window.history.pushState({}, '', path)
      render(<App />)
      expect(screen.queryByText(/^title:/), path).toBeNull()
      expect(screen.queryByText(/^description:/), path).toBeNull()
      cleanup()
    }
  })
})

afterEach(cleanup)
