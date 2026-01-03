# Codex Skill for Claude Code

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20macOS%20%7C%20Linux-blue.svg)]()
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Plugin-green.svg)]()

Delegate coding tasks to OpenAI's Codex CLI with configurable execution modes including YOLO mode for fully autonomous operation. This plugin bridges Claude Code's analytical capabilities with Codex's autonomous code execution.

## Quick Start

### Install via Claude Code Marketplace (Recommended)

```bash
# Add the marketplace
/plugin marketplace add veithly/codex-skill

# Install the plugin
/plugin install rick@codex-skill
```

### Prerequisites

Before using the plugin, ensure you have:

1. **OpenAI Codex CLI** installed:
   ```bash
   npm install -g @openai/codex
   ```

2. **OpenAI API Key** configured:
   ```bash
   # Linux/macOS
   export OPENAI_API_KEY="your-api-key"

   # Windows PowerShell
   $env:OPENAI_API_KEY = "your-api-key"
   ```

## Features

- **Multiple Execution Modes**: YOLO (full autonomy), Auto (balanced), Safe (conservative)
- **Non-Interactive Execution**: Uses `codex exec` for automation-friendly operation
- **Git Integration**: Automatic change tracking and rollback support
- **Cross-Platform**: Works on Windows, macOS, and Linux
- **Claude Integration**: Seamless workflow with other Claude Code skills

## Usage

```bash
# Default auto mode - balanced safety and automation
/codex Fix the null pointer exception in src/api/handlers.ts

# YOLO mode - full autonomy (use in hardened environments only!)
/codex --mode=yolo Implement user authentication with JWT

# Safe mode - requires more oversight
/codex --mode=safe Refactor the database connection module

# With custom timeout
/codex --timeout=600 Implement complex multi-file feature
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

| Aspect | Details |
|--------|---------|
| **Risk Level** | HIGH |
| **Approvals** | None |
| **Sandbox** | Disabled |
| **Best For** | CI/CD pipelines, Docker containers, VMs |

⚠️ **Warning**: Only use in externally hardened environments!

### Auto Mode (`--mode=auto`) - Default

| Aspect | Details |
|--------|---------|
| **Risk Level** | MEDIUM |
| **Approvals** | On-request |
| **Sandbox** | Workspace write |
| **Best For** | Development, refactoring, feature implementation |

### Safe Mode (`--mode=safe`)

| Aspect | Details |
|--------|---------|
| **Risk Level** | LOW |
| **Approvals** | Default policy |
| **Sandbox** | Workspace write |
| **Best For** | Production code, learning, sensitive operations |

## Alternative Installation Methods

### Via One-Click Installer

**Windows (PowerShell):**
```powershell
git clone https://github.com/veithly/codex-skill.git
cd codex-skill
.\scripts\install\install.ps1
```

**Linux/macOS (Bash):**
```bash
git clone https://github.com/veithly/codex-skill.git
cd codex-skill
chmod +x ./scripts/install/install.sh
./scripts/install/install.sh
```

### Via npm

```bash
npm install -g @anthropic-skills/codex
```

### Manual Installation

```bash
# Clone repository
git clone https://github.com/veithly/codex-skill.git
cd codex-skill

# Create directories
mkdir -p ~/.claude/commands/codex
mkdir -p ~/.claude/agents
mkdir -p ~/.claude/scripts

# Copy files
cp commands/codex/SKILL.md ~/.claude/commands/codex/
cp commands/codex/reference.md ~/.claude/commands/codex/
cp agents/codex.md ~/.claude/agents/
```

## Integration with Claude Workflow

### Debug → Fix
```bash
# Use Claude to analyze
/debug Investigate why user authentication fails

# Use Codex to fix
/codex --mode=safe Fix the race condition in auth token refresh
```

### Plan → Implement
```bash
# Use Claude to plan
/code Plan the new payment processing module

# Use Codex to implement
/codex Implement the payment module following the plan above
```

### Implement → Review
```bash
# Use Codex for rapid implementation
/codex Implement user registration with email verification

# Use Claude for review
/review Check the registration code for security vulnerabilities
```

## Configuration

### Global Codex Configuration

Create `~/.codex/config.toml`:

```toml
model = "gpt-5.2-codex"
sandbox = "workspace-write"
reasoning_effort = "high"

instructions = """
Follow project coding standards.
Write tests for new functionality.
"""
```

### Project-Level Configuration

Create `codex.toml` in your project root:

```toml
model = "gpt-5.2-codex"
sandbox = "workspace-write"
additional_dirs = ["../shared-libs"]

instructions = """
This is a TypeScript project.
Use functional components with React hooks.
"""
```

## Troubleshooting

### "stdin is not a terminal"

The skill uses `codex exec` for non-interactive execution. If running manually, use:
```bash
codex exec --full-auto "your task"
```

### "Codex CLI not found"

```bash
npm install -g @openai/codex
```

### "API key not configured"

```bash
export OPENAI_API_KEY="your-api-key"
```

## Security Considerations

- **YOLO mode** bypasses ALL safety measures - use only in isolated environments
- **API keys** should never be committed to version control
- **Always review** AI-generated code before committing
- **Use Git** for rollback capability

## File Structure

```
codex-skill/
├── .claude-plugin/
│   ├── marketplace.json    # Marketplace definition
│   └── plugin.json         # Plugin manifest
├── commands/
│   └── codex/
│       ├── SKILL.md        # Main skill definition
│       └── reference.md    # CLI quick reference
├── agents/
│   └── codex.md            # Sub-agent definition
├── scripts/
│   ├── install/            # One-click installers
│   ├── codex-runner.*      # Helper wrappers
│   └── codex-yolo.*        # Quick YOLO launchers
├── examples/               # Configuration examples
├── README.md               # This file
├── REQUIREMENTS.md         # Detailed requirements
├── CHANGELOG.md            # Version history
└── LICENSE                 # MIT License
```

## Requirements

| Component | Requirement |
|-----------|-------------|
| **Claude Code** | Latest version |
| **Node.js** | v18.0.0 or higher |
| **OpenAI Codex CLI** | v0.65.0 or higher |
| **Git** | v2.0+ (recommended) |

See [REQUIREMENTS.md](REQUIREMENTS.md) for detailed requirements.

## Contributing

Contributions are welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

MIT License - see [LICENSE](LICENSE) for details.

## Links

- [GitHub Repository](https://github.com/veithly/codex-skill)
- [OpenAI Codex CLI Documentation](https://developers.openai.com/codex/cli/)
- [Claude Code Documentation](https://docs.anthropic.com/claude-code)
