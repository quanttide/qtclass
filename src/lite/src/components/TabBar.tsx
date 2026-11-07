import type { ReactNode } from 'react'
import { NavLink, useLocation } from 'react-router-dom'
import { TABS, isTabPath, type TabIcon } from '../routes'

// 线性图标：理论=开卷、实践=任务板、我的=人形；当前页着色
const ICONS: Record<TabIcon, ReactNode> = {
  theory: (
    <svg viewBox="0 0 24 24" width="24" height="24" aria-hidden="true">
      <path
        d="M4 5.5h6a2 2 0 0 1 2 2v11a2 2 0 0 0-2-1.5H4zM20 5.5h-6a2 2 0 0 0-2 2v11a2 2 0 0 1 2-1.5h6z"
        fill="none"
        stroke="currentColor"
        strokeWidth="1.7"
        strokeLinecap="round"
        strokeLinejoin="round"
      />
    </svg>
  ),
  practice: (
    <svg viewBox="0 0 24 24" width="24" height="24" aria-hidden="true">
      <rect
        x="5"
        y="4.5"
        width="14"
        height="16"
        rx="2"
        fill="none"
        stroke="currentColor"
        strokeWidth="1.7"
      />
      <path
        d="M9 4.5V4a1.5 1.5 0 0 1 1.5-1.5h3A1.5 1.5 0 0 1 15 4v.5M8.5 10.5h7M8.5 14.5h7"
        fill="none"
        stroke="currentColor"
        strokeWidth="1.7"
        strokeLinecap="round"
      />
    </svg>
  ),
  mine: (
    <svg viewBox="0 0 24 24" width="24" height="24" aria-hidden="true">
      <circle cx="12" cy="8" r="3.5" fill="none" stroke="currentColor" strokeWidth="1.7" />
      <path
        d="M5 20c.8-3.6 3.6-5.5 7-5.5s6.2 1.9 7 5.5"
        fill="none"
        stroke="currentColor"
        strokeWidth="1.7"
        strokeLinecap="round"
      />
    </svg>
  ),
}

// 底部导航（微信式）：图标在上、文字在下，当前页高亮；压入页隐藏
function TabBar() {
  const { pathname } = useLocation()
  if (!isTabPath(pathname)) return null

  return (
    <nav className="tabBar" aria-label="主导航">
      {TABS.map((tab) => (
        <NavLink
          key={tab.path}
          to={tab.path}
          end={tab.path === '/'}
          className={({ isActive }) => `tabItem${isActive ? ' active' : ''}`}
        >
          <span className="tabIcon">{ICONS[tab.icon]}</span>
          <span className="tabLabel">{tab.label}</span>
        </NavLink>
      ))}
    </nav>
  )
}

export default TabBar
