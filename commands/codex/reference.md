# Codex CLI Reference

Quick reference for OpenAI Codex CLI commands and options.

## Non-Interactive Execution

**Important**: Always use `codex exec` for automated/scripted execution.

```bash
# Correct - non-interactive
codex exec --full-auto "your task"

# Wrong - requires terminal
codex --full-auto "your task"  # Will fail with "stdin is not a terminal"
```

## Command Line Options

### Execution Modes

| Flag | Description |
|------|-------------|
| `--dangerously-bypass-approvals-and-sandbox` | No approvals, no sandbox (YOLO mode) |
| `--full-auto` | Workspace write + on-request approval |
| `-s, --sandbox <level>` | Set sandbox: `read-only`, `workspace-write`, `danger-full-access` |

### Common Options

| Flag | Description |
|------|-------------|
| `-m, --model <MODEL>` | Specify model to use |
| `-C, --cd <DIR>` | Working directory for Codex |
| `--add-dir <DIR>` | Additional writable directory |
| `--skip-git-repo-check` | Allow running outside git repo |
| `--json` | Output as JSONL |
| `-o, --output-last-message <FILE>` | Save last message to file |

## Quick Examples

### Bug Fixing
```bash
codex exec --full-auto "Fix the TypeError in src/utils.ts"
```

### Feature Implementation
```bash
codex exec --full-auto "Add user registration API endpoint"
```

### YOLO Mode (Caution!)
```bash
codex exec --dangerously-bypass-approvals-and-sandbox "Implement auth module"
```

### With Custom Directory
```bash
codex exec --full-auto --add-dir ../shared "Update shared utilities"
```

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | Success |
| 1 | General error |
| 124 | Timeout (common on Windows) |

## Environment Variables

| Variable | Description |
|----------|-------------|
| `OPENAI_API_KEY` | Required - OpenAI API key |
| `CODEX_MODEL` | Override default model |

## More Information

- [Codex CLI Docs](https://developers.openai.com/codex/cli/)
- [Codex CLI Reference](https://developers.openai.com/codex/cli/reference/)
