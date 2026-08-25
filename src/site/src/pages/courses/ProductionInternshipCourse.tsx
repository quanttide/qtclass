import { useParams, Link } from 'react-router-dom'
import { productionInternship } from '../../data/courses'

// 使用 Vite 的 raw import 功能加载 markdown 文件
const lessonModules = import.meta.glob('../../data/lessons/*.md', { eager: true, query: '?raw', import: 'default' }) as Record<string, string>

// 简单的 markdown 到 HTML 转换器
function markdownToHtml(md: string): string {
  let html = md
    // 标题
    .replace(/^### (.+)$/gm, '<h3>$1</h3>')
    .replace(/^## (.+)$/gm, '<h2>$1</h2>')
    .replace(/^# (.+)$/gm, '<h1>$1</h1>')
    // 粗体和斜体
    .replace(/\*\*\*(.+?)\*\*\*/g, '<strong><em>$1</em></strong>')
    .replace(/\*\*(.+?)\*\*/g, '<strong>$1</strong>')
    .replace(/\*(.+?)\*/g, '<em>$1</em>')
    // 代码块
    .replace(/```(\w+)?\n([\s\S]*?)```/g, '<pre><code class="language-$1">$2</code></pre>')
    // 行内代码
    .replace(/`([^`]+)`/g, '<code>$1</code>')
    // 引用块
    .replace(/^> (.+)$/gm, '<blockquote>$1</blockquote>')
    // 无序列表
    .replace(/^- (.+)$/gm, '<li>$1</li>')
    // 有序列表
    .replace(/^\d+\. (.+)$/gm, '<li>$1</li>')
    // 水平线
    .replace(/^---$/gm, '<hr />')
    // 链接
    .replace(/\[([^\]]+)\]\(([^)]+)\)/g, '<a href="$2">$1</a>')
    // 段落（非标签开头的行）
    .replace(/^(?!<[hluop]|<li|<hr|<pre|<blockquote)(.+)$/gm, '<p>$1</p>')
    // 清理空行
    .replace(/\n{2,}/g, '\n')

  return html
}

function ProductionInternshipCourse() {
  const { lessonSlug } = useParams()
  
  const currentLesson = productionInternship.lessons.find(
    (lesson) => lesson.slug === lessonSlug
  )

  if (!currentLesson) {
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

  // 查找对应的 markdown 文件
  const lessonFileKey = Object.keys(lessonModules).find(
    (key) => key.includes(`${lessonSlug}.md`)
  )
  const markdownContent = lessonFileKey ? lessonModules[lessonFileKey] : '# 课程内容正在编写中...'

  const currentIndex = productionInternship.lessons.findIndex(
    (lesson) => lesson.slug === lessonSlug
  )
  const prevLesson = currentIndex > 0 ? productionInternship.lessons[currentIndex - 1] : null
  const nextLesson = currentIndex < productionInternship.lessons.length - 1
    ? productionInternship.lessons[currentIndex + 1]
    : null

  return (
    <main>
      <nav className="lesson-nav">
        <Link to="/courses/production-internship" className="back-link">
          ← 返回课程列表
        </Link>
      </nav>

      <article className="lesson-content">
        <header className="lesson-header">
          <span className="lesson-badge">第 {currentIndex + 1} 课</span>
          <h1>{currentLesson.title}</h1>
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
              ← 上一课：{prevLesson.title}
            </Link>
          )}
          {nextLesson && (
            <Link
              to={`/courses/production-internship/lessons/${nextLesson.slug}`}
              className="nav-button next"
            >
              下一课：{nextLesson.title} →
            </Link>
          )}
        </footer>
      </article>
    </main>
  )
}

export default ProductionInternshipCourse
