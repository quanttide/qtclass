// 浏览器调试工具：通过 CDP（Chrome DevTools Protocol）检查 Flutter Web 页面状态。
//
// 用于排查视频/渲染问题：加载页面后轮询 video 元素状态并捕获控制台/网络错误。
// 前置：启动 headless Chrome 并开启调试端口：
//     google-chrome --headless=new --enable-unsafe-swiftshader --remote-debugging-port=9222 about:blank
// 用法:
//     node scripts/inspect-web.mjs [URL] [等待秒数]
//     # 默认 http://localhost:8080/#/player，等待 60s
const target = process.argv[2] || 'http://localhost:8080/#/player';

async function main() {
  // 获取调试目标
  const res = await fetch('http://localhost:9222/json');
  const targets = await res.json();
  const page = targets.find((t) => t.type === 'page');
  if (!page) throw new Error('no page target');
  const ws = new WebSocket(page.webSocketDebuggerUrl);

  let id = 0;
  const pending = new Map();
  const send = (method, params = {}) =>
    new Promise((resolve) => {
      const msgId = ++id;
      pending.set(msgId, resolve);
      ws.send(JSON.stringify({ id: msgId, method, params }));
    });
  const consoleLogs = [];

  ws.onmessage = (ev) => {
    const msg = JSON.parse(ev.data);
    if (msg.id && pending.has(msg.id)) {
      pending.get(msg.id)(msg.result);
      pending.delete(msg.id);
    } else if (msg.method === 'Runtime.consoleAPICalled') {
      const text = (msg.params.args || [])
        .map((a) => a.value ?? a.description ?? '')
        .join(' ');
      consoleLogs.push(text);
      console.log('[console]', text);
    } else if (msg.method === 'Runtime.exceptionThrown') {
      const d = msg.params.exceptionDetails;
      console.log('[exception]', d.text, d.exception?.description ?? '');
      consoleLogs.push('EXCEPTION: ' + (d.exception?.description ?? d.text));
    }
  };

  await new Promise((r) => (ws.onopen = r));
  await send('Page.enable');
  await send('Runtime.enable');
  await send('Page.navigate', { url: target });
  console.log('navigated to', target);

  // 等待 Flutter 启动 + 视频初始化
  for (let i = 0; i < 40; i++) {
    await new Promise((r) => setTimeout(r, 1000));
    const r = await send('Runtime.evaluate', {
      expression: `(() => {
        const v = document.querySelector('video');
        if (!v) return { hasVideo: false };
        return {
          hasVideo: true,
          src: v.currentSrc || v.src,
          readyState: v.readyState,
          duration: v.duration,
          currentTime: v.currentTime,
          networkState: v.networkState,
          error: v.error ? v.error.code + ':' + v.error.message : null,
          paused: v.paused,
        };
      })()`,
      returnByValue: true,
    });
    const state = r.result?.value;
    if (state?.hasVideo) {
      console.log('[video]', JSON.stringify(state));
      if (state.duration > 0 || state.error) break;
    }
  }

  // 最终状态 + 截图
  const finalState = await send('Runtime.evaluate', {
    expression: `(() => {
      const v = document.querySelector('video');
      const spinner = document.querySelector('flutter-view, canvas');
      return {
        hasVideo: !!v,
        videoState: v ? { readyState: v.readyState, duration: v.duration, error: v.error ? v.error.code : null } : null,
        bodyText: document.body ? document.body.innerText.slice(0, 200) : '',
      };
    })()`,
    returnByValue: true,
  });
  console.log('[final]', JSON.stringify(finalState.result?.value));
  console.log('=== console 日志（前 20 条）===');
  consoleLogs.slice(0, 20).forEach((l) => console.log(l));
  ws.close();
  process.exit(0);
}

main().catch((e) => {
  console.error('ERR', e);
  process.exit(1);
});
