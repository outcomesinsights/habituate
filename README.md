# Habituate — give coding agents the institutional knowledge a repo can't hold

**Habituate** builds *habitats*: named groups of related repositories that share one hand-authored `CLAUDE.md` of institutional knowledge — the domain rules plus a map of how the repos relate — so an AI coding agent working across them *already knows the domain* instead of being re-taught it every session.

> **Early days.** This is a young, opinionated tool we built for our own multi-repo work and are sharing while it's still taking shape. Expect rough edges, in-flux conventions, and assumptions that fit our setup. It's a handful of plain files and one bash script — legible enough to read in a sitting and bend to yours.

## The problem

We kept re-explaining the same institutional knowledge to a forgetful agent. A recurring example: working in one repo, the agent would assume an upstream dependency churns constantly and that *we* had to figure out how to reintroduce our customizations — not knowing a sibling repo already handles exactly that, automatically. Third time, same conversation.

The knowledge exists — in our heads, scattered across repos — but it isn't *at hand* for the agent at the moment it works. A habitat puts it at hand.

## What a habitat is

A **habitat** is deliberately tiny: a directory that

1. **symlinks its member repos** into itself, and
2. carries **one `CLAUDE.md`** with the domain's authored rules + a short map of the members and how they relate.

That's the whole idea. You put your working directory *into* a habitat and start an agent there; because the habitat's `CLAUDE.md` is the current directory's `CLAUDE.md`, it auto-loads, and the agent reaches into each member repo through its symlink already knowing the rules and which repo owns what.

A habitat is a **view over** the repos, not a store that copies them. Members stay untouched and habitat-agnostic — a repo can belong to several habitats and doesn't need to know about any of them.

## What we hope to accomplish

- **Stop re-explaining.** The rules an agent keeps getting wrong are written down once, where the agent will actually load them.
- **Coordinate across repos.** An agent in a habitat knows the map — which member owns which kind of work — and routes code, tasks, and planning to the right repo.
- **Stay legible.** No database, no build step, no synthesis engine. If you can't read the whole thing at a glance, we consider that a bug.

## Design principles (hard constraints)

1. **Legibility above all.** Small, boring, inspectable. No daemon, no database, no build step, no synthesis engine.
2. **Authored, not synthesized.** The rules are facts we *write once*, not distilled from documents by machinery — so there's deliberately no ingest / re-index / invalidation layer to rot.
3. **Minimize invented conventions.** Real directories, real symlinks, a real `CLAUDE.md`, standard markdown. Nothing only our own tooling can follow.
4. **Privacy by placement.** The knowledge layer is where private, domain-specific rules live — and it is never committed into the member repos, which may be public.

These react to real failures we'd already paid for: coupling "where are my projects" to a stateful server that grew orchestration limbs and rotted into something no one could read; and freezing agent knowledge into a built artifact divorced from the code it described. Habitat knowledge stays in plain, live files next to the work.

## The CLI

A small bash CLI does the mechanical parts (agents are expected to run it; the authored knowledge stays hand-written):

- `habituate create <name> <member>…` — scaffold a habitat: symlink the members, stub a `CLAUDE.md`, `git init` + commit. Then you **author** the map + rules by hand. (`--from <parent>` suggests a parent directory's git-repo children — flagging nested/dormant ones — instead of naming members.)
- `habituate doctor [<name>]` — verify the symlinks, git repo, and structure.
- `habituate activity [<name>]` — flag members with in-flight work before making sweeping changes.
- `habituate ready [<name>]` / `habituate members [<name>]` — survey open work / list members across a habitat.
- `habituate hop <name>` — `cd` in and open a tmux session (via a shell wrapper).

No build, no dependencies beyond `bash` and `git` (plus optional [`just`](https://github.com/casey/just) + [`shellcheck`](https://www.shellcheck.net/) for the lint check).

## Status

Early and evolving. The tool works and we use it daily, but the conventions are still settling as we learn what habitats want to be. Ideas and feedback are welcome — with the caveat that it's shaped around our own workflow for now.

---

*A project of [Outcomes Insights](https://github.com/outcomesinsights).*
