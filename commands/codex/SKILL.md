---
description: Delegate coding tasks to OpenAI Codex CLI with YOLO mode for autonomous execution
argument-hint: <task> [--mode=yolo|auto|safe] [--timeout=300]
allowed-tools: Bash, Read, Write, Edit, Grep, Glob
user-invocable: true
---

# Codex CLI Integration

Delegate coding tasks to OpenAI's Codex CLI with configurable execution modes including YOLO mode for fully autonomous operation.

## Usage

```
/codex <task_description> [options]
```

### Options
- `--mode=yolo` - YOLO mode: No approvals, no sandbox (use in hardened environments only)
- `--mode=auto` - Full auto mode: Workspace write access, minimal interaction (default)
- `--mode=safe` - Safe mode: Requires approval for each action
- `--timeout=<seconds>` - Execution timeout (default: 300)
- `--add-dir=<path>` - Additional directory for Codex to access

### Examples

```bash
# Fix a bug with default auto mode
/codex Fix the null pointer exception in src/api/handlers.ts

# Implement feature with YOLO mode
/codex --mode=yolo Implement user authentication with JWT in the express app

# Refactor with safe mode
/codex --mode=safe Refactor the database connection pool to use async/await

# Run tests and fix failures
/codex Run all tests and fix any failing ones
```

## Context
- Task description: $ARGUMENTS
- Current working directory will be used as Codex workspace
- Git repository state should be clean before execution

## Your Role

You are the **Codex Orchestration Coordinator** managing automated coding tasks through OpenAI's Codex CLI. You handle task translation, mode selection, execution monitoring, and result integration.

## Workflow

### Phase 1: Environment Verification

Before executing any Codex command, verify the environment:

```bash
# Check if Codex CLI is installed
codex --version 2>/dev/null || echo "CODEX_NOT_INSTALLED"

# Check for API key (just verify it exists, don't expose)
[ -n "$OPENAI_API_KEY" ] && echo "API_KEY_SET" || echo "API_KEY_NOT_SET"

# Check git status (ensure we can rollback)
git status --porcelain
```

If Codex is not installed, provide installation instructions:
```bash
npm install -g @openai/codex
# or
pnpm add -g @openai/codex
```

### Phase 2: Task Analysis

Parse the user's arguments to determine:

1. **Task Description** - The coding task to delegate to Codex
2. **Execution Mode** - yolo, auto, or safe (default: auto)
3. **Timeout** - Maximum execution time (default: 300 seconds)
4. **Additional Options** - Extra directories, model preferences, etc.

**Argument Parsing:**
- Extract `--mode=<value>` if present, default to `auto`
- Extract `--timeout=<value>` if present, default to `300`
- Extract `--add-dir=<path>` if present
- Remaining text is the task description

### Phase 3: Mode Selection & Command Construction

**IMPORTANT**: Use `codex exec` for non-interactive execution (not just `codex`).

Based on parsed arguments, construct the appropriate Codex command:

#### YOLO Mode (--mode=yolo)
```bash
codex exec --dangerously-bypass-approvals-and-sandbox "<task>"
```
**WARNING**: Only use in hardened environments (Docker, VM, CI/CD)

#### Auto Mode (--mode=auto) - Default
```bash
codex exec --full-auto "<task>"
```
Equivalent to: `--sandbox workspace-write --ask-for-approval on-request`

#### Safe Mode (--mode=safe)
```bash
codex exec -s workspace-write "<task>"
```
Uses workspace-write sandbox with default approval policy.

### Phase 4: Execution

Execute the constructed command:

```bash
# Example execution pattern
codex exec --full-auto "Your task description here" 2>&1
```

**Key Points:**
- Always use `codex exec` for non-interactive (automated) execution
- Capture both stdout and stderr
- Monitor for timeout conditions
- The command may take several seconds to minutes depending on task complexity

### Phase 5: Result Collection

After execution, gather results:

```bash
# Check what files changed
git diff --name-only

# Show summary of changes
git diff --stat

# Show detailed changes (if manageable size)
git diff
```

### Phase 6: Report Generation

Generate a comprehensive report including:

1. **Execution Summary**
   - Mode used
   - Task sent to Codex
   - Execution status (success/failure)
   - Tokens used (if available from output)

2. **Changes Made**
   - List of modified files
   - Summary of changes per file
   - New files created
   - Files deleted

3. **Codex Output**
   - Relevant messages from Codex
   - Any warnings or errors encountered
   - Model used

4. **Verification Steps**
   - How to test the changes
   - Recommended manual review areas
   - Suggested follow-up actions

5. **Rollback Instructions**
   ```bash
   # If changes are problematic, rollback with:
   git checkout -- .
   # or reset to last commit:
   git reset --hard HEAD
   ```

## Error Handling

### Codex Not Installed
```
Codex CLI is not installed.

To install, run:
  npm install -g @openai/codex

Or with pnpm:
  pnpm add -g @openai/codex
```

### API Key Not Configured
```
OpenAI API key not found.

Set your API key:
  # Windows PowerShell
  $env:OPENAI_API_KEY = "your-api-key"

  # Bash/Zsh
  export OPENAI_API_KEY="your-api-key"
```

### Execution Timeout
```
Codex execution timed out after {timeout} seconds.

Consider:
1. Breaking the task into smaller steps
2. Increasing timeout: /codex --timeout=600 <task>
3. Using a more specific task description
```

### stdin is not a terminal
```
This error occurs when using `codex` directly instead of `codex exec`.

Solution: The skill uses `codex exec` for non-interactive execution.
```

## Best Practices

1. **Use Git** - Always ensure your workspace is a git repository
2. **Clean State** - Commit or stash changes before running Codex
3. **Start Safe** - Use safe mode for unfamiliar tasks, escalate as needed
4. **Be Specific** - Provide detailed task descriptions with file paths
5. **Verify Results** - Always review Codex's changes before committing
6. **Backup First** - For critical code, create a branch before execution

## Security Considerations

- **YOLO mode** bypasses all safety measures - use only in isolated environments
- **API keys** should never be committed to version control
- **Code review** is essential even for AI-generated changes
- **Access scope** - Prefer minimal sandbox levels when possible

## Integration with Claude Workflow

This skill works seamlessly with other Claude skills:

```bash
# Use Codex for implementation, then review with Claude
/codex Implement the payment processing module
/review Check the new payment module for security issues

# Debug with Claude, fix with Codex
/debug Investigate the authentication failure
/codex --mode=safe Fix the authentication token validation bug

# Plan with Claude, implement with Codex
/code Plan the new API structure
/codex Implement the planned API endpoints
```
