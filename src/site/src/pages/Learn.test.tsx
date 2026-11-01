import { describe, it, expect, afterEach } from 'vitest'
import { render, screen, cleanup } from '@testing-library/react'
import '@testing-library/jest-dom/vitest'
import App from '../App'

// 学习页价格分档：三档卡片在上，C 档明细两篇原样可达
describe('学习页价格分档', () => {
  it('prices 板块渲染三档', () => {
    window.history.pushState({}, '', '/learn')
    render(<App />)
    expect(screen.getByText('G 端 · 校企合作')).toBeInTheDocument()
    expect(screen.getByText('B 端 · 企业培训与人才交付')).toBeInTheDocument()
    expect(screen.getByText('C 端 · 个人学习')).toBeInTheDocument()
  })

  it('C 档下原有两篇价格明细可达', () => {
    window.history.pushState({}, '', '/learn')
    render(<App />)
    const consultation = screen.getByRole('link', { name: /一对一咨询定价/ })
    expect(consultation).toHaveAttribute('href', '/learn/prices/consultation')
    const freeParticipation = screen.getByRole('link', { name: /任务参与免费/ })
    expect(freeParticipation).toHaveAttribute('href', '/learn/prices/free-participation')
  })

  it('三档不带价格数字', () => {
    window.history.pushState({}, '', '/learn')
    const { container } = render(<App />)
    const tracks = ['G 端 · 校企合作', 'B 端 · 企业培训与人才交付', 'C 端 · 个人学习']
    for (const label of tracks) {
      const card = screen.getByText(label).closest('.learnCard') as HTMLElement
      expect(card, label).toBeTruthy()
      expect(card.textContent, label).not.toMatch(/\d+\s*元/)
    }
    expect(container).toBeTruthy()
  })
})

afterEach(cleanup)
