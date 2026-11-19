import type { Lesson } from '../../src/models/lesson'

// AI编程第 3 课。文字与步骤源自教程仓
// assets/tutorials/vibe-coding/docs/intro/lesson-3.html（内容不改写，只换载体）
const lesson: Lesson = {
  name: 'lesson-3-worker',
  course: 'AI编程',
  title: '这回，你说了不算',
  description: '只给一个模糊想法，让 AI 先出设计方案再实现，玩法规则全变了。',
  status: 'published',
  kicker: 'AI编程 · 第 3 课',
  lede: '前两课都是「别人给好的」。这一课，你自己提想法，让 AI 帮你设计成玩法。',
  steps: [
    {
      num: 1,
      title: '打开 WorkBuddy',
      do: '新开一个对话，接着用同一个游戏。',
      blocks: [
        {
          kind: 'note',
          label: '做完你会看到',
          lines: ['还是熟悉的输入框，可以打字、可以粘贴。'],
        },
      ],
    },
    {
      num: 2,
      title: '把想法交给 AI，让它来设计',
      do: '点按钮复制这段话——它不是命令，而是「提需求 + 让 AI 出方案」。',
      blocks: [
        {
          kind: 'copy',
          label: '点按钮一键复制',
          text: '我想把咖啡店游戏改成「打工人」版本，视角从店主换成办公室白领。你先帮我设计玩法：要贴合每天面对老板和同事的不确定性。我的想法还很模糊，你直接给出一套具体方案，然后照着做出来并上线。玩法数值细节你定，不用问我。',
        },
        {
          kind: 'note',
          label: '这段话为什么好用？',
          lines: [
            '① 说清了想法（打工人、上下级不确定）',
            '② 明确了要 AI 出方案，不是照搬',
            '③ 告诉它别来问你，直接做',
          ],
        },
      ],
    },
    {
      num: 3,
      title: '看 AI 怎么把想法变成玩法',
      do: '它会先设计，再动手。留意它是怎么「翻译」你的想法的。',
      blocks: [
        {
          kind: 'note',
          label: '做完你会看到（AI 的思路大致是这样）',
          lines: [
            '店主卖咖啡给客人 › 白领接老板派的活',
            '猜今晚来多少客人 › 猜今天老板派多少活',
            '备几杯 / 定价格 › 备几套方案 / 摆什么要价姿态',
            '街坊、军师、老店长 › 同事、老油条、老主管',
            '咖啡豆、满堂彩 › 绩效分、完美拿捏',
          ],
        },
      ],
    },
    {
      num: 4,
      title: '点开链接，看看它做成什么样',
      do: '你会拿到一个新链接，点开就是 AI 设计出来的打工人版。',
      blocks: [
        {
          kind: 'code',
          label: '做完你会看到',
          lines: [
            { tone: 'run', text: '› AI 正在设计玩法方案…' },
            { tone: 'run', text: '› 正在把咖啡店改成办公室…' },
            { tone: 'run', text: '› 正在上线…' },
            { tone: 'ok', text: '✓ 完成！一个全新的打工人游戏' },
          ],
        },
      ],
    },
  ],
  tip: '前两课，工具给什么你就用什么。这一课，你只给了一个模糊想法，AI 就帮你把它设计成了能玩的游戏。玩法细节我没想，AI 自己定了——但它定的每一样，都扣着「打工人」这个主题。这就是和 AI 一起做东西：你负责想要什么，它负责怎么实现。',
  foot: '想法是种子 · AI 帮你把它长成游戏',
}

export default lesson
