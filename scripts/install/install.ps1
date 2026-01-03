<#
.SYNOPSIS
    One-click installer for Codex Skill for Claude Code (Windows)
.DESCRIPTION
    Installs the Codex skill, agent definition, and helper scripts.
    Also checks for and optionally installs prerequisites.
.EXAMPLE
    .\install.ps1
.EXAMPLE
    .\install.ps1 -SkipPrereqs
#>

param(
    [switch]$SkipPrereqs,
    [switch]$Force
)

$ErrorActionPreference = "Stop"

# Colors
function Write-Status { param($msg) Write-Host "[*] $msg" -ForegroundColor Cyan }
function Write-Success { param($msg) Write-Host "[+] $msg" -ForegroundColor Green }
function Write-Warning { param($msg) Write-Host "[!] $msg" -ForegroundColor Yellow }
function Write-Error { param($msg) Write-Host "[-] $msg" -ForegroundColor Red }

# Banner
Write-Host @"

  ██████╗ ██████╗ ██████╗ ███████╗██╗  ██╗    ███████╗██╗  ██╗██╗██╗     ██╗
 ██╔════╝██╔═══██╗██╔══██╗██╔════╝╚██╗██╔╝    ██╔════╝██║ ██╔╝██║██║     ██║
 ██║     ██║   ██║██║  ██║█████╗   ╚███╔╝     ███████╗█████╔╝ ██║██║     ██║
 ██║     ██║   ██║██║  ██║██╔══╝   ██╔██╗     ╚════██║██╔═██╗ ██║██║     ██║
 ╚██████╗╚██████╔╝██████╔╝███████╗██╔╝ ██╗    ███████║██║  ██╗██║███████╗███████╗
  ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝    ╚══════╝╚═╝  ╚═╝╚═╝╚══════╝╚══════╝

  Codex Skill Installer for Claude Code (Windows)

"@ -ForegroundColor Magenta

# Get script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectDir = Split-Path -Parent (Split-Path -Parent $ScriptDir)

# Define paths
$ClaudeDir = "$env:USERPROFILE\.claude"
$CommandsDir = "$ClaudeDir\commands\codex"
$AgentsDir = "$ClaudeDir\agents"
$ScriptsDir = "$ClaudeDir\scripts"

Write-Status "Starting installation..."
Write-Host ""

# Step 1: Check prerequisites
if (-not $SkipPrereqs) {
    Write-Status "Checking prerequisites..."

    # Check Node.js
    try {
        $nodeVersion = node --version 2>&1
        Write-Success "Node.js: $nodeVersion"
    } catch {
        Write-Error "Node.js not found. Please install Node.js 18+ from https://nodejs.org/"
        exit 1
    }

    # Check npm
    try {
        $npmVersion = npm --version 2>&1
        Write-Success "npm: v$npmVersion"
    } catch {
        Write-Error "npm not found. Please reinstall Node.js."
        exit 1
    }

    # Check Git
    try {
        $gitVersion = git --version 2>&1
        Write-Success "Git: $gitVersion"
    } catch {
        Write-Warning "Git not found. Git is recommended for rollback support."
    }

    # Check/Install Codex CLI
    Write-Status "Checking Codex CLI..."
    try {
        $codexVersion = codex --version 2>&1
        Write-Success "Codex CLI: $codexVersion"
    } catch {
        Write-Warning "Codex CLI not found. Installing..."
        npm install -g @openai/codex
        if ($LASTEXITCODE -eq 0) {
            Write-Success "Codex CLI installed successfully"
        } else {
            Write-Error "Failed to install Codex CLI"
            exit 1
        }
    }

    Write-Host ""
}

# Step 2: Create directories
Write-Status "Creating directories..."

$dirs = @($CommandsDir, $AgentsDir, $ScriptsDir)
foreach ($dir in $dirs) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Success "Created: $dir"
    } else {
        Write-Success "Exists: $dir"
    }
}

Write-Host ""

# Step 3: Copy skill files
Write-Status "Installing skill files..."

