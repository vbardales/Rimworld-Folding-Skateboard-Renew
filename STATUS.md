---
localization: complete
translation_en: complete
translation_fr: complete
mod:          Folding Skateboard Renew (unofficial)
packageId:    nelim.foldingskateboard
repo:         Rimworld-Folding-Skateboard-Renew
visibility:   public
detached:     yes
workflow_stage: playTests[1.0.0]
settings_audit: not_applicable
automated_tests: 15 of 15 passed on 2026-09-28, nine of them seen to fail on injected faults; delivered DLL SHA-256 E829298B8F3A298380B4E0942D2534DE9C8760F7D342FB2F465234DDBA27551D
xml_tests:    passed on 2026-09-28 (Check-XmlFields, Check-DefRefs, Check-TypeRefs, Check-DefInjected); Check-XmlClasses not applicable
pickle_scenarios: 20 blocks in 6 features, 26 scenarios; first run 2026-09-28 (request 5877, English, sans-facultatifs, tree 6bc7657, exitReason passed): 25 passed, 0 failed, 1 skipped by requirement (feature 06); two of the five @review captures do not show the facing they are named for; replay of feature 05 on 2026-10-11 (request bfee) passed 5 of 5 with the five captures opened; French pass and incompat-original not run
audit_revision: 756cb4c61b47dda7850c5aa9d5be20cbcffd77ab
audit_date:   2026-10-02
licence:      silent
licence_at:   four places, the About and the Steam page among them; the page read again 2026-09-28
upstream_mod_remotes: N/A
dependencies: declared
showcase:     complete
echo_review_sha: 1963ddbf7e44584189a119f2225c8620d4fc80e5
code_review_sha: 8f4619cddda5298af8b7e3a05342e15aad9d8a59
social_preview_sha256: 4badb10cc619b465afcf357632b62ded7912f13dfe227c2217dd21cba1acb271
tested_on:    2026-10-14 (RimWorld 1.6, Pickle in WSL, English and French; nothing played by a person)
workshop:     "3806761118 (0.1.0, prepublished 2026-09-23; the item is private, visibility and subscription test not done)"
remaining:
  - done 2026-10-11 (closing pass 3): Tests/Pickle/Check-Steps.ps1 deleted, shared scripts/Check-Steps.ps1 passes (24 patterns, 179 step lines, one match each); _tools removed (Render-Preview.cjs, preview.html superseded by the shared renderer; Run-Functional-Tests.ps1 moved to scripts/ and justified in LOCAL_SCRIPTS.md; Generate-FrenchReview.ps1 deleted, FRENCH_REVIEW.md now from the shared Make-FrenchReview.ps1 with french-review-flags.json for the Shredder doubt), .build removed (Directory.Build.props deleted, intermediates now in Source/obj and Tests/Pickle/Source/obj, git-ignored); 15 of 15 offline tests pass; DLLs kept at the tested hash
  - done 2026-10-14: code review of Source/ from the first commit to 2037264, then revue du diff : images et texte seuls (About.xml description only, 8.m) up to the sha above (825 lines, 9 files; Tests/ commits do not reopen it, AUDIT.md 8.m). No defect that blocks. Noted, inherited from the original and not fixed: (1) a colonist downed outdoors on a hard floor with a board is still drawn riding and keeps Shredder; (2) a pawn who dies or leaves the game with a suspended speed trait leaves one entry in the saved `OriginalSpeedOffsets` dictionary; (3) if the inventory refuses the board and no cell is free, the board is lost after the warning; (4) the renderer asks MaterialPool for the material each frame, a cache lookup, not an allocation. All four are unverified in game
  - done 2026-10-12: tickets 69a1 (incompat-original: 1 of 1 passed, feature 06 played) and 478d (sans-facultatifs French: 24 of 25, `a wall directly south...` failed on facing 3 not 2, job=HaulToCell despite StopAll); lines in docs/runs/. Replays: 1256 (French captures, tree 98ae182) failed 3 of 5 on facing, cause: StopAll let the colony AI hand a new HaulToCell; fixed in 2037264 (Wait job), ticket 0f2a passed 5 of 5 on 2026-10-14, five captures opened. Lines in docs/runs/
  - done 2026-10-12: ticket 20261011-215617-032-bfee, 05-captures, English, sans-facultatifs: exitReason passed, 5 of 5, all five @review captures opened and as named (the four earlier replays failed on facing); line in docs/runs/README.md; evidence kept in Tests/Pickle/Evidence/2026-10-11-captures-en (summary, junit, messages.ndjson, Player.log, 5 JPEG; report.html and PNGs deleted). Still to play in playTests: full suite after the commit and deploy, French pass, incompat-original, feature 06 (needs silkcircuit.foldableskateboardmod)
  - done 2026-10-11: second review applied (ATTRIBUTION.md wording: upstream search, caravan postfix, SilkCircuit pronouns).
  - done 2026-10-11: French review by Virginie ("validé", on FRENCH_REVIEW.md at committed revision 5b694f5, corrections applied); translation_fr complete (AUDIT.md 6.g, 7.g). Token {PAWN_gender ? il : elle : al} rendering still to check in game (playTests)
  - unverified: the first run (docs/runs/) confirmed assumptions 1 to 4 and 6 to 10 of Tests/Pickle/README.md by passing; 5 (the collision in the log queue) is untested because feature 06 was skipped by requirement, and 11 (Pickle build) is not established. Nothing has been played in French
  - done 2026-09-28: request 20260928-104830-059-5877 ran, exitReason passed, 25 of 26, feature 06 skipped by requirement; line in docs/runs/. Evidence kept in Tests/Pickle/Evidence/2026-09-28-sans-facultatifs-en (summary, junit, messages.ndjson, Player.log, 5 JPEG); report.html and PNGs deleted. Player.log shows two "did not load any content" errors, both for code-only companion mods (load audit, this suite), not the mod
  - done 2026-09-28: replay of 05-captures (request 20260928-172643-796-23e6, tree 016fc42) failed 3 of 5: `Ada is facing 2 [South]`, not the asked direction, on rider-facing-west and board-on-back-facing-north. Cause found: a drafted idle colonist tracks the mouse cursor (RimWorld idle-facing), overriding the set rotation; the fixed south scenarios only passed by coincidence, the cursor projecting south. Fix: undraft after the Shredder assertion, before the photo. Report deleted, cause and fix recorded here and in docs/runs/. To replay
  - done 2026-09-28: second replay (request 20260928-225717-710-7de5, tree 0a0d657) failed 3 of 5, now the opposite way: `Ada is facing 3 [West]`, not South, on rider-facing-south and wall-south-no-board — the two the undraft fix had already made pass. Cause found: undrafting removed drafted aim, but the re-face step still ran before the camera-look-at and zoom steps, and idle facing can still drift during the real time those take. Fix: the facing step now runs last, immediately before the screenshot, in all four scenarios. Report deleted, cause and fix recorded here and in docs/runs/. To replay
  - done 2026-09-29: third replay (request 20260929-170915-679-2155, tree 4bf7196) failed 3 of 5, same two scenarios, same `Ada is facing 3 [West]`. The reorder did not touch the real cause: the failure's state dump showed Ada mid-job, `job=HaulToCell`, `drafted=False` — undrafting in a loaded save with real haulable items lets the colony AI hand her a work order the instant she is undrafted, and its JobDriver sets Rotation to the travel direction every tick, overriding the manual rotation regardless of when it was set. Fix: the `Faces` step (FoldingSkateboardSteps.cs) now also calls `pawn.jobs.StopAll()` and `pawn.pather.StopDead()` in the same call that sets Rotation, so no job can reclaim it between the last re-face and the photo. Report deleted, cause and fix recorded here and in docs/runs/. To replay
  - unverified: to reach tested, the passes sans-facultatifs (English, then French) and incompat-original must run green, no scenario may be @wip, the conditional feature 06 must be played and not skipped, and every @review capture of feature 05 must be opened (AUDIT.md, done to tested); nothing has run
  - feature: the avec-lts pass is not written. The Workshop mod that defines the 141 LTS floors is not identified (one bounded read of About.xml files found nothing before its time limit, which proves no absence), so there is no map, and that integration cannot yet be credited
  - unverified: the collision of the two mods' defNames is asserted by reading the game's log queue for an error mentioning Paddleboard (feature 06); which mod survives is not documented and not asserted
  - unverified: English and French display of the four pickup keys and the three DefInjected files in game, and the raw-key check; static coverage is complete
  - defect: the Steam page of item 3806761118 still carries the description of the 0.1.0 upload, which claims in-game testing and ends on a bare URL; the repository's description is corrected, the page changes only by update_description of a publish or by hand
  - unverified: the private 0.1.0 item was uploaded from the working tree and probably carries four .dds caches that git never held, and the earlier packageId; check its file list. 1.0.0 replaces both
  - decision: the ModIcon at 32 px shows the head clearly and the board as a dark shape; the control passes, the owner alone decides to leave it or remake it (STYLE_RIMWORLD.md)
  - decision: renew was removed from the packageId on 2026-09-28 under PUBLISHING.md of 2026-09-27, while the item is still private; reversible until publication, not after
  - not applicable, with reasons in TESTING.md: the recipe's gating by the game (2), the game's honouring of the provider's flags (6), a real caravan (13), removing the mod from a running colony (15, stated to players in the README instead), a tick-cost threshold (17)
  - unverified: not yet written for prepublished, namely the gallery and its order, the mature-content answer, the thank-you message for the original's page and Harmony's Covers cell, the Steam change note, the publish workflow and its dry-run
  - resolved 2026-09-28 (preTest to done): the Pickle suite is written in Tests/Pickle/ (6 features, 23 step patterns, a README that justifies the scope, two pass maps), and Check-Steps.ps1 resolves every step line to exactly one step. Written, not run: done does not ask for a run
