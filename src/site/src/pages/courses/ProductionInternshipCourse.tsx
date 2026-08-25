import { useParams, Link } from 'react-router-dom'
import { productionInternship } from '../../data/courses'

// 使用 Vite 的 raw import 功能加载 markdown 文件
const lessonModules = import.meta.glob('../../data/lessons/*.md', { eager: true, query: '?raw', import: 'default' }) as Record<string, string>

// 查找课程和章节信息
function findLessonInfo(slug: string) {
  let lessonIndex = 0
  for (const chapter of productionInternship.chapters) {
    for (const lesson of chapter.lessons) {
      lessonIndex++
      if (lesson.slug === slug) {
        return { chapter, lesson, index: lessonIndex }
      }
    }
  }
  return null
}

// 简单的 markdown 到 HTML 转换器
function markdownToHtml(md: string): string {
  const lines = md.split('\n')
  const htmlLines: string[] = []
  let inCodeBlock = false
  let codeContent = ''
  let codeLang = ''
  let inBlockquote = false
  let blockquoteContent = ''
  let listType: 'ul' | 'ol' | null = null
  let listItems: string[] = []

  const flushList = () => {
    if (listType && listItems.length > 0) {
      const tag = listType
      htmlLines.push(`<${tag}>`)
      listItems.forEach(item => {
        htmlLines.push(`  <li>${processInline(item)}</li>`)
      })
      htmlLines.push(`</${tag}>`)
      listItems = []
      listType = null
    }
  }

  const processInline = (text: string): string => {
    return text
      .replace(/\*\*\*(.+?)\*\*\*/g, '<strong><em>$1</em></strong>')
      .replace(/\*\*(.+?)\*\*/g, '<strong>$1</strong>')
      .replace(/\*(.+?)\*/g, '<em>$1</em>')
      .replace(/`([^`]+)`/g, '<code>$1</code>')
      .replace(/\[([^\]]+)\]\(([^)]+)\)/g, '<a href="$2">$1</a>')
  }

  for (const line of lines) {
    // 代码块处理
    if (line.startsWith('```')) {
      if (inCodeBlock) {
        htmlLines.push(`<pre><code class="language-${codeLang}">${codeContent.trim()}</code></pre>`)
        inCodeBlock = false
        codeContent = ''
        codeLang = ''
      } else {
        flushList()
        inCodeBlock = true
        codeLang = line.slice(3).trim()
      }
      continue
    }

    if (inCodeBlock) {
      codeContent += line + '\n'
      continue
    }

    // 空行处理
    if (line.trim() === '') {
      flushList()
      if (inBlockquote) {
        htmlLines.push(`<blockquote>${blockquoteContent.trim()}</blockquote>`)
        inBlockquote = false
        blockquoteContent = ''
      }
      continue
    }

    // 标题
    if (line.startsWith('### ')) {
      flushList()
      htmlLines.push(`<h3>${processInline(line.slice(4))}</h3>`)
      continue
    }
    if (line.startsWith('## ')) {
      flushList()
      htmlLines.push(`<h2>${processInline(line.slice(3))}</h2>`)
      continue
    }
    if (line.startsWith('# ')) {
      flushList()
      htmlLines.push(`<h1>${processInline(line.slice(2))}</h1>`)
      continue
    }

    // 引用块
    if (line.startsWith('> ')) {
      flushList()
      inBlockquote = true
      blockquoteContent += line.slice(2) + ' '
      continue
    }

    // 无序列表
    if (line.match(/^- /)) {
      if (listType !== 'ul') {
        flushList()
        listType = 'ul'
      }
      listItems.push(line.slice(2))
      continue
    }

    // 有序列表
    if (line.match(/^\d+\. /)) {
      if (listType !== 'ol') {
        flushList()
        listType = 'ol'
      }
      listItems.push(line.replace(/^\d+\. /, ''))
      continue
    }

    // 水平线
    if (line.match(/^---+$/)) {
      flushList()
      htmlLines.push('<hr />')
      continue
    }

    // 表格行（简单处理）
    if (line.startsWith('|') && line.endsWith('|')) {
      flushList()
      // 跳过分隔行
      if (line.match(/^\|[-\s|]+\|$/)) continue
      const cells = line.split('|').filter(c => c.trim()).map(c => `<td>${processInline(c.trim())}</td>`).join('')
      htmlLines.push(`<tr>${cells}</tr>`)
      continue
    }

    // 普通段落
    flushList()
    htmlLines.push(`<p>${processInline(line)}</p>`)
  }

  flushList()
  if (inBlockquote) {
    htmlLines.push(`<blockquote>${blockquoteContent.trim()}</blockquote>`)
  }

  return htmlLines.join('\n')
}

function ProductionInternshipCourse() {
  const { lessonSlug } = useParams()
  
  const lessonInfo = lessonSlug ? findLessonInfo(lessonSlug) : null

  if (!lessonInfo) {
    return (
      <main>
        <div className="not-found">
          <h2>课程内容未找到</h2>
          <p>请返回课程列表查看所有课程。</p>
          <Link to="/courses/production-internship" className="primaryLink">
            返回课程列表
          </Link>
        </div>
      </main>
    )
  }

  const { chapter, lesson, index } = lessonInfo

  // 查找对应的 markdown 文件
  const lessonFileKey = Object.keys(lessonModules).find(
    (key) => key.includes(`${lessonSlug}.md`)
  )
  const markdownContent = lessonFileKey ? lessonModules[lessonFileKey] : '# 课程内容正在编写中...'

  // 查找上一课和下一课
  const allLessons = productionInternship.chapters.flatMap(ch => ch.lessons)
  const currentIndex = allLessons.findIndex(l => l.slug === lessonSlug)
  const prevLesson = currentIndex > 0 ? allLessons[currentIndex - 1] : null
  const nextLesson = currentIndex < allLessons.length - 1 ? allLessons[currentIndex + 1] : null

  return (
    <main>
      <nav className="lesson-nav">
        <Link to="/courses/production-internship" className="back-link">
          ← 返回课程列表
        </Link>
      </nav>

      <article className="lesson-content">
        <header className="lesson-header">
          <span className="lesson-badge">第 {index} 课</span>
          <span className="chapter-badge">{chapter.title}</span>
          <h1>{lesson.title}</h1>
        </header>

        <div 
          className="lesson-body"
          dangerouslySetInnerHTML={{ __html: markdownToHtml(markdownContent) }}
        />

        <footer className="lesson-footer">
          {prevLesson && (
            <Link
              to={`/courses/production-internship/lessons/${prevLesson.slug}`}
              className="nav-button prev"
            >
              ← 上一课
            </Link>
          )}
          {nextLesson && (
            <Link
              to={`/courses/production-internship/lessons/${nextLesson.slug}`}
              className="nav-button next"
            >
              下一课 →
            </Link>
          )}
        </footer>
      </article>
    </main>
  )
}

export default ProductionInternshipCourse