# Copy SKILL.md
$skillSrc = Join-Path $ProjectDir "SKILL.md"
$skillDst = Join-Path $CommandsDir "SKILL.md"
if (Test-Path $skillSrc) {
    Copy-Item $skillSrc $skillDst -Force
    Write-Success "Installed: SKILL.md -> $skillDst"
} else {
    Write-Error "SKILL.md not found in $ProjectDir"
    exit 1
}

# Copy reference.md
$refSrc = Join-Path $ProjectDir "reference.md"
$refDst = Join-Path $CommandsDir "reference.md"
if (Test-Path $refSrc) {
    Copy-Item $refSrc $refDst -Force
    Write-Success "Installed: reference.md -> $refDst"
}

# Copy agent.md
$agentSrc = Join-Path $ProjectDir "agent.md"
$agentDst = Join-Path $AgentsDir "codex.md"
if (Test-Path $agentSrc) {
    Copy-Item $agentSrc $agentDst -Force
    Write-Success "Installed: agent.md -> $agentDst"
}

Write-Host ""

# Step 4: Copy helper scripts
Write-Status "Installing helper scripts..."

$scriptsSrc = Join-Path $ProjectDir "scripts"

# Copy PowerShell runner
$ps1Src = Join-Path $scriptsSrc "codex-runner.ps1"
$ps1Dst = Join-Path $ScriptsDir "codex-runner.ps1"
if (Test-Path $ps1Src) {
    Copy-Item $ps1Src $ps1Dst -Force
    Write-Success "Installed: codex-runner.ps1"
}

# Copy CMD launcher
$cmdSrc = Join-Path $scriptsSrc "codex-yolo.cmd"
$cmdDst = Join-Path $ScriptsDir "codex-yolo.cmd"
if (Test-Path $cmdSrc) {
    Copy-Item $cmdSrc $cmdDst -Force
    Write-Success "Installed: codex-yolo.cmd"
}

Write-Host ""

# Step 5: Check API key
Write-Status "Checking API key configuration..."

if ([string]::IsNullOrEmpty($env:OPENAI_API_KEY)) {
    Write-Warning "OPENAI_API_KEY environment variable is not set."
    Write-Host ""
    $configure = Read-Host "Would you like to configure it now? (y/N)"

    if ($configure -eq 'y' -or $configure -eq 'Y') {
        $apiKey = Read-Host "Enter your OpenAI API key"
        if (-not [string]::IsNullOrEmpty($apiKey)) {
            # Set for current session
            $env:OPENAI_API_KEY = $apiKey

            # Ask about persistence
            $persist = Read-Host "Add to PowerShell profile for persistence? (y/N)"
            if ($persist -eq 'y' -or $persist -eq 'Y') {
                $profileLine = "`n`$env:OPENAI_API_KEY = '$apiKey'"
                Add-Content $PROFILE $profileLine
                Write-Success "API key added to PowerShell profile"
            }

            Write-Success "API key configured for current session"
        }
    }
} else {
    Write-Success "API key is configured"
}

Write-Host ""

# Step 6: Verify installation
Write-Status "Verifying installation..."

$verified = $true

if (Test-Path $skillDst) {
    Write-Success "Skill file: OK"
} else {
    Write-Error "Skill file: MISSING"
    $verified = $false
}

if (Test-Path $agentDst) {
    Write-Success "Agent file: OK"
} else {
    Write-Error "Agent file: MISSING"
    $verified = $false
}

try {
    $null = codex --version 2>&1
    Write-Success "Codex CLI: OK"
} catch {
    Write-Error "Codex CLI: NOT WORKING"
    $verified = $false
}

Write-Host ""

# Summary
if ($verified) {
    Write-Host @"
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
║    $ScriptsDir
║                                                             ║
║  Documentation:                                             ║
║    $ProjectDir\README.md
║                                                             ║
╚════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Green
} else {
    Write-Error "Installation completed with errors. Please check the messages above."
    exit 1
}
