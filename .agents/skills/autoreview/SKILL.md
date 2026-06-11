---
name: autoreview
description: Run a structured Codex code review as a closeout check on dirty work, a branch, or a commit before handoff, commit, push, or ship.
---

# Auto Review

Run the local structured review helper as a closeout check. This is a second-pass code review, not approval routing and not a substitute for tests or live proof.

Use when the user asks for autoreview, Codex review, a second-model review, or when non-trivial code edits need a final review pass before handoff, commit, push, PR update, or ship.

## Contract

- Treat review output as advisory. Verify every finding in the real code path before changing anything.
- Reject speculative risks, style-only feedback, unrealistic edge cases, and fixes that add more complexity than the defect is worth.
- Prefer the smallest fix at the right ownership boundary. If a finding exposes a repeated bug class, inspect the touched scope for siblings.
- If a review-triggered fix changes code, rerun focused tests and rerun autoreview.
- Keep going until the helper returns clean or until you consciously reject the remaining finding with a concrete reason.
- Do not push just to review. Push only when the user requested push, ship, or PR update.
- Be patient. Codex review can take a while on large diffs. Heartbeat lines mean the review process is still healthy.

## Helper Path

Global skill path:

```bash
export AGENTS_HOME="${AGENTS_HOME:-$HOME/.agents}"
export AUTOREVIEW="$AGENTS_HOME/skills/autoreview/scripts/autoreview"
```

Check available options:

```bash
"$AUTOREVIEW" --help
```

## Pick Target

Dirty local work:

```bash
"$AUTOREVIEW" --mode local
```

`--mode uncommitted` is accepted as an alias for `--mode local`.

Branch or PR work:

```bash
"$AUTOREVIEW" --mode branch --base origin/main
```

If an open PR exists, use its actual base:

```bash
base=$(gh pr view --json baseRefName --jq .baseRefName)
"$AUTOREVIEW" --mode branch --base "origin/$base"
```

Committed single change:

```bash
"$AUTOREVIEW" --mode commit --commit HEAD
```

Auto mode chooses dirty local changes first, then a non-main branch against the detected PR base or `origin/main`:

```bash
"$AUTOREVIEW"
```

Do not force local mode after committing. Use branch or commit review for committed work.

## Context

Add extra review notes when useful:

```bash
"$AUTOREVIEW" --mode branch --base origin/main --prompt-file /tmp/review-notes.md
```

Attach evidence files when they materially help review:

```bash
"$AUTOREVIEW" --mode branch --base origin/main --dataset /tmp/evidence.json
```

## Parallel Closeout

Format first if formatting can move line numbers. Then tests and review can run together:

```bash
"$AUTOREVIEW" --parallel-tests "bun run test"
```

If tests or review lead to code edits, rerun the affected tests and rerun autoreview.

## Codex Options

The helper only supports Codex.

Useful knobs:

```bash
"$AUTOREVIEW" --model gpt-5.5 --thinking high
"$AUTOREVIEW" --no-web-search
"$AUTOREVIEW" --stream-engine-output
"$AUTOREVIEW" --dry-run
```

Environment defaults:

```bash
export AUTOREVIEW_MODEL=gpt-5.5
export AUTOREVIEW_THINKING=high
export CODEX_BIN=codex
```

The helper runs `codex exec` with read-only sandboxing, approval disabled, and reviewed-repo instruction/config isolation. It gives Codex a structured JSON schema and fails nonzero when accepted/actionable findings are present.

## Final Report

Include the command used, tests or proof run, accepted and rejected findings with brief reasons, and the final clean autoreview result or the exact reason a remaining finding was rejected.
