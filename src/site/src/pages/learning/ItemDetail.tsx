import { useParams, Link } from 'react-router-dom'
import { learningModules, itemsIn, extractTitle, type LearningSection } from '../../data/learning'
import { markdownToHtml } from '../../utils/markdown'

// 训练营详情：把「来源：tasks/<slug>.md」转换为指向具体任务的链接
function enrichTaskRefs(md: string): string {
  return md.replace(/来源：tasks\/([\w-]+)\.md/g, (_match, slug) => {
    const key = Object.keys(learningModules).find((k) => k.includes(`/tasks/${slug}.md`))
    const title = key ? extractTitle(learningModules[key]) : slug
    return `来源：[${title}](/learn/tasks/${slug})`
  })
}

const badgeLabels: Record<string, string> = {
  schedules: '训练营',
  tasks: '任务',
  prices: '价格',
}

function ItemDetail() {
  const { type, slug } = useParams()
  const sections: LearningSection[] = ['schedules', 'tasks', 'prices']
  const dir = (sections.includes(type as LearningSection) ? (type as LearningSection) : 'schedules') as LearningSection
  const item = itemsIn(dir).find((i) => i.slug === slug)
  const key = Object.keys(learningModules).find((k) => k.includes(`/${dir}/${slug}.md`))
  const markdownContent = key ? learningModules[key] : ''

  if (!item || !key) {
    return (
      <main>
        <div className="not-found">
          <h2>内容未找到</h2>
          <p>请返回学习页面查看全部内容。</p>
          <Link to="/learn" className="primaryLink">
            返回学习
          </Link>
        </div>
      </main>
    )
  }

  return (
    <main>
      <nav className="lesson-nav">
        <Link to="/learn" className="back-link">
          ← 返回学习
        </Link>
      </nav>

      <article className="lesson-content">
        <header className="lesson-header">
          <span className="lesson-badge">{badgeLabels[dir] ?? dir}</span>
          <h1>{item.title}</h1>
        </header>

        <div
          className="lesson-body"
          dangerouslySetInnerHTML={{
            __html: markdownToHtml(dir === 'schedules' ? enrichTaskRefs(markdownContent) : markdownContent),
          }}
        />
      </article>
    </main>
  )
}

export default ItemDetail
