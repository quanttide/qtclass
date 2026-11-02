import { describe, it, expect, afterEach } from 'vitest'
import { render, screen, cleanup } from '@testing-library/react'
import '@testing-library/jest-dom/vitest'
import App from '../App'

// 价格页：只保留三种服务模式
describe('价格页服务模式', () => {
  it('渲染三档', () => {
    window.history.pushState({}, '', '/prices')
    render(<App />)
    expect(screen.getByText('G 端 · 校企合作')).toBeInTheDocument()
    expect(screen.getByText('B 端 · 企业培训与人才交付')).toBeInTheDocument()
    expect(screen.getByText('C 端 · 个人学习')).toBeInTheDocument()
  })

  it('不渲染明细内容，三档不带价格数字', () => {
    window.history.pushState({}, '', '/prices')
    render(<App />)
    expect(screen.queryByRole('heading', { name: '一对一咨询定价' })).toBeNull()
    expect(screen.queryByRole('heading', { name: '任务参与免费' })).toBeNull()
    const tracks = ['G 端 · 校企合作', 'B 端 · 企业培训与人才交付', 'C 端 · 个人学习']
    for (const label of tracks) {
      const card = screen.getByText(label).closest('.learnCard') as HTMLElement
      expect(card.textContent, label).not.toMatch(/\d+\s*元/)
    }
  })
})

afterEach(cleanup)
