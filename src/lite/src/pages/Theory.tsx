// 理论页：课程清单（氛围编程的文案与课时源自教程仓 intro 讲义，可随教程更新；训练营不在本页）
// 卡片下方挂该课程已发布的课时入口，课时内容与文案来自 models/lesson，不在此改写
import { Link } from 'react-router-dom'
import { publishedLessonsOf } from '../models/lesson'
import { lessonPath } from '../routes'
const courses = [
  {
    name: '知识工作',
    level: '入门',
    audience: '新同学、实习生、业务协作成员',
    summary: '建立文档、信息收集、结构化表达和复盘的基本工作习惯。',
    modules: ['文档即资产', '信息收集与整理', '知识输出'],
  },
  {
    name: '氛围编程',
    level: '入门',
    audience: '想用 AI 把想法做成作品、不用写代码的成员',
    summary: '同一个游戏做四遍：做出来、改起来、创出来、推出去。每一步只用一句话指挥 AI，做出能发给朋友玩的上线作品。',
    modules: ['照着做', '换个壳', '自己设计', '拿出去'],
  },
  {
    name: '大数据导论',
    level: '进阶',
    audience: '数据岗位入门、业务分析协作成员',
    summary: '理解数据采集、治理、分析和应用的基本链路。',
    modules: ['数据资产', '分析流程', '业务指标'],
  },
  {
    name: '数据工程',
    level: '高阶',
    audience: '数据工程、平台建设和交付实施成员',
    summary: '面向真实项目的数据建模、管道、质量和交付规范。',
    modules: ['数据建模', '工程管道', '质量与运维'],
  },
  {
    name: '生产实习',
    level: '实训',
    audience: '公司内部培训、实训基地学员',
    summary: '以微型创业和真实交付为牵引，完成学习、Demo、进度和立项闭环。',
    modules: ['理解业务', '识别机会', '验证 Demo', '提交立项'],
  },
]

function renderCard(course: (typeof courses)[number]) {
  const courseLessons = publishedLessonsOf(course.name)

  return (
    <>
      <div className="courseTop">
        <h3>{course.name}</h3>
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

// 课程页：课程列表。所有课程都是实践课，不区分理论 / 实践，训练营不在本页
function Theory() {
  return (
    <main>
      <section className="courseSection" aria-labelledby="courses-title">
        <div className="sectionHead">
          <div>
            <p>Courses</p>
            <h2 id="courses-title">课程</h2>
          </div>
        </div>

        <div className="learnGrid">
          {courses.map((course) => (
            <div key={course.name} className="learnCard">
              {renderCard(course)}
            </div>
          ))}
        </div>
      </section>
    </main>
  )
}

export default Theory
