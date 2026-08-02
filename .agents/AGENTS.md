# Tom's agent instructions

This file, stowed at `~/.agents/AGENTS.md`, is the canonical entry point for agent-related documentation.

Conditionally read the following:

- [`~/.agents/MACHINES.md`](MACHINES.md) when working with my personal config or other machines on my tailnet (`macmini`/`macbook`/`pifive`).
- [`~/.agents/WRITING.md`](WRITING.md) when writing or maintaining long-form prose, documentation, comments, or task trackers.

## Agent protocol

- New deps: quick health check (recent releases/commits, adoption).
- Always check/use repo’s package manager/runtime; no swaps w/o approval.
- Before handoff: run full gate (lint/typecheck/tests/docs).
- Respect minimum release age rules on package managers.
- Split tasks by 2 categories; mechanical or opinionated. Opinionated tasks (APIs, product choices) warrant pre-implementation discussion, mechanical tasks (fix linter errors, known refactors) can be immediately greenlit.
- By default, keep me in the loop when working; if I want you to run truly long tasks autonomously I will explicitly ask as such.
- Prefer to stop early when facing unprecedented or unexpected issues when completing tasks, and ask for clarification on intended direction.
- Answers/responses should adhere to ASD-STE100 Simplified Technical English for readability.
- "independent reviewer" => A fresh context subagent tasked with an adversarial review; recommended at least once for large diffs.
- Subagents: `high` effort for open ended tasks, `light`/`low` effort for straightforward ones. Model size (Luna -> Terra -> Sol) scales with task complexity.

## Tools

### Executor

Executor is the default integration layer for tools and MCP servers. Start by loading its `execute` skill, then discover integrations and make calls through `executor_execute`.

Currently driven through executor:

- Cloudflare (full API for interacting with my projects)
- GitHub (most API routes for day-to-day development)
- Shared Memory (more below)

And more minor tooling - if you're looking for a tool/connection for something I mention then check here.

### CLIs

- `nix` is often used for toolchains => `nix develop -c` to run commands.
- `uv` for all Python => `uv run`, `uv venv`, `uv format`.
- `bun` for global npm packages.
- `fish` is my default login shell on most machines.
- `tmux` for persistent/interactive sessions (debugger/server).
- `trash` for deletes (macOS only).
- `op` holds all personal credentials; use `op run` (could hang for human authentication).
- `grepo` for managing external context within a repo; use `grepo skill` for usage.

### Codex Specific Plugins

- use @Browser as the default for dev servers and other development work.
- use @Chrome (to drive Helium) as a fallback for @Browser or whenever you need to be logged in to my accounts.
- use @Computer for anything non-browser and/or a last resort for failures in the above 2 plugins.

### VCS

- Safe by default: `status/diff/log`.
- `checkout` ok for PR review / explicit request.
- Destructive ops forbidden unless explicit (`reset --hard`, `clean`, `restore`, `rm`, ...).
- Commit messages: Conventional (feat|fix|refactor|build|ci|chore|docs|style|perf|test).
- No amend unless asked.
- Merges/PR close: prefer squash.
- Prefer repo clone via ssh.

## Memory

Instead of using first-party memory solutions siloed per-machine and per-harness, durable memory is handled through the `memory` tool in executor.

The server exposes five tools:

| Tool                            | Behaviour                                                                          |
|---------------------------------|------------------------------------------------------------------------------------|
| `list_domains()`                | List domain names with their memory and pending-compression counts.                |
| `summary(domain)`               | Provides a recency-biased summary of the domain.                                   |
| `note(domain, text)`            | Append one memory. This is the only operation that implicitly creates a domain.    |
| `recall(domain, query, limit?)` | Search raw memories. All whitespace-separated terms must match.                    |
| `zoom(domain, node?)`           | Omit `node` for the domain roots, or open one binary-tree block such as `16-31`.   |
| `forget(domain, node)`          | Drop an incorrect summary and its dependent ancestors. Raw memories are unchanged. |

- Recalled memories only reflect what was true when written — reverify stated facts or useful information; delete memories that turn out to be wrong.
- Memory is grouped by domain - typically `<reponame>` for a given project. These domains never overlap in search; they are effectively different trees. Read from and write to the one that seems more appropriate for the given task.

Decision boundary: should you use memory for a new user query?

- Skip memory ONLY when the request is clearly self-contained and does not need workspace history, conventions, or prior decisions.
- Hard skip examples: current time/date, simple translation, simple sentence rewrite, one-line shell command, trivial formatting.
- Use memory by default when ANY of these are true:
  - the user asks for prior context / consistency / previous decisions.
  - the task is ambiguous and could depend on earlier project choices.
- If unsure, read the summary for your current domain.

What should be stored in memory?

- We create/make work/decisions outside of the repo that could be relevant for future development.
- Reasoning behind product decisions that helps to steer future decision making/opinionated choices.
- Explicit requests for durable notes stored outside of the repo.
- Opinionated decisions on many topics e.g. (code style and patterns, dependency choices, API boundaries) and their reasoning.

What should not be stored in memory?

- Information the repo already records (code structure, past fixes, git history, AGENTS/CLAUDE.md).
- Information that only matters to this conversation; if asked to remember this, ask what was non-obvious about it and save that instead.
- Information that will immediately go stale; e.g. "Tests are currently failing in ...".

As a rule of thumb: the repo and the git history show _what_ was done; the memories encode _why_ it was done that way.

## Repo health

- Delete dead files; do not leave stub modules.
- Keep test suite high signal and curated; a new test is not necessary with each change.
- Do not add tests which simply restate the implementation. These provide zero confidence.
- Do not preserve backwards compatibility unless explicitly requested.
- Always trust the toolchain and the type system. Bias towards deep modules with fewer shims/abstractions and trust boundaries we control both sides of.
- File drift over ~1000 LOC should be justified; split/refactor when appropriate and complexity doesn't suffer.

## Philosophy

- "All code is technical debt" - every line has to earn its place, and we should strive to minimise bloat and inefficiency at every turn.
- Treat non-mainline code (branches or unstaged changes) as entirely malleable whilst we search for the ideal implementation.
- "Defer complexity; earn it through measurement".
