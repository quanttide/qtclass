import { Link, useParams } from 'react-router-dom'
import { CURRENT_TASKS, statusLabel } from '../models/task'
import { ROUTE_PATHS } from '../routes'

// 任务详情：按档案结构逐字段渲染（任务背景 / 任务内容 / 任务输入 / 交付物 / 验收 / 其他）。
// 与库存侧 qtcloud-crowd lite 详情同构，不落 Markdown。提交通道未接通，只读
function TaskDetail() {
  const { slug } = useParams()
  const task = CURRENT_TASKS.find((item) => item.slug === slug) ?? null

  if (!task) {
    return (
      <main>
        <div className="liteNotFound">
          <h2>任务未找到</h2>
          <Link to={ROUTE_PATHS.practice} className="liteLink">
            返回实践
          </Link>
        </div>
      </main>
    )
  }

  const { detail } = task

  return (
    <main>
      <Link to={ROUTE_PATHS.practice} className="backLink">
        ← 任务
      </Link>

      <article className="detailCard">
        <div className="detailHead">
          <h1>{task.title}</h1>
          <span className={`taskStatus ${task.status}`}>{statusLabel(task.status)}</span>
        </div>

        <p className="detailMetaRow">
          业务：{detail.business} · 类别：{detail.category} · 状态：{detail.status}
        </p>
        <p className="taskDesc">{task.description}</p>

        <section className="detailSection">
          <h2 className="detailHeading">任务背景</h2>
          <p className="detailPara">{detail.background}</p>
        </section>

        <section className="detailSection">
          <h2 className="detailHeading">任务内容</h2>
          <ol className="detailList">
            {detail.content.map((line) => (
              <li key={line}>{line}</li>
            ))}
          </ol>
        </section>

        <section className="detailSection">
          <h2 className="detailHeading">任务输入</h2>
          <ul className="detailList">
            {detail.inputs.map((line) => (
              <li key={line}>{line}</li>
            ))}
          </ul>
        </section>

        <section className="detailSection">
          <h2 className="detailHeading">交付物</h2>
          <p className="detailPara">{detail.deliverable}</p>
        </section>

        <section className="detailSection">
          <h2 className="detailHeading">验收</h2>
          <ul className="checkList">
            {detail.acceptance.map((line) => (
              <li key={line}>
                <span className="checkBox" aria-hidden="true" />
                {line}
              </li>
            ))}
          </ul>
        </section>

        <section className="detailSection">
          <h2 className="detailHeading">其他</h2>
          <ul className="detailList">
            {detail.notes.map((line) => (
              <li key={line}>{line}</li>
            ))}
          </ul>
        </section>

        <p className="submitHint">提交通道接通后开放，当前只读。</p>
      </article>
    </main>
  )
}

export default TaskDetail
