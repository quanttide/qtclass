import { Link, useParams } from 'react-router-dom'
import Markdown from '../components/Markdown'
import { CURRENT_TASKS, getTaskbook, statusLabel } from '../models/task'
import { ROUTE_PATHS } from '../routes'

// 任务详情：题面（说明 + 指派任务书正文）。提交通道未接通，只读
function TaskDetail() {
  const { slug } = useParams()
  const task = CURRENT_TASKS.find((item) => item.slug === slug) ?? null

  if (!task) {
    return (
      <main>
        <div className="liteNotFound">
          <h2>任务未找到</h2>
          <Link to={ROUTE_PATHS.today} className="liteLink">
            返回今日任务
          </Link>
        </div>
      </main>
    )
  }

  const taskbook = task.taskbookSlug ? getTaskbook(task.taskbookSlug) : undefined

  return (
    <main>
      <nav className="taskNav">
        <Link to={ROUTE_PATHS.today} className="liteLink">
          ← 今日任务
        </Link>
        <span className={`taskStatus ${task.status}`}>{statusLabel(task.status)}</span>
      </nav>

      <article className="taskBody">
        <Markdown>{task.prompt}</Markdown>
        {taskbook && (
          <section className="taskMaterial">
            <h2 className="materialTitle">题面素材：{taskbook.title}</h2>
            <Markdown>{taskbook.content}</Markdown>
          </section>
        )}
        <p className="submitHint">提交通道接通后开放，当前只读。</p>
      </article>
    </main>
  )
}

export default TaskDetail
