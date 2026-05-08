#!/usr/bin/env bash
# Position finder: test multiple Y coordinates to locate card centers
# Usage: ./tests/find-position.sh
# Replaces scripts/find-click-y.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

cleanup() { stop_app; }
trap cleanup EXIT

init
start_app

if ! find_window; then
  echo "ERROR: Cannot find window" >&2
  exit 1
fi

activate_window

echo ""
echo "=== Position Finder ==="
echo "Testing Y coordinates from Flutter y=80 to y=300"
echo ""

for fy in $(seq 80 20 300); do
  echo "--- Click at Flutter y=${fy} (window y=$((fy + TITLE_H))) ---"
  fclick "$CX" "$fy" 1

  # Try clicking toolbar 出勤 to check if we're in classroom
  click 34 "$TB_Y" 0.3
  xdotool key Escape 2>/dev/null || true
  sleep 0.2

  # Try 下课 to go back
  click 1261 "$TB_Y" 0.3
  xdotool key Escape 2>/dev/null || true
  sleep 0.5

  echo "  Reset complete"
  echo ""
done

echo "=== Position finder done ==="
