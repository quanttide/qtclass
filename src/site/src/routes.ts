// 路由路径与链接地址的唯一来源
export function scheduleItemPath(slug: string): string {
  return `/schedules/${slug}`
}

export const ROUTE_PATHS = {
  home: '/',
  course: '/courses',
  prices: '/prices',
  scheduleItem: '/schedules/:slug',
} as const
