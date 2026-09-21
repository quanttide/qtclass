// 学习页数据：源自 quanttide-learn 数据仓 data/profile（schedules/ 训练营、tasks/ 任务）的静态副本
// 同步方式：将上游对应目录的 *.md 复制到本包 data/learning/ 对应目录
export interface LearningItem {
  slug: string
  title: string
  description: string
}

// 根锚定路径（相对 Vite 项目根）：CI 与本地一致
export const learningModules = import.meta.glob('/data/learning/**/*.md', {
  eager: true,
  query: '?raw',
  import: 'default',
}) as Record<string, string>

// 解析 YAML frontmatter（title / description），失败返回 null
function parseFrontmatter(md: string): { title: string; description: string } | null {
  const m = md.match(/^---\n([\s\S]*?)\n---/)
  if (!m) return null
  const fm = m[1]
  const get = (key: string): string => {
    const line = fm.split('\n').find((l) => l.startsWith(`${key}:`))
    return line ? line.slice(key.length + 1).trim() : ''
  }
  const title = get('title')
  const description = get('description')
  if (!title && !description) return null
  return { title, description }
}

function extractTitle(md: string): string {
  const fm = parseFrontmatter(md)
  if (fm?.title) return fm.title
  const line = md.split('\n').find((l) => l.startsWith('# '))
  return line ? line.slice(2).trim() : '未命名'
}

export { extractTitle }

// 提取标题后的第一段正文作为卡片描述（无 frontmatter 时回退）
function extractDescription(md: string): string {
  const fm = parseFrontmatter(md)
  if (fm?.description) return fm.description
  const lines = md.split('\n')
  let inCode = false
  for (const line of lines) {
    if (line.startsWith('```')) {
      inCode = !inCode
      continue
    }
    if (inCode) continue
    const t = line.trim()
    if (!t) continue
    if (t.startsWith('#')) continue
    if (t.startsWith('-') || /^\d+\./.test(t)) continue
    if (t.startsWith('>') || t.startsWith('|')) continue
    return t
      .replace(/\*\*(.+?)\*\*/g, '$1')
      .replace(/\[(.+?)\]\((.+?)\)/g, '$1')
      .replace(/`([^`]+)`/g, '$1')
  }
  return ''
}

// 学习板块：标题、英文副题与说明的唯一来源
export const LEARNING_SECTIONS = [
  {
    key: 'schedules',
    title: '训练营',
    subtitle: 'Schedules',
    description: '按学习路径推进的训练计划。',
  },
  {
    key: 'tasks',
    title: '任务',
    subtitle: 'Tasks',
    description: '面向协作者开放的实践任务，通过 Issue 和 PR 协作完成。',
  },
  {
    key: 'prices',
    title: '价格',
    subtitle: 'Prices',
    description: '任务参与免费；一对一咨询按专家职级定价。',
  },
] as const

export type LearningSection = (typeof LEARNING_SECTIONS)[number]['key']

export function isLearningSection(value: unknown): value is LearningSection {
  return LEARNING_SECTIONS.some((section) => section.key === value)
}

export function sectionOf(key: LearningSection) {
  return LEARNING_SECTIONS.find((section) => section.key === key)!
}

export function itemsIn(dir: LearningSection): LearningItem[] {
  return Object.keys(learningModules)
    .filter((key) => key.includes(`/${dir}/`))
    .map((key) => {
      const slug = key.split('/').pop()!.replace(/\.md$/, '')
      return {
        slug,
        title: extractTitle(learningModules[key]),
        description: extractDescription(learningModules[key]),
      }
    })
    .sort((a, b) => a.title.localeCompare(b.title, 'zh'))
}
