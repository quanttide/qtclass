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

// 任务书内容库：data/tasks/ 静态副本——当前为空，旧任务书已整体下架，待标准化小任务重新上架
// 加载器与 frontmatter 解析保留，回填文件即恢复；两把尺标签已随体系转至 qtcloud-crowd lite
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
      content: stripFrontmatter(raw),
    }
  })
  .filter((item): item is Taskbook => item !== null)
  .sort((a, b) => a.slug.localeCompare(b.slug))

export function getTaskbook(slug: string): Taskbook | undefined {
  return taskbooks.find((item) => item.slug === slug)
}

// 静态任务数据：四个业务平台 Lite 的测评任务（标准化小任务，按六步模板产出）
// 形状、五状态机与详情/反馈页保留；任务书正文在 data/tasks/，两者 slug 对齐
export const CURRENT_TASKS: Task[] = [
  {
    slug: 'review-qtdata-lite',
    title: '测评量潮数据 Lite',
    description: '用统一方法测评 lite.data.cloud.quanttide.com，产出四维打分与三问题一亮点的测评报告。',
    status: 'todo',
    deadline: '见任务书',
    prompt: `按任务书六步执行：立题、定输入、走步骤、出交付、对验收、记报酬。提交通道接通前，本页只读。`,
    taskbookSlug: 'review-qtdata-lite',
  },
  {
    slug: 'review-qtclass-lite',
    title: '测评量潮课堂 Lite',
    description: '用统一方法测评 lite.class.quanttide.com，产出四维打分与三问题一亮点的测评报告。',
    status: 'todo',
    deadline: '见任务书',
    prompt: `按任务书六步执行：立题、定输入、走步骤、出交付、对验收、记报酬。提交通道接通前，本页只读。`,
    taskbookSlug: 'review-qtclass-lite',
  },
  {
    slug: 'review-qtcloud-lite',
    title: '测评量潮云 Lite',
    description: '用统一方法测评 lite.cloud.quanttide.com，产出四维打分与三问题一亮点的测评报告。',
    status: 'todo',
    deadline: '见任务书',
    prompt: `按任务书六步执行：立题、定输入、走步骤、出交付、对验收、记报酬。提交通道接通前，本页只读。`,
    taskbookSlug: 'review-qtcloud-lite',
  },
  {
    slug: 'review-qtconsult-lite',
    title: '测评量潮咨询 Lite',
    description: '用统一方法测评 lite.consult.cloud.quanttide.com，产出四维打分与三问题一亮点的测评报告。',
    status: 'todo',
    deadline: '见任务书',
    prompt: `按任务书六步执行：立题、定输入、走步骤、出交付、对验收、记报酬。提交通道接通前，本页只读。`,
    taskbookSlug: 'review-qtconsult-lite',
  },
]
