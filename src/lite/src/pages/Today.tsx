import { Link } from 'react-router-dom'
import { CURRENT_TASK, statusLabel } from '../models/task'
import { taskItemPath } from '../routes'

// 今日任务：首屏只有一张任务卡，无选择、无导航、无配置——学员在做，不在看
function Today() {
  return (
    <main>
      <p className="todayHint">今日任务</p>
      <Link to={taskItemPath(CURRENT_TASK.slug)} className="taskCard">
        <div className="taskCardTop">
          <h2>{CURRENT_TASK.title}</h2>
          <span className={`taskStatus ${CURRENT_TASK.status}`}>{statusLabel(CURRENT_TASK.status)}</span>
        </div>
        <p className="taskDesc">{CURRENT_TASK.description}</p>
        <p className="taskDeadline">截止：{CURRENT_TASK.deadline}</p>
      </Link>
    </main>
  )
}

export default Today
