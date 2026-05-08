#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
STUDIO_BIN="$SCRIPT_DIR/../src/studio/build/linux/x64/release/bundle/qtclass_studio"

cleanup() { pkill -f "qtclass_studio" 2>/dev/null || true; }
trap cleanup EXIT
cleanup && sleep 1

"$STUDIO_BIN" &
sleep 4

WID=$(xdotool search --name "量潮课堂" 2>/dev/null | tail -1)
eval "$(xdotool getwindowgeometry --shell "$WID")")
echo "Window: ${WIDTH}x${HEIGHT}"

xdotool windowactivate --sync "$WID"
xdotool windowraise "$WID"
sleep 1

CW=$WIDTH

# 试探多个 Y 坐标来找"正在上课"卡片
# 从 y=80 到 y=300，每隔 20px 点击一次
for y in 80 100 120 140 160 180 200 220 240 260 280 300; do
  echo ""
  echo "--- Testing click at ($((CW/2)), $y) ---"
  xdotool mousemove --window "$WID" $((CW/2)) "$y"
  sleep 0.3
  xdotool click 1
  sleep 1.5
  
  # 检查是否进入课堂（窗口应该还在，但页面内容变了）
  # 点击"出勤"按钮来验证是否进入了课堂页
  xdotool mousemove --window "$WID" 40 $((HEIGHT - 30))
  sleep 0.2
  xdotool click 1
  sleep 0.5
  
  # 按 Escape 关闭可能的底部菜单
  xdotool key Escape
  sleep 0.3
  
  # 如果进入课堂，点击"下课"返回课表
  xdotool mousemove --window "$WID" 1261 $((HEIGHT - 30))
  sleep 0.2
  xdotool click 1
  sleep 0.5
  
  # Escape again
  xdotool key Escape
  sleep 0.5
  
  echo "  Reset for next test"
done
