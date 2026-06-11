---
name: autoreview
description: Run a fresh read-only Codex subagent review as a closeout check on dirty work, a branch, or a commit before handoff, commit, push, PR update, or ship.
---

# Auto Review

Run one fresh read-only Codex subagent as a second-pass code review. This is a closeout check, not approval routing and not a substitute for tests or live proof.

Use when the user asks for autoreview, Codex review, a second-model review, or when non-trivial code edits need a final review pass before handoff, commit, push, PR update, or ship.

## Contract

- The caller agent chooses the review target and passes it explicitly to the review subagent.
- Use a new subagent with fresh context. Do not reuse the current conversation as the reviewer's working context.
- The review subagent is read-only: no file edits, no formatting, no test mutation, no git mutation.
- Spawn exactly one review subagent per pass. Do not run a swarm or split the review by area unless the user explicitly asks.
- Treat review output as advisory. The caller agent verifies every finding in the real code path before changing anything.
- Reject speculative risks, style-only feedback, unrealistic edge cases, and fixes that add more complexity than the defect is worth.
- Prefer the smallest fix at the right ownership boundary. If a finding exposes a repeated bug class, inspect the touched scope for siblings.
- If a review-triggered fix changes code, rerun focused tests and rerun autoreview.
- Keep going until the review subagent gives a clear go, or until the caller agent consciously rejects the remaining finding with a concrete reason.
- Do not push just to review. Push only when the user requested push, ship, or PR update.
- Be patient. Fresh-context review can take a while on large diffs.

## Pick Target

The caller agent decides what is under review before spawning the subagent.

Use the current repository state to choose one of these targets:

- Dirty local work: staged, unstaged, and relevant untracked files.
- Branch or PR work: diff against the actual PR base when an open PR exists; otherwise diff against the appropriate base branch.
- Committed single change: the specified commit, usually `HEAD`.

Do not force local review after committing. Use branch or commit review for committed work.

Pass the exact target to the subagent. Include the repository path, review mode, base or commit when relevant, and any user-supplied review notes.

## Subagent Prompt

Spawn a single read-only review subagent. The prompt should be specific enough that the reviewer can reconstruct the diff itself from git.

Use this shape:

```text
Run a read-only code review of this target.

Repository: <absolute repo path>
Target: <dirty local work | branch diff | commit>
Base or commit: <base ref, commit ref, or none>
Extra context: <short notes, tests already run, user concerns, or none>

Rules:
- Do not modify files.
- Do not run formatters, package installs, generators, or git mutation commands.
- You may inspect files, git diff, git status, git log, and read-only command output.
- Report only actionable defects introduced or exposed by this target.
- Prioritize bugs, regressions, concrete security issues, broken user workflows, and meaningful test gaps.
- Reject style-only feedback, speculative risks, and fixes whose complexity is not justified.
- For each finding, include file path, line number, severity, evidence, and the concrete failure mode.
- End with exactly one of:
  - GO: no actionable findings.
  - NOGO: actionable findings listed above.
```

Prefer a subagent role intended for exploration/review. Do not ask it to implement fixes.

## Caller Workflow

After spawning the review subagent:

- Wait for the subagent response.
- Read all findings and verify each one in the real code path.
- Apply only accepted fixes, keeping them small and at the right ownership boundary.
- Rerun focused tests or proof for accepted fixes.
- Rerun autoreview if code changed.
- Stop when the subagent returns GO, or when any remaining NOGO finding is explicitly rejected with a concrete reason.

## Final Report

Include the target reviewed, tests or proof run, accepted and rejected findings with brief reasons, and the final GO result or the exact reason a remaining NOGO finding was rejected.
