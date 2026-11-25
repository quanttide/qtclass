import { describe, it, expect, afterEach } from 'vitest'
import { render, screen, cleanup } from '@testing-library/react'
import '@testing-library/jest-dom/vitest'
import App from '../App'

// 课时链路：课堂页出入口 → 课时详情按 name 取到 → 未知名诚实提示
describe('课时详情', () => {
  afterEach(cleanup)

  it('课堂页AI编程卡导航到课程主页', () => {
    window.history.pushState({}, '', '/')
    render(<App />)
    const link = screen.getByRole('link', { name: 'AI编程 课程主页' })
    expect(link).toHaveAttribute('href', '/courses/ai-programming')
  })

  it('课时详情渲染页眉与分步正文', () => {
    window.history.pushState({}, '', '/lessons/hello-world')
    render(<App />)
    expect(screen.getByText('AI编程 · 第 1 课')).toBeInTheDocument()
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

  it('未知课时回课堂', () => {
    window.history.pushState({}, '', '/lessons/no-such')
    render(<App />)
    expect(screen.getByText('课时未找到')).toBeInTheDocument()
  })

  it('四张通识卡都进课程主页，按分级展示并标已上线', () => {
    window.history.pushState({}, '', '/')
    render(<App />)
    // 分级标题 + 四张卡整体可点进课程主页；课时列表在课程主页，不在卡片上
    expect(screen.getByRole('heading', { level: 2, name: '通识课程 · 大一' })).toBeInTheDocument()
    expect(screen.getAllByRole('link', { name: /课程主页/ })).toHaveLength(4)
    expect(screen.getAllByText('已上线')).toHaveLength(4)
    // 班级块：有班的两门卡上带状态与报名条件，限额只有 AI编程有事实
    expect(screen.getAllByText(/报名条件/)).toHaveLength(2)
    expect(screen.getByText(/免费 3~5 名/)).toBeInTheDocument()
    expect(screen.getByRole('link', { name: 'AI创意 课程主页' })).toHaveAttribute(
      'href',
      '/courses/ai-creative',
    )
    expect(screen.getByRole('link', { name: 'AI办公 课程主页' })).toHaveAttribute(
      'href',
      '/courses/ai-office',
    )
    expect(screen.getByRole('link', { name: 'AI编程 课程主页' })).toHaveAttribute(
      'href',
      '/courses/ai-programming',
    )
    expect(screen.getByRole('link', { name: 'AI教学 课程主页' })).toHaveAttribute(
      'href',
      '/courses/ai-teaching',
    )
  })

  it('AI办公课时渲染页眉与一键复制指令', () => {
    window.history.pushState({}, '', '/lessons/work-hello-world')
    render(<App />)
    expect(screen.getByText('AI办公 · 第 1 课')).toBeInTheDocument()
    expect(
      screen.getByRole('heading', { level: 1, name: '总裁查岗：一句话摸清家底' }),
    ).toBeInTheDocument()
    expect(screen.getByRole('heading', { level: 2, name: '打开工具，粘贴下面这句话' })).toBeInTheDocument()
    expect(
      screen.getAllByText(/访问 game.quanttide.com\/tycoon/).length,
    ).toBeGreaterThan(0)
    expect(screen.getByRole('button', { name: '复制这句话' })).toBeInTheDocument()
  })

  it('AI创意课时第 3 步给出可复制的生成指令', () => {
    window.history.pushState({}, '', '/lessons/creative-hello-world')
    render(<App />)
    expect(screen.getByRole('heading', { level: 1, name: '用 AI 生成你的第一张图' })).toBeInTheDocument()
    expect(screen.getByRole('heading', { level: 2, name: '复制这句话，发给元宝' })).toBeInTheDocument()
    expect(screen.getAllByRole('button', { name: '复制这句话' }).length).toBeGreaterThan(0)
    expect(screen.getAllByText(/用刚才那段提示词，直接生成一张图片/).length).toBeGreaterThan(0)
  })

  it('领域课程已移到 qtcloud-course 的课程清单，学员端不出现', () => {
    window.history.pushState({}, '', '/')
    render(<App />)

    for (const moved of ['知识工作', '大数据导论', '数据工程', '生产实习']) {
      expect(screen.queryByText(moved)).toBeNull()
    }
  })

  it('课堂页上架课程顺序：AI创意 → AI办公 → AI编程 → AI教学', () => {
    window.history.pushState({}, '', '/')
    render(<App />)
    const cards = screen.getAllByRole('heading', { level: 3 }).map((node) => node.textContent)
    expect(cards).toEqual(['AI创意', 'AI办公', 'AI编程', 'AI教学'])
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
    expect(screen.getByText('AI编程 · 第二章 · 第 1 课')).toBeInTheDocument()
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
