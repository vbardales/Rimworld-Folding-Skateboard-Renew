# Folded from STATUS.md (history, 2026-10-13)

## Superseded decision — done (2026-09-13)

*Superseded on 2026-09-28. Against today's `AUDIT.md` the decision below did not hold until the Pickle suite
was written, which it now is: see the decision above. Kept as it was written.*

`preTest -> done` is established under the user's workflow. `done` means ready for
final functional validation in game; it does not mean tested in game or published.
The earlier decision to retain preTest was overly conservative, not a failed test.

- TESTING.md contains 17 written functional scenarios with shared or scenario-specific
  preconditions, actions and expected results.
- The updated automated suite passed 13/13 against the delivered DLL after the pickup
  translation change; compilation passed with zero warnings/errors.
- All seven distributed XML files parsed; five DefInjected paths passed with zero errors.
  Four nonempty EN/FR menu templates passed key and format-argument checks.
- Earlier image, localization, settings and dependency gates remain established.
  Settings tests and MainButtons customization tests are not applicable: no relevant
  settings, empty page or shortcut exists. This does not exempt gameplay persistence.

Evidence is recorded in the dated sections below and in [AUDIT-2026-09-13.md](AUDIT-2026-09-13.md).
On this documentation-only update, HEAD and the delivered DLL hash were rechecked:
`2b519339bc8b58c9edf841d68ba86e19518bd72a` plus existing uncommitted corrections;
DLL SHA256 `9B14EE844E85C36C00E86A849E54FA06CA23FCFFD25B4922B7B62CE5CF792C62`.
The hash matches the tested delivery. Tests were not rerun for this documentation update.
Existing local work and historical results are preserved.

### Next transition, as written on 2026-09-13

Execute the applicable TESTING.md scenarios in RimWorld 1.6 with Harmony and record
actual outcomes, game/mod versions, save context and log evidence. Cover a new game
and an existing save, English and French UI, pickup refusals, trait restoration,
save/reload and leaving the map. Check logs for errors and unresolved keys. Run the
mod-removal scenario only on a disposable copy of a save. Any fixes require the
corresponding regression tests before tested can be claimed.

Options and MainButtons checks remain not applicable unless such features are added.
Record optional integrations actually exercised (for example LTS floors); do not infer
integration compatibility from static inspection. `tested_on` remains empty until
successful gameplay validation is recorded. No scenario has been certified in game.

The About description's unsupported in-game-testing claim and bare GitHub link remain
tracked publication-documentation defects. They are not hidden by done and must be
addressed before publication; they do not negate the technical readiness gate above.

## Historical evidence

Read by a sweep across every mod, rather than by asking each thread in turn. It lives at the
root, never inside `Mod/`, so Steam never receives it.

The sweep of 2026-09-12 read what it could off the disk and left four fields for whoever holds
this mod. They are answered now, and this is what they rest on.

- **`stage`** — one of `port`, `showcase`, `preTest`, `done`, `tested`, `published`. **`showcase`**:
  the port itself is finished and pushed, and what is left is the two images. The session group
  says the same thing.
- **`tested_on`** — the date of the last run in game. **Empty, and it means never.** The mod has
  never been loaded by RimWorld, here or anywhere: it was ported by reading the 1.6 assembly, not
  by running it. `_tools/Run-Functional-Tests.ps1` asks the installed game the questions that can
  be settled without launching it, and passes; it says nothing about what a colony does, which is
  what `TESTING.md` is for.
- **`dependencies`** — **`declared`**, and it is the whole answer. Harmony is the only mod this one
  needs, and the About names it in `modDependencies`. The 1.6 assembly and Harmony are the only
  things the C# references. The ~170 terrain names in `SkateableTerrain` include floors from LTS
  Systems' mods, but a name belonging to a mod that is not loaded simply resolves to nothing: they
  are opportunities, not dependencies, and declaring them would be wrong.
- **`remaining`** — what is left, in three kinds: `feature` for something missing from a first
  release, `defect` for a known fault left unfixed, `unverified` for what could not be checked.

`workshop` stays empty because the mod has never been uploaded: there is no `PublishedFileId.txt`
in the folder, which is also why the `packageId` could still be renamed on 2026-09-12.

## Audit of 2026-09-13

Previous stage: `preTest`. Retained stage: `preview` = **Preview generated**
(user workflow: **Preview générée**). This code extends the legacy vocabulary below;
`preOptions`, `options` and `l10n` map literally to the user's workflow stages.
The previous narrative is retained as historical context, not current validation evidence.

