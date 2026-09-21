import { homeIntro } from '../models/home'
import { markdownToHtml } from '../utils/markdown'

// 首页：量潮课堂介绍。课程体系在 /courses，学习资料在 /learn
function Home() {
  return (
    <main>
      <section className="courseSection">
        <div className="lesson-content">
          <div
            className="lesson-body"
            dangerouslySetInnerHTML={{ __html: markdownToHtml(homeIntro) }}
          />
        </div>
      </section>
    </main>
  )
}

export default Home
