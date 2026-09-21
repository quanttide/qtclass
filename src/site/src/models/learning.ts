import { load as parseYaml } from 'js-yaml'

// 学习页数据：源自 quanttide-learn 数据仓 data/profile（schedules/ 训练营、tasks/ 任务）的静态副本
// 同步方式：将上游对应目录的 *.md 复制到本包 data/learning/ 对应目录
export interface LearningItem {
  slug: string
  title: string
  description: string
}

// 根锚定路径（相对 Vite 项目根）：CI 与本地一致
export const LEARNING_DIR = '/data/learning/'

const learningModules = import.meta.glob('/data/learning/**/*.md', {
  eager: true,
  query: '?raw',
  import: 'default',
}) as Record<string, string>

// glob 的键形如 /data/learning/<板块>/<slug>.md
function parseLearningPath(path: string): { section: string; slug: string } | null {
  if (!path.startsWith(LEARNING_DIR) || !path.endsWith('.md')) return null
  const segments = path.slice(LEARNING_DIR.length, -3).split('/')
  if (segments.length !== 2) return null
  const [section, slug] = segments
  if (!section || !slug) return null
  return { section, slug }
}

// 解析 YAML frontmatter（title / description），无元数据或解析失败返回 null
export function parseFrontmatter(md: string): { title: string; description: string } | null {
  const match = md.replace(/\r\n/g, '\n').match(/^---\n([\s\S]*?)\n---/)
  if (!match) return null

  let data: unknown
  try {
    data = parseYaml(match[1])
  } catch {
    return null
  }
  if (typeof data !== 'object' || data === null) return null

  const text = (value: unknown) => (typeof value === 'string' ? value.trim() : '')
  const { title, description } = data as Record<string, unknown>
  const parsed = { title: text(title), description: text(description) }
  if (!parsed.title && !parsed.description) return null
  return parsed
}

function extractTitle(md: string): string {
  const fm = parseFrontmatter(md)
  if (fm?.title) return fm.title
  const line = md.split('\n').find((l) => l.startsWith('# '))
  return line ? line.slice(2).trim() : '未命名'
}

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

export interface LearningEntry extends LearningItem {
  section: LearningSection
  content: string
}

// 学习资料索引：路径一次解析为板块与 slug，不再按路径子串匹配
export const learningEntries: LearningEntry[] = Object.entries(learningModules)
  .map(([path, content]): LearningEntry | null => {
    const parsed = parseLearningPath(path)
    if (!parsed || !isLearningSection(parsed.section)) return null
    return {
      section: parsed.section,
      slug: parsed.slug,
      title: extractTitle(content),
      description: extractDescription(content),
      content,
    }
  })
  .filter((entry): entry is LearningEntry => entry !== null)
  .sort((a, b) => a.section.localeCompare(b.section) || a.slug.localeCompare(b.slug))

export function getLearningEntry(
  section: LearningSection,
  slug: string,
): LearningEntry | undefined {
  return learningEntries.find((entry) => entry.section === section && entry.slug === slug)
}

export function itemsIn(dir: LearningSection): LearningItem[] {
  return learningEntries
    .filter((entry) => entry.section === dir)
    .map(({ slug, title, description }) => ({ slug, title, description }))
    .sort((a, b) => a.title.localeCompare(b.title, 'zh'))
}
