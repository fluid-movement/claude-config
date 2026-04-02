---
name: goreleaser
description: >
  Sets up GoReleaser with GitHub Actions for building and publishing Go binaries
  on release tags. Go projects only. Triggers: "set up goreleaser", "add goreleaser",
  "set up goreleaser release", "configure goreleaser".
---

# goreleaser setup

Go projects only. If no `go.mod` exists, tell the user this skill is for Go projects only.

## Steps

1. **Read Go version** — parse the `go` directive from `go.mod` (e.g. `go 1.24.2` → `'1.24'`, major.minor only).

2. **Copy templates from `~/.claude/skills/goreleaser/templates/`:**
   - `release.yml` → `.github/workflows/release.yml`, replacing `GO_VERSION` with the detected version
   - `.goreleaser.yaml` → `.goreleaser.yaml` (no changes needed)

3. **GitHub setup — tell the user:**

   > **GitHub settings to configure:**
   >
   > 1. Go to **Settings → Actions → General → Workflow permissions**
   >    Set to **"Read and write permissions"** and save.
   >    (Skip if already done for release-please.)
   >
   > 2. **No extra secrets needed** — `GITHUB_TOKEN` is provided automatically and
   >    is sufficient for publishing releases on public repos.
   >
   > **How it works:** When a `v*` tag is pushed (e.g. by release-please merging a
   > release PR), GoReleaser builds binaries for linux/darwin/windows × amd64/arm64,
   > packages them as `.tar.gz` / `.zip`, and attaches them to the GitHub Release.

4. **Summary** — list the files created. Mention that `.goreleaser.yaml` can be
   customized (e.g. add `ldflags` for version injection, change target platforms).
