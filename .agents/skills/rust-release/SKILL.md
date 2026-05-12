---
name: rust-release
description: "Guide for releasing Rust crates from a repo with a cautious, verification-first workflow. Use when Codex needs to prepare a Rust release, bump crate versions, validate a release candidate, create and push `vX.Y.Z` tags, run `cargo publish`, handle workspace or multi-crate publishing, or figure out whether the latest commit already contains the intended version bump."
---

# Rust Release

Run a Rust release from the repo's actual contract, not from muscle memory. Read the repo's `AGENTS.md`, `Cargo.toml` files, workspace layout, and release workflow before mutating anything.

Prefer stopping to clarify over guessing. Releases are hard to take back.

## Release Contract

Establish these facts first:

- which branch is the release source of truth, usually `main`
- which runtime wrapper is required, for example `nix develop -c`
- which crates are publishable in this repo
- whether versions move in lockstep or independently
- whether one repo tag maps cleanly to the release, and what format the workflow expects
- whether the repo publishes to crates.io or another registry
- whether there are extra binaries, artifacts, or docs gates beyond normal Rust checks

Read local sources for that contract before acting:

- `AGENTS.md`
- root `Cargo.toml` and member `Cargo.toml` files
- `.github/workflows/release*.yml` and related CI files
- release docs if the repo has them

If any of these remain ambiguous after reading the repo, stop and ask a short clarifying question before mutating.

## Workflow

### 1. Sync Local State

Require a clean tree before a release flow. Check `git status --short`, fetch remotes and tags, and inspect the release branch state.

Default expectation:

- local branch can fast-forward to the latest remote release branch
- release happens from the latest `origin/main` unless the repo documents something else

If the tree is dirty, the branch diverges unexpectedly, or switching to the release branch would discard work, stop and ask.

### 2. Decide the Release Version

Resolve version intent before editing manifests.

Use this order:

1. If the user specifies the version, trust that.
2. Otherwise inspect the latest commit and manifest diff. If the newest commit already bumped the relevant crate version(s), treat that as the chosen release version.
3. Otherwise determine the required version bump from the repo's actual changes.

Before bumping or tagging, verify the target does not already exist:

- git tag not already present locally or on `origin`
- crate version not already published to the target registry

For workspaces:

- if crates release in lockstep, bump every participating crate and internal dependency edge together
- if crates version independently, determine the exact publish set and tag policy from repo docs or recent history

If an independently versioned workspace does not clearly map to one `vX.Y.Z` tag, stop and ask instead of inventing a tag scheme.

### 3. Run the Full Quality Gate

Use the repo-native wrapper for every command. Do not replace it with plain `cargo` unless the repo already uses plain `cargo`.

If the user asked for release readiness rather than an immediate publish, do a short findings-first review before mutating anything. Clear blockers first; only continue into versioning, tagging, and publish once the tip is actually releasable.

Examples:

- Nix repo: `nix develop -c cargo test`
- plain Rust repo: `cargo test`

Default gate for a Rust release candidate:

- format check
- clippy with the repo's usual feature set and warning policy
- tests
- build
- docs checks if the repo has them
- `cargo publish --dry-run` for each crate that will be published

When crate contents could be sensitive to local repo state, also inspect `cargo package --list` from a clean or detached checkout before the real publish.

For workspaces or multiple binaries, run the gates at the scope the repo expects. If the repo has a canonical release gate in CI or docs, mirror that.

If you had to bump versions after the first gate pass, rerun the affected checks and dry-runs on the release commit so the final publish happens from a clean, verified tree.

### 4. Apply the Release Commit If Needed

Only change versions if step 2 concluded they were not already bumped.

When bumping:

- update every relevant `Cargo.toml`
- update `Cargo.lock` when the repo tracks it
- update internal path dependency versions when the workspace needs them aligned
- keep docs and generated metadata consistent if the repo requires that

Create a dedicated release commit once the tree is correct and clean. Use the repo's conventional style; `chore: release X.Y.Z` is a safe default when no stronger convention exists.

### 5. Tag and Push

Create the release tag in the format the repo expects. Default to `vX.Y.Z` when the workflow clearly uses that format.

Do not tag a commit that has not passed the release gate.

If the release commit is only local, push the release branch before or with the tag so the remote release workflow can see the tagged commit.

For a simple single-version repo, the normal order is:

1. ensure the release commit is on the intended branch tip
2. push that branch if needed
3. create `vX.Y.Z`
4. push the tag

### 6. Publish

Publish from the same verified commit you tagged.

Trusted publishing typically publishes to crates.io from the tag-triggered release workflow. If the repo does not use trusted publishing, local publish requires `op run` and human approval.

For multi-crate releases:

- publish in dependency order when crates depend on each other
- wait for registry propagation when a dependent crate requires the newly published version
- use member-specific publish commands when the repo does not publish the entire workspace at once

If the repo uses an alternate registry, pass the required registry flags instead of assuming crates.io.

### 7. Watch the Release Surface

After pushing the tag and publishing, verify the expected external effects:

- tag exists on `origin`
- publish succeeded for every intended crate
- GitHub release workflow or release job started if the repo has one

If the release object is not visible yet, check workflow status before assuming failure. Tag-triggered GitHub releases can lag behind the pushed tag.

## Stop Conditions

Stop and ask before mutating when any of these are true:

- dirty working tree
- unclear release branch
- unclear crate publish set
- unclear version choice
- unclear tag policy
- existing tag or already-published target version
- workspace has independent versioning but the repo's tagging/publish policy is not obvious
- registry target or publish path is unclear

## Biases

Keep the release flow conservative:

- prefer repo evidence over generic Rust habits
- prefer exact commands over paraphrase
- prefer one more verification step over a speculative publish
- prefer a short clarification question over a wrong release
