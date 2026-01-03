# Codex Skill Requirements

This document details all requirements for running the Codex Skill for Claude Code.

## System Requirements

### Minimum Requirements

| Component | Requirement |
|-----------|-------------|
| **Operating System** | Windows 10/11, macOS 10.15+, Linux (Ubuntu 18.04+) |
| **RAM** | 4 GB minimum |
| **Disk Space** | 500 MB for CLI and dependencies |
| **Network** | Internet connection for API calls |

### Recommended Requirements

| Component | Recommendation |
|-----------|----------------|
| **RAM** | 8 GB or more |
| **CPU** | Multi-core processor |
| **SSD** | For faster file operations |

## Software Dependencies

### Required

| Software | Version | Purpose | Installation |
|----------|---------|---------|--------------|
| **Node.js** | 18.0.0+ | Runtime for Codex CLI | [nodejs.org](https://nodejs.org/) |
| **npm** or **pnpm** | Latest | Package manager | Comes with Node.js |
| **Claude Code** | Latest | Host application | [claude.ai/code](https://claude.ai/code) |
| **OpenAI Codex CLI** | Latest | Core functionality | `npm i -g @openai/codex` |

### Recommended

| Software | Version | Purpose | Installation |
|----------|---------|---------|--------------|
| **Git** | 2.0+ | Change tracking & rollback | [git-scm.com](https://git-scm.com/) |
| **PowerShell** | 7.0+ | Windows scripting (Windows) | [Microsoft](https://docs.microsoft.com/en-us/powershell/) |
| **Bash** | 4.0+ | Scripting (Linux/macOS) | Usually pre-installed |

## API Requirements

### OpenAI API Key

**Required**: An OpenAI API key with Codex access.

**How to Obtain:**
1. Go to [OpenAI Platform](https://platform.openai.com/)
2. Sign up or log in
3. Navigate to API Keys section
4. Create a new API key
5. Copy and save securely

**Configuration:**

```bash
# Linux/macOS
export OPENAI_API_KEY="sk-..."

# Windows PowerShell
$env:OPENAI_API_KEY = "sk-..."
```

### API Usage & Costs

- Codex CLI uses GPT-5.2-Codex model by default
- Usage is billed per token
- Check [OpenAI Pricing](https://openai.com/pricing) for current rates
- Monitor usage at [OpenAI Usage Dashboard](https://platform.openai.com/usage)

## Claude Code Requirements

### Skill Installation Locations

```
~/.claude/
├── skills/
│   └── codex/
│       ├── SKILL.md        # Required
│       └── reference.md    # Optional
├── agents/
│   └── codex.md           # Optional (for sub-agent usage)
└── scripts/
    ├── codex-runner.sh    # Optional helper
    └── codex-runner.ps1   # Optional helper
```

### Permissions

The skill requires:
- Read/write access to `~/.claude/` directory
- Execute permission for scripts
- Network access for API calls

## Environment Requirements

### Shell Requirements

**Linux/macOS:**
- Bash 4.0+ or Zsh
- `timeout` command (optional, for timeout support)
- Standard POSIX utilities

**Windows:**
- PowerShell 7.0+ recommended
- Or Git Bash / MSYS2 / WSL2

### Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `OPENAI_API_KEY` | Yes | OpenAI API authentication |
| `CODEX_MODEL` | No | Override default model |
| `CODEX_TIMEOUT` | No | Default timeout (seconds) |

## Recommended Claude Code Skills

These skills enhance the Codex workflow:

| Skill | Purpose | Integration Pattern |
|-------|---------|---------------------|
| `/debug` | Problem analysis | Debug → Fix with Codex |
| `/review` | Code review | Implement → Review |
| `/code` | Planning | Plan → Implement |
| `/test` | Testing | Implement → Test |
| `/commit` | Git commits | Implement → Commit |
| `/ask` | Research | Research → Implement |

## Network Requirements

### Required Endpoints

| Endpoint | Port | Purpose |
|----------|------|---------|
| `api.openai.com` | 443 | Codex API |
| `registry.npmjs.org` | 443 | Package installation |

### Firewall Configuration

Ensure outbound HTTPS (port 443) is allowed to:
- `*.openai.com`
- `registry.npmjs.org`

### Proxy Support

If behind a corporate proxy:

```bash
# Set proxy environment variables
export HTTP_PROXY="http://proxy:port"
export HTTPS_PROXY="http://proxy:port"
```

## Security Requirements

### API Key Security

- Never commit API keys to version control
- Use environment variables or secure vaults
- Rotate keys periodically
- Use separate keys for dev/prod

### YOLO Mode Requirements

YOLO mode should ONLY be used in:
- Docker containers
- Dedicated VMs
- CI/CD pipelines with isolation
- Air-gapped development environments

### Code Review Requirements

All Codex-generated code should be reviewed before:
- Merging to main branch
- Deploying to production
- Using in security-sensitive contexts

## Compatibility Matrix

### Operating System Support

| OS | Version | Status |
|----|---------|--------|
| Windows 11 | All | Fully Supported |
| Windows 10 | 1903+ | Fully Supported |
| macOS | 10.15+ | Fully Supported |
| Ubuntu | 18.04+ | Fully Supported |
| Debian | 10+ | Fully Supported |
| Fedora | 32+ | Fully Supported |
| CentOS | 8+ | Supported |
| Arch Linux | Latest | Supported |

### Node.js Compatibility

| Node.js Version | Status |
|-----------------|--------|
| 22.x | Fully Supported |
| 20.x LTS | Fully Supported |
| 18.x LTS | Fully Supported |
| 16.x | Not Supported |
| <16 | Not Supported |

### Codex CLI Versions

| Version | Status |
|---------|--------|
| 0.77.0+ | Recommended |
| 0.65.0+ | Supported |
| <0.65.0 | May have issues |

## Troubleshooting Requirements Issues

### Check Node.js Version

```bash
node --version
# Should be v18.0.0 or higher
```

### Check npm Version

```bash
npm --version
```

### Check Codex CLI Version

```bash
codex --version
```

### Verify API Key

```bash
# Don't expose full key
echo $OPENAI_API_KEY | head -c 10
```

### Test Codex Connectivity

```bash
codex exec --full-auto "echo hello"
```

## Support

For issues related to:

- **Codex CLI**: [OpenAI Codex Issues](https://github.com/openai/codex/issues)
- **Claude Code**: [Claude Code Issues](https://github.com/anthropics/claude-code/issues)
- **This Skill**: Open an issue in this repository
