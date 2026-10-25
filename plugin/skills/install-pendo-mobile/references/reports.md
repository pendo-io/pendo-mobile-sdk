# Phase 8 report templates

Read by `SKILL.md` Phase 8. Render exactly one template. Every report states its mode on its first line: a reader must never have to guess from a missing section whether a build was skipped or just not mentioned.

## Detect report

Used in `detect` mode. There is no branch, no changed file and no build to report.

```markdown
## Pendo detect (no changes made)

**Platform:** <platform> / <sub-framework>
**Pendo package:** <the dependency `references/<platform>.md` would add, named exactly as its Dependency section names it, plus what that section says about versioning — including "no version pinned by Pendo" where that is so; never invent one. Where the section is tiered (iOS: SPM, CocoaPods, vendored framework), name the tier this repo would land on and the signal that decides it.>
**Already installed:** <"no — none of the N indicators found", or Phase 3's state — complete or partial — with which indicators matched and in which files, plus the SDK generation where it was visible without extra work>
**Can install:** <"yes"; "no — <the blocking constraint and the value read>"; or "no — Pendo is already installed here (<state>)". Phase 3's gate stops an `integrate` run just as a failed constraint does, so never report "yes" on an instrumented repo.>

### Requirements
- <one line per Global Constraints row for this platform: the value read, the floor, and which of the four outcomes it landed on>

### What an install would do
<Two to five lines from the reference's own step headings: the dependency, where `setup()` goes, where `startSession()` would go, the deep-link config. Enough to decide; a full narration is `--dry-run`'s job.>

### Requires your attention
- <indeterminate and not-applicable constraints, with why — no build ran, so none of these were closed by a build>

### Next step
<**When Phase 3 found an install, this is that state's next step, never an install command** — `integrate` would refuse this repo. Complete: nothing to do. Partial: which pieces are wired and which are not, and the ways forward from Phase 3, starting with `--mode doctor` to finish it. Name the SDK generation if visible, but never offer an upgrade.

Otherwise, the exact command: `--mode integrate` to install, or `--mode verify` to install and build. Say that a Pendo API key **and** a Designer URL scheme are both needed for a working install, found together at Pendo UI → `Settings` → `Subscription settings` → select the app → `App Details`, and that not having them yet is not a blocker: the install uses clearly marked placeholders to replace later. Mention a dirty tree if one was seen, since `integrate` will refuse it unless run with `--force-dirty`.>
```

## Install report

Used on a completed `integrate` or `verify` run.

