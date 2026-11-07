import Markdown from '../components/Markdown'
import { stripFrontmatter } from '../utils/frontmatter'

// 首页内容静态副本（源自宣传册取材，data/home/index.md），根锚定路径与 CI 一致
const homeModules = import.meta.glob('/data/home/*.md', {
  eager: true,
  query: '?raw',
  import: 'default',
}) as Record<string, string>

// 首页：课程特色。正文剥 frontmatter 后渲染
function Home() {
  const raw = homeModules['/data/home/index.md'] ?? ''
  return (
    <main>
      <article>
        <Markdown>{stripFrontmatter(raw)}</Markdown>
      </article>
    </main>
  )
}

export default Home
