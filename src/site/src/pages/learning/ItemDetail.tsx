import { useParams, Link } from 'react-router-dom'
import { getLearningEntry, isLearningSection, sectionOf } from '../../models/learning'
import { markdownToHtml } from '../../utils/markdown'
import { learnItemPath, ROUTE_PATHS } from '../../routes'

// 训练营详情：把「来源：tasks/<slug>.md」转换为指向具体任务的链接
function enrichTaskRefs(md: string): string {
  return md.replace(/来源：tasks\/([\w-]+)\.md/g, (_match, slug) => {
    const title = getLearningEntry('tasks', slug)?.title ?? slug
    return `来源：[${title}](${learnItemPath('tasks', slug)})`
  })
}

function ItemDetail() {
  const { type, slug } = useParams()
  const section = isLearningSection(type) ? sectionOf(type) : null
  const entry = section && slug ? getLearningEntry(section.key, slug) : undefined

  if (!section || !entry) {
    return (
      <main>
        <div className="not-found">
          <h2>内容未找到</h2>
          <p>请返回学习页面查看全部内容。</p>
          <Link to={ROUTE_PATHS.learn} className="primaryLink">
            返回学习
          </Link>
        </div>
      </main>
    )
  }

  return (
    <main>
      <nav className="lesson-nav">
        <Link to={ROUTE_PATHS.learn} className="back-link">
          ← 返回学习
        </Link>
      </nav>

      <article className="lesson-content">
        <header className="lesson-header">
          <span className="lesson-badge">{section.title}</span>
          <h1>{entry.title}</h1>
        </header>

        <div
          className="lesson-body"
          dangerouslySetInnerHTML={{
            __html: markdownToHtml(
              section.key === 'schedules' ? enrichTaskRefs(entry.content) : entry.content,
            ),
          }}
        />
      </article>
    </main>
  )
}

export default ItemDetail
