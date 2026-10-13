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