```markdown
## Pendo install complete

**Mode:** <integrate — installed, not built | verify — installed and built>
**Platform:** <platform> / <sub-framework>
**Branch:** <branch>
**SDK version:** <resolved version> (baseline <pin>)
**Working tree:** <clean before the run | had uncommitted changes (`--force-dirty`): the paths in `preexistingDirty`, which this install did not author>
**Pendo config:** <"live — real API key and scheme" | "⚠ PLACEHOLDERS — this install is not live until they are replaced (see below)">

### Replace before this works
<Only when Phase 5 wrote a placeholder, and always here, above "Files changed": it is the one unfinished thing about this install. One line per placeholder: the sentinel, every `file:line` it was written to, and what replaces it. State the effect: `YOUR_API_KEY_HERE` means no analytics reach Pendo and its install check will not pass; `YOUR_SCHEME_ID_HERE` means Designer pairing will never work. Name where both come from (Pendo UI → `Settings` → `Subscription settings` → select the app → `App Details`) and give the grep that finds every site: `grep -rn "YOUR_API_KEY_HERE\|YOUR_SCHEME_ID_HERE" .`. Never merge this into "Requires your attention": that is a list of caveats, this is a blocking to-do.>

### Files changed
- `path` — what changed. Add "⚠ mixed — also holds your uncommitted changes; review its diff" when the path is in `preexistingDirty`.

### Files the build touched
- `path` — what the toolchain did and the command that caused it (e.g. "`ios/Podfile.lock` — added by `pod install` during Phase 7"). Never list a path from `preexistingDirty` here. Omit this section when Phase 7's post-build `git status --porcelain` found nothing beyond "Files changed" and `preexistingDirty`, and always in `integrate`, where no build ran.

### Build
<In `integrate`, exactly: "Not run — mode `integrate` installs without building. Nothing here has been proven to compile. To verify: `bash <skill-dir>/scripts/verify-build.sh <platform>` from the app root, or re-run this skill with `--mode verify`." Name the app root if it is not the git root. Never write PASS, FAIL or a bare "skipped" here, and never omit the section: an install report with no Build line reads as verified.
In `verify`, the real result. If Phase 5 wrote a placeholder, add: a placeholder compiles, so **a PASS proves the code is valid, not that Pendo is live**.
`ios`/`android` (one target): PASS with the command, FAIL with the error, or "not verified" with `verify-build.sh`'s reason.
`maui`: the script builds the **Android head only**. Say which TFM it built (the project's own, e.g. `net10.0-android`) and that the iOS, MacCatalyst and Windows heads were not verified.
`react-native`/`expo`/`flutter` (two heads): one line per head — PASS with its command, FAIL with its error, or "not verified" with the script's reason (toolchain absent, wrong directory, or a failure whose output never mentions Pendo). Never compress two heads into one word.>

### Requires your attention
- <anything unwired, e.g. startSession has no identifier>
- <every Phase 4 constraint that came back indeterminate, with why it could not be read and where to check it>
- <every report-only Phase 4 mismatch (`compileSdkVersion`, Java `sourceCompatibility`), with the file and property to raise>
- <every Phase 4 constraint not applicable to this repo shape (managed Expo's native-head minimums; MAUI's Kotlin floor, which lives in the binding AAR)>
```

Under `--dry-run`: render `**Branch:** (not created — dry run)`, rename `### Files changed` to `### Would change`, and omit `### Build` and `### Files the build touched`.

## Early-exit report

Used on any stop: Phase 0's dirty tree, Phase 1's declined toolchain warning, Phase 2's missing reference, Phase 3's gate, Phase 4's AGP floor (read directly, or inferred from a Gradle wrapper below 8.0) or a declined mismatch. Also Phase 6's Android version lookup (`references/android.md` §2) when it fails and the user cannot supply the version. That stop comes after the branch exists, so Phase 5 step 2's rollback runs first. **Missing credentials are never an exit**: Phase 5 writes a placeholder and the run completes. **In `detect`, `doctor` and `report` the only exit here is Phase 2's missing reference**: they run neither Phase 0 nor Phase 5, and their Phase 3 and 4 stops are findings in their own reports.

```markdown
## Pendo install stopped

**Mode:** <the mode that was running>
**Phase:** <phase number and name where it stopped>
**Reason:** <why, in one sentence>
**Branch:** <"none created — still on `<originalRef>`" before Phase 5's branch step, or "returned to `<originalRef>`" if a branch was created and this run switched back. When `originalRef` is a commit SHA, say "returned to detached HEAD at `<sha>`" — never render an empty pair of backticks.>
**Files changed:** <"none" for a stop before Phase 6. For a later stop: each file this run wrote and then reverted, and under `--force-dirty` each mixed file left as it is.>

### Next step
<What the user does to resolve it and re-run — e.g. "commit or stash your changes, or re-run with `--force-dirty`", "upgrade the project's Android Gradle Plugin to 8.0 or higher", "confirm the toolchain and re-run". Never ask the user to fetch an API key or scheme first: a missing credential is never the reason for a stop.

For Phase 3's gate, the classified state's next step from Phase 3: "already instrumented — nothing to do" for **complete**; for **partial**, which pieces are wired and which are not, plus the ways forward, starting with `--mode doctor` to finish it. Name the SDK generation if visible, and stop there: this skill installs, it does not upgrade.>
```

If a branch was created in Phase 5 and the run stops before the install report, undo this run's edits, switch back to `originalRef` and delete the install branch, all as `references/integrate.md` Phase 5 step 2 describes, and reflect that in the Branch line. Under `--force-dirty`, also list any mixed file that was left as it is.
