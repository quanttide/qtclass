import { describe, it, expect, afterEach } from 'vitest'
import { render, screen, cleanup } from '@testing-library/react'
import '@testing-library/jest-dom/vitest'
import App from './App'

// 冒烟：三个页签与压入页必须渲染可用。白屏（坏 import、渲染期崩溃、内容定位失败）会在这里失败
// 两把尺标签体系已转至 qtcloud-crowd lite，本仓不再有筛选器
describe('页面渲染冒烟', () => {
  const routes = [
    { path: '/practice', text: /货架当前为空/ },
    { path: '/', text: 'AI编程' },
    { path: '/courses/vibe-coding', text: '课程介绍' },
    { path: '/mine', text: /待接入/ },
  ]

  for (const { path, text } of routes) {
    it(`渲染 ${path}（${text}）`, () => {
      window.history.pushState({}, '', path)
      render(<App />)
      expect(screen.getAllByText(text).length).toBeGreaterThan(0)
    })
  }

  it('反馈页空数据不崩（无任务即无卡片）', () => {
    window.history.pushState({}, '', '/feedback')
    render(<App />)
    expect(screen.queryByText(/尚无评语/)).toBeNull()
  })

  it('未知任务回实践', () => {
    window.history.pushState({}, '', '/tasks/no-such')
    render(<App />)
    expect(screen.getByText('任务未找到')).toBeInTheDocument()
  })

  it('未知路径重定向到课堂', () => {
    window.history.pushState({}, '', '/whatever')
    render(<App />)
    expect(screen.getAllByText('AI编程').length).toBeGreaterThan(0)
  })

  it('顶栏标题与底部三页签', () => {
    window.history.pushState({}, '', '/')
    render(<App />)
    expect(screen.getByRole('heading', { name: '量潮课堂' })).toBeInTheDocument()
    const nav = screen.getByRole('navigation', { name: '主导航' })
    expect(nav).toBeInTheDocument()
    for (const label of ['课堂', '实践', '我的']) {
      expect(screen.getAllByText(label).length).toBeGreaterThan(0)
    }
  })

  it('压入页隐藏底部导航', () => {
    window.history.pushState({}, '', '/tasks/qtgame-tycoon')
    render(<App />)
    expect(screen.queryByRole('navigation', { name: '主导航' })).toBeNull()
  })

  it('实践页无筛选器（标签体系已转出）', () => {
    window.history.pushState({}, '', '/practice')
    render(<App />)
    expect(screen.queryByRole('group', { name: '需求的精确程度' })).toBeNull()
    expect(screen.queryByRole('group', { name: '验收标准的开放程度' })).toBeNull()
  })
})

afterEach(cleanup)
