<#
.SYNOPSIS
    Codex CLI wrapper for Claude Code integration
.DESCRIPTION
    Runs OpenAI Codex CLI with configurable modes (YOLO, Auto, Safe)
    and provides proper error handling and result collection.
.PARAMETER Task
    The coding task to send to Codex
.PARAMETER Mode
    Execution mode: 'yolo', 'auto' (default), or 'safe'
.PARAMETER Timeout
    Maximum execution time in seconds (default: 300)
.PARAMETER AddDir
    Additional directory to grant Codex access to
.EXAMPLE
    .\codex-runner.ps1 -Task "Fix the bug in src/api.ts" -Mode auto
.EXAMPLE
    .\codex-runner.ps1 -Task "Implement user auth" -Mode yolo -Timeout 600
#>

param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$Task,

    [Parameter(Mandatory=$false)]
    [ValidateSet('yolo', 'auto', 'safe')]
    [string]$Mode = 'auto',

    [Parameter(Mandatory=$false)]
    [int]$Timeout = 300,

    [Parameter(Mandatory=$false)]
    [string]$AddDir = ""
)

# Colors for output
function Write-ColorOutput {
    param([string]$Message, [string]$Color = "White")
    Write-Host $Message -ForegroundColor $Color
}

# Check if Codex is installed
function Test-CodexInstalled {
    try {
        $null = & codex --version 2>&1
        return $LASTEXITCODE -eq 0
    } catch {
        return $false
    }
}

# Check for API key
function Test-ApiKey {
    return -not [string]::IsNullOrEmpty($env:OPENAI_API_KEY)
}

# Build Codex command arguments
function Get-CodexArgs {
    param([string]$Task, [string]$Mode, [string]$AddDir)

    $args = @('exec')

    switch ($Mode) {
        'yolo' {
            $args += '--dangerously-bypass-approvals-and-sandbox'
        }
        'auto' {
            $args += '--full-auto'
        }
        'safe' {
            $args += '-s'
            $args += 'workspace-write'
        }
    }

    if (-not [string]::IsNullOrEmpty($AddDir)) {
        $args += '--add-dir'
        $args += $AddDir
    }

    $args += $Task

    return $args
}

# Main execution
function Invoke-Codex {
    Write-ColorOutput "`n=== Codex CLI Runner ===" "Cyan"
    Write-ColorOutput "Mode: $Mode" "Yellow"
    Write-ColorOutput "Timeout: ${Timeout}s" "Yellow"
    Write-ColorOutput "Task: $Task`n" "White"

    # Pre-flight checks
    Write-ColorOutput "[1/4] Checking Codex installation..." "Gray"
    if (-not (Test-CodexInstalled)) {
        Write-ColorOutput "ERROR: Codex CLI is not installed." "Red"
        Write-ColorOutput "Install with: npm install -g @openai/codex" "Yellow"
        exit 1
    }
    Write-ColorOutput "  Codex CLI found" "Green"

    Write-ColorOutput "[2/4] Checking API key..." "Gray"
    if (-not (Test-ApiKey)) {
        Write-ColorOutput "ERROR: OPENAI_API_KEY environment variable not set." "Red"
        Write-ColorOutput '$env:OPENAI_API_KEY = "your-key"' "Yellow"
        exit 1
    }
    Write-ColorOutput "  API key configured" "Green"

    Write-ColorOutput "[3/4] Checking git status..." "Gray"
    $gitStatus = git status --porcelain 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-ColorOutput "  WARNING: Not a git repository" "Yellow"
    } elseif ($gitStatus) {
        Write-ColorOutput "  WARNING: Uncommitted changes detected" "Yellow"
    } else {
        Write-ColorOutput "  Git workspace clean" "Green"
    }

    # Build command
    $codexArgs = Get-CodexArgs -Task $Task -Mode $Mode -AddDir $AddDir

    Write-ColorOutput "[4/4] Executing Codex..." "Gray"
    if ($Mode -eq 'yolo') {
        Write-ColorOutput "  WARNING: YOLO mode active - no approvals, no sandbox" "Red"
    }
    Write-ColorOutput ""

    # Execute
    $startTime = Get-Date

    try {
        & codex @codexArgs 2>&1
        $exitCode = $LASTEXITCODE
    } catch {
        Write-ColorOutput "ERROR: Execution failed - $_" "Red"
        exit 1
    }

    $duration = (Get-Date) - $startTime

    # Show changes
    Write-ColorOutput "`n=== Changes Made ===" "Cyan"
    $changes = git diff --stat 2>&1
    if ($changes -and $LASTEXITCODE -eq 0) {
        Write-Output $changes
    } else {
        Write-ColorOutput "No file changes detected (or not a git repo)" "Yellow"
    }

    # Summary
    Write-ColorOutput "`n=== Execution Summary ===" "Cyan"
    Write-ColorOutput "Duration: $($duration.TotalSeconds.ToString('F1'))s" "White"
    Write-ColorOutput "Exit Code: $exitCode" $(if($exitCode -eq 0){"Green"}else{"Red"})

    # Rollback instructions
    Write-ColorOutput "`n=== Rollback (if needed) ===" "Gray"
    Write-ColorOutput "git checkout -- .        # Discard all changes" "Gray"
    Write-ColorOutput "git reset --hard HEAD    # Reset to last commit" "Gray"

    exit $exitCode
}

# Run
Invoke-Codex
