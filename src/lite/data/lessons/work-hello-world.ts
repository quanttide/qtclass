import type { Lesson } from '../../src/models/lesson'

// AI办公第 1 课。文字与步骤源自 data/profile/vibe-working/hello-world.html（内容不改写，只换载体）
const lesson: Lesson = {
  name: 'work-hello-world',
  course: 'AI办公',
  title: '总裁查岗：一句话摸清家底',
  description: '当一回总裁：发一句话让 AI 去公开网站采集，交一份能逐条核对的现状报告。',
  status: 'published',
  kicker: 'AI办公 · 第 1 课',
  lede: '不用开会、不用问人——发一句话，让 AI 去公开网站上替你查，交一份现状报告。',
  steps: [
    {
      num: 1,
      title: '打开工具，粘贴下面这句话',
      do: '这是总裁的指令——告诉 AI 去哪两个网站、采什么、写成什么。',
      blocks: [
        {
          kind: 'copy',
          label: '一键复制这句话',
          text: '访问 game.quanttide.com/tycoon 和 tycoon.game.quanttide.com，采集游戏部门当前的公开信息（产品是什么、玩法几步、有多少吉祥物、几个周目、当前展示状态、能看到的版本号），整理成一份《游戏部门现状报告》。用表格和要点呈现。最后单独列出"公开渠道查不到的信息"，不要编造。',
        },
        {
          kind: 'note',
          label: '做完你会看到',
          lines: ['输入框里出现上面那段话（不用手打），按回车，看它跑。'],
        },
      ],
    },
    {
      num: 2,
      title: '等 AI 去两个网站采集',
      do: '它会打开网页、读取文字和数字、提取关键信息——就像派了个助理去实地看。',
      blocks: [
        {
          kind: 'code',
          label: '做完你会看到',
          lines: [
            { tone: 'run', text: '› 正在访问 game.quanttide.com/tycoon' },
            { tone: 'run', text: '› 正在访问 tycoon.game.quanttide.com' },
            { tone: 'run', text: '› 正在整理…' },
            { tone: 'ok', text: '✓ 采集完成' },
          ],
        },
      ],
    },
    {
      num: 3,
      title: '拿到一份《游戏部门现状报告》',
      do: '这是你的产出——一份结构化的报告，不是一堆网页链接。',
      blocks: [
        {
          kind: 'note',
          label: '做完你会看到',
          lines: [
            '一份分板块的报告，有表格、有要点、有"查不到的信息"清单。',
            '产品概况、玩法与规模、技术版本痕迹，最后单独一栏"公开渠道查不到的信息"。',
          ],
        },
      ],
    },
    {
      num: 4,
      title: '用总裁的眼光验收',
      do: '报告里的数字，你能回网站核对上吗？查不到的部分，它有没有老实说"查不到"，而不是编一句？',
      blocks: [
        {
          kind: 'note',
          label: '做完你会看到',
          lines: [
            '你能在网站截图里找到报告里写的每个数字——这就是"验收"。',
            'AI 只能报它真正看到的东西——这是数据采集最重要的规矩。',
          ],
        },
      ],
    },
  ],
  tip: '注意"公开渠道查不到的信息"那一栏：它老老实实写了"查不到"，而不是瞎编一个团队人数。',
  foot: '从"做出来"扩展到"看清楚"',
}

export default lesson
