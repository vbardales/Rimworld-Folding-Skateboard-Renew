# Protocol documents read by this mod's session

Read in full on 2026-09-28 by session `local_40bd9ed8-65bc-4776-8224-f7aa71edee50`, before the
workflow audit of the same day (`STATUS.md`, `docs/AUDIT-2026-09-28.md`). `AGENTS.md` reached the
session as project instructions and was also read as a file.

The **version** of a file is the last commit that touched it, then the first ten characters of its
content hash (`git hash-object --no-filters`), then whether the working copy carried changes that
were not committed. A document marked **useful** is read again when its version moves, from the diff
against the version written here, not in full. A document marked **not useful** is read again only
when its trigger happens.

## Where the versions come from

The protocol documents are not in the monorepo: commit `90d51374` moved them to
`vbardales/Rimworld-protocols`, whose git dir is `../rimworld-protocols.git` and whose work tree is the
monorepo root. From the monorepo, `git log -1 -- AUDIT.md` returns the commit that *deleted* the file,
a plausible hash and a recent date for the opposite of what is wanted. From `Documents\rimworld`:

```
git --git-dir=../rimworld-protocols.git --work-tree=. log -1 --format='%h %ad' --date=short -- AUDIT.md
git --git-dir=../rimworld-protocols.git --work-tree=. status --short -- AUDIT.md
```

Everything else (PickleTools, Release-Admin, Ticket-Dispatcher) has a repository of its own: the usual
`git log -1 -- <file>` inside it. Two files below are under a `M` working copy, so their version is the
last commit *plus* changes that were on disk that day: the hash is what identifies what was read.

## Useful

| Document | Version read | Working copy | What it settled for this mod |
| --- | --- | --- | --- |
| `AUDIT.md` | `c5ca0c0` 2026-09-26, `799b1f89d9` | modified, not committed | The chain of states; `done` needs the Pickle suite *written* and its scope justified, running it is `tested`; the three new conditions of `tested`; what a `0.1.0` pre-publication is and how the CHANGELOG records it; the session title `<packageId without nelim.> / <stage>`; never launch RimWorld |
| `AGENTS.md` | `3a1d2cb` 2026-09-24, `bb4c08c1e4` | clean | Settings gate, then translations, then `preTest`; the evidence policy (latest report per scenario for the current revision, delete the rest, list before deleting, never delete what STATUS points to) |
| `PUBLISHING.md` | `95c6dfd` 2026-09-28, `323eccec04` | clean | The `(unofficial)` suffix and paragraph for a public `silent` mod; **`renew` stays out of the packageId of a mod that is not yet public** (2026-09-27); the description ends on `Source code on GitHub`; the origin's repository is looked for first; the ModIcon is checked, never made; tools are named; Workshop links at every mention |
| `TRANSLATIONS.md` | `f5c2d9d` 2026-09-25, `fac8188128` | clean | No sentence assembled from translated fragments: it found the three pickup refusals of this mod, fixed on 2026-09-13 |
| `MOD_SETTINGS.md` | `b83933b` 2026-09-23, `a61cd54192` | clean | What a justified `not_applicable` needs: the sources, not the absence of a page |
| `STYLE_RIMWORLD.md` | `7311308` 2026-09-25, `529e2f58c4` | modified, not committed | The ModIcon is checked at 32 px and never made; the four-colour overlay; the veil measured on the rendered PNG; `Art/Preview.png` as the source's name; the folder icons |
| `Rimworld-Ticket-Dispatcher/docs/WELCOME.md` | `77ca9d7` 2026-09-27, `a1d893776e` | clean | Ignore `desktop.ini` and `*.ico` so they never reach `Mod/`; this file's own reading rule; how a run is filed and what a request does not carry |

## Partly useful: needed when the suite is written and when the first run is filed

