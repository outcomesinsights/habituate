# Project Instructions for AI Agents

This file provides instructions and context for AI coding agents working on this project.

<!-- BEGIN BEADS INTEGRATION v:1 profile:minimal hash:6cd5cc61 -->
## Beads Issue Tracker

This project uses **bd (beads)** for issue tracking. Run `bd prime` to see full workflow context and commands.

### Quick Reference

```bash
bd ready              # Find available work
bd show <id>          # View issue details
bd update <id> --claim  # Claim work
bd close <id>         # Complete work
```

### Rules

- Use `bd` for ALL task tracking — do NOT use TodoWrite, TaskCreate, or markdown TODO lists
- Run `bd prime` for detailed command reference and session close protocol
- Use `bd remember` for persistent knowledge — do NOT use MEMORY.md files

**Architecture in one line:** issues live in a local Dolt DB; sync uses `refs/dolt/data` on your git remote; `.beads/issues.jsonl` is a passive export. See https://github.com/gastownhall/beads/blob/main/docs/SYNC_CONCEPTS.md for details and anti-patterns.

## Agent Context Profiles

The managed Beads block is task-tracking guidance, not permission to override repository, user, or orchestrator instructions.

- **Conservative (default)**: Use `bd` for task tracking. Do not run git commits, git pushes, or Dolt remote sync unless explicitly asked. At handoff, report changed files, validation, and suggested next commands.
- **Minimal**: Keep tool instruction files as pointers to `bd prime`; use the same conservative git policy unless active instructions say otherwise.
- **Team-maintainer**: Only when the repository explicitly opts in, agents may close beads, run quality gates, commit, and push as part of session close. A current "do not commit" or "do not push" instruction still wins.

## Session Completion

This protocol applies when ending a Beads implementation workflow. It is subordinate to explicit user, repository, and orchestrator instructions.

1. **File issues for remaining work** - Create beads for anything that needs follow-up
2. **Run quality gates** (if code changed) - Tests, linters, builds
3. **Update issue status** - Close finished work, update in-progress items
4. **Handle git/sync by active profile**:
   ```bash
   # Conservative/minimal/default: report status and proposed commands; wait for approval.
   git status

   # Team-maintainer opt-in only, unless current instructions forbid it:
   git pull --rebase
   git push
   git status
   ```
5. **Hand off** - Summarize changes, validation, issue status, and any blocked sync/commit/push step

**Critical rules:**
- Explicit user or orchestrator instructions override this Beads block.
- Do not commit or push without clear authority from the active profile or the current user request.
- If a required sync or push is blocked, stop and report the exact command and error.
<!-- END BEADS INTEGRATION -->


## What habituate is

**habituate creates *habitats*.** A *habitat* is a named group of related repos sharing one authored `CLAUDE.md` of institutional knowledge, so an agent working across them already knows the domain. This repo is the **tool + deliberation**; materialized habitats live under `habitats/` (gitignored — local, per-machine, each its own git repo). See `README.md` for the vision and design principles.

No build step, no tests — deliberately just plain files (*legibility above all*).

## Structure

- `habitats/<name>/` — one directory per habitat: symlinks to its member repos + one authored `CLAUDE.md` (map + rules + routing). Each habitat is **its own git repo**.
- `HABITAT.md` — the general "how to work in a habitat" instructions, **symlinked as `habitats/CLAUDE.md`** so it auto-loads (walk-up) for every habitat. General only; domain specifics live in each habitat's `CLAUDE.md`.
- `habitats/` is **gitignored here** — habituate tracks the tool + deliberation, not the local views.
- Current habitats: **`vocabulary`** (the OHDSI vocab repos).

## The CLI (agents run this, not the human)

Habitats are created/checked with `bin/habituate` (on `PATH` via home-manager):

- `habituate create <name> <member>…` — scaffold: symlink members (absolute paths), stub a `CLAUDE.md`, ensure the `habitats/CLAUDE.md → HABITAT.md` symlink, `git init` + commit. Then **author** the map/rules/routing by hand. Pass `--from <parent>` instead of members and it suggests the parent's git-repo children (flagging nested/dormant) for you to hand-pick — it prints candidates + a ready-to-edit `create` line and scaffolds nothing.
- `habituate doctor [<name>]` — verify symlinks resolve, git repo, parent symlink present.
- `habituate activity [<name>]` — flag members with in-flight work (another agent / parallel edits) before sweeping changes.
- `habituate hop <name>` — (shell wrapper) cd in + tmux session named `<name>`.

Members are **not** wired — a member may belong to several habitats and stays habitat-agnostic. A habitat loads because you `cd` into it (its `CLAUDE.md` + the `HABITAT.md` parent), not because members import it.

## Deliberation & tasks

- This repo's **own** seeds/beads (`seeds list`, `bd ready`) are for developing **habituate itself**.
- **Inside a habitat**, seeds and beads go in the **member repos** (see `HABITAT.md`) — not here.

## Conventions

- Hard constraints (see `README.md`): **legibility above all**, **authored not synthesized**, **minimize invented conventions**, **privacy by placement**.
- A habitat `CLAUDE.md` / `HABITAT.md` is a ~1-page briefing, **not a wiki**.

## Principles

- Keep member repos agnostic: no habitat identity or cross-repo references in a member's artifacts (lane line; flag + check with Ryan before crossing) — habituate-24, 2026-07-16
