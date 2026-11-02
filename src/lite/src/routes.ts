// 路由路径与链接地址的唯一来源
export const ROUTE_PATHS = {
  today: '/',
  taskItem: '/tasks/:slug',
  feedback: '/feedback',
} as const

export function taskItemPath(slug: string): string {
  return `/tasks/${slug}`
}
