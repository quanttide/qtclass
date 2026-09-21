// 路由路径与链接地址的唯一来源
import { productionInternship } from './models/courses'

const courseBase = `/courses/${productionInternship.slug}`

export function coursePath(courseSlug: string): string {
  return `/courses/${courseSlug}`
}

export function lessonPath(lessonSlug: string): string {
  return `${courseBase}/lessons/${lessonSlug}`
}

export function learnItemPath(type: string, slug: string): string {
  return `/learn/${type}/${slug}`
}

export const ROUTE_PATHS = {
  home: '/',
  learn: '/learn',
  learnItem: '/learn/:type/:slug',
  productionInternship: courseBase,
  productionInternshipLesson: `${courseBase}/lessons/:lessonSlug`,
} as const
