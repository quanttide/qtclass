import { describe, it, expect, afterEach } from 'vitest'
import { render, screen, cleanup } from '@testing-library/react'
import '@testing-library/jest-dom/vitest'
import App from './App'

// 冒烟：首页与价格页必须渲染出内容，未知路由回首页。白屏会在这里失败
describe('页面渲染冒烟', () => {
  const routes = [
    { path: '/', text: /议事型课堂/ },
    { path: '/prices', text: 'G 端 · 校企合作' },
  ]

  for (const { path, text } of routes) {
    it(`渲染 ${path}`, () => {
      window.history.pushState({}, '', path)
      render(<App />)
      expect(screen.getAllByText(text).length).toBeGreaterThan(0)
    })
  }

  it('未知路径重定向到首页', () => {
    window.history.pushState({}, '', '/whatever')
    render(<App />)
    expect(screen.getAllByText(/议事型课堂/).length).toBeGreaterThan(0)
  })

  it('首页不渲染元数据', () => {
    window.history.pushState({}, '', '/')
    render(<App />)
    expect(screen.queryByText(/^title:/)).toBeNull()
    expect(screen.queryByText(/^description:/)).toBeNull()
  })

  it('导航含 lite 与 studio 连接引用', () => {
    window.history.pushState({}, '', '/')
    render(<App />)
    const lite = screen.getByRole('link', { name: 'Lite' })
    expect(lite).toHaveAttribute('href', 'https://lite.class.quanttide.com')
    expect(lite).toHaveAttribute('target', '_blank')
    const studio = screen.getByRole('link', { name: 'Studio' })
    expect(studio).toHaveAttribute('href', 'https://studio.class.quanttide.com')
    expect(studio).toHaveAttribute('target', '_blank')
  })
})

afterEach(cleanup)
