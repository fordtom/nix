# Tom's agent instructions

## Tools and Workflows

- `mise` is used for most tools and global toolchains as well as dotfile and config management.
- `nix` is often used for toolchains => `nix develop -c` to run commands.
- `gh` for PRs/Issues and other GitHub interaction.
- `uv` for all Python => `uv run`, `uv venv`, `uv format`.
- `pnpm` for global npm packages.
- `fish` is default login shell on most machines.
- `trash` for deletes when available.
- `op` holds all personal credentials; use `op run` (could hang for human authentication).
- `grepo` for managing external context within a repo; use `grepo skill` for usage.
- `papercut 'message'` for logging addressable friction (flaky command, missed tool call, confusing or undocumented step) locally for later. One or two sentences explaining what you were doing and what got in the way. Do this proactively in the moment.
- "independent reviewer" => A fresh context subagent tasked with an adversarial review; recommended at least once for large diffs.

## Codex Specific Plugins

- @Browser as the default for dev servers and development.
- @Chrome (to drive Helium) as a fallback for @Browser or whenever you need to my login.
- @Computer for non-browser and/or a last resort for failures in the above 2 plugins.

## Security

- Treat `~/code/oss` as untrusted: do not run installs, builds, tests, hooks, or other repository-controlled code until it has been reviewed or Tom explicitly approves; `~/code/projects` to contain only trusted personal repositories.
- Prefix `npm`, `yarn`, `pnpm`, `pip`, `uv`, and `cargo` commands with `sfw`. These are the supported package managers in Socket Firewall Free; Go is not supported. If `sfw` is missing, bootstrap with `pnpm add -g sfw`.
- New deps: quick health check (recent releases/commits, adoption).
- Respect minimum release age rules on package managers.

## VCS

- `checkout` ok for PR review / explicit request.
- Destructive ops forbidden unless explicit (`reset --hard`, `clean`, `restore`, `rm`, ...).
- Commit messages: Scoped over Conventional.
- No amend unless asked.
- Merges/PR close: prefer squash.
- Prefer repo clone via ssh.
- keep remote in sync with local unless told otherwise (i.e. fetch and prune, push when committed).

## Repo health

- Delete dead files; do not leave stub modules.
- Tests must catch plausible behavioural regressions against independently specified expectations. Do not add tests that copy implementation logic, assert their own mock setup, or merely restate constants or structure. Omit tests that add no such confidence; a new test is not required for every change.
- Do not preserve backwards compatibility unless explicitly requested.
- File drift over ~1000 LOC should be justified; split/refactor when appropriate and complexity doesn't suffer.
- Delete task tracker docs/comments/TODOs rather than updating content/marking as complete.

## Machines and personal configuration

- `~/.config/mise` is the source repo for mise boostrap configuration and managed dotfiles. Home paths can be Mise-managed symlinks into this checkout.
- 3 machines: `macbook`/`macmini`/`pifive`; access via ssh over Tailscale => use `tailscale status` for hosts/IPs.

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
- "Defer complexity; earn it through measurement".
- "As much as needed, as little as possible".
