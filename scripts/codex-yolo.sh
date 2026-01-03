#!/usr/bin/env bash
#
# Quick YOLO mode Codex runner (Linux/macOS)
#
# Usage:
#   ./codex-yolo.sh "your task description"
#
# WARNING: YOLO mode bypasses all approvals and sandboxing!
# Only use in hardened environments (Docker, VM, CI/CD).
#

if [ -z "$1" ]; then
    echo "Usage: codex-yolo \"your task description\""
    echo ""
    echo "WARNING: YOLO mode bypasses all approvals and sandboxing!"
    echo "Only use in hardened environments."
    exit 1
fi

echo ""
echo "=== CODEX YOLO MODE ==="
echo "WARNING: No approvals, no sandbox!"
echo "Task: $*"
echo ""

codex exec --dangerously-bypass-approvals-and-sandbox "$*"

echo ""
echo "=== Done ==="
echo "Check changes with: git diff --stat"
