# Install phases (`integrate` and `verify`)

Read by `SKILL.md` before Phase 0 in `integrate` and `verify`, and by `references/doctor.md` at D4 before its first write. `detect` and `report` never read it. It holds the phases that write: Phase 0's clean-tree check, Phase 5's credentials and branch, Phase 6's install and Phase 7's build, plus the contract a platform reference is entered with.

## The phase contract

The contract governs Phase 6. `detect`, `doctor` and `report` never resolve the values below.

**A reference is entered with these five values resolved, and never asks for them again:**

| Field | Resolved in | Values |
|---|---|---|
| `apiKey` | Phase 5 | a real Pendo integration key, or the declared placeholder `YOUR_API_KEY_HERE` — never an invented value |
| `urlScheme` | Phase 5 | a real `pendo-xxxx` scheme, or the declared placeholder `YOUR_SCHEME_ID_HERE` — never an invented value |
| `platform` | Phase 1 | `ios` \| `android` \| `react-native` \| `expo` \| `flutter` \| `maui` |
| `subPlatform` | Phase 1 | the sub-platform table in `SKILL.md` — `null` where the platform has no variant |
| `branchName` | Phase 5 | the branch created before Phase 6's first edit |

**The router decides `apiKey` and `urlScheme`; a reference writes what it is handed.** Each is a real value or one of the two placeholders above, nothing else, and the reference writes it as a literal in every slot. The references' ban on placeholders forbids **inventing** a value. It is not a licence to refuse, alter or skip a step because the value is a placeholder. Skipping the deep-link step on a placeholder scheme, for example, would leave the install incomplete and hide what the report exists to show.

**A reference must end with these two guarantees:**

1. The repo is in a state `scripts/verify-build.sh <platform>` can attempt to build: no half-written files, no dangling syntax.
2. It hands back, for the report, the files it *itself* changed (one-line reason each) and anything it left unwired (e.g. no `startSession` because the app has no identity source), so Phase 8 can list it under "Requires your attention". Phase 7's own file churn is never part of this list.

## Phase 0: Refuse a dirty tree

In `integrate` and `verify`: run `git status --porcelain`. If it prints anything and `--force-dirty` was not passed, **stop** (early-exit report). Tell the user to commit or stash first, or re-run with `--force-dirty`. This is a hard stop, not a warning: there is no PR to close here, and a dirty tree has no free rollback. Nothing has been created yet, so no cleanup is needed. Offer `--mode detect` as what they can run right now.

**With `--force-dirty`**, record every path `git status --porcelain -uall` prints as `preexistingDirty` (`-uall` lists each untracked file, not just its folder), say once that the run continues on a tree with uncommitted changes, and continue. The Phase 5 branch carries those changes with it. When a step must edit a file in `preexistingDirty`, edit it and mark it in the report as mixed: it holds both the user's changes and this run's edit, so its diff needs review before committing.

## Phase 5: Resolve credentials and create the branch

In `integrate` and `verify`, now and only now:

1. Resolve the API key from `--api-key` and the scheme from `--scheme`; ask for whichever is missing, **both in one message**, since they sit side by side at `App Details`. Asking only now is deliberate: the app is identified, its reference exists, it is not instrumented, and it meets the requirements, so a run that was going to stop has already stopped without asking anyone for a key.

   **Both are needed for a working install, but neither is required to proceed.** They often belong to someone else in the organisation. When the user does not have one or both:

   - **Write the declared placeholder**: `YOUR_API_KEY_HERE` for the key, `YOUR_SCHEME_ID_HERE` for the scheme. These are Pendo's own placeholders from its guides: recognisable on sight and easy to grep.
   - **Announce it; do not ask a second time.** Say the install uses placeholders and is not live until they are replaced, then continue.
   - **Carry it into the report as its own state**: the `**Pendo config:**` line and the `### Replace before this works` section.

   **Never invent a plausible-looking value.** A made-up key (`a1b2c3d4-…`) or scheme (`pendo-abc123`) looks like a correct install, so nobody goes looking for it. A placeholder is safe only because it cannot be mistaken for real.

   **What a placeholder costs.** A placeholder key: the SDK reports to nothing, no analytics arrive, and Pendo's install check (`Pendo SDK was successfully integrated and connected to the server`) never passes. A placeholder scheme: Designer pairing silently never works. Both compile, so **a passing `verify` build proves the code is valid, not that Pendo is live**; say so.

   **This does not extend to identifiers.** A placeholder credential means no data flows. A placeholder visitor or account ID means made-up data flows into the customer's subscription permanently. `references/identity.md`'s ban is absolute: with no real identifier, write `setup()` and no `startSession` call at all.
2. *(Skipped under `--dry-run`.)* Record where to return to, as `originalRef`: `git branch --show-current`. **If it prints nothing, HEAD is detached** (a tag checkout, bisect, CI or submodule checkout): record `git rev-parse HEAD` instead, and note that it is a commit, not a branch. Never treat the empty string as a branch name. Then `git checkout -b pendo-install-<platform>`. **If the run stops for any reason between here and the install report, undo this run's edits before switching back, then delete the install branch, and say so in the report.** Nothing in this skill commits Phase 6's edits, so `git checkout <originalRef>` alone is not a rollback: it carries the uncommitted edits onto `originalRef`. On a clean start, while still on the install branch, run `git -C "$(git rev-parse --show-toplevel)" checkout -- .` and then `git -C "$(git rev-parse --show-toplevel)" clean -fd`. Both are anchored at the git root because Phase 7 may have left the shell in a monorepo's app root. Under `--force-dirty`, never run those two blanket commands, because they would also destroy the user's own uncommitted work. Revert only the paths this run changed that are not in `preexistingDirty`, from the git root (`git -C "$(git rev-parse --show-toplevel)" checkout -- <path>`, or delete a file this run created by its root-relative path). Leave every mixed file as it is and list it in the report: it also holds the user's own edits, so reverting it would destroy them. Then `git checkout <originalRef>` and `git branch -d pendo-install-<platform>`, so no empty branch is left behind. Checking out a recorded SHA restores the same detached HEAD.

