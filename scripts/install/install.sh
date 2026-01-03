#!/usr/bin/env bash
#
# One-click installer for Codex Skill for Claude Code (Linux/macOS)
#
# Usage:
#   ./install.sh [options]
#
# Options:
#   --skip-prereqs    Skip prerequisite checks
#   --force           Force overwrite existing files
#   --help            Show this help message
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Functions
status() { echo -e "${CYAN}[*]${NC} $1"; }
success() { echo -e "${GREEN}[+]${NC} $1"; }
warning() { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[-]${NC} $1"; }

# Banner
echo -e "${MAGENTA}"
cat << 'EOF'

  ██████╗ ██████╗ ██████╗ ███████╗██╗  ██╗    ███████╗██╗  ██╗██╗██╗     ██╗
 ██╔════╝██╔═══██╗██╔══██╗██╔════╝╚██╗██╔╝    ██╔════╝██║ ██╔╝██║██║     ██║
 ██║     ██║   ██║██║  ██║█████╗   ╚███╔╝     ███████╗█████╔╝ ██║██║     ██║
 ██║     ██║   ██║██║  ██║██╔══╝   ██╔██╗     ╚════██║██╔═██╗ ██║██║     ██║
 ╚██████╗╚██████╔╝██████╔╝███████╗██╔╝ ██╗    ███████║██║  ██╗██║███████╗███████╗
  ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝    ╚══════╝╚═╝  ╚═╝╚═╝╚══════╝╚══════╝

  Codex Skill Installer for Claude Code (Linux/macOS)

EOF
echo -e "${NC}"

# Parse arguments
SKIP_PREREQS=false
FORCE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --skip-prereqs)
            SKIP_PREREQS=true
            shift
            ;;
        --force)
            FORCE=true
            shift
            ;;
        --help)
            echo "Usage: $0 [--skip-prereqs] [--force] [--help]"
            exit 0
            ;;
        *)
            error "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

# Define paths
CLAUDE_DIR="$HOME/.claude"
COMMANDS_DIR="$CLAUDE_DIR/commands/codex"
AGENTS_DIR="$CLAUDE_DIR/agents"
SCRIPTS_DIR="$CLAUDE_DIR/scripts"

status "Starting installation..."
echo ""

# Step 1: Check prerequisites
if [ "$SKIP_PREREQS" = false ]; then
    status "Checking prerequisites..."

    # Check Node.js
    if command -v node &> /dev/null; then
        NODE_VERSION=$(node --version)
        success "Node.js: $NODE_VERSION"
    else
        error "Node.js not found. Please install Node.js 18+ from https://nodejs.org/"
        exit 1
    fi

    # Check npm
    if command -v npm &> /dev/null; then
        NPM_VERSION=$(npm --version)
        success "npm: v$NPM_VERSION"
    else
        error "npm not found. Please reinstall Node.js."
        exit 1
    fi

    # Check Git
    if command -v git &> /dev/null; then
        GIT_VERSION=$(git --version)
        success "Git: $GIT_VERSION"
    else
        warning "Git not found. Git is recommended for rollback support."
    fi

    # Check/Install Codex CLI
    status "Checking Codex CLI..."
    if command -v codex &> /dev/null; then
        CODEX_VERSION=$(codex --version 2>&1)
        success "Codex CLI: $CODEX_VERSION"
    else
        warning "Codex CLI not found. Installing..."
        npm install -g @openai/codex
        if [ $? -eq 0 ]; then
            success "Codex CLI installed successfully"
        else
            error "Failed to install Codex CLI"
            exit 1
        fi
    fi

    echo ""
fi

# Step 2: Create directories
status "Creating directories..."

for dir in "$COMMANDS_DIR" "$AGENTS_DIR" "$SCRIPTS_DIR"; do
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        success "Created: $dir"
    else
        success "Exists: $dir"
    fi
done

echo ""

# Step 3: Copy skill files
status "Installing skill files..."

# Copy SKILL.md
SKILL_SRC="$PROJECT_DIR/SKILL.md"
SKILL_DST="$COMMANDS_DIR/SKILL.md"
if [ -f "$SKILL_SRC" ]; then
    cp "$SKILL_SRC" "$SKILL_DST"
    success "Installed: SKILL.md"
