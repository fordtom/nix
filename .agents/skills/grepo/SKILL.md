---
name: grepo
description: "Guide for working with grepo, a CLI that manages project-local read-only reference repositories. Use this skill only when a project contains a `.repos/` directory with a `.lock` file alongside symlinks into a shared cache."
---

# grepo

grepo pins recurring read-only reference sources into a project-local `.repos/` directory. `.repos/.lock` is the tracked source of truth; each `.repos/<alias>` is a generated symlink into a shared cached snapshot (a plain read-only tree with `.git` stripped).

Legacy projects may still use `grepo/` instead of `.repos/`; grepo discovers either, but warns on the legacy path. Override the directory with `grepo --dir <name>` or `GREPO_DIR`.

To get started and read the skill/instructions related to your current binary, run `grepo skill` to print the skill contents.

Note that if you are working within a devspace, it's likely that the .repos/ dir is instead managed by `ds context` which implements a simplified subset of grepo's capabilities (git backed only, by refs, no tarballs or manifest parsing). you can read `grepo skill` for context or run `ds skill context` if it exists.
