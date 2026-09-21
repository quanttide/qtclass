// 首页内容：源自 quanttide-tech 数据仓 data/brochure/qtclass/index.md 的静态副本
// 同步方式：上游改动后复制到本包 data/home/index.md

const HOME_INTRO_PATH = '/data/home/index.md'

// 根锚定路径（相对 Vite 项目根）：CI 与本地一致
const homeModules = import.meta.glob('/data/home/*.md', {
  eager: true,
  query: '?raw',
  import: 'default',
}) as Record<string, string>

export const homeIntro = homeModules[HOME_INTRO_PATH] ?? ''
