import { Link, useParams } from 'react-router-dom'
import { getCourse } from '../models/course'
import { publishedLessonsOf } from '../models/lesson'
import { cohortsOf, COHORT_STATUS_LABEL } from '../models/cohort'
import { lessonPath, ROUTE_PATHS } from '../routes'

// 课程主页：课程介绍 + 课时列表 + 班级信息。压入页，隐藏页签
function CourseDetail() {
  const { slug } = useParams()
  const course = slug ? getCourse(slug) : undefined

  if (!course) {
    return (
      <main>
        <div className="liteNotFound">
          <h2>课程未找到</h2>
          <Link to={ROUTE_PATHS.classroom} className="liteLink">
            返回课堂
          </Link>
        </div>
      </main>
    )
  }

  const lessons = publishedLessonsOf(course.name)
  const cohorts = cohortsOf(course.name)

  return (
    <main>
      <header className="lessonHero">
        <span className="lessonKicker">
          {course.track} · {course.level}
        </span>
        <h1>{course.name}</h1>
        <p>{course.summary}</p>
      </header>

      <article className="taskBody">
        <section aria-label="课程介绍">
          <p className="lessonListTitle">课程介绍</p>
          <p className="audience">{course.audience}</p>
          <div className="moduleList">
            {course.modules.map((module) => (
              <span key={module}>{module}</span>
            ))}
          </div>
        </section>

        {lessons.length > 0 && (
          <section className="lessonList" aria-label="课时">
            <p className="lessonListTitle">课时</p>
            {lessons.map((lesson) => (
              <Link key={lesson.name} to={lessonPath(lesson.name)} className="lessonLink">
                <span>{lesson.title}</span>
                <span aria-hidden="true">›</span>
              </Link>
            ))}
          </section>
        )}

        {cohorts.length > 0 && (
          <section className="cohortList" aria-label="班级">
            <p className="lessonListTitle">班级</p>
            {cohorts.map((cohort) => (
              <div key={cohort.id} className="cohortRow">
                <div className="cohortTop">
                  <h2>{cohort.name}</h2>
                  <span className={`cohortStatus ${cohort.status}`}>
                    {COHORT_STATUS_LABEL[cohort.status]}
                  </span>
                </div>
                <p className="cohortMeta">{cohort.schedule}</p>
                {cohort.quota && (
                  <p className="cohortField">
                    <span className="cohortFieldLabel">限额</span>
                    {cohort.quota}
                  </p>
                )}
                {cohort.window && (
                  <p className="cohortField">
                    <span className="cohortFieldLabel">报名窗口</span>
                    {cohort.window}
                  </p>
                )}
                {cohort.apply && (
                  <p className="cohortField">
                    <span className="cohortFieldLabel">报名条件</span>
                    {cohort.apply}
                  </p>
                )}
                {cohort.signup && (
                  <a className="cohortSignup" href={cohort.signup.href}>
                    {cohort.signup.label} ›
                  </a>
                )}
                {cohort.note && <p className="cohortMeta">{cohort.note}</p>}
              </div>
            ))}
          </section>
        )}
      </article>
    </main>
  )
}

export default CourseDetail
