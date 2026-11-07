import { describe, it, expect, afterEach } from 'vitest'
import { render, screen, cleanup, fireEvent, within } from '@testing-library/react'
import '@testing-library/jest-dom/vitest'
import App from './App'

// 冒烟：三个页签、压入页与筛选器必须渲染可用。白屏（坏 import、渲染期崩溃、内容定位失败）会在这里失败
describe('页面渲染冒烟', () => {
  const routes = [
    { path: '/', text: '小说发行工作室任务' },
    { path: '/', text: '模拟经营游戏工作室任务' },
    { path: '/theory', text: '大数据导论' },
    { path: '/mine', text: /待接入/ },
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

  it('未知任务回实践', () => {
    window.history.pushState({}, '', '/tasks/no-such')
    render(<App />)
    expect(screen.getByText('任务未找到')).toBeInTheDocument()
  })

  it('未知路径重定向到实践', () => {
    window.history.pushState({}, '', '/whatever')
    render(<App />)
    expect(screen.getAllByText('小说发行工作室任务').length).toBeGreaterThan(0)
  })

  it('顶栏标题与底部三页签', () => {
    window.history.pushState({}, '', '/')
    render(<App />)
    expect(screen.getByRole('heading', { name: '量潮课堂' })).toBeInTheDocument()
    const nav = screen.getByRole('navigation', { name: '主导航' })
    expect(nav).toBeInTheDocument()
    for (const label of ['理论', '实践', '我的']) {
      expect(screen.getAllByText(label).length).toBeGreaterThan(0)
    }
  })

  it('压入页隐藏底部导航', () => {
    window.history.pushState({}, '', '/tasks/qtgame-tycoon')
    render(<App />)
    expect(screen.queryByRole('navigation', { name: '主导航' })).toBeNull()
  })
})

describe('两排筛选', () => {
  it('点「精确」筛出试用 CLI，行内回显选中态', () => {
    window.history.pushState({}, '', '/')
    render(<App />)

    // 默认全部可见
    expect(screen.getByText(/摸底 lark-cli/)).toBeInTheDocument()

    fireEvent.click(screen.getByRole('button', { name: '精确' }))
    expect(screen.getByText(/试用量潮工作云/)).toBeInTheDocument()
    expect(screen.queryByText(/摸底 lark-cli/)).toBeNull()

    const row = screen.getByRole('group', { name: '需求的精确程度' })
    expect(within(row).getByRole('button', { name: '精确' })).toHaveAttribute(
      'aria-pressed',
      'true',
    )
    expect(within(row).getByRole('button', { name: '全部' })).toHaveAttribute(
      'aria-pressed',
      'false',
    )
  })

  it('精确 × 开放无交集时给出空态', () => {
    window.history.pushState({}, '', '/')
    render(<App />)

    fireEvent.click(screen.getByRole('button', { name: '精确' }))
    fireEvent.click(screen.getByRole('button', { name: '开放' }))

    expect(screen.getByText('没有符合筛选条件的任务书。')).toBeInTheDocument()
    const row = screen.getByRole('group', { name: '验收标准的开放程度' })
    expect(within(row).getByRole('button', { name: '开放' })).toHaveAttribute(
      'aria-pressed',
      'true',
    )
  })

  it('两排选项常驻可见（无弹层）', () => {
    window.history.pushState({}, '', '/')
    render(<App />)
    expect(screen.queryByRole('dialog')).toBeNull()
    for (const label of ['模糊', '半精确', '封闭', '半开放']) {
      expect(screen.getByRole('button', { name: label })).toBeInTheDocument()
    }
  })
})

afterEach(cleanup)
