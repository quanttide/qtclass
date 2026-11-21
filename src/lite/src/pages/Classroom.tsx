// 课堂页：课程清单（AI编程的文案与课时源自教程仓 intro 讲义；氛围创作 / 氛围工作 / 氛围教学的文案源自 data/profile 各自的 hello-world 课件，可随课件更新；训练营不在本页）
// 卡片下方挂该课程已发布的课时入口，课时内容与文案来自 models/lesson，不在此改写
import { Link } from 'react-router-dom'
import { publishedLessonsOf } from '../models/lesson'
import { lessonPath } from '../routes'
// online=false 为暂未上架：数据保留但不对外展示，上架时改回 true
const courses = [
  {
    name: '知识工作',
    level: '入门',
    audience: '新同学、实习生、业务协作成员',
    summary: '建立文档、信息收集、结构化表达和复盘的基本工作习惯。',
    modules: ['文档即资产', '信息收集与整理', '知识输出'],
    online: false,
  },
  {
    name: '氛围创作',
    level: '入门',
    audience: '想把一段文字画出来、第一次用 AI 生图的成员',
    summary: '四步把一段小说变成一张图：先让 AI 教你读懂原文，再让它写提示词、生成图片，最后反推提示词结构——学会的是可复用的方法，不是背模板。',
    modules: ['提供背景', '制作提示词', '生成图片', '反推结构'],
    online: true,
  },
  {
    name: 'AI编程',
    level: '入门',
    audience: '想用 AI 把想法做成作品、不用写代码的成员',
    summary: '同一个游戏做四遍：做出来、改起来、创出来、推出去。每一步只用一句话指挥 AI，做出能发给朋友玩的上线作品。',
    modules: ['照着做', '换个壳', '自己设计', '拿出去'],
    online: true,
  },
  {
    name: '氛围工作',
    level: '入门',
    audience: '想让 AI 替自己跑公开网站、拿现状报告的成员',
    summary: '当一回总裁：发一句话让 AI 去公开网站采集部门现状，交一份能逐条核对的报告——查不到的它得老实写查不到，不许编。',
    modules: ['一句话指令', 'AI 采集', '现状报告', '验收核对'],
    online: true,
  },
  {
    name: '氛围教学',
    level: '入门',
    audience: '会做一件事、有人想学，但没学过教学法的成员',
    summary: '不用教龄不用证书：挑一件你熟的事，拆成几步，每步写清「做完你会看到」，生成自己的课程闯关图——做一遍就做出来了。',
    modules: ['想一件事', '拆成几步', '做完你会看到', '生成课程图'],
    online: true,
  },
  {
    name: '大数据导论',
    level: '进阶',
    audience: '数据岗位入门、业务分析协作成员',
    summary: '理解数据采集、治理、分析和应用的基本链路。',
    modules: ['数据资产', '分析流程', '业务指标'],
    online: false,
  },
  {
    name: '数据工程',
    level: '高阶',
    audience: '数据工程、平台建设和交付实施成员',
    summary: '面向真实项目的数据建模、管道、质量和交付规范。',
    modules: ['数据建模', '工程管道', '质量与运维'],
    online: false,
  },
  {
    name: '生产实习',
    level: '实训',
    audience: '公司内部培训、实训基地学员',
    summary: '以微型创业和真实交付为牵引，完成学习、Demo、进度和立项闭环。',
    modules: ['理解业务', '识别机会', '验证 Demo', '提交立项'],
    online: false,
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

        <div className="learnGrid">
          {courses.filter((course) => course.online).map((course) => (
            <div key={course.name} className="learnCard">
              {renderCard(course)}
            </div>
          ))}
        </div>
      </section>
    </main>
  )
}

export default Classroom
