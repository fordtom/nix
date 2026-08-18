# Tom's agent instructions

## Agent protocol

- Answers/responses should adhere to ASD-STE100 Simplified Technical English for readability. Default to natural prose over bullet-heavy answers.
- Split tasks by 2 categories; mechanical or opinionated. Opinionated tasks (APIs, product choices) warrant pre-implementation discussion, mechanical tasks (fix linter errors, known refactors) can be immediately greenlit.
- By default, keep me in the loop when working; if I want you to run truly long tasks autonomously I will explicitly ask as such.
- Prefer to stop early when facing unprecedented or unexpected issues when completing tasks, and ask for clarification on intended direction.
- "independent reviewer" => A fresh context subagent tasked with an adversarial review; recommended at least once for large diffs.
- Subagents: `high` effort for open ended tasks, `light`/`low` effort for straightforward ones. Model size (Luna -> Terra -> Sol) scales with task complexity.
- Before handoff: run full gate (lint/typecheck/tests/docs).
- Encountered friction (flaky command, missed tool call, confusing or undocumented step)? => `papercut 'message'` logs this locally for later. One or two sentences explaining what you were doing and what got in the way. Do this proactively in the moment.

## Tools

- `nix` is often used for toolchains => `nix develop -c` to run commands.
- `gh` for PRs/Issues and other GitHub interaction.
- `uv` for all Python => `uv run`, `uv venv`, `uv format`.
- `pnpm` for global npm packages.
- `fish` is default login shell on most machines.
- `tmux` for persistent/interactive sessions (debugger/server).
- `trash` for deletes when available.
- `op` holds all personal credentials; use `op run` (could hang for human authentication).
- `grepo` for managing external context within a repo; use `grepo skill` for usage.

## Codex Specific Plugins

- use @Browser as the default for dev servers and other development work.
- use @Chrome (to drive Helium) as a fallback for @Browser or whenever you need to be logged in to my accounts.
- use @Computer for anything non-browser and/or a last resort for failures in the above 2 plugins.

## Security

- `sfw` socket firewall to be prefixed to ALL PACKAGE MANAGER CALLS - PNPM, CARGO, UV; if missing run `pnpm add -g sfw`.
- New deps: quick health check (recent releases/commits, adoption).
- Always check/use repo’s package manager/runtime; no swaps w/o approval.
- Respect minimum release age rules on package managers.

## VCS

- Safe by default: `status/diff/log`.
- `checkout` ok for PR review / explicit request.
- Destructive ops forbidden unless explicit (`reset --hard`, `clean`, `restore`, `rm`, ...).
- Commit messages: Conventional (feat|fix|refactor|build|ci|chore|docs|style|perf|test).
- No amend unless asked.
- Merges/PR close: prefer squash.
- Prefer repo clone via ssh.

## Repo health

- Delete dead files; do not leave stub modules.
- Keep test suite high signal and curated; a new test is not necessary with each change.
- Do not add tests which simply restate the implementation. These provide zero confidence.
- Do not preserve backwards compatibility unless explicitly requested.
- Always trust the toolchain and the type system. Bias towards deep modules with fewer shims/abstractions and trust boundaries we control both sides of.
- File drift over ~1000 LOC should be justified; split/refactor when appropriate and complexity doesn't suffer.
- Delete task tracker docs/comments/TODOs rather than updating content/marking as complete.

## Machines and personal configuration

- `~/config` is the source for nix-darwin and Home Manager configuration plus dotfiles.
- Home paths can be symlinks into this checkout. Edit the source then run `stow .` inside `~/config`.
- 3 machines: `macbook`/`macmini`/`pifive`; access via ssh over Tailscale => use `tailscale status` for hosts/IPs.
- Macs use nix-darwin with shared user configuration in `users/tomford/home-manager.nix`. Pi has Nix only for project environments and builds.
- When editing machine nix configs leave rebuild/application step to me. Project flakes are fine to edit/run.

## Writing guidance

- Organise content around the task. Give each section/paragraph one topic. Create emphasis through order and structure.
- Define unavoidable jargon on first use. Use exact names, numbers and dates.
- Use sentence case headings and descriptive link text. Use numbered lists only for ordered items.
- Lead with affirmative scope; minimize negative framing.
- Code should be self-documenting; implementation docs live in code rather than markdown sidecars.
- Docs should only reflect current behaviour/contracts; git diff is the place for historical context.
- When writing on my behalf => British English; minimise/drop filler sentences; clear, succinct and to the point.

## Philosophy

- "All code is technical debt" - every line has to earn its place; strive to minimise bloat and inefficiency at every turn.
- Treat non-mainline code (branches or unstaged changes) as entirely malleable whilst we search for the ideal implementation.
- "Defer complexity; earn it through measurement".
- "As much as needed, as little as possible".
