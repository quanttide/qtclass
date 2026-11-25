import type { Example } from '../src/models/example'

// 示例载荷：加一条 = 加一行再发版（lite/v0.x.y）
// 现状：只放官方版（原型稿里无分歧的两条）；学员作品未放，署名口径未定
export const examples: Example[] = [
  {
    course: 'AI编程',
    title: '滁州夜市 · 串串摊',
    action: '试玩游戏',
    url: 'https://tycoon.game.quanttide.com',
    note: '游戏原版。先玩一遍，熟悉玩法和规则，再打开课程看任务书。',
  },
  {
    course: 'AI编程',
    title: '原版宣传册',
    action: '查看宣传册',
    url: 'https://game.quanttide.com/tycoon',
    note: '游戏的官方介绍页，看它怎么被包装和呈现，也是第 4 课的参照样板。',
  },
]
