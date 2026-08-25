import { Link } from 'react-router-dom'
import { productionInternship } from '../data/courses'

function ProductionInternship() {
  let lessonIndex = 0

  return (
    <main>
      <section className="course-hero">
        <h1>{productionInternship.title}</h1>
        <p>{productionInternship.description}</p>
      </section>

      <section className="course-content">
        <h2>课程教案</h2>
        <div className="chapter-list">
          {productionInternship.chapters.map((chapter) => (
            <div key={chapter.id} className="chapter">
              <h3 className="chapter-title">{chapter.title}</h3>
              <div className="lesson-list">
                {chapter.lessons.map((lesson) => {
                  lessonIndex++
                  return (
                    <Link
                      key={lesson.id}
                      to={`/courses/production-internship/lessons/${lesson.slug}`}
                      className="lesson-card"
                    >
                      <span className="lesson-number">{lessonIndex}</span>
                      <div className="lesson-info">
                        <h4>{lesson.title}</h4>
                      </div>
                    </Link>
                  )
                })}
              </div>
            </div>
          ))}
        </div>
      </section>
    </main>
  )
}

export default ProductionInternship
