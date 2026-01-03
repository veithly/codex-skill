#!/usr/bin/env node
/**
 * npm uninstall script for Codex Skill
 * Removes skill files from Claude Code directories
 */

import { rmSync, existsSync } from 'fs';
import { join } from 'path';
import { homedir } from 'os';

const CLAUDE_DIR = join(homedir(), '.claude');
const COMMANDS_DIR = join(CLAUDE_DIR, 'commands', 'codex');
const AGENTS_DIR = join(CLAUDE_DIR, 'agents');
const SCRIPTS_DIR = join(CLAUDE_DIR, 'scripts');

console.log('');
console.log('Codex Skill - Uninstaller');
console.log('=========================');
console.log('');

const filesToRemove = [
  join(COMMANDS_DIR, 'SKILL.md'),
  join(COMMANDS_DIR, 'reference.md'),
  join(AGENTS_DIR, 'codex.md'),
  join(SCRIPTS_DIR, 'codex-runner.ps1'),
  join(SCRIPTS_DIR, 'codex-runner.sh'),
  join(SCRIPTS_DIR, 'codex-yolo.cmd'),
  join(SCRIPTS_DIR, 'codex-yolo.sh'),
];

for (const file of filesToRemove) {
  if (existsSync(file)) {
    try {
      rmSync(file);
      console.log(`[+] Removed: ${file}`);
    } catch (err) {
      console.error(`[-] Failed to remove ${file}: ${err.message}`);
    }
  }
}

// Try to remove empty codex directory
if (existsSync(COMMANDS_DIR)) {
  try {
    rmSync(COMMANDS_DIR, { recursive: true });
    console.log(`[+] Removed: ${COMMANDS_DIR}`);
  } catch (err) {
    // Directory might not be empty, that's ok
  }
}

console.log('');
console.log('Codex skill uninstalled successfully.');
console.log('');
