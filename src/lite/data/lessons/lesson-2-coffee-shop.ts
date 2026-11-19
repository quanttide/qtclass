import type { Lesson } from '../../src/models/lesson'

// AI编程第 2 课。文字与步骤源自教程仓
// assets/tutorials/vibe-coding/docs/intro/lesson-2.html（内容不改写，只换载体）
const lesson: Lesson = {
  name: 'lesson-2-coffee-shop',
  course: 'AI编程',
  title: '换个壳，又是新游戏',
  description: '把串串摊改成咖啡店——玩法数值一个没动，只换了皮。',
  status: 'published',
  kicker: 'AI编程 · 第 2 课',
  lede: '上一课的串串摊，只需改一句话就变成咖啡店——玩法、数值一个字都没动。',
  steps: [
    {
      num: 1,
      title: '打开 WorkBuddy',
      do: '接着上一课，还在这个游戏里。',
      blocks: [
        {
          kind: 'note',
          label: '做完你会看到',
          lines: ['还是上次那个串串摊游戏的对话，能接着往下说。'],
        },
      ],
    },
    {
      num: 2,
      title: '复制这句话，粘贴进去',
      do: '点按钮复制，粘贴到输入框。注意它特意说了「玩法别改」。',
      blocks: [
        {
          kind: 'copy',
          label: '点按钮一键复制',
          text: '把串串摊游戏改成咖啡店主题：招牌、文案、配色、图标、吉祥物全都换成咖啡店，但玩法、数值、规则一个都不要改。改完上线。',
        },
        {
          kind: 'note',
          label: '做完你会看到',
          lines: ['输入框里出现上面那一整段话。'],
        },
      ],
    },
    {
      num: 3,
      title: '按回车，等它跑完',
      do: '它会自己把所有文字、图标、配色换一遍，玩法原封不动。',
      blocks: [
        {
          kind: 'code',
          label: '做完你会看到',
          lines: [
            { tone: 'run', text: '› 正在把所有文案换成咖啡店…' },
            { tone: 'run', text: '› 正在换配色、图标、吉祥物…' },
            { tone: 'run', text: '› 正在确认玩法数值没动…' },
            { tone: 'run', text: '› 正在上线…' },
            { tone: 'ok', text: '✓ 完成！给你新的游戏链接' },
          ],
        },
      ],
    },
    {
      num: 4,
      title: '点开新链接，对比着玩两局',
      do: '一边开咖啡店，一边回想串串摊。是不是玩法完全一样？',
      blocks: [
        {
          kind: 'link',
          label: '做完你会看到（新的链接长这样）',
          url: 'https://xxxx.app.workbuddy.host/?sharecode=XXXXXXXX',
          tip: '点开就是咖啡店，但一玩就发现——套路还是那个套路',
        },
      ],
    },
  ],
  tip: '想明白了吗？你只改了一句话，AI 就做出了一款「新游戏」。其实所有软件都这样：表面花里胡哨，核心逻辑就那么点。壳想换什么样就换什么样，里面的玩法不动。——你现在，已经看懂软件的门道了。',
  foot: '万变不离其宗 · 原来软件就这么简单',
}

export default lesson
