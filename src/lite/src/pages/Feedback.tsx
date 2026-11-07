import { CURRENT_TASKS, statusLabel } from '../models/task'

// 反馈查看：教师评语与状态。当前无已交任务，逐任务展示空态；回退走顶栏返回
function Feedback() {
  return (
    <main>
      {CURRENT_TASKS.map((task) => (
        <section key={task.slug} className="feedbackCard">
          <div className="taskCardTop">
            <h2>{task.title}</h2>
            <span className={`taskStatus ${task.status}`}>{statusLabel(task.status)}</span>
          </div>
          <p className="taskDesc feedbackEmpty">尚无评语。提交任务后，教师的评语与通过 / 退回状态会显示在这里。</p>
        </section>
      ))}
    </main>
  )
}

export default Feedback
