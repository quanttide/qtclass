import { Link } from 'react-router-dom'
import { itemsIn } from '../data/learning'

const sections = [
  {
    key: 'schedules' as const,
    title: '训练营',
    subtitle: 'Schedules',
    description: '按学习路径推进的训练计划。',
  },
  {
    key: 'tasks' as const,
    title: '任务',
    subtitle: 'Tasks',
    description: '面向协作者开放的实践任务，通过 Issue 和 PR 协作完成。',
  },
  {
    key: 'careers' as const,
    title: '成长通道',
    subtitle: 'Careers',
    description: '从首次参与到可入职：进度条、成长速度参考与考核规则。',
  },
  {
    key: 'prices' as const,
    title: '价格',
    subtitle: 'Prices',
    description: '一对一咨询定价与超额申请额度；代金券的挣取渠道。',
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

          <div className="learnGrid">
            {itemsIn(section.key).map((item) => (
              <Link key={item.slug} to={`/learn/${section.key}/${item.slug}`} className="learnCard">
                <div className="courseTop">
                  <h3>{item.title}</h3>
                </div>
                {item.description && <p className="summary">{item.description}</p>}
              </Link>
            ))}
          </div>
        </section>
      ))}
    </main>
  )
}

export default Learn
