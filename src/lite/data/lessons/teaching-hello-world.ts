import type { Lesson } from '../../src/models/lesson'

// AI教学第 1 课。文字与步骤源自 data/profile/vibe-teaching/hello-world.html（内容不改写，只换载体）
const lesson: Lesson = {
  name: 'teaching-hello-world',
  course: 'AI教学',
  title: '把你熟的一件事，做成一门课',
  description: '不用教龄不用证书：想一件你熟的事，拆成几步，每步写清「做完你会看到」，生成你的课程闯关图。',
  status: 'published',
  kicker: 'AI教学 · 第 1 课',
  lede: '不用教龄，不用证书。你只要会做一件事，而且有人想学——把它说出来、拆成几关，就是一门课。',
  steps: [
    {
      num: 1,
      title: '想一件你熟、别人想学的事',
      do: '素材不用我给——你自己最清楚有什么能教。想起一件填一件。',
      blocks: [
        {
          kind: 'note',
          label: '想不出来？问自己三个问题',
          lines: [
            '什么东西你做得很熟，朋友老来问你怎么弄？',
            '什么东西你会，但大多数人做得乱七八糟？',
            '你曾经随手教会过别人什么？',
          ],
        },
        {
          kind: 'note',
          label: '选好了就打勾',
          lines: ['✓ 这件事我闭着眼都能做出来', '✓ 身边有人问过我怎么做 / 想学'],
        },
        {
          kind: 'note',
          label: '填好的样例：收纳整理',
          lines: [
            '① 分类——把所有东西摊出来，分成几类',
            '② 取舍——丢掉不用的，只留真正需要的',
            '③ 归位——每类固定一个位置，用完放回',
            '④ 维持——每天花两分钟归位',
          ],
        },
      ],
    },
    {
      num: 2,
      title: '把它拆成几步',
      do: '一件熟事，就是几个动作连起来。几步都行——够学生照着做出来就好。',
      blocks: [
        {
          kind: 'note',
          label: '做完你会看到',
          lines: ['几步都行，够学生照着做出来就好。'],
        },
      ],
    },
    {
      num: 3,
      title: '给每步写「做完你会看到」',
      do: '通识课里你最爱看的那一句。学生靠它对照。',
      blocks: [
        {
          kind: 'note',
          label: '做完你会看到',
          lines: ['写清楚，别人才做得出。'],
        },
      ],
    },
    {
      num: 4,
      title: '生成你的课',
      do: '点一下，看看你刚做出来的东西长什么样。',
      blocks: [
        {
          kind: 'note',
          label: '做完你会看到 —— 这就是你做出来的一门课',
          lines: ['挑一件你熟的事 + 拆几步 + 每步写清楚"做完看到啥"。'],
        },
        {
          kind: 'note',
          label: '复制这张课程图',
          lines: ['把课程图发给别人，能教会就说明这是一门好课。'],
        },
      ],
    },
  ],
  tip: '你没背任何理论，做一遍就做出来了——做课，本来就这么简单。',
  foot: '把你会的事说出来，就是一门课',
}

export default lesson
