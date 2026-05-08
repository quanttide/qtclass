#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$SCRIPT_DIR/.."
STUDIO_BIN="$PROJECT_DIR/src/studio/build/linux/x64/release/bundle/qtclass_studio"
VIDEO_OUT="$PROJECT_DIR/assets/videos/studio.mp4"

cleanup() {
  echo ""
  echo "Stopping..."
  pkill -f "qtclass_studio" 2>/dev/null || true
  pkill -f "ffmpeg.*x11grab" 2>/dev/null || true
  xdotool mousemove 0 0 2>/dev/null || true
}
trap cleanup EXIT

cleanup
sleep 1

echo "Starting studio..."
"$STUDIO_BIN" &
sleep 4

WID=$(xdotool search --name "量潮课堂" 2>/dev/null | tail -1)
if [ -z "$WID" ]; then
  echo "ERROR: Cannot find window" >&2
  exit 1
fi
echo "Window ID: $WID"

eval "$(xdotool getwindowgeometry --shell "$WID")"
echo "W=${WIDTH} H=${HEIGHT} at ${X},${Y}"
WIN_W=$WIDTH
WIN_H=$HEIGHT

xdotool windowactivate --sync "$WID"
xdotool windowraise "$WID"
sleep 1

echo "Recording to $VIDEO_OUT..."
ffmpeg -y -f x11grab -video_size "${WIN_W}x${WIN_H}" -i ":0.0+${X},${Y}" \
  -framerate 30 -vf "pad=ceil(iw/2)*2:ceil(ih/2)*2" \
  -c:v libx264 -preset ultrafast -crf 18 -pix_fmt yuv420p "$VIDEO_OUT" &
FFMPEG_PID=$!
sleep 2

xdotool windowactivate --sync "$WID"
xdotool windowraise "$WID"
sleep 1

# Layout constants
TITLE_H=36
FH=$((WIN_H - TITLE_H))        # Flutter content height
CX=$((WIN_W / 2))              # Window center X
TB_Y=$((TITLE_H + FH - 35))    # Toolbar center Y

click_win() {
  xdotool windowactivate --sync "$WID" 2>/dev/null || true
  xdotool mousemove --window "$WID" "$1" "$2" click 1
  sleep "$3"
}

echo "Demo: 上课流程 (${WIN_W}x${WIN_H})"

# 1. 展示课表
sleep 3

# 2. 点击"正在上课"卡片进入课堂
# Flutter y = 122 (AppBar 56 + section 24 + card margin 4 + card center 38)
click_win "$CX" $((TITLE_H + 122)) 2

# 3. 工具栏"出勤"
click_win 34 "$TB_Y" 1

# 4. 底部菜单"全部正常"
# 菜单 ~252px, 第一项中心在 y = 567 + 56 + 24 = 647
click_win 300 $((WIN_H - 252 + 56 + 24)) 2

# 5. 展示标记结果
sleep 2

# 6. 下课
click_win 1261 "$TB_Y" 1

# 7. 确认对话框
sleep 1
click_win 740 $((WIN_H / 2 + 60)) 2

# 8. 回到课表
sleep 2

# 鼠标移开
xdotool windowactivate --sync "$WID"
xdotool mousemove --window "$WID" $((WIN_W - 50)) $((WIN_H - 50))
sleep 1

echo "Stopping recording..."
kill "$FFMPEG_PID" 2>/dev/null || true
sleep 2

echo "Done! Video saved to $VIDEO_OUT"
