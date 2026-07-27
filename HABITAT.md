# Working in a habitat

You are in a **habitat** — a workspace over a group of related repos, symlinked into this directory.
Work across them **from here**; reach into a member by its symlink (e.g. `./icd10cm/…`). This habitat's
own `CLAUDE.md` (loaded alongside this file) carries the domain map, rules, and the specific work-routing.

## How to work here

- **Route each task to the member repo that owns it** — see this habitat's `CLAUDE.md` for the routing.
  Code, seeds, and beads all go in **that member**, not here.
- **Planning & deliberation → seeds, in the owning member's `.seeds`.** cd into that member (via its
  symlink here) and run `seeds …` there — **new to the workflow? run `seeds prime` first** (and `bd prime`
  for tasks); they print the AI-oriented cheat sheet. Plan mode is ephemeral — **seeds are the durable
  record**, so capture plans as seeds. Tasks → that member's `bd`.
- **No habitat-level seeds or beads** (yet) — a habitat has none of its own; everything lands in members.
- **A `seeds` command/skill invoked from the habitat fans out across *every* member's `.seeds`.**
  Because the habitat has no seeds DB of its own, running something like `/transcript-seeds` (or any
  `seeds` operation) here means **all member-repos' seeds databases should be consulted and modified as
  appropriate** — route each candidate to the member that owns it (per this habitat's `CLAUDE.md` routing),
  and one invocation can legitimately touch several members. Don't treat the cwd basename as a single
  target slug — there may be no member (or extraction) by that name. Honor pre-flight **per member**
  (clean tree, `habituate activity`, coordinate before clobbering): they're independent git repos, so a
  dirty or actively-worked member is skipped/flagged on its own without blocking the clean ones.
- **Members are habitat-agnostic.** A member may belong to several habitats and is not wired
  to know about any of them; don't add habitat knowledge or cross-repo references into a member. Working
  *directly* in a member repo is rare and deliberate — with no habitat context by default. If you think you
  need to cross this line, flag it and check with Ryan first.
- **Watch for concurrent activity.** Because a member can belong to several habitats — and Ryan may be
  working it in parallel — **another agent may already have its fingers in a shared member.** Before sweeping
  changes, run **`habituate activity <habitat>`** to flag members with in-flight work (dirty tree / git lock /
  uncommitted `.beads`-`.seeds`), and coordinate rather than clobber.

## Managing habitats (you run the CLI, not the human)

- `habituate create <name> <member>…` — scaffold a new habitat, then **author** its `CLAUDE.md` (map + rules + routing) by hand. (Unsure of the members? `habituate create <name> --from <parent>` suggests a parent dir's git-repo children, flagging nested/dormant — it only prints, you re-run `create` with the set you pick.)
- `habituate doctor [<name>]` — verify symlinks, git repo, parent symlink.
- `habituate list` / `habituate path <name>` — enumerate / locate.

---
*Lives at `habituate/HABITAT.md`, symlinked as `habitats/CLAUDE.md` so it auto-loads for every habitat.
General only — each habitat's own `CLAUDE.md` holds the domain specifics.*
