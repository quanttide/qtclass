import { parseFrontmatter, stripFrontmatter } from '../utils/frontmatter'

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

interface LearnApiTask {
  id: string
  title: string
  description: string
}

interface LearnApiSchedule {
  id: string
  title: string
  description?: string
  tasks: LearnApiTask[]
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
      content: stripFrontmatter(content),
    }
  })
  .filter((entry): entry is LearningEntry => entry !== null)
  .sort((a, b) => a.section.localeCompare(b.section) || a.slug.localeCompare(b.slug))

function apiBaseUrl(): string {
  const env = (import.meta as ImportMeta & { env?: Record<string, string | undefined> }).env
  return (env?.VITE_QTCLOUD_LEARN_API_URL ?? 'https://learn.cloud.quanttide.com').replace(/\/$/, '')
}

function slugFromId(id: string, prefix: string): string {
  return id.startsWith(prefix) ? id.slice(prefix.length) : id
}

function taskEntry(task: LearnApiTask): LearningEntry {
  return {
    section: 'tasks',
    slug: slugFromId(task.id, 'task-'),
    title: task.title,
    description: task.description,
    content: `# ${task.title}\n\n${task.description}`,
  }
}

function scheduleEntry(schedule: LearnApiSchedule): LearningEntry {
  const tasks = schedule.tasks
    .map((task, index) => {
      const slug = slugFromId(task.id, 'task-')
      return `## Task ${index + 1}: ${task.title}\n\n${task.description}\n\n来源：tasks/${slug}.md`
    })
    .join('\n\n')
  const description = schedule.description ?? ''
  return {
    section: 'schedules',
    slug: slugFromId(schedule.id, 'schedule-'),
    title: schedule.title,
    description,
    content: `# ${schedule.title}\n\n${description}${tasks ? `\n\n${tasks}` : ''}`,
  }
}

export function learningEntriesFromApi(
  schedules: LearnApiSchedule[],
  tasks: LearnApiTask[],
): LearningEntry[] {
  const priceEntries = learningEntries.filter((entry) => entry.section === 'prices')
  return [
    ...schedules.map(scheduleEntry),
    ...tasks.map(taskEntry),
    ...priceEntries,
  ].sort((a, b) => a.section.localeCompare(b.section) || a.slug.localeCompare(b.slug))
}

export async function loadLearningEntries(fetcher: typeof fetch = fetch): Promise<LearningEntry[]> {
  const baseUrl = apiBaseUrl()
  try {
    const [schedulesResp, tasksResp] = await Promise.all([
      fetcher(`${baseUrl}/schedules`),
      fetcher(`${baseUrl}/tasks`),
    ])
    if (!schedulesResp.ok || !tasksResp.ok) return learningEntries
    const schedules = (await schedulesResp.json()) as LearnApiSchedule[]
    const tasks = (await tasksResp.json()) as LearnApiTask[]
    return learningEntriesFromApi(schedules, tasks)
  } catch {
    return learningEntries
  }
}

export function getLearningEntry(
  section: LearningSection,
  slug: string,
  entries: LearningEntry[] = learningEntries,
): LearningEntry | undefined {
  return entries.find((entry) => entry.section === section && entry.slug === slug)
}

export function itemsIn(
  dir: LearningSection,
  entries: LearningEntry[] = learningEntries,
): LearningItem[] {
  return entries
    .filter((entry) => entry.section === dir)
    .map(({ slug, title, description }) => ({ slug, title, description }))
    .sort((a, b) => a.title.localeCompare(b.title, 'zh'))
}
