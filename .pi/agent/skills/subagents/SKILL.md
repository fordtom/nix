---
name: subagents
description: Use when the user asks Pi to delegate work to subagents or names a Pi, Claude Code, or Codex subagent.
---

# Subagents

Each subagent is headless, has its own context window, cannot see the parent conversation, cannot ask the user, and cannot spawn subagents or workflows. Give every child a self-contained prompt with paths, constraints, and the expected report.

## Harnesses

- `pi`: best default. Omit `model` and `reasoning_effort` to inherit the parent model and thinking level. Do not select an Anthropic-provider Pi model.
- `claude`: Claude Code using its authenticated CLI. Prefer the latest Fable model with high effort unless the user requests another model.
- `codex`: Codex CLI using its authenticated CLI. Prefer `gpt-5.6-sol` with high effort unless the user requests another model.

The shared reasoning scale is `off`, `minimal`, `low`, `medium`, `high`, `xhigh`, and `max`. Each harness maps it to its native controls.

## Spawn and manage

Call `subagent_spawn` with a complete `prompt`, short `name`, chosen `harness`, and optional `working_dir`, `model`, and `reasoning_effort`. At most four subagents run concurrently.

- `subagent_check({ id })`: inspect without blocking.
- `subagent_list()`: list all runs.
- `subagent_wait({ ids })`: block only when the results are required to proceed.
- `subagent_cancel({ ids })`: stop runs while preserving partial transcripts.
- `/subagents`: inspect or take over a run interactively.
- `/btw`: ask a side question while the main agent continues.

Results return automatically. After spawning, continue useful parent work instead of immediately waiting.
