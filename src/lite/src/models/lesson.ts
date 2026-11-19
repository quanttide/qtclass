// 课时契约：静态数据先行，页面只认本形状；provider 接通后换数据源，页面不动
// 对应规格 docs/specification/lesson 的 Course → Lesson → Scene：
// 静态层暂用 steps 承载 Scene 序列，接通后换 scenes，页面不动

export type LessonStatus = 'draft' | 'published'

// 一步 = 一个动作 + 若干展示块。块类型按内容实际形态收口，新增形态才加类型
export type LessonBlock =
  // 「做完你会看到」：学员的预期结果，lines 逐行渲染
  | { kind: 'note'; label: string; lines: string[] }
  // 一键复制：学员原样粘贴的指令，不手打
  | { kind: 'copy'; label: string; text: string }
  // 过程回显：等它跑完时屏幕上滚过的行，tone 区分进行中与完成
  | { kind: 'code'; label?: string; lines: { tone?: 'run' | 'ok'; text: string }[] }
  // 产出链接：跑完拿到的地址，tip 写清容易漏的那截
  | { kind: 'link'; label: string; url: string; tip?: string }
  // 对照图：学员比对自己屏幕用的截图，tip 写清看到什么算对
  | { kind: 'image'; label: string; src: string; alt: string; tip?: string }

export interface LessonStep {
  // 步骤序号，页面按序渲染
  num: number
  title: string
  // 学员要做的动作
  do: string
  blocks: LessonBlock[]
}

export interface Lesson {
  // 课时名，符合 slug 标准，兼可读路径与编排，不另设 slug 字段
  name: string
  // 所属课程名，与理论页 courses.name 同源
  course: string
  title: string
  description: string
  status: LessonStatus
  // 页眉小标签，如「AI编程 · 第 1 课」
  kicker?: string
  // 页眉下的一句引导
  lede?: string
  steps: LessonStep[]
  // 课末提示
  tip?: string
  // 页脚一句话
  foot?: string
}

// 课时内容库：data/lessons/ 静态载荷，一个文件一个课时
const lessonModules = import.meta.glob('/data/lessons/**/*.ts', {
  eager: true,
  import: 'default',
}) as Record<string, Lesson>

function nameOf(path: string): string | null {
  if (!path.startsWith('/data/lessons/') || !path.endsWith('.ts')) return null
  return path.slice('/data/lessons/'.length, -3)
}

export const lessons: Lesson[] = Object.entries(lessonModules)
  .map(([path, lesson]) => (nameOf(path) === lesson.name ? lesson : null))
  .filter((item): item is Lesson => item !== null)
  .sort((a, b) => a.name.localeCompare(b.name))

export function getLesson(name: string): Lesson | undefined {
  return lessons.find((item) => item.name === name)
}

// 某门课程下已发布的课时，课程清单卡用它出入口；draft 不对外
export function publishedLessonsOf(courseName: string): Lesson[] {
  return lessons.filter((item) => item.course === courseName && item.status === 'published')
}
