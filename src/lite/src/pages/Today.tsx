import { Link } from 'react-router-dom'
import { CURRENT_TASKS, statusLabel } from '../models/task'
import { taskItemPath } from '../routes'

// 今日任务：首屏只有任务卡，无选择、无导航、无配置——学员在做，不在看
function Today() {
  return (
    <main>
      <p className="todayHint">今日任务</p>
      {CURRENT_TASKS.map((task) => (
        <Link key={task.slug} to={taskItemPath(task.slug)} className="taskCard">
          <div className="taskCardTop">
            <h2>{task.title}</h2>
            <span className={`taskStatus ${task.status}`}>{statusLabel(task.status)}</span>
          </div>
          <p className="taskDesc">{task.description}</p>
          <p className="taskDeadline">截止：{task.deadline}</p>
        </Link>
      ))}
    </main>
  )
}

export default Today