See [AUDIT-2026-09-13.md](AUDIT-2026-09-13.md) for the revision, initial local changes,
ordered gates, commands, findings and remaining checks. GitHub existence, public visibility
and pushed HEAD were checked live. Build succeeded and reproduced the distributed DLL
byte for byte. All 13 automated tests and all 5 DefInjected path checks passed; seven
distributed XML files also passed syntax and resource checks. Both images were inspected.
The initial restricted compiler-probe failure was environmental and passed on retry.

### Settings audit

`not_applicable`: faithful fixed-balance port, no useful configuration requirement found.
Source and Def inventory confirms no ModSettings, empty settings page or MainButtons shortcut.
No customization integration was tested. Gameplay trait persistence is still unverified.

### Translation audit

EN/FR resource coverage is complete: two owned Keyed entries, two verified vanilla keys,
five valid French injected fields with English Def sources. `localization: partial` because
three disabled-menu messages concatenate translated fragments contrary to TRANSLATIONS.md.
No missing key or failed in-game rendering is asserted. FR/EN runtime checks remain pending.

## Preview correction and test diagnostic follow-up — 2026-09-13

Stage at that follow-up: `options`. `preview` -> `preOptions` now passes; the independent
`settings_audit: not_applicable` remains valid, so `preOptions` -> `options` also passes.
The next gate is l10n, still blocked by the recorded translated-fragment construction.
The earlier audit and its original stage decision above are historical evidence.

The overlay now uses the prescribed Renew suffix hierarchy, the (unofficial) tag,
shared primary ink for title/summary, current spacing and typography, and a 1.6 badge.
The source illustration and crop are unchanged. The paving's warm rose-brown family
anchors the secondary ink; the lamp supplies the more saturated golden accent.
Canonical composition: `Art/Preview.config.json`, rendered by the shared `Render-Preview.cjs` of the protocols repository (the mod copies were removed 2026-10-11).
and installed Chrome. The renderer waits for fonts and source image decoding.

The delivered PNG was inspected at 896 x 504 and 268 px wide: title and version
identifiable, rule visible, tag/suffix and accent distinct, no overlap or clipping.
PNG size: 577,913 bytes. Chrome reports Segoe UI Semibold for the title, not fallback.
Contrast minima measured against every background pixel in each text bounding box:
title 7.77:1, suffix 5.47:1, tag 4.79:1, summary 6.06:1; opaque badge 9.96:1.
QA snapshots and machine-readable measurements are in `.build/preview-qa/` (not shipped).

The compile probe now fails explicitly as UNVERIFIED when dotnet is missing or a
failed build has SDK/restore/infrastructure errors or no C# diagnostics. It preserves
the exit code and useful diagnostic lines and does not infer obsolete private access.
A real restricted run reproduced MSB4184 and correctly reported the SDK access denial;
the suite stayed nonzero. This replaces the misleading publiciser-removal suggestion.
No mod C# or language resource changed; prior DLL and localization checks remain applicable.
Final verification: the updated 13-test suite passed with SDK access (exit 0),
including the expected PawnRenderer.pawn diagnostic. Render-Preview.cjs exited 0;
git diff --check passed. No gameplay run or publication was performed.

## Complete pickup translations — 2026-09-13

Replaced all three disabled pickup labels with complete owned EN/FR templates:
TakeAlreadyCarrying, TakeForbidden and TakeNoPath. Each receives the localized item
label as {0}; no translated-fragment concatenation or vanilla refusal key remains.
The ordinary TakeToInventory action remains translated, giving four keys per language.
No gameplay condition, pickup action, settings or dependency was changed.

Updated the existing resource test to check duplicates, empty/unused keys and to format
each template with a sample item argument; malformed or missing arguments fail the suite.
Updated TESTING.md refusal and French scenarios, and CHANGELOG.md. The audit's original
observations above remain historical; this section records the correction.

`dotnet build Source/FoldingSkateboard.csproj --no-restore --nologo` succeeded with
zero warnings/errors and installed the updated DLL in Mod/Assemblies.
Delivered SHA256: `9B14EE844E85C36C00E86A849E54FA06CA23FCFFD25B4922B7B62CE5CF792C62`.
Revision baseline remains 2b519339bc8b58c9edf841d68ba86e19518bd72a plus the documented
local changes. Earlier image, settings and dependency validations remain applicable.
The changed menu needs English/French in-game regression checks (TESTING.md 4–6 and 16);
these have not been executed. No gameplay success is claimed.

