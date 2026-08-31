// 简单的 markdown 到 HTML 转换器（与课程详情页共用）
export function markdownToHtml(md: string): string {
  const lines = md.split('\n')
  const htmlLines: string[] = []
  let inCodeBlock = false
  let codeContent = ''
  let codeLang = ''
  let inBlockquote = false
  let blockquoteContent = ''
  let listType: 'ul' | 'ol' | null = null
  let listItems: string[] = []

  const flushList = () => {
    if (listType && listItems.length > 0) {
      const tag = listType
      htmlLines.push(`<${tag}>`)
      listItems.forEach(item => {
        htmlLines.push(`  <li>${processInline(item)}</li>`)
      })
      htmlLines.push(`</${tag}>`)
      listItems = []
      listType = null
    }
  }

  const processInline = (text: string): string => {
    return text
      .replace(/\*\*\*(.+?)\*\*\*/g, '<strong><em>$1</em></strong>')
      .replace(/\*\*(.+?)\*\*/g, '<strong>$1</strong>')
      .replace(/\*(.+?)\*/g, '<em>$1</em>')
      .replace(/`([^`]+)`/g, '<code>$1</code>')
      .replace(/\[([^\]]+)\]\(([^)]+)\)/g, '<a href="$2">$1</a>')
  }

  for (const line of lines) {
    // 代码块处理
    if (line.startsWith('```')) {
      if (inCodeBlock) {
        htmlLines.push(`<pre><code class="language-${codeLang}">${codeContent.trim()}</code></pre>`)
        inCodeBlock = false
        codeContent = ''
        codeLang = ''
      } else {
        flushList()
        inCodeBlock = true
        codeLang = line.slice(3).trim()
      }
      continue
    }

    if (inCodeBlock) {
      codeContent += line + '\n'
      continue
    }

    // 空行处理
    if (line.trim() === '') {
      flushList()
      if (inBlockquote) {
        htmlLines.push(`<blockquote>${blockquoteContent.trim()}</blockquote>`)
        inBlockquote = false
        blockquoteContent = ''
      }
      continue
    }

    // 标题
    if (line.startsWith('### ')) {
      flushList()
      htmlLines.push(`<h3>${processInline(line.slice(4))}</h3>`)
      continue
    }
    if (line.startsWith('## ')) {
      flushList()
      htmlLines.push(`<h2>${processInline(line.slice(3))}</h2>`)
      continue
    }
    if (line.startsWith('# ')) {
      flushList()
      htmlLines.push(`<h1>${processInline(line.slice(2))}</h1>`)
      continue
    }

    // 引用块
    if (line.startsWith('> ')) {
      flushList()
      inBlockquote = true
      blockquoteContent += line.slice(2) + ' '
      continue
    }

    // 无序列表
    if (line.match(/^- /)) {
      if (listType !== 'ul') {
        flushList()
        listType = 'ul'
      }
      listItems.push(line.slice(2))
      continue
    }

    // 有序列表
    if (line.match(/^\d+\. /)) {
      if (listType !== 'ol') {
        flushList()
        listType = 'ol'
      }
      listItems.push(line.replace(/^\d+\. /, ''))
      continue
    }

    // 水平线
    if (line.match(/^---+$/)) {
      flushList()
      htmlLines.push('<hr />')
      continue
    }

    // 表格行（简单处理）
    if (line.startsWith('|') && line.endsWith('|')) {
      flushList()
      // 跳过分隔行
      if (line.match(/^\|[-\s|]+\|$/)) continue
      const cells = line.split('|').filter(c => c.trim()).map(c => `<td>${processInline(c.trim())}</td>`).join('')
      htmlLines.push(`<tr>${cells}</tr>`)
      continue
    }

    // 普通段落
    flushList()
    htmlLines.push(`<p>${processInline(line)}</p>`)
  }

  flushList()
  if (inBlockquote) {
    htmlLines.push(`<blockquote>${blockquoteContent.trim()}</blockquote>`)
  }

  return htmlLines.join('\n')
}
