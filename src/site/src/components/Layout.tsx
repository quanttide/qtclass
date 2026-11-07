import type { ReactNode } from 'react'
import { NavLink } from 'react-router-dom'
import { EXTERNAL_LINKS, ROUTE_PATHS } from '../routes'

// 站点外框：导航 + 页头 + 内容区，路由出口由调用方以 children 传入
function Layout({ children }: { children: ReactNode }) {
  return (
    <div className="app">
      <nav className="site-nav">
        <div className="nav-inner">
          <a className="site-brand" href={ROUTE_PATHS.home}>
            量潮课堂
          </a>
          <div className="site-links">
            <NavLink
              to={ROUTE_PATHS.home}
              end
              className={({ isActive }) => (isActive ? 'active' : '')}
            >
              首页
            </NavLink>
            <NavLink
              to={ROUTE_PATHS.prices}
              className={({ isActive }) => (isActive ? 'active' : '')}
            >
              价格
            </NavLink>
            <a href={EXTERNAL_LINKS.lite} target="_blank" rel="noreferrer">
              Lite
            </a>
            <a href={EXTERNAL_LINKS.studio} target="_blank" rel="noreferrer">
              Studio
            </a>
          </div>
        </div>
      </nav>

      <header className="hero">
        <h1>量潮课堂</h1>
        <p>课程特色 · 价格与合作方式</p>
      </header>

      <div className="content">{children}</div>
    </div>
  )
}

export default Layout
