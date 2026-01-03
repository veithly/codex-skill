#!/usr/bin/env node
/**
 * npm postinstall script for Codex Skill
 * Automatically installs skill files to Claude Code directories
 */

import { copyFileSync, mkdirSync, existsSync, chmodSync } from 'fs';
import { join, dirname } from 'path';
import { homedir, platform } from 'os';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
const projectRoot = dirname(__dirname);

const CLAUDE_DIR = join(homedir(), '.claude');
const COMMANDS_DIR = join(CLAUDE_DIR, 'commands', 'codex');
const AGENTS_DIR = join(CLAUDE_DIR, 'agents');
const SCRIPTS_DIR = join(CLAUDE_DIR, 'scripts');

const isWindows = platform() === 'win32';

console.log('');
console.log('╔═══════════════════════════════════════════════════╗');
console.log('║     Codex Skill for Claude Code - Installer       ║');
console.log('╚═══════════════════════════════════════════════════╝');
console.log('');

// Create directories
const dirs = [COMMANDS_DIR, AGENTS_DIR, SCRIPTS_DIR];
for (const dir of dirs) {
  if (!existsSync(dir)) {
    mkdirSync(dir, { recursive: true });
    console.log(`[+] Created: ${dir}`);
  }
}

// Copy files
const filesToCopy = [
  { src: 'SKILL.md', dest: join(COMMANDS_DIR, 'SKILL.md') },
  { src: 'reference.md', dest: join(COMMANDS_DIR, 'reference.md') },
  { src: 'agent.md', dest: join(AGENTS_DIR, 'codex.md') },
];

// Platform-specific scripts
if (isWindows) {
  filesToCopy.push(
    { src: join('scripts', 'codex-runner.ps1'), dest: join(SCRIPTS_DIR, 'codex-runner.ps1') },
    { src: join('scripts', 'codex-yolo.cmd'), dest: join(SCRIPTS_DIR, 'codex-yolo.cmd') }
  );
} else {
  filesToCopy.push(
    { src: join('scripts', 'codex-runner.sh'), dest: join(SCRIPTS_DIR, 'codex-runner.sh'), executable: true },
    { src: join('scripts', 'codex-yolo.sh'), dest: join(SCRIPTS_DIR, 'codex-yolo.sh'), executable: true }
  );
}

for (const file of filesToCopy) {
  const srcPath = join(projectRoot, file.src);
  if (existsSync(srcPath)) {
    try {
      copyFileSync(srcPath, file.dest);
      console.log(`[+] Installed: ${file.src}`);

      // Make executable on Unix
      if (file.executable && !isWindows) {
        chmodSync(file.dest, '755');
      }
    } catch (err) {
      console.error(`[-] Failed to copy ${file.src}: ${err.message}`);
    }
  } else {
    console.warn(`[!] Source not found: ${srcPath}`);
  }
}

console.log('');
console.log('╔═══════════════════════════════════════════════════╗');
console.log('║            Installation Complete!                  ║');
console.log('╠═══════════════════════════════════════════════════╣');
console.log('║                                                    ║');
console.log('║  Usage in Claude Code:                             ║');
console.log('║    /codex Fix the bug in src/api.ts               ║');
console.log('║    /codex --mode=yolo Implement feature           ║');
console.log('║                                                    ║');
console.log('║  Ensure OPENAI_API_KEY is set!                    ║');
console.log('║                                                    ║');
console.log('╚═══════════════════════════════════════════════════╝');
console.log('');
