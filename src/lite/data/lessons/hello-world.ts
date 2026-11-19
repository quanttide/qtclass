import type { Lesson } from '../../src/models/lesson'

// 氛围编程第 1 课。文字与步骤源自教程仓
// assets/tutorials/vibe-coding/docs/intro/hello-world.html（内容不改写，只换载体）
const lesson: Lesson = {
  name: 'hello-world',
  course: '氛围编程',
  title: '做出你的第一个游戏',
  description: '照着五步做出并上线你的第一个游戏，全程不用写代码。',
  status: 'published',
  kicker: '氛围编程 · 第 1 课',
  lede: '不用懂代码，照着做就行。每一步都告诉你「做完会看到什么」',
  steps: [
    {
      num: 1,
      title: '打开 WorkBuddy',
      do: '在手机上打开 WorkBuddy App',
      blocks: [
        {
          kind: 'note',
          label: '做完你会看到',
          lines: ['屏幕下方有一个输入对话框，可以打字、也可以粘贴。'],
        },
      ],
    },
    {
      num: 2,
      title: '复制这句话，粘贴进去',
      do: '点下面的按钮复制，然后粘贴到输入框。不用手打。',
      blocks: [
        {
          kind: 'copy',
          label: '点按钮一键复制',
          text: 'tycoon.game.quanttide.com 照着这个做一遍并且上线',
        },
        {
          kind: 'note',
          label: '做完你会看到',
          lines: [
            '输入框里出现这一行字：',
            'tycoon.game.quanttide.com 照着这个做一遍并且上线',
          ],
        },
      ],
    },
    {
      num: 3,
      title: '按回车，等它跑完',
      do: '发送后不用管，它会自己干活。大约等一两分钟。',
      blocks: [
        {
          kind: 'code',
          label: '做完你会看到',
          lines: [
            { tone: 'run', text: '› 正在读取这个网页…' },
            { tone: 'run', text: '› 正在照着做游戏…' },
            { tone: 'run', text: '› 正在上线…' },
            { tone: 'ok', text: '✓ 完成！给你一个游戏链接' },
          ],
        },
      ],
    },
    {
      num: 4,
      title: '复制生成的链接',
      do: '把那串链接完整复制下来，别漏了后面那一截。',
      blocks: [
        {
          kind: 'link',
          label: '做完你会看到（链接长这样）',
          url: 'https://xxxx.app.workbuddy.host/?sharecode=XXXXXXXX',
          tip: '?sharecode= 后面那串一定要带上，不然打不开',
        },
      ],
    },
    {
      num: 5,
      title: '发给朋友，玩两局',
      do: '把链接发到群里，点开就能玩。这就是你的 Hello World。',
      blocks: [
        {
          kind: 'image',
          label: '做完你会看到（游戏首页）',
          src: '/lessons/hello-world/game-preview.png',
          alt: '串串摊游戏首页对照图',
          tip: '看到这个夜市摊页面，点「开张！」就能玩了',
        },
      ],
    },
  ],
  tip: '想改就再说一句话。比如“把标题改成我的名字，重新上线”，不满意就再说，直到满意为止。',
  foot: '做出来，就是胜利 · 先做起来，别管为什么',
}

export default lesson
