#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
STUDIO_BIN="$SCRIPT_DIR/../src/studio/build/linux/x64/release/bundle/qtclass_studio"

cleanup() {
  pkill -f "qtclass_studio" 2>/dev/null || true
  xdotool mousemove 0 0 2>/dev/null || true
}
trap cleanup EXIT

cleanup && sleep 1

echo "Starting studio..."
"$STUDIO_BIN" &
sleep 4

WID=$(xdotool search --name "量潮课堂" 2>/dev/null | tail -1)
eval "$(xdotool getwindowgeometry --shell "$WID")"
echo "Window: ${WIDTH}x${HEIGHT}"
xdotool windowactivate --sync "$WID" && xdotool windowraise "$WID"
sleep 1

TITLE_H=36
FH=$((HEIGHT - TITLE_H))  # Flutter content height
CW=$WIDTH

click() {
  echo "  click ($1, $2)"
  xdotool mousemove --window "$WID" "$1" "$2" click 1
  sleep "$3"
}

echo ""
echo "=== Testing click coordinates ==="
echo "Content area: ${CW}x${FH} (title bar ${TITLE_H}px)"
echo ""

# 1. 点击"正在上课"卡片 → 进入课堂
# Flutter 坐标: AppBar 56 + section header ~24 + card margin 4 + card center ~38 = 122
# 窗口坐标(带标题栏): 122 + 36 = 158
echo "1. 课表 → 点击'正在上课'卡片 (CW/2, 158)"
click $((CW / 2)) $((TITLE_H + 122)) 2
echo "   (若成功: 页面切换到课堂内)"

# 2. 工具栏"出勤"按钮
# 内容区 783px, AppBar 56px, 剩余 727px
# ProgressBar 32px + Expanded + Toolbar 70px
# Toolbar 在 Flutter y = 783 - 70 = 713, 中心 = 748
# 窗口坐标: 748 + 36 = 784
# X: Container padding 16 + InkWell padding 8 + icon center 10 = 34
TB_Y=$((TITLE_H + FH - 35))  # Toolbar center
echo "2. 课堂 → 点击'出勤'按钮 (34, ${TB_Y})"
click 34 "$TB_Y" 1
echo "   (若成功: 底部弹出菜单)"

# 3. 底部菜单"全部正常"
# 菜单约 252px 高, 从 y=819-252=567 开始
# 第一项 ListTile 中心: 567 + 56(header) + 24 = 647
BS_Y=$((HEIGHT - 252 + 56 + 24))
echo "3. 菜单 → 点击'全部正常' (300, ${BS_Y})"
click 300 "$BS_Y" 2
echo "   (若成功: 学员出勤变绿)"

# 4. 工具"下课"按钮
# ElevatedButton.icon 在 Row 右侧, 中心约 x=1261
echo "4. 课堂 → 点击'下课' (1261, ${TB_Y})"
click 1261 "$TB_Y" 1
echo "   (若成功: 弹出确认对话框)"

# 5. 对话框"下课"确认
# AlertDialog 居中, 约 200px 高
# 按钮在 actions 区右下方
echo "5. 对话框 → 点击'下课' (740, 480)"
click 740 $((HEIGHT / 2 + 60)) 2
echo "   (若成功: 返回课表)"

echo ""
echo "=== Test complete ==="
