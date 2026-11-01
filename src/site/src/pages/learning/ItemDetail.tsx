import { useParams, Link } from 'react-router-dom'
import { useEffect, useState } from 'react'
import Markdown from '../../components/Markdown'
import {
  getLearningEntry,
  learningEntries,
  loadLearningEntries,
  sectionOf,
  type LearningEntry,
} from '../../models/learning'
import { ROUTE_PATHS } from '../../routes'

// 训练营详情：正文原样渲染（来源行随任务下线不再转链）
function ItemDetail() {
  const { slug } = useParams()
  const [entries, setEntries] = useState<LearningEntry[]>(learningEntries)

  useEffect(() => {
    let alive = true
    loadLearningEntries().then((next) => {
      if (alive) setEntries(next)
    })
    return () => {
      alive = false
    }
  }, [])

  const entry = slug ? getLearningEntry('schedules', slug, entries) : undefined

  if (!entry) {
    return (
      <main>
        <div className="not-found">
          <h2>内容未找到</h2>
          <p>请返回课程页面查看全部内容。</p>
          <Link to={ROUTE_PATHS.course} className="primaryLink">
            返回课程
          </Link>
        </div>
      </main>
    )
  }

  return (
    <main>
      <nav className="lesson-nav">
        <Link to={ROUTE_PATHS.course} className="back-link">
          ← 返回课程
        </Link>
      </nav>

      <article className="lesson-content">
        <header className="lesson-header">
          <span className="lesson-badge">{sectionOf('schedules').title}</span>
          <h1>{entry.title}</h1>
        </header>

        <div className="lesson-body">
          <Markdown>{entry.content}</Markdown>
        </div>
      </article>
    </main>
  )
}

export default ItemDetail
