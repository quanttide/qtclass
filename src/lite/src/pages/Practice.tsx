import { useState } from 'react'
import { Link } from 'react-router-dom'
import FilterSheet from '../components/FilterSheet'
import {
  CURRENT_TASKS,
  acceptanceLabel,
  requirementLabel,
  statusLabel,
  taskbooks,
  type AcceptanceFilter,
  type RequirementFilter,
} from '../models/task'
import { taskItemPath } from '../routes'

// 实践页：任务书库（当前指派在前）+ 顶部两把尺筛选。学员在做，不在看
function Practice() {
  const [requirement, setRequirement] = useState<RequirementFilter>('all')
  const [acceptance, setAcceptance] = useState<AcceptanceFilter>('all')
  const [sheetOpen, setSheetOpen] = useState(false)

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

  const summary = [
    requirement !== 'all' ? `需求：${requirementLabel(requirement)}` : null,
    acceptance !== 'all' ? `验收：${acceptanceLabel(acceptance)}` : null,
  ]
    .filter(Boolean)
    .join(' · ')

  return (
    <main>
      <div className="filterBar">
        <button
          type="button"
          className="filterEntry"
          aria-label="筛选任务书"
          onClick={() => setSheetOpen(true)}
        >
          {summary || '筛选'}
          <span className="filterCaret" aria-hidden="true">
            ▾
          </span>
        </button>
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

      {sheetOpen && (
        <FilterSheet
          requirement={requirement}
          acceptance={acceptance}
          onRequirement={setRequirement}
          onAcceptance={setAcceptance}
          onClose={() => setSheetOpen(false)}
        />
      )}
    </main>
  )
}

export default Practice
