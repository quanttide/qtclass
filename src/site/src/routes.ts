// 路由路径与链接地址的唯一来源
export function learnItemPath(type: string, slug: string): string {
  return `/learn/${type}/${slug}`
}

export const ROUTE_PATHS = {
  home: '/',
  course: '/courses',
  learn: '/learn',
  learnItem: '/learn/:type/:slug',
} as const
