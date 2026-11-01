import Markdown from '../components/Markdown'
import { homeIntro } from '../models/home'

// 首页：量潮课堂介绍。课程体系在 /courses，价格与合作在 /prices
function Home() {
  return (
    <main>
      <section className="courseSection">
        <div className="lesson-content lesson-body">
          <Markdown>{homeIntro}</Markdown>
        </div>
      </section>
    </main>
  )
}

export default Home