| Document | Version read | Working copy | Why only partly, and when to read it again |
| --- | --- | --- | --- |
| `PickleTools/Authoring/README.md` | `8d3ca6d` 2026-09-26, `a6e3e2eac0` | clean | Not in the list of documents to read, read anyway: it says what belongs in Gherkin and what does not, which is the scope argument of `TESTING.md`. Applied on 2026-09-28 to write the suite. Read again when a feature or a step changes |
| `PickleTools/Headless/README.md` | `ed4e73a` 2026-09-26, `b64e7beefc` | clean | Filters, passes, `-DepMap`, `-Then`/`-ThenWithout`, exit codes, evidence. Needed at the first request |
| `Rimworld-Ticket-Dispatcher/docs/SUBMIT.md` | `d07b2b8` 2026-09-26, `7ab5e437d4` | clean | Options of `Submit-PickleRun.ps1`. Read again at the first request |
| `PickleTools/docs/steps.md` | `cba3ca1` 2026-09-25, `ada122c30f` | clean | The companion tools' steps. Used on 2026-09-28: the load-audit step. Nothing else was needed from it. Pickle's own built-in steps were read from a local checkout, `Documents/pickle-local/stands-still/Docs/steps.md` (Pickle commit `a1293b0`, 2026-09-21): **not established as the installed version's**, so a step used from it is checked against the running build |
| `PickleTools/README.md` | `c771bef` 2026-09-25, `93986d5c45` | clean | The table of companion tools. Read again with the catalogue |
| `PickleTools/TESTING.md` | `650adce` 2026-09-25, `f88f15c373` | clean | Only "What to keep after a test, and what to delete" was needed; it is applied in this mod's `TESTING.md` |
| `Rimworld-Release-Admin/docs/OPERATIONS.md` | `3c03f51` 2026-09-26, `347a0d63b9` | clean | The item exists, so the "first publication" part is behind this mod. The workflow generation, dry-run and `publish` are for `prepublished`. Its scripts `about-description.mjs` and `changenote.mjs` (code, not prose) were read and used to produce `About.xml` from `PUBLICATION.md` |
| `scripts/SEARCHING.md` | `50de695` 2026-09-28, `45f0fa13cc` | clean | The corpus search, bounded roots and filters, the `-s` resumable mode, and the ban on unbounded walks. Still needed for the `avec-lts` pass: the Workshop mod that defines the 141 `LTS_...` floors is not identified. Re-read 2026-09-28 for `upstream_mod_remotes` in `STATUS.md`: content unchanged since the earlier reading (same hash), no search run needed — the original's repository was already established absent by the audit (finding 5), so `upstream_mod_remotes: N/A`. **Applied badly once, on 2026-09-28**: a recursive `grep -rl` over the whole monorepo was started to look for the packageId, ran two minutes and was stopped. The bounded form is a fixed list of `About.xml` globs |

## Not useful

| Document | Version read | Working copy | Why, and the trigger that makes it useful |
| --- | --- | --- | --- |
| `WORKSHOP_COMMENTS.md` | `dea856b` 2026-09-28, `77588f7429` | clean | Thank-you comments for public items; nothing is public. Trigger: `tested -> prepublished`, when the message for the original's page (3414678101, a first contact since the source is `silent`) is drafted and Harmony's `Covers` cell is extended |

## Not read

None of the listed documents.

## This mod's own documents

Read: `STATUS.md`, `README.md`, `CHANGELOG.md`, `ATTRIBUTION.md`, `LICENSE`, `TESTING.md`,
`Mod/About/About.xml`, `AUDIT-2026-09-13.md` (the previous audit, kept as history).

Created on 2026-09-28: `PUBLICATION.md` (the Steam description, once), `docs/PROTOCOLS-READ.md` (this
file), `docs/runs/README.md` (the format of the run history; no run yet), `docs/AUDIT-2026-09-28.md`, and
the whole of `Tests/Pickle/`.

Absent, and what that means:

- Nothing else of the mod's own is absent that it needs. `Tests/Pickle/` was absent in the morning and was
  written in the afternoon: see `docs/AUDIT-2026-09-28.md`, addendum.
- `BACKLOG.md`, `NOTES.md`, `BUGS.md`: nothing that `STATUS.md`'s `remaining` list does not already
  hold. Trigger for `BUGS.md`: the first defect a run reports. Trigger for `BACKLOG.md`: an idea that
  is wanted and not scheduled.
- `docs/runs/*.md` lines: no run has happened; a line is written when one does, before its folder is
  deleted.
