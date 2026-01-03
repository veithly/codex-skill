# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-01-03

### Added

- Initial release of Codex Skill for Claude Code
- Three execution modes:
  - **YOLO mode** (`--mode=yolo`): Full autonomy with no approvals or sandboxing
  - **Auto mode** (`--mode=auto`): Balanced mode with workspace write access (default)
  - **Safe mode** (`--mode=safe`): Conservative mode with default approval policy
- Cross-platform support:
  - Windows (PowerShell)
  - Linux (Bash)
  - macOS (Bash)
- One-click installation scripts for all platforms
- npm package support for easy installation
- Claude Code Marketplace manifest
- Helper scripts:
  - `codex-runner.ps1` / `codex-runner.sh` - Full-featured wrapper
  - `codex-yolo.cmd` / `codex-yolo.sh` - Quick YOLO mode launcher
- Agent definition for sub-agent usage
- Comprehensive documentation:
  - README with installation and usage instructions
  - REQUIREMENTS.md with detailed dependencies
  - reference.md with CLI quick reference
- Example configuration files for Codex CLI
- GitHub Actions CI/CD workflows

### Technical Details

- Uses `codex exec` for non-interactive execution
- Supports additional directory access with `--add-dir`
- Supports custom timeouts with `--timeout`
- Git integration for change tracking and rollback

## [Unreleased]

### Planned

- Integration tests with mock Codex CLI
- VS Code extension for visual mode selection
- Task history and replay functionality
- Cost estimation before execution
