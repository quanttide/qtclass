import { Link } from 'react-router-dom'
import { CURRENT_TASKS, statusLabel, taskbooks } from '../models/task'
import { taskItemPath } from '../routes'

// 实践页 = 货架：任务书列表（当前指派在前）。两把尺标签体系已转至 qtcloud-crowd lite（库存侧）
function Practice() {
  const currentSlugs = CURRENT_TASKS.map((task) => task.slug)
  const books = [...taskbooks].sort((a, b) => {
    const ai = currentSlugs.indexOf(a.slug)
    const bi = currentSlugs.indexOf(b.slug)
    if (ai !== -1 || bi !== -1) return (ai === -1 ? Infinity : ai) - (bi === -1 ? Infinity : bi)
    return a.slug.localeCompare(b.slug)
  })

  return (
    <main>
      {books.length === 0 && (
        <p className="todayHint">货架当前为空——旧任务书已下线，标准化小任务整理中。</p>
      )}

      {books.map((book) => {
        const task = CURRENT_TASKS.find((item) => item.slug === book.slug)
        return (
          <Link key={book.slug} to={taskItemPath(book.slug)} className="taskCard">
            <div className="taskCardTop">
              <h2>{task?.title || book.title}</h2>
              {task && (
                <span className={`taskStatus ${task.status}`}>{statusLabel(task.status)}</span>
              )}
            </div>
            <p className="taskDesc">{task?.description || book.description}</p>
            {task && <p className="taskDeadline">截止：{task.deadline}</p>}
          </Link>
        )
      })}
    </main>
  )
}

export default Practice
