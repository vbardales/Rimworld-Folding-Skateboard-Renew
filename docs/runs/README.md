# Run history

One text line per game run, in git. The reports themselves (captures, `Player.log`, `junit.xml`) stay on
disk under `Tests/Pickle/Evidence/`, which git ignores; `AGENTS.md` and `TESTING.md` say what to keep
there and what to delete. A folder is deleted **after** its line is written, and never while
`STATUS.md` or a tracked file points at it: repoint the field to its line here first.

One game run so far, below. An empty table would be the honest state before one.

| Date | Request | Revision | Pass | Language | Filter | `exitReason` | Played / discovered | Passed | Failed | Skipped | Flaky | Captures opened | Note |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 2026-09-28 | 20260928-172643-796-23e6 | 016fc42 | sans-facultatifs | English | 05-captures | failed | 3 of 5 | 3 | 2 | 0 | 0 | 0 of 5 | Both failures: `Ada is facing 2 [South], not 3/0 [West/North]`. Cause: a drafted, idle colonist tracks the mouse cursor to aim (RimWorld idle-facing), overriding the set rotation; the camera-centred cursor projects toward South, which happens to match the two scenarios that already passed. Fix: undraft after the Shredder assertion, before the photo (05-captures.feature, commit pending); the trait check runs off the Tick patch, not drafted state. Report deleted after this line and the cause in STATUS.md: failed attempt, superseded by the replay |
| 2026-09-28 | 20260928-225717-710-7de5 | 0a0d657 | sans-facultatifs | English | 05-captures | failed | 3 of 5 | 3 | 2 | 0 | 0 | 0 of 5 | Both failures now South: `Ada is facing 3 [West], not 2 [South]`, on the two scenarios undrafting had already fixed. Cause: undrafting removed drafted aim, but the re-face step still ran before the camera-look-at and zoom steps; real time passes ticks during those, in which idle facing can still drift. Fix: the facing step now runs last, immediately before the screenshot, in all four scenarios (05-captures.feature, commit pending). Report deleted after this line and the cause in STATUS.md: failed attempt, superseded by the replay |
| 2026-09-28 | 20260928-104830-059-5877 | 6bc7657 | sans-facultatifs | English | none | passed | 25 of 26 | 25 | 0 | 1 (feature 06, by requirement `@requires:silkcircuit.foldableskateboardmod`) | 0 | 5 of 5 | The two captures named west and north show the rider facing the camera, and no board on the back: the state assertion passed, the picture does not show the facing. Steps changed (`is facing`, re-face before the picture); to replay. Folder trimmed to text + 5 JPEG |

How to fill a line: the request id from the dispatcher's `RUN_DONE`, the full or ten-character SHA of
the tree that was staged (a request carries none, so it is written in the request's label), the pass
map name and the language, the filter as given, then `exitReason` **read before** any count, played
against discovered, and the number of `@review` captures actually opened. A run that produced no
report is a line too: `no-report` in `exitReason`, and the cause in the note. That is infrastructure,
not a result.
