import { examples } from '../../data/examples'

// 示例：课程主页第四节——先只放官方版（无分歧），学员作品待署名口径定了再加数据行
// 英文名按团队习惯用 example
export interface Example {
  course: string
  // 展示名，如「滁州夜市 · 串串摊」
  title: string
  // 动作词，如「试玩游戏」
  action: string
  url: string
  // 一句话说明它为什么是参照
  note: string
}

export function examplesOf(course: string): Example[] {
  return examples.filter((example) => example.course === course)
}
