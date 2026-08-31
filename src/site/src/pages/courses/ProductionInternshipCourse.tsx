import { useParams, Link } from 'react-router-dom'
import { productionInternship } from '../../data/courses'
import { markdownToHtml } from '../../utils/markdown'

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
