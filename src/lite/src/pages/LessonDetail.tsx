import { useState } from 'react'
import { Link, useParams } from 'react-router-dom'
import { getLesson, publishedLessonsOf, type LessonBlock } from '../models/lesson'
import { lessonPath, ROUTE_PATHS } from '../routes'

// 一键复制：剪贴板不可用时只回退成「请长按复制」，不假装成功
function CopyBox({ label, text }: { label: string; text: string }) {
  const [state, setState] = useState<'idle' | 'done' | 'manual'>('idle')

  async function copy() {
    try {
      await navigator.clipboard.writeText(text)
      setState('done')
    } catch {
      setState('manual')
    }
    window.setTimeout(() => setState('idle'), 2500)
  }

  const buttonLabel =
    state === 'done' ? '已复制，去粘贴吧' : state === 'manual' ? '请长按上面文字复制' : '复制这句话'

  return (
    <div className="copyBox">
      <p className="copyLabel">{label}</p>
      <p className="copyText">{text}</p>
      <button type="button" className={`copyBtn${state === 'done' ? ' done' : ''}`} onClick={copy}>
        {buttonLabel}
      </button>
    </div>
  )
}

function Block({ block }: { block: LessonBlock }) {
  switch (block.kind) {
    case 'note':
      return (
        <div className="lessonResult">
          <p className="lessonLab">{block.label}</p>
          {block.lines.map((line) => (
            <p key={line} className="mockInput">
              {line}
            </p>
          ))}
        </div>
      )
    case 'copy':
      return <CopyBox label={block.label} text={block.text} />
    case 'code':
      return (
        <div className="lessonResult">
          {block.label && <p className="lessonLab">{block.label}</p>}
          <div className="mockStep">
            {block.lines.map((line) => (
              <p key={line.text} className={line.tone ?? ''}>
                {line.text}
              </p>
            ))}
          </div>
        </div>
      )
    case 'link':
      return (
        <div className="lessonResult">
          <p className="lessonLab">{block.label}</p>
          <p className="mockLink">{block.url}</p>
          {block.tip && <p className="lessonTip">{block.tip}</p>}
        </div>
      )
    case 'image':
      return (
        <div className="lessonResult">
          <p className="lessonLab">{block.label}</p>
          <img src={block.src} alt={block.alt} className="lessonShot" />
          {block.tip && <p className="lessonTip">{block.tip}</p>}
        </div>
      )
  }
}

// 课时详情：按 name取课时，页眉 + 分步正文 + 课末提示。压入页，隐藏页签
function LessonDetail() {
  const { name } = useParams()
  const lesson = name ? getLesson(name) : undefined

  if (!lesson) {
    return (
      <main>
        <div className="liteNotFound">
          <h2>课时未找到</h2>
          <Link to={ROUTE_PATHS.theory} className="liteLink">
            返回课堂
          </Link>
        </div>
      </main>
    )
  }

  const siblings = publishedLessonsOf(lesson.course)
  const index = siblings.findIndex((item) => item.name === lesson.name)
  const prev = index > 0 ? siblings[index - 1] : undefined
  const next = index >= 0 && index < siblings.length - 1 ? siblings[index + 1] : undefined

  return (
    <main>
      <header className="lessonHero">
        {lesson.kicker && <span className="lessonKicker">{lesson.kicker}</span>}
        <h1>{lesson.title}</h1>
        {lesson.lede && <p>{lesson.lede}</p>}
      </header>

      <article className="taskBody">
        {lesson.steps.map((step) => (
          <section key={step.num} className="lessonStep">
            <div className="lessonHead">
              <span className="lessonNum">{step.num}</span>
              <div>
                <h2>{step.title}</h2>
                <p className="lessonDo">{step.do}</p>
              </div>
            </div>
            {step.blocks.map((block, index) => (
              <Block key={`${step.num}-${index}`} block={block} />
            ))}
          </section>
        ))}

        {lesson.tip && <p className="lessonCallout">{lesson.tip}</p>}
        {lesson.foot && <p className="lessonFoot">{lesson.foot}</p>}
        {(prev || next) && (
          <nav className="lessonNav" aria-label="课时导航">
            <div>
              {prev && (
                <Link to={lessonPath(prev.name)} className="lessonNavLink">
                  <span className="lessonNavDir">‹ 上一课</span>
                  <span className="lessonNavTitle">{prev.title}</span>
                </Link>
              )}
            </div>
            <div className="lessonNavNext">
              {next && (
                <Link to={lessonPath(next.name)} className="lessonNavLink">
                  <span className="lessonNavDir">下一课 ›</span>
                  <span className="lessonNavTitle">{next.title}</span>
                </Link>
              )}
            </div>
          </nav>
        )}
        <p className="submitHint">课时内容与教程仓同源，改动以教程仓为准。</p>
      </article>
    </main>
  )
}

export default LessonDetail