session:      local_b01ccdc3-6c60-4c47-bf84-550369df5630
updated:      2026-10-11, full audit of transitions 1 to 7 against AUDIT.md ad0347e: retained writeTests[1.0.0] (7.g fails: translation_fr partial, Virginie review pending; target version 1.0.0 per CHANGELOG, not 0.1.0); the table-only mapping to playTests was wrong (stage field removed, protocols_read_sha written), capture-facing replay ticket bfee filed; 2026-10-02, audit re-applied against AUDIT.md d1fdbe1 (stage kept, workflow_stage added, evidence trimmed, protocols re-read); 2026-09-30, translation_fr set to partial (FRENCH_REVIEW.md generated, awaiting Virginie's review); fourth capture replay's cause found (undrafted colonist picks up a real haul job that overrides Rotation) and fixed (StopAll + StopDead in the facing step), fifth replay to file
protocols_read_sha: abe91647aaaabbb913f42a9a699ab0b3db63942c
---
# Folding Skateboard Renew — status

## Current state, 2026-10-13

Stage `playTests[1.0.0]`. Automated 15 of 15 and the XML checks pass on the delivered DLL. Pickle on 1.6: English full run 25 of 26 plus feature 06 green, English captures 5 of 5, French full run 24 of 25, French captures 5 of 5 after the `Faces` fix (ticket `0f2a`, five captures opened). Code review of `Source/` done (`code_review_sha`). Still open for the exit of `playTests`: the rendering of the `{PAWN_gender ? il : elle : al}` token in the Shredder description (no scenario shows it), the raw-key check, Virginie's call on the ModIcon, and the 1.7 pass (separate, `tested_1_7` absent). Nothing has been played by a person. The earlier decision text, the 2026-10-02 audit and the 2026-09-30 translation audit are in [docs/STATUS-HISTORY.md](docs/STATUS-HISTORY.md).

## Vocabulary

`licence`: `open` an explicit licence, `silent` no licence and a dead source, `alive` no licence
but a living source, `forbidden` a written refusal, `original` owing nothing to anyone — not a
name, not an idea traceable to one mod, not a value derived from its assets.

`showcase`, read off the disk: `none` neither image, `icon` or `preview` one of the two,
`complete` both. It says which files exist, never whether they are any good: this mod counted as
`icon` on 2026-09-12 while that icon was four times too wide and forty times too heavy for the
32 px it is shown at.

## What this file is for, and the one way it goes wrong

It is read by sweeps that ask all 116 mods a question at once, and the answers are only worth
what the sheets are worth. A sheet that says `done` while a defect sits unwritten is worse than
no sheet: the sweep reports a clean mod and nobody looks again.

So the rule for keeping it is the same one the documents of this repository follow — **a line
that stops being true is a line to change, and the moment to change it is the commit that made
it false.** Not the next sweep, which will simply copy the lie forward.

## Audit — 2026-10-11 (transitions 1 to 7, checked one by one)

Retained **`writeTests[1.0.0]`**. The earlier same-day line mapped the old `done` to `playTests` by the correspondence table alone; that was not an audit.

- 1 to 2 (setupRepo, makeSources): repository, remote, STATUS, ModIcon and Preview sources present (owner's, not generated here).
- 3 (code): CHANGELOG `[1.0.0] unreleased` says what changes; Mod/Assemblies DLL is the git-tracked build, SHA-256 E829298B... (a fresh rebuild gives another hash, so the tested DLL was restored, not replaced).
- 4 (dependencies): About.xml names Harmony in `modDependencies`, `incompatibleWith` the original, `loadAfter`; `dependencies: declared`, justified above.
- 5 (settings): `not_applicable`, sources and Defs show no ModSettings, page or shortcut.
- 6 (localize): Check-Translations PASS, Check-DefInjected 5 keys 0 errors, FRENCH_REVIEW.md regenerated by the shared Make-FrenchReview.ps1.
- 7 (writeTests): 7.b 15 of 15 offline tests rerun green today; 7.c Check-XmlFields, Check-DefRefs, Check-TypeRefs, Check-DefInjected green today; 7.d Pickle suite written (Check-Steps shared script: 24 patterns, 179 lines, one match each); 7.e non-applicability reasons in TESTING.md. **7.g FAILS**: `translation_fr: partial`, Virginie's review of FRENCH_REVIEW.md not done, and a session never marks its own French reviewed. 7.a note: the scenarios file is `TESTING.md`, AUDIT.md names `TEST_SCENARIOS.md`; not renamed, to be arbitrated.
- Pickle ticket bfee (05-captures) stays queued: playing it early is harmless, but it counts as `playTests` work.

## Audit — 2026-10-11, exit of writeTests

Reviewer: Virginie, 2026-10-11, FRENCH_REVIEW.md at revision `5b694f5`; corrections applied (trait label "Pro de la glisse", il/elle/al branch, +2 bonus wording, PUBLICATION, About.xml, CHANGELOG, ATTRIBUTION wording); she validated. 7.g now met, so 7.a to 7.h hold and the stage moves to `playTests[1.0.0]`. Ticket bfee (05-captures) is now playTests work in progress.

## Preview refresh — 2026-10-12

Echo: kept as the new line-art `Art/echo-preview.png` (replaces `echo.png` and `echo-source.svg`; it shows the board itself, which is what the gallery shows). `Art/Preview.config.json` now points at it, with `panelRight -13`, `panelWidth 42`, `panelTop 8` so the outline sits clear of the title (the first render crossed the final D). Rendered with the shared `Render-Preview.cjs`: `Mod/About/Preview.png` 896 x 504, 600,926 bytes; `Art/Gallery/0-preview.png` is its byte copy (the tracked name was `0-Preview.png`, renamed). Text, palette and badge are unchanged, so the earlier contrast measurements stand; they were not measured again on this render. GitHub social preview uploaded through the browser, `og:image` downloaded and byte-identical (`social_preview_sha256` above). Nothing was published to the Workshop: the Steam page of item 3806761118 still carries the old image until the 1.0.0 publish.

## Folded history

Superseded 2026-09-13 decisions, the sweep notes and the 2026-09-13 to 2026-10-03 dated sections moved to [docs/STATUS-HISTORY.md](docs/STATUS-HISTORY.md) on 2026-10-13 (rule: STATUS.md keeps the current state only).