Final resource and assembly suite: 13/13 passed, exit 0, four keys per language.
All seven distributed XML files parse. Stage at that follow-up: preTest; localization is complete,
with prior settings and dependency checks preserved. In-game validation remains pending.

DefInjected recheck: 5 keys checked, 0 errors, exit 0 (11,589 definitions indexed).


## Preview source migration — 2026-10-03

Copy, typography, layout and palette are consolidated in `Art/Preview.config.json`. Canonical inputs are `Art/Preview-source.png`, `Art/echo.png` and `Art/ModIcon-source.png`; temporary renderer diagnostics belong under ignored `Art/.render/`. Existing Preview, gallery and ICO outputs were preserved because they were present and coherent; no render was run. Superseded JSON files and generated QA intermediates were removed. Nothing published.


# Folded 2026-10-13: sections of the retired `done` vocabulary

## Current decision — done (2026-09-28)

Stage `done`. Stage codes: `done` is the workflow's `done`; the codes `preview`, `preOptions`, `options` and
`l10n` of the 2026-09-13 audit map literally to the states of the same name in `AUDIT.md`. **`done` means
ready for the final in-game validation. It does not mean tested in game, and nothing has been played.**

**How it got here, in two steps the same day.** The audit of the morning, recorded in
[docs/AUDIT-2026-09-28.md](docs/AUDIT-2026-09-28.md), retained **`preTest`**: every gate up to it was met, once
the description that failed on arrival was corrected, and `done` was not, because `AUDIT.md` asks for the Pickle
scenarios to be written with their scope justified and `Tests/Pickle/` did not exist. The audit itself creates
nothing; the session that holds the mod then wrote the suite, and the criteria of `done` were checked again:

| Criterion of `preTest -> done` | State |
| --- | --- |
| Functional scenarios written, with preconditions, actions and expected results | met: `TESTING.md`, seventeen |
| Automated tests written, run, green | met: 15 of 15, on the delivered DLL; nine seen to fail on injected faults |
| Pickle scenarios written, scope justified | met: six features in `Tests/Pickle/`, 26 scenarios expanded; scope in `TESTING.md` ("What plays each scenario") and `Tests/Pickle/README.md` |
| XML tests written, run, green | met: `Check-XmlFields`, `Check-DefRefs`, `Check-TypeRefs`, `Check-DefInjected` |
| Every non-applicability justified, no artificial test | met: five, each with its reason in `TESTING.md` |
| Results correspond to the delivered version | met: `Mod/Assemblies/FoldingSkateboard.dll` is unchanged since `6364ed8`, SHA-256 above |

The document read and the versions are in [docs/PROTOCOLS-READ.md](docs/PROTOCOLS-READ.md).

**What was done on the way**, no game launched and nothing published:

- Committed fifteen days of uncommitted work, in the state the 0.1.0 upload held, then
  `Add published Workshop file ID for 0.1.0` (item `3806761118`, `CHANGELOG.md` `## [0.1.0]`).
- Corrected the description, which said the port was made under "in-game testing": it has never run. It is
  now written once in `PUBLICATION.md`, and `About.xml` is its plain text, ending on `Source code on GitHub`.
  The tools are named as they are: Claude Code, and OpenAI's `gpt-image` (both source renders say so in their
  C2PA manifest).
