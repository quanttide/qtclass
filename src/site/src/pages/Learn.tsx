import { Link } from 'react-router-dom'
import { itemsIn } from '../data/learning'

const sections = [
  {
    key: 'schedules' as const,
    title: '训练营',
    subtitle: 'Schedule',
    description: '按学习路径推进的训练计划。',
  },
  {
    key: 'tasks' as const,
    title: '任务',
    subtitle: 'Tasks',
    description: '面向协作者开放的实践任务，通过 Issue 和 PR 协作完成。',
  },
]

function Learn() {
  return (
    <main>
      {sections.map((section) => (
        <section key={section.key} className="courseSection">
          <div className="sectionHead">
            <div>
              <p>{section.subtitle}</p>
              <h2>{section.title}</h2>
            </div>
            <p className="sectionDesc">{section.description}</p>
          </div>

          <div className="courseGrid">
            {itemsIn(section.key).map((item) => (
              <article key={item.slug} className="courseCard">
                <div className="courseTop">
                  <h3>{item.title}</h3>
                </div>
                <Link
                  to={`/learn/${section.key}/${item.slug}`}
                  className="primaryLink"
                  style={{ marginTop: '16px' }}
                >
                  查看
                </Link>
              </article>
            ))}
          </div>
        </section>
      ))}
    </main>
  )
}

export default Learn
