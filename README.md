# Codex Skill for Claude Code

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20macOS%20%7C%20Linux-blue.svg)]()
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Compatible-green.svg)]()

Delegate coding tasks to OpenAI's Codex CLI with configurable execution modes including YOLO mode for fully autonomous operation. This skill bridges Claude Code's analytical capabilities with Codex's autonomous code execution.

## Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Quick Installation](#quick-installation)
- [Manual Installation](#manual-installation)
- [Usage](#usage)
- [Execution Modes](#execution-modes)
- [Configuration](#configuration)
- [Integration with Claude Workflow](#integration-with-claude-workflow)
- [Troubleshooting](#troubleshooting)
- [Security Considerations](#security-considerations)
- [Contributing](#contributing)
- [License](#license)

## Features

- **Multiple Execution Modes**: YOLO (full autonomy), Auto (balanced), Safe (conservative)
- **Non-Interactive Execution**: Uses `codex exec` for automation-friendly operation
- **Git Integration**: Automatic change tracking and rollback support
- **Cross-Platform**: Works on Windows, macOS, and Linux
- **Error Handling**: Comprehensive error detection and recovery
- **Claude Integration**: Seamless workflow with other Claude Code skills

## Requirements

### System Requirements

| Component | Requirement |
|-----------|-------------|
| **Claude Code** | Latest version installed and configured |
| **Node.js** | v18.0.0 or higher |
| **npm/pnpm** | Latest version |
| **Git** | v2.0 or higher (for change tracking) |
| **Shell** | Bash (Linux/macOS) or PowerShell 7+ (Windows) |

### Required Software

1. **OpenAI Codex CLI**
   ```bash
   # Install globally
   npm install -g @openai/codex
   # or
   pnpm add -g @openai/codex
   ```

2. **OpenAI API Key**
   - Obtain from [OpenAI Platform](https://platform.openai.com/api-keys)
   - Required for Codex CLI authentication

### Recommended Skills (Optional)

This skill works best when combined with these Claude Code skills:

| Skill | Purpose | Integration |
|-------|---------|-------------|
| `/debug` | Problem analysis | Debug with Claude, fix with Codex |
| `/review` | Code review | Implement with Codex, review with Claude |
| `/code` | Planning | Plan with Claude, implement with Codex |
| `/test` | Testing | Generate tests after Codex implementation |
| `/commit` | Git commits | Commit Codex changes with proper messages |

## Quick Installation

### One-Click Installation

#### Windows (PowerShell)
```powershell
# Run in PowerShell
.\scripts\install\install.ps1
```

#### Linux/macOS (Bash)
```bash
chmod +x ./scripts/install/install.sh
./scripts/install/install.sh
```

### What the Installer Does

1. Checks for prerequisites (Node.js, npm, Git)
2. Installs OpenAI Codex CLI if not present
3. Copies skill files to `~/.claude/commands/codex/`
4. Copies agent definition to `~/.claude/agents/codex.md`
5. Copies helper scripts to `~/.claude/scripts/`
6. Verifies installation
7. Prompts for API key configuration (optional)

## Manual Installation

### Step 1: Clone or Download

```bash
git clone https://github.com/user/codex-skill.git
cd codex-skill
```

### Step 2: Install Codex CLI

```bash
npm install -g @openai/codex
```

### Step 3: Configure API Key

#### Windows (PowerShell)
```powershell
# Set for current session
$env:OPENAI_API_KEY = "your-api-key"

# Add to profile for persistence
Add-Content $PROFILE "`n`$env:OPENAI_API_KEY = 'your-api-key'"
```

#### Linux/macOS (Bash)
```bash
# Set for current session
export OPENAI_API_KEY="your-api-key"

# Add to profile for persistence
echo 'export OPENAI_API_KEY="your-api-key"' >> ~/.bashrc
source ~/.bashrc
```

### Step 4: Copy Skill Files

```bash
# Create directories if they don't exist
mkdir -p ~/.claude/commands/codex
mkdir -p ~/.claude/agents
mkdir -p ~/.claude/scripts

# Copy files
cp SKILL.md ~/.claude/commands/codex/
cp reference.md ~/.claude/commands/codex/
cp agent.md ~/.claude/agents/codex.md
cp scripts/codex-runner.sh ~/.claude/scripts/    # Linux/macOS
cp scripts/codex-runner.ps1 ~/.claude/scripts/   # Windows
```

### Step 5: Verify Installation

```bash
# Check Codex CLI
codex --version

# Test the skill in Claude Code
# /codex --help
```

## Usage

### Basic Commands

```bash
# Default auto mode - balanced safety and automation
/codex Fix the null pointer exception in src/api/handlers.ts

# YOLO mode - full autonomy (use in hardened environments only!)
/codex --mode=yolo Implement user authentication with JWT

# Safe mode - requires more oversight
/codex --mode=safe Refactor the database connection module

# With custom timeout
/codex --timeout=600 Implement complex multi-file feature

# With additional directory access
/codex --add-dir=../shared-libs Update shared utility functions
```

### Command Syntax

```
/codex <task_description> [options]
```

### Options

| Option | Description | Default |
|--------|-------------|---------|
| `--mode=<mode>` | Execution mode: `yolo`, `auto`, `safe` | `auto` |
| `--timeout=<seconds>` | Maximum execution time | `300` |
| `--add-dir=<path>` | Additional directory for Codex to access | - |

## Execution Modes

### YOLO Mode (`--mode=yolo`)

```bash
codex exec --dangerously-bypass-approvals-and-sandbox "<task>"
```

| Aspect | Details |
|--------|---------|
| **Risk Level** | HIGH |
| **Approvals** | None |
| **Sandbox** | Disabled |
| **Best For** | CI/CD pipelines, Docker containers, VMs |
| **Caution** | Only use in externally hardened environments |

### Auto Mode (`--mode=auto`) - Default

```bash
codex exec --full-auto "<task>"
```

| Aspect | Details |
|--------|---------|
| **Risk Level** | MEDIUM |
| **Approvals** | On-request |
| **Sandbox** | Workspace write |
| **Best For** | Development, refactoring, feature implementation |

### Safe Mode (`--mode=safe`)

```bash
codex exec -s workspace-write "<task>"
```

| Aspect | Details |
|--------|---------|
| **Risk Level** | LOW |
| **Approvals** | Default policy |
| **Sandbox** | Workspace write |
| **Best For** | Production code, learning, sensitive operations |

## Configuration

### Global Codex Configuration

Create `~/.codex/config.toml`:

```toml
# Default model
model = "gpt-5.2-codex"

# Default sandbox level
sandbox = "workspace-write"

# Reasoning settings
reasoning_effort = "high"

# Custom instructions
instructions = """
Follow these guidelines:
- Write clean, readable code
- Add comments for complex logic
- Follow existing code patterns
- Include error handling
"""
```

### Project-Level Configuration

Create `codex.toml` in your project root:

```toml
model = "gpt-5.2-codex"
sandbox = "workspace-write"

additional_dirs = ["../shared-libs"]

instructions = """
Project: My TypeScript App
- Use TypeScript strict mode
- Use functional components with React hooks
- Follow patterns in src/components/
"""
```

## Integration with Claude Workflow

### Workflow Patterns

#### Debug → Fix
```bash
# 1. Use Claude to analyze the problem
/debug Investigate why user authentication fails intermittently

# 2. Use Codex to implement the fix
/codex --mode=safe Fix the race condition in auth token refresh
```

#### Plan → Implement
```bash
# 1. Use Claude to plan the architecture
/code Plan the new payment processing module structure

# 2. Use Codex to implement
/codex Implement the payment processing module following the plan above
```

#### Implement → Review
```bash
# 1. Use Codex for rapid implementation
/codex Implement user registration with email verification

# 2. Use Claude for thorough review
/review Check the new registration code for security vulnerabilities
```

#### Implement → Test → Commit
```bash
# 1. Implement feature
/codex Add REST API endpoint for user profile updates

# 2. Generate tests
/codex Write unit tests for the new profile update endpoint

# 3. Commit with proper message
/commit
```

### Sub-Agent Usage

The Codex agent can be used as a sub-agent:

```
Task(subagent_type="codex", prompt="Implement feature X with proper error handling")
```

## Troubleshooting

### Common Issues

#### "stdin is not a terminal"

**Cause**: Using `codex` instead of `codex exec` for non-interactive execution.

**Solution**: The skill automatically uses `codex exec`. If running manually:
```bash
# Wrong
codex --full-auto "task"

# Correct
codex exec --full-auto "task"
```

#### "Codex CLI not found"

**Solution**:
```bash
npm install -g @openai/codex
```

#### "API key not configured"

**Solution**:
```bash
# Check if set
echo $OPENAI_API_KEY

# Set it
export OPENAI_API_KEY="your-api-key"
```

#### Execution Timeout

**Solution**: Increase timeout or break into smaller tasks:
```bash
/codex --timeout=600 "your complex task"
```

### Verification Commands

```bash
# Check Codex installation
codex --version

# Check API key (don't expose the full key)
echo $OPENAI_API_KEY | head -c 10

# Test Codex connectivity
codex exec --full-auto "echo 'Hello from Codex'"

# Check skill installation
ls ~/.claude/commands/codex/
ls ~/.claude/agents/codex.md
```

## Security Considerations

### API Key Security

- **Never commit** API keys to version control
- Use environment variables or secure vaults
- Rotate keys periodically

### YOLO Mode Warnings

⚠️ **YOLO mode bypasses ALL safety measures**

**Only use when**:
- Inside Docker containers
- Inside dedicated VMs
- In CI/CD pipelines with proper isolation
- When you have full backups

### Code Review

**Always review AI-generated code before**:
- Committing to main branch
- Deploying to production
- Merging pull requests

## File Structure

```
codex-skill/
├── README.md                    # This documentation
├── LICENSE                      # MIT License
├── SKILL.md                     # Main skill definition
├── agent.md                     # Sub-agent definition
├── reference.md                 # CLI quick reference
├── REQUIREMENTS.md              # Detailed requirements
├── scripts/
│   ├── codex-runner.ps1         # Windows PowerShell wrapper
│   ├── codex-runner.sh          # Linux/macOS Bash wrapper
│   ├── codex-yolo.cmd           # Windows quick YOLO launcher
│   ├── codex-yolo.sh            # Linux/macOS quick YOLO launcher
│   └── install/
│       ├── install.ps1          # Windows one-click installer
│       ├── install.sh           # Linux/macOS one-click installer
│       └── uninstall.sh         # Uninstaller script
└── examples/
    ├── config.toml              # Example global config
    └── project-config.toml      # Example project config
```

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## License

MIT License - see [LICENSE](LICENSE) for details.

## Acknowledgments

- [OpenAI Codex CLI](https://developers.openai.com/codex/cli/)
- [Claude Code](https://claude.ai/code)
- [Anthropic](https://www.anthropic.com/)
