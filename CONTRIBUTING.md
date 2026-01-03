# Contributing to Codex Skill

Thank you for your interest in contributing to the Codex Skill for Claude Code!

## How to Contribute

### Reporting Issues

1. Check existing issues to avoid duplicates
2. Use the issue template if available
3. Include:
   - Clear description of the problem
   - Steps to reproduce
   - Expected vs actual behavior
   - Environment details (OS, Node.js version, Codex CLI version)

### Submitting Pull Requests

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-feature`
3. Make your changes
4. Test on multiple platforms if possible
5. Update documentation as needed
6. Commit with clear messages: `git commit -m "feat: add new feature"`
7. Push to your fork: `git push origin feature/my-feature`
8. Open a Pull Request

### Commit Message Convention

We follow [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `style:` - Code style changes (formatting, etc.)
- `refactor:` - Code refactoring
- `test:` - Adding or updating tests
- `chore:` - Maintenance tasks

### Code Style

- Use clear, descriptive variable names
- Add comments for complex logic
- Follow existing patterns in the codebase
- Ensure scripts work on all platforms

### Testing

Before submitting:

1. Test the installation script on your platform
2. Verify the skill works in Claude Code
3. Check that helper scripts execute correctly
4. Run any existing tests: `npm test`

### Documentation

- Update README.md if adding features
- Update REQUIREMENTS.md if adding dependencies
- Add entries to CHANGELOG.md for notable changes
- Include JSDoc comments for JavaScript functions

## Development Setup

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/codex-skill.git
cd codex-skill

# Install development dependencies (if any)
npm install

# Test installation locally
node scripts/npm-install.js

# Make changes and test
```

## Questions?

Feel free to open an issue for questions or discussions.

Thank you for contributing! 🎉
