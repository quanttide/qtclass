import { Link } from 'react-router-dom'
import { useEffect, useState } from 'react'
import { LEARNING_SECTIONS, PRICES_TRACKS, itemsIn, learningEntries, loadLearningEntries, type LearningEntry } from '../models/learning'
import { learnItemPath } from '../routes'

function Learn() {
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

  return (
    <main>
      {LEARNING_SECTIONS.map((section) => (
        <section key={section.key} className="courseSection">
          <div className="sectionHead">
            <div>
              <p>{section.subtitle}</p>
              <h2>{section.title}</h2>
            </div>
            <p className="sectionDesc">{section.description}</p>
          </div>

          <div className="learnGrid">
            {section.key === 'prices' &&
              PRICES_TRACKS.map((track) => (
                <div key={track.key} className="learnCard">
                  <div className="courseTop">
                    <h3>{track.label}</h3>
                  </div>
                  <p className="summary">{track.summary}</p>
                  <p className="audience">{track.action}</p>
                </div>
              ))}
            {itemsIn(section.key, entries).map((item) => (
              <Link key={item.slug} to={learnItemPath(section.key, item.slug)} className="learnCard">
                <div className="courseTop">
                  <h3>{item.title}</h3>
                </div>
                {item.description && <p className="summary">{item.description}</p>}
              </Link>
            ))}
          </div>
        </section>
      ))}
    </main>
  )
}

export default Learn
