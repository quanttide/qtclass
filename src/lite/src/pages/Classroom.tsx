// 课堂页：课程清单卡（AI编程的文案与课时源自教程仓 intro 讲义；AI创意 / AI办公 / AI教学的文案源自 data/profile 各自的 hello-world 课件，可随课件更新；训练营不在本页）
// 卡片整体导航到课程主页（介绍、课时、班级都在那里）；卡片只带一行班级状态
// 这里只放已上线的通识课；全量清单（含领域课程与上线状态）在 qtcloud-course 的 src/lite
import { Link } from 'react-router-dom'
import { courses } from '../models/course'
import { cohortsOf, COHORT_STATUS_LABEL } from '../models/cohort'
import { coursePath } from '../routes'

/** 分级：通识先行（大一），领域在后（大三）；领域课程在 qtcloud-course 的课程清单里 */
const stageOf: Record<string, string> = { 通识: '大一', 领域: '大三' }

/** 页面上出现过的分级，按 courses 里的先后 */
const tracks = [...new Set(courses.filter((course) => course.online).map((course) => course.track))]

function renderCard(course: (typeof courses)[number]) {
  const cohort = cohortsOf(course.name)[0]

  return (
    <>
      <div className="courseTop">
        <h3>{course.name}</h3>
        <span className="courseStatus">已上线</span>
        <span>{course.level}</span>
      </div>
      <p className="audience">{course.audience}</p>
      <p className="summary">{course.summary}</p>
      <div className="moduleList">
        {course.modules.map((module) => (
          <span key={module}>{module}</span>
        ))}
      </div>
      {cohort && (
        <div className="cardCohort">
          <div className="cardCohortTop">
            <span className={`cohortBadge ${cohort.status}`}>
              {COHORT_STATUS_LABEL[cohort.status]}
            </span>
            <span className="cardCohortName">{cohort.name}</span>
            {cohort.quota && <span className="cardCohortQuota">限额 {cohort.quota}</span>}
          </div>
          {cohort.apply && (
            <p className="cardCohortApply">报名条件：{cohort.apply}</p>
          )}
        </div>
      )}
      <span className="courseHomeLink" aria-hidden="true">
        课程主页 ›
      </span>
    </>
  )
}

// 课程列表：所有课程都是实践课，不区分理论 / 实践，训练营不在本页
function Classroom() {
  return (
    <main>
      <section className="courseSection" aria-labelledby="courses-title">
        <div className="sectionHead">
          <div>
            <p>Courses</p>
            <h2 id="courses-title">课程</h2>
          </div>
        </div>

        {tracks.map((track) => (
          <div key={track}>
            <h2 className="trackHead">
              {track}课程 · {stageOf[track]}
            </h2>
            <div className="learnGrid">
              {courses
                .filter((course) => course.online && course.track === track)
                .map((course) => (
                  <Link
                    key={course.name}
                    to={coursePath(course.slug)}
                    className="learnCard"
                    aria-label={`${course.name} 课程主页`}
                  >
                    {renderCard(course)}
                  </Link>
                ))}
            </div>
          </div>
        ))}
      </section>
    </main>
  )
}

export default Classroom
