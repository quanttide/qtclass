import { Link } from 'react-router-dom'
import { productionInternship } from '../data/courses'

function ProductionInternship() {
  return (
    <main>
      <section className="course-hero">
        <h1>{productionInternship.title}</h1>
        <p>{productionInternship.description}</p>
      </section>

      <section className="course-content">
        <h2>课程教案</h2>
        <div className="lesson-grid">
          {productionInternship.lessons.map((lesson, index) => (
            <Link
              key={lesson.id}
              to={`/courses/production-internship/lessons/${lesson.slug}`}
              className="lesson-card"
            >
              <span className="lesson-number">{index + 1}</span>
              <div className="lesson-info">
                <h3>{lesson.title}</h3>
              </div>
            </Link>
          ))}
        </div>
      </section>
    </main>
  )
}

export default ProductionInternship
