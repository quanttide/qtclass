import { Link } from 'react-router-dom'
import { CURRENT_TASKS, statusLabel } from '../models/task'
import { taskItemPath } from '../routes'

// 实践页 = 货架：任务清单。卡片与课堂页同构（sectionHead + learnGrid + learnCard），
// 无筛选、无两把尺标签——分类与方法归库存侧 qtcloud-crowd lite
function Practice() {
  const tasks = [...CURRENT_TASKS].sort((a, b) => a.slug.localeCompare(b.slug))

  return (
    <main>
      <section className="courseSection" aria-labelledby="practice-title">
        <div className="sectionHead">
          <div>
            <p>Practice</p>
            <h2 id="practice-title">任务</h2>
          </div>
        </div>

        {tasks.length === 0 && <p className="todayHint">货架当前为空。</p>}

        <div className="learnGrid">
          {tasks.map((task) => (
            <Link
              key={task.slug}
              to={taskItemPath(task.slug)}
              className="learnCard"
              aria-label={`${task.title} 任务详情`}
            >
              <div className="courseTop">
                <h3>{task.title}</h3>
                <span className={`taskStatus ${task.status}`}>{statusLabel(task.status)}</span>
              </div>
              <p className="summary">{task.description}</p>
              <span className="courseHomeLink" aria-hidden="true">
                任务详情 ›
              </span>
            </Link>
          ))}
        </div>
      </section>
    </main>
  )
}

export default Practice