- Took `renew` out of the packageId: `nelim.foldingskateboard`.
- Two more offline tests (the definitions, the provider's declared gates), and the plan in `TESTING.md`.
- Checked the original for a repository: none, so no fork and no pull request; the port began from the
  `Source/` its Workshop payload ships. Recorded in `ATTRIBUTION.md`.
- Wrote the README's "Known limitations", the one that matters being what removing the mod mid-ride can cost.
- Ignored `*.dds`, `*.ico`, `desktop.ini` and the evidence folders; trimmed two superseded copies under
  `.build/`. No Pickle report exists for this mod, so no launcher archive was touched.

### Next transition: `done -> tested`

Nothing of it has started. It needs the game, through the dispatcher and never directly:

- Play the passes: `sans-facultatifs` in English and in French, and `incompat-original`, commands in
  `Tests/Pickle/README.md`. Write `avec-lts` once the LTS mod is identified.
- **No scenario left `@wip`.** Repaired and replayed, or deleted with its reason written.
- **Every conditional scenario has run.** Feature 06 carries `@requires:silkcircuit.foldableskateboardmod`: it
  must have its pass, on a map that mounts that mod, and its report must be read, suite and scenario names
  checked first (the report folder is shared by the whole machine). A scenario skipped for want of its
  condition is not a scenario passed.
- **No manual test left to tick.** Everything in `TESTING.md` is automated and green or listed as not
  applicable with its reason. The `@review` captures are still opened.
- `exitReason` read before any count; scenarios played against features discovered; the log read from the start;
  every scenario that ever failed replayed green on a build that contains its fix.
- Then Options and MainButtons stay not applicable unless a setting is added.

### Evidence policy

Reports stay on disk under `Tests/Pickle/Evidence/` (ignored by git) and one line per run goes to
`docs/runs/`. Keep the summary, the junit and messages files, `Player.log`, the completeness marker and the
opened `@review` captures as JPEG; delete `screenshots/` copied whole, `report.html`, failed or superseded
reports and anything on a superseded build, after the line is written and after repointing any field that
named it. List before deleting. The full table is in `TESTING.md`.
## Audit — 2026-10-02

Previous stage `done` (`workflow_stage` was missing, now written). Retained: **`done`**. Revision audited
`756cb4c`, working tree clean, no game launched. Documents re-read against `AUDIT.md` d1fdbe1,
`PUBLISHING.md` 4e8f11a and `TRANSLATIONS.md` af8427f: see [docs/PROTOCOLS-READ.md](docs/PROTOCOLS-READ.md).

- Gates before `preTest` still hold: `Mod/About/Preview.png` carries the ModIcon in the left corner (rule of
  2026-09-29) and `Art/Gallery/0-preview.png` is byte-identical to it. The ModIcon decision stays the owner's.
- `l10n` against today's TRANSLATIONS.md: no displayed number goes through a key (four Keyed strings and three
  DefInjected files carry only `{0}`, the item label), so the plural rule has nothing to check. The French
  gender rule was audited on 2026-09-30; `translation_fr` stays `partial` until Virginie reads
  `FRENCH_REVIEW.md`. That is an unverified review, not a defect, so `stage` does not fall.
- Cleaned: no `.dds`, `.ico`, `desktop.ini` or evidence file is tracked, and all four are in `.gitignore`. On
  disk `Tests/Pickle/Evidence/` went from 63 MB to 1.6 MB. Deleted: the empty `2026-09-28-captures-en`, and
  `2026-09-30-captures-en-4` (61 MB, a failed replay on a tree older than the `StopAll` fix, its failure
  already a line in `docs/runs/`). Kept: `2026-09-28-sans-facultatifs-en`, the only full run and the only
  proof of the 21 scenarios no replay repeated. `pickle-reports-archive/` holds nothing of this mod.
- The original has no git repository (`ATTRIBUTION.md`, 2026-09-28): `upstream_mod_remotes: N/A`, no fork, no
  pull request to make.
- `0.1.0` was prepublished: `Mod/About/PublishedFileId.txt` holds `3806761118` and `CHANGELOG.md` records
  `## [0.1.0] — 2026-09-23`.
- `done -> tested`, as `AUDIT.md` now writes it: no scenario `@wip`; every `@requires:` scenario played on a
  map that mounts that mod (feature 06); no manual test left to tick; `@review` captures opened.

## Translation audit — 2026-09-30

`translation_fr` reset to `unchecked` by the 2026-09-30 French gender-agreement rule (TRANSLATIONS.md
section 3), then set to `partial` here: audited by this session, not yet reviewed by Virginie.

French lives in four files, all read in full this session:
- `Mod/Languages/French/Keyed/FoldingSkateboard.xml` — four pickup-refusal/action strings
- `Mod/Languages/French/DefInjected/ThingDef/FoldingSkateboard.xml` — the board's label/description
- `Mod/Languages/French/DefInjected/TraitDef/FoldingSkateboard.xml` — the Shredder trait's label/description
- `Mod/Languages/French/DefInjected/JobDef/FoldingSkateboard.xml` — the pickup job's report string

None of the eight French texts uses `{PAWN_gender ? ...}`: the two that name the colonist ("le colon
porte déjà...", "le colon gagne le trait...") use the invariant noun "colon" rather than an agreeing
adjective or participle, which TRANSLATIONS.md's "prefer a wording with no agreement" already permits.
One row flagged `?` in `FRENCH_REVIEW.md`: the Shredder trait label ("Rideur") has no gender switch and
no English `labelFemale`, so it is unclear whether the new rule reaches invariant trait labels.

`FRENCH_REVIEW.md` generated by `_tools/Generate-FrenchReview.ps1` (reads the shipped XML, not
hand-copied), revision: this commit. Virginie has not reviewed it yet: no reviewer/date/corrections line
below, and `translation_fr` stays `partial` until she has.

