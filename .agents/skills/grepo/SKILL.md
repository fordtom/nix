---
name: grepo
description: "Guide for working with grepo, a CLI that manages project-local read-only reference repositories. Use this skill only when a project contains a `.repos/` directory with a `.lock` file alongside symlinks into a shared cache, and the user is asking you to research something from another repository or implied local checkout."
---

# grepo

grepo pins recurring read-only reference sources into a project-local `.repos/` directory. `.repos/.lock` is the tracked source of truth; each `.repos/<alias>` is a generated symlink into a shared cached snapshot (a plain read-only tree with `.git` stripped).

Legacy projects may still use `grepo/` instead of `.repos/`; grepo discovers either, but warns on the legacy path. Override the directory with `grepo --dir <name>` or `GREPO_DIR`.

To get started and read the skill/instructions related to your current binary, run `grepo skill` to print the skill contents.
