import { describe, it, expect, afterEach } from 'vitest'
import { render, screen, cleanup } from '@testing-library/react'
import '@testing-library/jest-dom/vitest'
import App from './App'

// 冒烟：三个页签与压入页必须渲染可用。白屏（坏 import、渲染期崩溃、内容定位失败）会在这里失败
// 两把尺标签体系已转至 qtcloud-crowd lite，本仓不再有筛选器与任务书 Markdown
describe('页面渲染冒烟', () => {
  const routes = [
    { path: '/practice', text: '测评量潮数据 Lite' },
    { path: '/practice', text: '测评量潮咨询 Lite' },
    { path: '/tasks/trial-qtclass-lite', text: '任务背景' },
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

  it('反馈页逐任务展示评语位（四任务四卡）', () => {
    window.history.pushState({}, '', '/feedback')
    render(<App />)
    expect(screen.getAllByText(/尚无评语/).length).toBe(4)
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
    window.history.pushState({}, '', '/tasks/trial-qtdata-lite')
    render(<App />)
    expect(screen.queryByRole('navigation', { name: '主导航' })).toBeNull()
  })

  it('实践页无筛选器（标签体系已转出），四本试用任务在架', () => {
    window.history.pushState({}, '', '/practice')
    render(<App />)
    expect(screen.queryByRole('group', { name: '需求的精确程度' })).toBeNull()
    expect(screen.queryByRole('group', { name: '验收标准的开放程度' })).toBeNull()
    expect(screen.getAllByText(/测评量潮/).length).toBe(4)
    expect(screen.queryByText(/货架当前为空/)).toBeNull()
  })
})

// 实践与课堂同构：都是 sectionHead + learnGrid + learnCard 卡片
describe('实践页与课堂页 UI 统一', () => {
  it('实践页是 learnGrid 卡片', () => {
    window.history.pushState({}, '', '/practice')
    render(<App />)
    expect(document.querySelectorAll('.learnGrid').length).toBe(1)
    expect(document.querySelectorAll('.learnCard').length).toBe(4)
    expect(screen.getByRole('heading', { name: '任务' })).toBeInTheDocument()
    expect(screen.getByText('Practice')).toBeInTheDocument()
  })

  it('课堂页同为 learnGrid 卡片', () => {
    window.history.pushState({}, '', '/')
    render(<App />)
    expect(document.querySelectorAll('.learnGrid').length).toBeGreaterThan(0)
    expect(document.querySelectorAll('.learnCard').length).toBeGreaterThan(0)
    expect(screen.getByText('Courses')).toBeInTheDocument()
  })

  it('实践卡片压入详情，卡片带入口行', () => {
    window.history.pushState({}, '', '/practice')
    render(<App />)
    const card = screen.getByRole('link', { name: '测评量潮数据 Lite 任务详情' })
    expect(card).toHaveClass('learnCard')
    expect(card).toHaveTextContent('任务详情 ›')
  })
})

// 任务详情：按档案结构逐字段渲染，与库存侧同构，不落 Markdown
describe('任务详情', () => {
  function openDetail() {
    window.history.pushState({}, '', '/tasks/trial-qtdata-lite')
    render(<App />)
  }

  it('六个章节齐全', () => {
    openDetail()
    expect(
      screen.getByRole('heading', { level: 1, name: '测评量潮数据 Lite' }),
    ).toBeInTheDocument()
    for (const heading of ['任务背景', '任务内容', '任务输入', '交付物', '验收', '其他']) {
      expect(screen.getByRole('heading', { level: 2, name: heading })).toBeInTheDocument()
    }
    expect(
      screen.getByText('业务：量潮数据 · 类别：测评 · 状态：待认领'),
    ).toBeInTheDocument()
    expect(screen.getByText(/首页 → 数据功能页 → 返回/)).toBeInTheDocument()
    expect(screen.getByText(/提交通道接通后开放/)).toBeInTheDocument()
  })

  it('不落 Markdown：无原始标记、无代金券与 Issue', () => {
    openDetail()
    expect(screen.queryByText(/^## /)).toBeNull()
    expect(screen.queryByText(/^- 业务/m)).toBeNull()
    expect(screen.queryByText(/立题/)).toBeNull()
    expect(screen.queryByText(/代金券/)).toBeNull()
    expect(screen.queryByText(/Issue/)).toBeNull()
    expect(screen.queryByText(/四维打分/)).toBeNull()
  })

  it('带返回入口', () => {
    openDetail()
    expect(screen.getByRole('link', { name: '← 任务' })).toBeInTheDocument()
  })
})

afterEach(cleanup)
