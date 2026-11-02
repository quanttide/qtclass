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

// 任务书内容库：data/tasks/ 静态副本（源自 site，迁出后不再回流）
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
  content: string
}

export const taskbooks: Taskbook[] = Object.entries(taskbookModules)
  .map(([path, raw]): Taskbook | null => {
    const slug = slugOf(path)
    if (!slug) return null
    const fm = parseFrontmatter(raw)
    return {
      slug,
      title: fm?.title ?? slug,
      content: stripFrontmatter(raw),
    }
  })
  .filter((item): item is Taskbook => item !== null)
  .sort((a, b) => a.slug.localeCompare(b.slug))

export function getTaskbook(slug: string): Taskbook | undefined {
  return taskbooks.find((item) => item.slug === slug)
}

// 静态任务数据：provider 未就绪期间的载荷。首任务 = 任务书修订（入场即教研）
export const CURRENT_TASK: Task = {
  slug: 'revise-docs-bylaw',
  title: '修订任务书：文档工程章程',
  description: '读一篇任务书，标出不清楚的地方，提交修订建议。',
  status: 'todo',
  deadline: '本周内',
  prompt: `# 修订任务书：文档工程章程

你要修订的任务书《文档工程章程》全文见下方题面。

## 怎么做

1. 通读任务书全文
2. 标出读不懂、有歧义、或明显过时的地方
3. 写下你的修订建议：改哪句、改成什么、为什么

## 为什么

任务书是我们把工作交代给新人的方式。你读不懂的地方，下一个人也读不懂——修订任务书就是教研。

提交通道将在 provider v0.2 接通后开放，当前不收集任何提交。`,
  taskbookSlug: 'docs-bylaw',
}

// 反馈（静态）：provider 接通后由真实回写替换
export const CURRENT_FEEDBACK = {
  taskTitle: CURRENT_TASK.title,
  status: CURRENT_TASK.status,
  comment: '',
  grader: '',
}
