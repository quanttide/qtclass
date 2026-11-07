import { useState } from 'react'
import { Link } from 'react-router-dom'
import {
  ACCEPTANCES,
  CURRENT_TASKS,
  REQUIREMENTS,
  acceptanceLabel,
  requirementLabel,
  statusLabel,
  taskbooks,
  type AcceptanceFilter,
  type RequirementFilter,
} from '../models/task'
import { taskItemPath } from '../routes'

// 实践页：任务书库（当前指派在前）+ 顶部两排分段筛选（需求 / 验收各一排，选项常驻可见）
function Practice() {
  const [requirement, setRequirement] = useState<RequirementFilter>('all')
  const [acceptance, setAcceptance] = useState<AcceptanceFilter>('all')

  const currentSlugs = CURRENT_TASKS.map((task) => task.slug)
  const ordered = [...taskbooks].sort((a, b) => {
    const ai = currentSlugs.indexOf(a.slug)
    const bi = currentSlugs.indexOf(b.slug)
    if (ai !== -1 || bi !== -1) return (ai === -1 ? Infinity : ai) - (bi === -1 ? Infinity : bi)
    return a.slug.localeCompare(b.slug)
  })
  const books = ordered.filter(
    (book) =>
      (requirement === 'all' || book.tags.requirement === requirement) &&
      (acceptance === 'all' || book.tags.acceptance === acceptance),
  )

  return (
    <main>
      <div className="filterBar">
        <div className="filterRow" role="group" aria-label="需求的精确程度">
          <span className="filterLabel">需求：</span>
          <div className="filterSegs">
            <button
              type="button"
              className={`filterSeg${requirement === 'all' ? ' active' : ''}`}
              aria-pressed={requirement === 'all'}
              onClick={() => setRequirement('all')}
            >
              全部
            </button>
            {REQUIREMENTS.map((item) => (
              <button
                key={item.value}
                type="button"
                className={`filterSeg${requirement === item.value ? ' active' : ''}`}
                aria-pressed={requirement === item.value}
                onClick={() => setRequirement(item.value)}
              >
                {item.label}
              </button>
            ))}
          </div>
        </div>
        <div className="filterRow" role="group" aria-label="验收标准的开放程度">
          <span className="filterLabel">验收：</span>
          <div className="filterSegs">
            <button
              type="button"
              className={`filterSeg${acceptance === 'all' ? ' active' : ''}`}
              aria-pressed={acceptance === 'all'}
              onClick={() => setAcceptance('all')}
            >
              全部
            </button>
            {ACCEPTANCES.map((item) => (
              <button
                key={item.value}
                type="button"
                className={`filterSeg${acceptance === item.value ? ' active' : ''}`}
                aria-pressed={acceptance === item.value}
                onClick={() => setAcceptance(item.value)}
              >
                {item.label}
              </button>
            ))}
          </div>
        </div>
      </div>

      {books.length === 0 && <p className="todayHint">没有符合筛选条件的任务书。</p>}

      {books.map((book) => {
        const task = CURRENT_TASKS.find((item) => item.slug === book.slug)
        const tags = [
          book.tags.requirement ? `需求：${requirementLabel(book.tags.requirement)}` : null,
          book.tags.acceptance ? `验收：${acceptanceLabel(book.tags.acceptance)}` : null,
        ].filter(Boolean)
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
            {tags.length > 0 && <p className="taskTags">{tags.join(' · ')}</p>}
          </Link>
        )
      })}
    </main>
  )
}

export default Practice
