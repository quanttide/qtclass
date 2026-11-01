import { useEffect, useState } from 'react'
import Markdown from '../components/Markdown'
import {
  PRICES_TRACKS,
  learningEntries,
  loadLearningEntries,
  type LearningEntry,
} from '../models/learning'

// 价格页：三档付费对象在上（询价口径不标价格），C 档明细两篇内联
function Prices() {
  const [entries, setEntries] = useState<LearningEntry[]>(learningEntries)

  useEffect(() => {
    let alive = true
    loadLearningEntries().then((next) => {
      if (alive) setEntries(next)
    })
    return () => {
      alive = false
    }
  }, [])

  const details = entries.filter((entry) => entry.section === 'prices')

  return (
    <main>
      <section className="courseSection" aria-labelledby="prices-title">
        <div className="sectionHead">
          <div>
            <p>Prices</p>
            <h2 id="prices-title">价格</h2>
          </div>
          <p className="sectionDesc">定价跟付费对象与商业模式走，不跟课程走。</p>
        </div>

        <div className="learnGrid">
          {PRICES_TRACKS.map((track) => (
            <div key={track.key} className="learnCard">
              <div className="courseTop">
                <h3>{track.label}</h3>
              </div>
              <p className="summary">{track.summary}</p>
              <p className="audience">{track.action}</p>
            </div>
          ))}
        </div>
      </section>

      {details.map((item) => (
        <section key={item.slug} className="courseSection">
          <div className="sectionHead">
            <div>
              <h2>{item.title}</h2>
            </div>
          </div>
          <div className="lesson-content lesson-body">
            {/* 正文首行自带与章节标题重复的一级标题，内联时剥离 */}
            <Markdown>{item.content.replace(/^\s*# [^\n]*\n?/, '')}</Markdown>
          </div>
        </section>
      ))}
    </main>
  )
}

export default Prices
