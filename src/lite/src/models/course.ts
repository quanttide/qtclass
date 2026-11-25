// 课程清单：课堂页卡片与课程主页共用的唯一来源
// 这里只放已上线的通识课；全量清单（含领域课程与上线状态）在 qtcloud-course 的 src/lite
export interface Course {
  name: string
  // 路由用的英文短名，与中文课名解耦
  slug: string
  track: string
  level: string
  audience: string
  summary: string
  modules: string[]
  online: boolean
}

export const courses: Course[] = [
  {
    name: 'AI创意',
    slug: 'vibe-creating',
    track: '通识',
    level: '入门',
    audience: '想把一段文字画出来、第一次用 AI 生图的成员',
    summary:
      '四步把一段小说变成一张图：先让 AI 教你读懂原文，再让它替你写提示词、生成图片，最后教你怎么写——提示词不用记。',
    modules: ['读懂原文', '替你写提示词', '生成图片', '教你写'],
    online: true,
  },
  {
    name: 'AI办公',
    slug: 'vibe-working',
    track: '通识',
    level: '入门',
    audience: '想让 AI 替自己跑公开网站、拿现状报告的成员',
    summary:
      '当一回总裁：发一句话让 AI 去公开网站采集部门现状，交一份能逐条核对的报告——查不到的它得老实写查不到，不许编。',
    modules: ['一句话指令', 'AI 采集', '现状报告', '验收核对'],
    online: true,
  },
  {
    name: 'AI编程',
    slug: 'vibe-coding',
    track: '通识',
    level: '入门',
    audience: '想用 AI 把想法做成作品、不用写代码的成员',
    summary:
      '同一个游戏做四遍：做出来、改起来、创出来、推出去。每一步只用一句话指挥 AI，做出能发给朋友玩的上线作品。',
    modules: ['照着做', '换个壳', '自己设计', '拿出去'],
    online: true,
  },
  {
    name: 'AI教学',
    slug: 'vibe-teaching',
    track: '通识',
    level: '入门',
    audience: '会做一件事、有人想学，但没学过教学法的成员',
    summary:
      '不用教龄不用证书：挑一件你熟的事，拆成几步，每步写清「做完你会看到」，生成自己的课程闯关图——做一遍就做出来了。',
    modules: ['想一件事', '拆成几步', '做完你会看到', '生成课程图'],
    online: true,
  },
]

export function getCourse(slug: string): Course | undefined {
  return courses.find((item) => item.slug === slug)
}
