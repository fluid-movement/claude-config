---
name: release-please
description: >
  Sets up release-please with GitHub Actions for automated versioning and
  changelog generation. Triggers: "set up release please", "add release please",
  "set up release please with github flow", "configure release please".
---

# release-please setup

## Steps

1. **Detect project type** — read `go.mod` → type `"go"`, `package.json` → type `"node"`. If unclear, ask.

2. **Read Go version** (Go projects only) — parse the `go` directive from `go.mod` (e.g. `go 1.24.2` → `'1.24'`, major.minor only).

3. **Create `.github/workflows/`** if it doesn't exist.

4. **Copy templates from `~/.claude/skills/release-please/templates/`:**
   - `release-please.yml` → `.github/workflows/release-please.yml` (no changes needed)
   - `pr-title.yml` → `.github/workflows/pr-title.yml` (no changes needed)
   - `ci-go.yml` → `.github/workflows/ci.yml`, replacing `GO_VERSION` with the detected version (Go projects only; ask user what to use for other project types)
   - `release-please-config.json` → `release-please-config.json`, replacing `RELEASE_TYPE` with the detected type
   - `.release-please-manifest.json` → `.release-please-manifest.json` (no changes needed, starts at `0.0.0`)

5. **GitHub setup — tell the user:**

   > **GitHub settings to configure:**
   >
   > 1. Go to **Settings → Actions → General → Workflow permissions**
   >    Set to **"Read and write permissions"** and save.
   >
   > 2. *(Optional but recommended)* Add branch protection on `main`:
   >    **Settings → Branches → Add rule** for `main`
   >    - Check "Require a pull request before merging"
   >    - Check "Require status checks to pass" → add `lint` (from pr-title.yml)
   >
   > That's it — no extra secrets needed. `GITHUB_TOKEN` is provided automatically.
   >
   > **How it works:** Every PR merged to `main` that uses conventional commits
   > (`feat:`, `fix:`, `chore:`, etc.) will cause release-please to open or update
   > a release PR. Merging that PR creates a version tag and a GitHub Release.

6. **Summary** — list the files created and confirm the starting version is `0.0.0`.
