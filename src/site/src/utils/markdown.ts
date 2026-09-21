import DOMPurify from 'dompurify'

// 首部 YAML frontmatter：元数据由 src/models 解析使用，不进入正文
const FRONTMATTER_RE = /^---\r?\n([\s\S]*?)\r?\n---[ \t]*\r?\n?/

function stripFrontmatter(md: string): string {
  const match = md.match(FRONTMATTER_RE)
  // 块内无键值行时视为普通分隔线，不作元数据剥离
  if (!match || !/^[A-Za-z_][\w-]*\s*:/m.test(match[1])) return md
  return md.slice(match[0].length)
}

// 简单的 markdown 到 HTML 转换器（与课程详情页共用）
// 先剥离元数据，输出经 DOMPurify 清洗后交给 dangerouslySetInnerHTML
export function markdownToHtml(md: string): string {
  return DOMPurify.sanitize(renderMarkdown(stripFrontmatter(md)))
}

function renderMarkdown(md: string): string {
  const lines = md.split('\n')
  const htmlLines: string[] = []
  let inCodeBlock = false
  let codeContent = ''
  let codeLang = ''
  let inBlockquote = false
  let blockquoteContent = ''
  let listType: 'ul' | 'ol' | null = null
  let listItems: string[] = []
  let tableRows: string[] | null = null

  const processInline = (text: string): string => {
    return text
      .replace(/\*\*\*(.+?)\*\*\*/g, '<strong><em>$1</em></strong>')
      .replace(/\*\*(.+?)\*\*/g, '<strong>$1</strong>')
      .replace(/\*(.+?)\*/g, '<em>$1</em>')
      .replace(/`([^`]+)`/g, '<code>$1</code>')
      .replace(/\[([^\]]+)\]\(([^)]+)\)/g, '<a href="$2">$1</a>')
  }

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

  // 表格行以 `|` 起止；第二行是分隔行时，首行作表头
  const tableCells = (row: string): string[] =>
    row.slice(1, -1).split('|').map(cell => processInline(cell.trim()))

  const flushTable = () => {
    if (!tableRows) return
    const rows = tableRows
    tableRows = null

    const isSeparator = (row: string) => /^\|[\s:|-]+\|$/.test(row)
    const hasHeader = rows.length > 1 && isSeparator(rows[1])
    const header = hasHeader ? rows[0] : null
    const body = hasHeader ? rows.slice(2) : rows

    htmlLines.push('<table>')
    if (header) {
      htmlLines.push('  <thead>')
      htmlLines.push(`    <tr>${tableCells(header).map(cell => `<th>${cell}</th>`).join('')}</tr>`)
      htmlLines.push('  </thead>')
    }
    htmlLines.push('  <tbody>')
    body.forEach(row => {
      htmlLines.push(`    <tr>${tableCells(row).map(cell => `<td>${cell}</td>`).join('')}</tr>`)
    })
    htmlLines.push('  </tbody>')
    htmlLines.push('</table>')
  }

  // 块级结构（列表、表格、引用）在遇到新的块之前收尾
  const flushBlocks = () => {
    flushList()
    flushTable()
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
        flushBlocks()
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
      flushBlocks()
      if (inBlockquote) {
        htmlLines.push(`<blockquote>${blockquoteContent.trim()}</blockquote>`)
        inBlockquote = false
        blockquoteContent = ''
      }
      continue
    }

    // 标题
    if (line.startsWith('### ')) {
      flushBlocks()
      htmlLines.push(`<h3>${processInline(line.slice(4))}</h3>`)
      continue
    }
    if (line.startsWith('## ')) {
      flushBlocks()
      htmlLines.push(`<h2>${processInline(line.slice(3))}</h2>`)
      continue
    }
    if (line.startsWith('# ')) {
      flushBlocks()
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
        flushTable()
        listType = 'ul'
      }
      listItems.push(line.slice(2))
      continue
    }

    // 有序列表
    if (line.match(/^\d+\. /)) {
      if (listType !== 'ol') {
        flushList()
        flushTable()
        listType = 'ol'
      }
      listItems.push(line.replace(/^\d+\. /, ''))
      continue
    }

    // 水平线
    if (line.match(/^---+$/)) {
      flushBlocks()
      htmlLines.push('<hr />')
      continue
    }

    // 表格行（表头与分隔行在 flushTable 内识别）
    if (line.startsWith('|') && line.endsWith('|')) {
      flushList()
      if (!tableRows) tableRows = []
      tableRows.push(line)
      continue
    }

    // 普通段落
    flushBlocks()
    htmlLines.push(`<p>${processInline(line)}</p>`)
  }

  flushBlocks()
  if (inBlockquote) {
    htmlLines.push(`<blockquote>${blockquoteContent.trim()}</blockquote>`)
  }

  return htmlLines.join('\n')
}
