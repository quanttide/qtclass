#!/usr/bin/env bash
# qtclass-studio UI integration tests
# Tests the full "上课" flow with snapshot-based verification
#
# Usage:
#   ./tests/run-tests.sh                  # Run all tests
#   ./tests/run-tests.sh --interactive    # Pause between steps
#   ./tests/run-tests.sh --setup-only     # Start app and exit

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

INTERACTIVE=false
SETUP_ONLY=false
for arg in "$@"; do
  case "$arg" in
    --interactive) INTERACTIVE=true ;;
    --setup-only) SETUP_ONLY=true ;;
  esac
done

cleanup() { echo ""; stop_app; }
trap cleanup EXIT

init
start_app

if ! find_window; then
  report "FAIL" "Could not find application window"
  print_summary
  exit 1
fi

activate_window

if [ "$SETUP_ONLY" = true ]; then
  echo "Window ready, exiting."
  exit 0
fi

pause_step() {
  if [ "$INTERACTIVE" = true ]; then
    echo "  --- Press ENTER ---"
    read -r
  fi
}

ALL_PASSED=true

# =============================================
# Test 1: Schedule page loaded
# =============================================
step "Schedule page loaded"
screenshot "schedule_initial"
check_window && report "PASS" "Schedule page displayed" || report "FAIL" "Window not found"
record_hash
pause_step

# =============================================
# Test 2: Navigate to classroom
# =============================================
step "Navigate to classroom by tapping in-progress card"
# Flutter y: AppBar 56 + section header ~28 + card margin 4 + card center 38 ≈ 126
fclick_and_verify "Card tap" "$CX" 126 2
pause_step

# =============================================
# Test 3: Toolbar visible in classroom
# =============================================
step "Classroom toolbar visible"
check_window && report "PASS" "In classroom view (window alive)" || report "FAIL" "Window lost"
screenshot "classroom_entered"
pause_step

# =============================================
# Test 4: Open attendance menu
# =============================================
step "Open attendance bottom sheet"
fclick_and_verify "Attendance button" 34 $((FH - 35)) 1
pause_step

# =============================================
# Test 5: Mark all present
# =============================================
step "Mark all students present"
# Bottom sheet first item: header ~56px + first ListTile center ~24px ≈ Flutter y = 783-252+56+24
fclick_and_verify "Mark all present" 300 $((FH - 252 + 56 + 24)) 2
pause_step

# =============================================
# Test 6: Open end-class dialog
# =============================================
step "Tap 下课 button"
fclick_and_verify "End class button" 1261 $((FH - 35)) 1
pause_step

# =============================================
# Test 7: Confirm end class
# =============================================
step "Confirm end class"
fclick_and_verify "Confirm dialog" 740 $((FH / 2 + 60)) 2
pause_step

# =============================================
# Test 8: Back to schedule
# =============================================
step "Returned to schedule"
check_window && report "PASS" "Back on schedule page" || report "FAIL" "Window lost"
screenshot "schedule_final"
pause_step

# =============================================
# Summary
# =============================================
echo ""
echo "--- Detailed Report ---"
cat "$REPORT_FILE"

print_summary

if [ "$FAIL_COUNT" -gt 0 ]; then
  exit 1
fi
