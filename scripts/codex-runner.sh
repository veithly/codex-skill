#!/usr/bin/env bash
#
# Codex CLI wrapper for Claude Code integration (Linux/macOS)
#
# Usage:
#   ./codex-runner.sh "your task" [mode] [timeout] [add-dir]
#
# Arguments:
#   task      The coding task to send to Codex (required)
#   mode      Execution mode: yolo, auto (default), safe
#   timeout   Maximum execution time in seconds (default: 300)
#   add-dir   Additional directory to grant Codex access to
#
# Examples:
#   ./codex-runner.sh "Fix the bug in src/api.ts"
#   ./codex-runner.sh "Implement auth" yolo
#   ./codex-runner.sh "Refactor module" safe 600
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
GRAY='\033[0;90m'
NC='\033[0m'

# Parse arguments
TASK="${1:-}"
MODE="${2:-auto}"
TIMEOUT="${3:-300}"
ADD_DIR="${4:-}"

# Validate task
if [ -z "$TASK" ]; then
    echo -e "${RED}Error: Task description is required${NC}"
    echo ""
    echo "Usage: $0 \"your task\" [mode] [timeout] [add-dir]"
    echo ""
    echo "Modes:"
    echo "  yolo   - No approvals, no sandbox (DANGEROUS)"
    echo "  auto   - Full auto mode (default)"
    echo "  safe   - Workspace write with default approval"
    exit 1
fi

# Validate mode
case "$MODE" in
    yolo|auto|safe)
        ;;
    *)
        echo -e "${RED}Error: Invalid mode '$MODE'${NC}"
        echo "Valid modes: yolo, auto, safe"
        exit 1
        ;;
esac

# Functions
status() { echo -e "${CYAN}[*]${NC} $1"; }
success() { echo -e "${GREEN}[+]${NC} $1"; }
warning() { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[-]${NC} $1"; }

# Banner
echo ""
echo -e "${CYAN}=== Codex CLI Runner ===${NC}"
echo -e "Mode: ${YELLOW}$MODE${NC}"
echo -e "Timeout: ${YELLOW}${TIMEOUT}s${NC}"
echo -e "Task: $TASK"
echo ""

# Pre-flight checks
status "[1/4] Checking Codex installation..."
if command -v codex &> /dev/null; then
    CODEX_VERSION=$(codex --version 2>&1)
    success "Codex CLI: $CODEX_VERSION"
else
    error "Codex CLI is not installed."
    echo "Install with: npm install -g @openai/codex"
    exit 1
fi

status "[2/4] Checking API key..."
if [ -z "$OPENAI_API_KEY" ]; then
    error "OPENAI_API_KEY environment variable not set."
    echo "Set with: export OPENAI_API_KEY=\"your-key\""
    exit 1
fi
success "API key configured"

status "[3/4] Checking git status..."
if git rev-parse --is-inside-work-tree &> /dev/null; then
    GIT_STATUS=$(git status --porcelain)
    if [ -n "$GIT_STATUS" ]; then
        warning "Uncommitted changes detected"
    else
        success "Git workspace clean"
    fi
else
    warning "Not a git repository"
fi

# Build command arguments
CODEX_ARGS=("exec")

case "$MODE" in
    yolo)
        CODEX_ARGS+=("--dangerously-bypass-approvals-and-sandbox")
        ;;
    auto)
        CODEX_ARGS+=("--full-auto")
        ;;
    safe)
        CODEX_ARGS+=("-s" "workspace-write")
        ;;
esac

if [ -n "$ADD_DIR" ]; then
    CODEX_ARGS+=("--add-dir" "$ADD_DIR")
fi

CODEX_ARGS+=("$TASK")

# Execute
status "[4/4] Executing Codex..."
if [ "$MODE" = "yolo" ]; then
    warning "YOLO mode active - no approvals, no sandbox"
fi
echo ""

START_TIME=$(date +%s)

# Run with timeout
if command -v timeout &> /dev/null; then
    timeout "$TIMEOUT" codex "${CODEX_ARGS[@]}" 2>&1 || EXIT_CODE=$?
else
    # macOS doesn't have timeout by default
    codex "${CODEX_ARGS[@]}" 2>&1 || EXIT_CODE=$?
fi

EXIT_CODE=${EXIT_CODE:-0}

END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

# Show changes
echo ""
echo -e "${CYAN}=== Changes Made ===${NC}"
if git rev-parse --is-inside-work-tree &> /dev/null; then
    git diff --stat 2>/dev/null || echo "No changes detected"
else
    echo "Not a git repository - cannot show diff"
fi

# Summary
echo ""
echo -e "${CYAN}=== Execution Summary ===${NC}"
echo "Duration: ${DURATION}s"
if [ "$EXIT_CODE" -eq 0 ]; then
    echo -e "Exit Code: ${GREEN}$EXIT_CODE${NC}"
else
    echo -e "Exit Code: ${RED}$EXIT_CODE${NC}"
fi

# Rollback instructions
echo ""
echo -e "${GRAY}=== Rollback (if needed) ===${NC}"
echo -e "${GRAY}git checkout -- .        # Discard all changes${NC}"
echo -e "${GRAY}git reset --hard HEAD    # Reset to last commit${NC}"

exit $EXIT_CODE
