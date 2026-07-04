---
name: devspace
description: "Guide for working inside a devspace checkout — a disposable jj workspace whose repository state syncs to a shared server, driven by the `ds` CLI. Use whenever a directory looks like a jj repo but plain `jj` fails (e.g. 'Unsupported commit backend type devspace'), when a `.git` directory exists but git reads return junk or mutations fail on permissions, when the user mentions devspace / `ds add` / a devspace checkout, or when `ds` is the prescribed VCS tool. Explains detection, the ds verbs, publishing via bookmarks, and checkout lifecycle."
---

# devspace

Devspace replicates jj repository state across disposable real-file checkouts through a shared server. A devspace checkout looks like a jj workspace, but plain `jj` and `git` both fail there: jj errors with an unsupported `devspace` commit backend, and the `.git` directory is a read-only Nix compatibility shim (git reads return junk, git mutations fail on permissions). That is deliberate — `ds` is the only VCS surface.

If you find yourself in one: work in the change you've been given, and do not interact with the VCS beyond snapshots/describe unless told to. `ds skill` prints the canonical embedded guide; prefer it if the `ds` binary is newer than this skill.

## Daily work

- Edit files normally. jj snapshots the working copy on every command.
- Run jj through `ds`: `ds status`, `ds log`, `ds diff`, `ds new`, `ds describe`. Anything that is not a devspace verb falls through to jj, so normal jj knowledge applies.
- Give your change a name early: `ds describe -m "..."`. Unnamed changes are hard to identify in a shared `ds log`.
- `@` is this workspace's working-copy commit, exactly as in jj.
- `ds info --json` prints the repo name, workspace id, server address, and checkout root.
- Read-only reference repos under `.repos/` are managed with `ds context <sync|list|update>` (grepo's semantics).

## Publishing through Git

Bookmarks are the publishing boundary. Git commands run on the server against the canonical repo, never locally: `ds git fetch` / `ds git push`. To publish, set a bookmark on the tip you want (`ds bookmark set <name> -r @-`) and `ds git push -b <name>`. In `ds git` arguments, exact `@`/`@-`/`@+` resolve to this workspace's commits; anything else must be a concrete commit, change id, or bookmark.

## Sharing the repo

Other agents and humans may be in sibling checkouts of the same repo simultaneously. `ds log` shows their heads as `<workspace-id>@` — check before building on shared history. Do not rewrite another workspace's commits; on divergent-change or immutable errors, keep your work and report the conflict instead of force-resolving. Stale working-copy states heal automatically (`ds update-stale` for the manual path).

## Blocked / lifecycle

- `ds workspace ...` is blocked; lifecycle belongs to `ds add`, `ds list`, `ds remove`, `ds update-stale`, `ds info`.
- One-shot config overrides (`--config*`) are rejected; persist settings with `ds config set`.
- The checkout is disposable but never delete the directory yourself — `ds remove` is the only correct ending (syncs final state, forgets the workspace server-side, then deletes). Leave removal to the operator unless asked.
