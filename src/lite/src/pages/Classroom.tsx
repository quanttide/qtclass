// 课堂页：课程清单（AI编程的文案与课时源自教程仓 intro 讲义；AI创意 / AI办公 / AI教学的文案源自 data/profile 各自的 hello-world 课件，可随课件更新；训练营不在本页）
// 卡片下方挂该课程已发布的课时入口，课时内容与文案来自 models/lesson，不在此改写
// 这里只放已上线的通识课；全量清单（含领域课程与上线状态）在 qtcloud-course 的 src/lite
import { Link } from 'react-router-dom'
import { publishedLessonsOf } from '../models/lesson'
import { lessonPath } from '../routes'

/** 分级：通识先行（大一），领域在后（大三）；领域课程在 qtcloud-course 的课程清单里 */
const stageOf: Record<string, string> = { 通识: '大一', 领域: '大三' }

const courses = [
  {
    name: 'AI创意',
    track: '通识',
    level: '入门',
    audience: '想把一段文字画出来、第一次用 AI 生图的成员',
    summary: '四步把一段小说变成一张图：先让 AI 教你读懂原文，再让它替你写提示词、生成图片，最后教你怎么写——提示词不用记。',
    modules: ['读懂原文', '替你写提示词', '生成图片', '教你写'],
    online: true,
  },
  {
    name: 'AI办公',
    track: '通识',
    level: '入门',
    audience: '想让 AI 替自己跑公开网站、拿现状报告的成员',
    summary: '当一回总裁：发一句话让 AI 去公开网站采集部门现状，交一份能逐条核对的报告——查不到的它得老实写查不到，不许编。',
    modules: ['一句话指令', 'AI 采集', '现状报告', '验收核对'],
    online: true,
  },
  {
    name: 'AI编程',
    track: '通识',
    level: '入门',
    audience: '想用 AI 把想法做成作品、不用写代码的成员',
    summary: '同一个游戏做四遍：做出来、改起来、创出来、推出去。每一步只用一句话指挥 AI，做出能发给朋友玩的上线作品。',
    modules: ['照着做', '换个壳', '自己设计', '拿出去'],
    online: true,
  },
  {
    name: 'AI教学',
    track: '通识',
    level: '入门',
    audience: '会做一件事、有人想学，但没学过教学法的成员',
    summary: '不用教龄不用证书：挑一件你熟的事，拆成几步，每步写清「做完你会看到」，生成自己的课程闯关图——做一遍就做出来了。',
    modules: ['想一件事', '拆成几步', '做完你会看到', '生成课程图'],
    online: true,
  },
]

/** 页面上出现过的分级，按 courses 里的先后 */
const tracks = [...new Set(courses.filter((course) => course.online).map((course) => course.track))]

function renderCard(course: (typeof courses)[number]) {
  const courseLessons = publishedLessonsOf(course.name)

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
      {courseLessons.length > 0 && (
        <div className="lessonList">
          <p className="lessonListTitle">课时</p>
          {courseLessons.map((lesson) => (
            <Link key={lesson.name} to={lessonPath(lesson.name)} className="lessonLink">
              <span>{lesson.title}</span>
              <span aria-hidden="true">›</span>
            </Link>
          ))}
        </div>
      )}
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
                  <div key={course.name} className="learnCard">
                    {renderCard(course)}
                  </div>
                ))}
            </div>
          </div>
        ))}
      </section>
    </main>
  )
}

export default Classroom
