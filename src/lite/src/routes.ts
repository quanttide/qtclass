// 路由路径与链接地址的唯一来源
export const ROUTE_PATHS = {
  practice: '/',
  theory: '/theory',
  mine: '/mine',
  taskItem: '/tasks/:slug',
  feedback: '/feedback',
} as const

// 底部导航三个页签（顺序即导航顺序：理论、实践、我的）
export const TABS = [
  { path: ROUTE_PATHS.theory, label: '理论', icon: 'theory' },
  { path: ROUTE_PATHS.practice, label: '实践', icon: 'practice' },
  { path: ROUTE_PATHS.mine, label: '我的', icon: 'mine' },
] as const

export type TabIcon = (typeof TABS)[number]['icon']

// 页签根路径显示底部导航；任务详情与反馈为压入页，按微信惯例隐藏页签
const TAB_PATHS: string[] = [ROUTE_PATHS.practice, ROUTE_PATHS.theory, ROUTE_PATHS.mine]

export function isTabPath(pathname: string): boolean {
  return TAB_PATHS.includes(pathname)
}

export function taskItemPath(slug: string): string {
  return `/tasks/${slug}`
}
