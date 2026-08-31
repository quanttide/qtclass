// 学习页数据：源自 data/profile 子模块（schedules/ 训练营、tasks/ 任务）的静态副本
// 同步方式：将 data/profile 下对应目录的 *.md 复制到 src/data/learning/ 对应目录
export interface LearningItem {
  slug: string
  title: string
  description: string
}

// 使用 Vite 的 raw import 功能加载 markdown 文件
export const learningModules = import.meta.glob('../data/learning/**/*.md', {
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

export function itemsIn(dir: 'schedules' | 'tasks'): LearningItem[] {
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
