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

function extractTitle(md: string): string {
  const line = md.split('\n').find((l) => l.startsWith('# '))
  return line ? line.slice(2).trim() : '未命名'
}

export { extractTitle }

// 提取标题后的第一段正文作为卡片描述
function extractDescription(md: string): string {
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
