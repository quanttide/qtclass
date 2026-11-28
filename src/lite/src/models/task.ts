import { parseFrontmatter, stripFrontmatter } from '../utils/frontmatter'

// 任务契约：静态数据先行，页面只认本形状；provider v0.2 就绪后换数据源，页面不动
export interface Task {
  slug: string
  title: string
  description: string
  status: TaskStatus
  deadline: string
  // 题面：任务书等 Markdown 内容，渲染前剥 frontmatter
  prompt: string
  // 题面素材：指派的任务书 slug，详情页连正文一并渲染
  taskbookSlug?: string
}

export type TaskStatus = 'todo' | 'doing' | 'submitted' | 'returned' | 'passed'

export const TASK_STATUSES: { key: TaskStatus; label: string }[] = [
  { key: 'todo', label: '待做' },
  { key: 'doing', label: '进行' },
  { key: 'submitted', label: '已交' },
  { key: 'returned', label: '退回' },
  { key: 'passed', label: '通过' },
]

export function statusLabel(status: TaskStatus): string {
  return TASK_STATUSES.find((item) => item.key === status)?.label ?? status
}

// 任务书两把尺：frontmatter `tags:` 下的取值与显示名——筛选器与卡片共用的单一事实源
export const REQUIREMENTS = [
  { value: 'fuzzy', label: '模糊' },
  { value: 'semi', label: '半精确' },
  { value: 'precise', label: '精确' },
] as const

export const ACCEPTANCES = [
  { value: 'closed', label: '封闭' },
  { value: 'semi', label: '半开放' },
  { value: 'open', label: '开放' },
] as const

export type RequirementValue = (typeof REQUIREMENTS)[number]['value']
export type AcceptanceValue = (typeof ACCEPTANCES)[number]['value']
export type RequirementFilter = 'all' | RequirementValue
export type AcceptanceFilter = 'all' | AcceptanceValue

export interface TaskTags {
  requirement?: RequirementValue
  acceptance?: AcceptanceValue
}

export function requirementLabel(value: RequirementValue): string {
  return REQUIREMENTS.find((item) => item.value === value)?.label ?? value
}

export function acceptanceLabel(value: AcceptanceValue): string {
  return ACCEPTANCES.find((item) => item.value === value)?.label ?? value
}

function asRequirement(value: string | undefined): RequirementValue | undefined {
  return REQUIREMENTS.some((item) => item.value === value) ? (value as RequirementValue) : undefined
}

function asAcceptance(value: string | undefined): AcceptanceValue | undefined {
  return ACCEPTANCES.some((item) => item.value === value) ? (value as AcceptanceValue) : undefined
}

// 任务书内容库：data/tasks/ 静态副本——当前为空，旧任务书已整体下架，待标准化小任务重新上架
// 加载器、frontmatter 解析与两把尺筛选均保留，回填文件即恢复
const taskbookModules = import.meta.glob('/data/tasks/**/*.md', {
  eager: true,
  query: '?raw',
  import: 'default',
}) as Record<string, string>

function slugOf(path: string): string | null {
  if (!path.startsWith('/data/tasks/') || !path.endsWith('.md')) return null
  return path.slice('/data/tasks/'.length, -3)
}

export interface Taskbook {
  slug: string
  title: string
  description: string
  // 两把尺（tags.requirement / tags.acceptance），未标注为 {}
  tags: TaskTags
  content: string
}

export const taskbooks: Taskbook[] = Object.entries(taskbookModules)
  .map(([path, raw]): Taskbook | null => {
    const slug = slugOf(path)
    if (!slug) return null
    const fm = parseFrontmatter(raw)
    // 标题取 frontmatter，缺则取正文首个一级标题，再回退 slug
    const h1 = raw
      .replace(/\r\n/g, '\n')
      .split('\n')
      .find((line) => line.startsWith('# '))
      ?.slice(2)
      .trim()
    return {
      slug,
      title: fm?.title || h1 || slug,
      description: fm?.description || '',
      tags: {
        requirement: asRequirement(fm?.tags?.requirement),
        acceptance: asAcceptance(fm?.tags?.acceptance),
      },
      content: stripFrontmatter(raw),
    }
  })
  .filter((item): item is Taskbook => item !== null)
  .sort((a, b) => a.slug.localeCompare(b.slug))

export function getTaskbook(slug: string): Taskbook | undefined {
  return taskbooks.find((item) => item.slug === slug)
}

// 静态任务数据：货架当前为空——旧任务书已整体下架，待标准化小任务重新上架
// 形状、五状态机与详情/反馈页均保留，回填即恢复
export const CURRENT_TASKS: Task[] = []