else
    error "SKILL.md not found in $PROJECT_DIR"
    exit 1
fi

# Copy reference.md
REF_SRC="$PROJECT_DIR/reference.md"
REF_DST="$COMMANDS_DIR/reference.md"
if [ -f "$REF_SRC" ]; then
    cp "$REF_SRC" "$REF_DST"
    success "Installed: reference.md"
fi

# Copy agent.md
AGENT_SRC="$PROJECT_DIR/agent.md"
AGENT_DST="$AGENTS_DIR/codex.md"
if [ -f "$AGENT_SRC" ]; then
    cp "$AGENT_SRC" "$AGENT_DST"
    success "Installed: agent.md -> codex.md"
fi

echo ""

# Step 4: Copy helper scripts
status "Installing helper scripts..."

SCRIPTS_SRC="$PROJECT_DIR/scripts"

# Copy Bash runner
BASH_SRC="$SCRIPTS_SRC/codex-runner.sh"
BASH_DST="$SCRIPTS_DIR/codex-runner.sh"
if [ -f "$BASH_SRC" ]; then
    cp "$BASH_SRC" "$BASH_DST"
    chmod +x "$BASH_DST"
    success "Installed: codex-runner.sh"
fi

# Copy YOLO launcher
YOLO_SRC="$SCRIPTS_SRC/codex-yolo.sh"
YOLO_DST="$SCRIPTS_DIR/codex-yolo.sh"
if [ -f "$YOLO_SRC" ]; then
    cp "$YOLO_SRC" "$YOLO_DST"
    chmod +x "$YOLO_DST"
    success "Installed: codex-yolo.sh"
fi

echo ""

# Step 5: Check API key
status "Checking API key configuration..."

if [ -z "$OPENAI_API_KEY" ]; then
    warning "OPENAI_API_KEY environment variable is not set."
    echo ""
    read -p "Would you like to configure it now? (y/N) " -n 1 -r
    echo ""

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        read -p "Enter your OpenAI API key: " API_KEY
        if [ -n "$API_KEY" ]; then
            export OPENAI_API_KEY="$API_KEY"

            # Detect shell and offer to persist
            SHELL_RC=""
            if [ -n "$ZSH_VERSION" ]; then
                SHELL_RC="$HOME/.zshrc"
            elif [ -n "$BASH_VERSION" ]; then
                SHELL_RC="$HOME/.bashrc"
            fi

            if [ -n "$SHELL_RC" ]; then
                read -p "Add to $SHELL_RC for persistence? (y/N) " -n 1 -r
                echo ""
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    echo "export OPENAI_API_KEY=\"$API_KEY\"" >> "$SHELL_RC"
                    success "API key added to $SHELL_RC"
                fi
            fi

            success "API key configured for current session"
        fi
    fi
else
    success "API key is configured"
fi

echo ""

# Step 6: Verify installation
status "Verifying installation..."

VERIFIED=true

if [ -f "$SKILL_DST" ]; then
    success "Skill file: OK"
else
    error "Skill file: MISSING"
    VERIFIED=false
fi

if [ -f "$AGENT_DST" ]; then
    success "Agent file: OK"
else
    error "Agent file: MISSING"
    VERIFIED=false
fi

if command -v codex &> /dev/null; then
    success "Codex CLI: OK"
else
    error "Codex CLI: NOT WORKING"
    VERIFIED=false
fi

echo ""

# Summary
if [ "$VERIFIED" = true ]; then
    echo -e "${GREEN}"
    cat << EOF
╔════════════════════════════════════════════════════════════╗
║                  Installation Complete!                     ║
╠════════════════════════════════════════════════════════════╣
║                                                             ║
║  Usage in Claude Code:                                      ║
║                                                             ║
║    /codex Fix the bug in src/api.ts                        ║
║    /codex --mode=yolo Implement feature X                  ║
║    /codex --mode=safe Refactor module Y                    ║
║                                                             ║
║  Helper scripts installed to:                               ║
║    $SCRIPTS_DIR
║                                                             ║
║  Documentation:                                             ║
║    $PROJECT_DIR/README.md
║                                                             ║
╚════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
else
    error "Installation completed with errors. Please check the messages above."
    exit 1
fi
