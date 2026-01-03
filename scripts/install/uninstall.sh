#!/usr/bin/env bash
#
# Uninstaller for Codex Skill for Claude Code
#
# Usage:
#   ./uninstall.sh
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

status() { echo -e "${CYAN}[*]${NC} $1"; }
success() { echo -e "${GREEN}[+]${NC} $1"; }
warning() { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[-]${NC} $1"; }

echo ""
echo "Codex Skill Uninstaller"
echo "======================="
echo ""

read -p "Are you sure you want to uninstall the Codex skill? (y/N) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Uninstall cancelled."
    exit 0
fi

CLAUDE_DIR="$HOME/.claude"

# Remove skill files
status "Removing skill files..."

SKILL_DIR="$CLAUDE_DIR/commands/codex"
if [ -d "$SKILL_DIR" ]; then
    rm -rf "$SKILL_DIR"
    success "Removed: $SKILL_DIR"
else
    warning "Not found: $SKILL_DIR"
fi

# Remove agent
AGENT_FILE="$CLAUDE_DIR/agents/codex.md"
if [ -f "$AGENT_FILE" ]; then
    rm -f "$AGENT_FILE"
    success "Removed: $AGENT_FILE"
else
    warning "Not found: $AGENT_FILE"
fi

# Remove scripts
status "Removing helper scripts..."

for script in "codex-runner.sh" "codex-runner.ps1" "codex-yolo.sh" "codex-yolo.cmd"; do
    SCRIPT_FILE="$CLAUDE_DIR/scripts/$script"
    if [ -f "$SCRIPT_FILE" ]; then
        rm -f "$SCRIPT_FILE"
        success "Removed: $script"
    fi
done

echo ""
success "Codex skill uninstalled successfully."
echo ""
echo "Note: Codex CLI is still installed. To remove it, run:"
echo "  npm uninstall -g @openai/codex"
echo ""
