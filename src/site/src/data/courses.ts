export interface Lesson {
  id: string
  title: string
  slug: string
}

export interface Course {
  id: string
  title: string
  slug: string
  description: string
  lessons: Lesson[]
}

export const productionInternship: Course = {
  id: 'production-internship',
  title: '生产实习',
  slug: 'production-internship',
  description: '以微型创业和真实交付为牵引，完成学习、Demo、进度和立项闭环。',
  lessons: [
    {
      id: 'qtdata-intro',
      title: '量潮数据经营现状',
      slug: 'qtdata-intro',
    },
    {
      id: 'qtdata-business',
      title: '量潮数据业务模式',
      slug: 'qtdata-business',
    },
    {
      id: 'qtclass-intro',
      title: '量潮课堂简介',
      slug: 'qtclass-intro',
    },
    {
      id: 'qtclass-sales',
      title: '量潮课堂销售指南',
      slug: 'qtclass-sales',
    },
    {
      id: 'qtclass-strategy',
      title: '量潮课堂经营目标',
      slug: 'qtclass-strategy',
    },
    {
      id: 'qtcloud-intro',
      title: '量潮云简介',
      slug: 'qtcloud-intro',
    },
    {
      id: 'qtrecurit-intro',
      title: '量潮招聘工作教程',
      slug: 'qtrecurit-intro',
    },
    {
      id: 'qtrecurit-survey',
      title: '发送准入问卷',
      slug: 'qtrecurit-survey',
    },
  ],
}

export const courses: Course[] = [productionInternship]
