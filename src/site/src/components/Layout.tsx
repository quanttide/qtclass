import type { ReactNode } from 'react'
import { NavLink } from 'react-router-dom'
import { ROUTE_PATHS } from '../routes'

// 站点外框：导航 + 页头 + 内容区，路由出口由调用方以 children 传入
function Layout({ children }: { children: ReactNode }) {
  return (
    <div className="app">
      <nav className="site-nav">
        <div className="nav-inner">
          <a className="site-brand" href={ROUTE_PATHS.home}>量潮课堂</a>
          <div className="site-links">
            <NavLink to={ROUTE_PATHS.home} end className={({ isActive }) => (isActive ? 'active' : '')}>
              课程
            </NavLink>
            <NavLink to={ROUTE_PATHS.learn} className={({ isActive }) => (isActive ? 'active' : '')}>
              学习
            </NavLink>
          </div>
        </div>
      </nav>

      <header className="hero">
        <h1>量潮课堂</h1>
        <p>课程体系展示 · 学习资料区框架</p>
      </header>

      <div className="content">{children}</div>
    </div>
  )
}

export default Layout
