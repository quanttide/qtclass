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

export const productionInternship: Course = {
  id: 'production-internship',
  title: '生产实习',
  slug: 'production-internship',
  description: '以微型创业和真实交付为牵引，完成学习、Demo、进度和立项闭环。',
  chapters: [
    {
      id: 'qtdata',
      title: '量潮数据',
      lessons: [
        {
          id: 'qtdata-intro',
          title: '经营现状',
          slug: 'qtdata-intro',
        },
        {
          id: 'qtdata-business',
          title: '业务模式',
          slug: 'qtdata-business',
        },
      ],
    },
    {
      id: 'qtclass',
      title: '量潮课堂',
      lessons: [
        {
          id: 'qtclass-intro',
          title: '课程简介',
          slug: 'qtclass-intro',
        },
        {
          id: 'qtclass-sales',
          title: '销售指南',
          slug: 'qtclass-sales',
        },
        {
          id: 'qtclass-strategy',
          title: '经营目标',
          slug: 'qtclass-strategy',
        },
      ],
    },
    {
      id: 'qtcloud',
      title: '量潮云',
      lessons: [
        {
          id: 'qtcloud-intro',
          title: '产品简介',
          slug: 'qtcloud-intro',
        },
      ],
    },
    {
      id: 'qtrecurit',
      title: '量潮招聘',
      lessons: [
        {
          id: 'qtrecurit-intro',
          title: '招聘流程',
          slug: 'qtrecurit-intro',
        },
        {
          id: 'qtrecurit-survey',
          title: '发送准入问卷',
          slug: 'qtrecurit-survey',
        },
      ],
    },
  ],
}

export const courses: Course[] = [productionInternship]
