// 课程结构：数据结构与装载在此，具体数据在包级 data/courses/*.json
import productionInternshipData from '../../data/courses/production-internship.json'

export interface Lesson {
  id: string
  title: string
  slug: string
}

export interface Chapter {
  id: string
  title: string
  lessons: Lesson[]
}

export interface Course {
  id: string
  title: string
  slug: string
  description: string
  chapters: Chapter[]
}

export const productionInternship: Course = productionInternshipData