Under `--dry-run`, do step 1 in full, including the placeholder fallback, and skip step 2: no branch is created.

## Phase 6: Run the platform reference

**`detect` and `report` do not reach this phase.** Using the reference read in Phase 2, run its install steps in order with the resolved `apiKey`, `urlScheme`, `platform`, `subPlatform` and `branchName`. Do not ask for credentials again, do not re-detect, and do not open another platform's reference "just to check". Under `--dry-run`, narrate what the steps would change instead of making the edits.

## Phase 7: Verify the build

**`verify` only, plus `doctor` when the user asks for the build at D4.** In `detect` and `report` nothing is installed, and in `integrate` building is not part of the job. Do not run the script in those modes, and do not treat that as a pass: the report's `### Build` section has mandatory wording for "not run because of the mode". An `integrate` run must never read as verified.

```bash
bash "<skill-dir>/scripts/verify-build.sh" <platform>
```

`<skill-dir>` is the directory this `SKILL.md` was loaded from, the one holding `references/`. **Never hardcode `~/.claude/skills/install-pendo-mobile/`**: plugin, project or snapshot copies live elsewhere, and a wrong path reports a present script as absent.

**Run it from the app root, which is not always the git root**: the directory with the app's manifest (`package.json` for `react-native`/`expo`, `pubspec.yaml` for `flutter`, the Gradle wrapper for `android`) next to its native directories. In a monorepo the app may be several levels down (seen: a Flutter app at `compass_app/app`). When run from the wrong place, the script exits `2` with a line starting `wrong directory` that names candidate app roots. Re-run from there; it is not a failed verification.

**Managed Expo: tell the user first.** The script runs `npx expo prebuild --no-install`, builds the generated native projects, then **deletes exactly the directories it generated**. The prebuild is the only way to catch broken config-plugin output; the cleanup keeps the next run's `managed`/`prebuilt` detection and installed gate from reading directories this skill created. Report both halves in `### Build`, or that the directories were left behind if so.

If the script is missing from this copy of the skill, say in `### Build` that verification could not run and why: no PASS, no FAIL. If Phase 1 found the toolchain missing and the user continued, skip this phase and say so. Skip it under `--dry-run`.

**Exit codes:** `0` build passed. `1` build failed **and the failure is attributable to this install**. `2` not verified: a toolchain is absent, the script ran from the wrong directory, or the build failed with **no mention of Pendo in the failing step's own output**.

That last case applies to every native head on every platform. Build failures that predate this skill are common (a dead `compile()` Gradle DSL in a third-party module; a `react-native-worklets` CMake ordering failure; a Gradle/JDK class-file mismatch), and calling one `1` would tell a developer Pendo broke an app it never touched. Attribution looks only at the failing step's output, because a successful `pod install` lists `Pendo (x.y.z)` and would otherwise make every later failure look Pendo-caused.

`2` is never reported as FAIL, and never as a silent PASS. The script always prints an `Android head:` / `iOS head:` line per native head saying which were verified and why not. For `react-native`/`expo`/`flutter`, carry each head's line into the report instead of collapsing them into one word.

**Build churn is not this run's editing.** `pod install` can rewrite `Podfile.lock` and the Xcode project on every iOS-bearing head, Gradle can rewrite wrapper or lock files, and `npx expo prebuild` generates native directories. A reference's list of such files (e.g. `references/flutter.md`'s "Files the build changes on its own") is illustrative, not complete. After this phase, run `git status --porcelain` and compare it with the reference's own reported edits and, under `--force-dirty`, with `preexistingDirty`: any extra path is churn, reported under `### Files the build touched`, not folded into `### Files changed` and not left out.

## Constraints

- **Never let a placeholder install read as finished.** It gets the `**Pendo config:** ⚠ PLACEHOLDERS` line and its own `### Replace before this works` section naming every `file:line`, above "Files changed". A passing `verify` build does not change this.
- **Never report an install as verified in a mode that did not build it.** `integrate` says so in `### Build`, in the template's words, every time.
- Never proceed past Phase 0 on a dirty tree in `integrate` and `verify` unless `--force-dirty` was passed; then keep the user's changes apart in the report. `detect` reports it as an observation.
- Never skip creating the branch in Phase 5: a branch must exist before Phase 6 writes anything.
- If the run stops after Phase 5 created the branch, always undo this run's edits first, exactly as Phase 5 step 2 says: the blanket commands from the git root on a clean start; under `--force-dirty`, only the paths this run changed that the user had not, with mixed files left as they are and listed. Then switch back to `originalRef`, delete the install branch, and say so. Never leave a stray branch, and never leave the run's edits on `originalRef` except inside a listed mixed file. On a detached HEAD, `originalRef` is the commit SHA; never treat an empty `git branch --show-current` as a branch name.
- Never report Phase 7 as PASS or FAIL if `verify-build.sh` did not run, including when the mode is why.
- Never blame a build failure on this install without evidence: the script returns `1` only when the failing step's output mentions Pendo, and its `2` verdicts are reported as "not verified", never as FAIL and never as a silent PASS.
- Never fold Phase 7's file churn into "Files changed", and never omit it: report it under "Files the build touched".
