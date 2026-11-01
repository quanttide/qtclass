import { describe, it, expect, afterEach } from 'vitest'
import { render, screen, cleanup } from '@testing-library/react'
import '@testing-library/jest-dom/vitest'
import App from '../App'

// 价格页：三档付费对象在上，C 档明细两篇内联
describe('价格页分档', () => {
  it('渲染三档', () => {
    window.history.pushState({}, '', '/prices')
    render(<App />)
    expect(screen.getByText('G 端 · 校企合作')).toBeInTheDocument()
    expect(screen.getByText('B 端 · 企业培训与人才交付')).toBeInTheDocument()
    expect(screen.getByText('C 端 · 个人学习')).toBeInTheDocument()
  })

  it('C 档明细两篇内联可见', () => {
    window.history.pushState({}, '', '/prices')
    render(<App />)
    expect(screen.getByRole('heading', { name: '一对一咨询定价' })).toBeInTheDocument()
    expect(screen.getByRole('heading', { name: '任务参与免费' })).toBeInTheDocument()
  })

  it('三档卡片不带价格数字', () => {
    window.history.pushState({}, '', '/prices')
    render(<App />)
    const tracks = ['G 端 · 校企合作', 'B 端 · 企业培训与人才交付', 'C 端 · 个人学习']
    for (const label of tracks) {
      const card = screen.getByText(label).closest('.learnCard') as HTMLElement
      expect(card, label).toBeTruthy()
      expect(card.textContent, label).not.toMatch(/\d+\s*元/)
    }
  })
})

afterEach(cleanup)
