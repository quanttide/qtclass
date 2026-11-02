import { Link } from 'react-router-dom'
import { CURRENT_FEEDBACK, statusLabel } from '../models/task'
import { ROUTE_PATHS } from '../routes'

// 反馈查看：教师评语与状态。当前无已交任务，展示状态与空态说明
function Feedback() {
  return (
    <main>
      <nav className="taskNav">
        <Link to={ROUTE_PATHS.today} className="liteLink">
          ← 今日任务
        </Link>
      </nav>

      <section className="feedbackCard">
        <div className="taskCardTop">
          <h2>{CURRENT_FEEDBACK.taskTitle}</h2>
          <span className={`taskStatus ${CURRENT_FEEDBACK.status}`}>
            {statusLabel(CURRENT_FEEDBACK.status)}
          </span>
        </div>
        {CURRENT_FEEDBACK.comment ? (
          <p className="taskDesc">{CURRENT_FEEDBACK.comment}</p>
        ) : (
          <p className="taskDesc feedbackEmpty">尚无评语。提交任务后，教师的评语与通过 / 退回状态会显示在这里。</p>
        )}
      </section>
    </main>
  )
}

export default Feedback
