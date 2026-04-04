# SpecLeap Framework Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.1.0] - 2026-04-04

### Added

#### 🎯 13 New Agent Skills (Total: 33)

**Design & Frontend (3):**
- `web-design-guidelines` (vercel-labs) — Vercel-style design patterns
- `vercel-composition-patterns` (vercel-labs) — React composition best practices
- `agent-browser` (vercel-labs) — Browser automation for testing

**Brainstorming & Documentation (2):**
- `brainstorming` (obra/superpowers) — Ideation techniques for spec refinement
- `pdf` (anthropics) — PDF analysis and manipulation

**DevOps & Infrastructure (2):**
- `terraform-engineer` (jeffallan) — Infrastructure as Code with Terraform
- `monitoring-expert` (jeffallan) — Performance profiling and monitoring

**Mobile Development (2):**
- `react-native-expert` (jeffallan) — React Native mobile development
- `flutter-expert` (jeffallan) — Flutter cross-platform development

**Documentation (1):**
- `code-documenter` (jeffallan) — Automatic code documentation generation

**Security (1):**
- `security-reviewer` (jeffallan) — Security review and pentesting patterns

**Testing Advanced (2):**
- `playwright-expert` (jeffallan) — E2E testing with Playwright
- `test-master` (jeffallan) — Advanced testing methodologies

**Total:** 20 → **33 skills** (+65% improvement)

### Changed
- Updated `scripts/install-skills.sh` header to reflect 33 total skills
- Updated `README.md` skills section with complete categorization
- Bumped version to `2.1.0` (minor version: new features added)

### Added - 2026-03-20

#### 🛡️ 3-Layer Validation System
- **Git hooks pre-commit** (`scripts/install-git-hooks.sh`) - Automatic validation in <5 seconds
  - Validates syntax, linters, formatters
  - Prevents CONTRATO.md modifications (immutable)
  - Prevents debug code (console.log, var_dump)
  - Rejects commits that fail validation
- **Full validation in `implementar` command** - Exhaustive checks (1-5 min)
  - Unit tests + integration tests
  - Validation vs CONTRATO.md and specs
  - Coverage >= 80% requirement
  - Only pushes if ALL tests pass
- **CodeRabbit integration** - Deep PR review (5-10 min)
  - Architecture, security, business logic validation
  - Automatic comments on PRs
  - Profile "assertive" configured
  - `.coderabbit.yaml` included

#### ❓ Help Command & Discoverability
- Created `.commands/ayuda.md` - Complete command reference
- Lists ALL available commands (conversational + CLI)
- Explains when to use each workflow
- Updated `CLAUDE.md` to auto-detect `ayuda`, `help`, `comandos`

#### 📚 Documentation & Clarity
- **OpenSpec vs Conversational workflows** - Clear distinction when to use each
  - Conversational: Small teams, rapid development
  - OpenSpec CLI: Enterprise, formal proposals, traceability
  - Both can coexist and complement each other
- **CodeRabbit clarification** - Works with BOTH workflows, not just OpenSpec
- **README.md** - Complete system explanation with 3-layer validation
- **SETUP.md** - Git hooks installation as Step 4
- **scripts/README.md** - Scripts reference guide

### Changed - 2026-03-20

#### URLs & Branding
- All repository URLs updated: `specleap` → `specleap-framework`
- "Conceptual Creative" → "SpecLeap Community/Contributors"
- "Pamela Anderson" → "SpecLeap Contributor" (in examples)
- Package.json repository URLs corrected

#### Documentation Links
- Fixed broken `docs/` references (directory was removed)
- Updated to point to actual existing files
- `.commands/`, `openspec/`, `.agents/` references

### Removed - 2026-03-20

#### Security & Privacy
- `openspec/cli/jira.sh` - Private Jira credentials
- `docs/` directory (7 files, 2,630 lines) - Old ArchSpec landing with private references
- All mentions of:
  - conceptualcreative.com domains
  - Private Atlassian URLs
  - Personal emails (p.anderson@, gidharvey@)
  - Internal project names

### Fixed - 2026-03-20

- Survey count corrected: 58 questions (not 56)
- Git ignore: Added `kofi-images/` to prevent accidental push

---

## Statistics - 2026-03-20

**Files changed:** 24  
**Lines added:** ~2,500  
**Lines removed:** ~2,650 (mostly private data cleanup)  
**Commits:** 4

**Key improvements:**
- ✅ 100% private data removed
- ✅ Quality validation system implemented
- ✅ Complete discoverability (help command)
- ✅ Clear workflow distinction (conversational vs CLI)
- ✅ Professional documentation

---

## Migration Guide

### For Existing Users

#### To enable git hooks:
```bash
cd your-project
bash scripts/install-git-hooks.sh
```

#### To discover all commands:
In chat with your AI assistant:
```
ayuda
```

Or in terminal:
```bash
openspec --help
```

#### To understand when to use CLI vs conversational:
- **Small team (1-3 devs):** Use conversational commands in chat
- **Large team (4+ devs):** Use OpenSpec CLI for formal proposals
- **Both:** Use conversational for daily work, CLI for big changes

---

## Coming Soon

- [ ] Integration tests for git hooks
- [ ] CI/CD templates
- [ ] More Agent Skills (TIER 2)
- [ ] Docker support
- [ ] VS Code extension

---

**Full details:** See individual commit messages and PR descriptions.
