# Shared library for qtclass-studio UI tests
# Source this file: source "$(dirname "$0")/lib/common.sh"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
STUDIO_BIN="$PROJECT_DIR/src/studio/build/linux/x64/release/bundle/qtclass_studio"
SCREENSHOT_DIR="$SCRIPT_DIR/screenshots"
REPORT_FILE="$SCRIPT_DIR/report.txt"

PASS_COUNT=0
FAIL_COUNT=0
STEP_NUM=0
PREV_HASH=""

TITLE_H=36

init() {
  mkdir -p "$SCREENSHOT_DIR"
  rm -f "$REPORT_FILE"
  : > "$REPORT_FILE"
  PASS_COUNT=0
  FAIL_COUNT=0
  STEP_NUM=0
}

cleanup() {
  echo ""
  pkill -f "qtclass_studio" 2>/dev/null || true
  pkill -f "ffmpeg.*x11grab" 2>/dev/null || true
  xdotool mousemove 0 0 2>/dev/null || true
}

report() {
  local status="$1" msg="$2"
  echo "[$status] $msg" | tee -a "$REPORT_FILE"
  case "$status" in
    PASS) PASS_COUNT=$((PASS_COUNT + 1)) ;;
    FAIL) FAIL_COUNT=$((FAIL_COUNT + 1)) ;;
  esac
}

step() {
  STEP_NUM=$((STEP_NUM + 1))
  echo ""
  echo "=== Step $STEP_NUM: $* ==="
}

# Capture window snapshot hash for change detection
snapshot_hash() {
  if [ -z "${WID:-}" ]; then
    echo "hash_unavailable"
    return
  fi
  xwd -id "$WID" 2>/dev/null | sha1sum | cut -d' ' -f1
  return "${PIPESTATUS[0]}"
}

# Capture screenshot to file (xwd format), convert if possible
screenshot() {
  local name="$1"
  local xwd_path="$SCREENSHOT_DIR/${STEP_NUM}_${name}.xwd"
  if [ -n "${WID:-}" ]; then
    xwd -id "$WID" -out "$xwd_path" 2>/dev/null
    if [ -f "$xwd_path" ] && [ -s "$xwd_path" ]; then
      echo "  screenshot: $xwd_path"
    else
      echo "  (screenshot failed)"
    fi
  fi
}

# Verify screen changed from before action
verify_changed() {
  local label="$1"
  local after
  after=$(snapshot_hash)
  if [ "$after" = "hash_unavailable" ]; then
    report "FAIL" "$label - window lost (crash?)"
    return 1
  fi
  if [ "$after" != "$PREV_HASH" ]; then
    report "PASS" "$label - screen content changed"
    PREV_HASH=$after
    return 0
  else
    report "FAIL" "$label - screen unchanged, click likely missed"
    return 1
  fi
}

# Record hash to compare against next step
record_hash() {
  PREV_HASH=$(snapshot_hash)
}

# Check window is alive
check_window() {
  if xdotool getwindowgeometry "$WID" &>/dev/null; then
    return 0
  else
    echo "  WARNING: Window no longer accessible"
    return 1
  fi
}

find_window() {
  local retries="${1:-6}" wait_sec="${2:-2}"
  echo "Finding window '量潮课堂'..."
  for i in $(seq 1 "$retries"); do
    WID=$(xdotool search --name "量潮课堂" 2>/dev/null | tail -1)
    if [ -n "$WID" ]; then
      eval "$(xdotool getwindowgeometry --shell "$WID")"
      echo "  Found window ${WID}: ${WIDTH}x${HEIGHT} at ${X},${Y}"
      WIN_W=$WIDTH
      WIN_H=$HEIGHT
      CX=$((WIN_W / 2))
      FH=$((WIN_H - TITLE_H))
      TB_Y=$((TITLE_H + FH - 35))
      record_hash
      return 0
    fi
    echo "  Attempt $i/$retries: window not found, waiting ${wait_sec}s..."
    sleep "$wait_sec"
  done
  echo "  ERROR: Window not found after $retries attempts" >&2
  return 1
}

activate_window() {
  xdotool windowactivate --sync "$WID" 2>/dev/null || true
  xdotool windowraise "$WID" 2>/dev/null || true
  sleep 0.3
}

click() {
  local x="$1" y="$2" wait="${3:-1}"
  activate_window
  xdotool mousemove --window "$WID" "$x" "$y"
  sleep 0.1
  xdotool click 1
  sleep "$wait"
}

fclick() {
  local fx="$1" fy="$2" wait="${3:-1}"
  click "$fx" $((fy + TITLE_H)) "$wait"
}

click_and_verify() {
  local label="$1" x="$2" y="$3" wait="${4:-1}"
  echo "  Action: $label at ($x, $y)"
  screenshot "before_${STEP_NUM}"
  click "$x" "$y" "$wait"
  screenshot "after_${STEP_NUM}"
  verify_changed "$label" || true
}

fclick_and_verify() {
  local label="$1" fx="$2" fy="$3" wait="${4:-1}"
  click_and_verify "$label" "$fx" $((fy + TITLE_H)) "$wait"
}

start_app() {
  cleanup
  sleep 1
  echo "Starting studio..."
  "$STUDIO_BIN" &
  sleep 4
}

stop_app() {
  pkill -f "qtclass_studio" 2>/dev/null || true
  sleep 1
}

print_summary() {
  local total=$((PASS_COUNT + FAIL_COUNT))
  echo ""
  echo "==========================================="
  echo "  Test Results: ${PASS_COUNT}/${total} passed"
  echo "  Report: $REPORT_FILE"
  echo "  Screenshots: $SCREENSHOT_DIR/"
  echo "==========================================="
}
