@echo off
REM Quick YOLO mode Codex runner
REM Usage: codex-yolo "your task description"
REM
REM WARNING: YOLO mode bypasses all approvals and sandboxing!
REM Only use in hardened environments (Docker, VM, CI/CD).

if "%~1"=="" (
    echo Usage: codex-yolo "your task description"
    echo.
    echo WARNING: YOLO mode bypasses all approvals and sandboxing!
    echo Only use in hardened environments.
    exit /b 1
)

echo.
echo === CODEX YOLO MODE ===
echo WARNING: No approvals, no sandbox!
echo Task: %*
echo.

codex exec --dangerously-bypass-approvals-and-sandbox %*

echo.
echo === Done ===
echo Check changes with: git diff --stat
