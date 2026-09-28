# Run history

One text line per game run, in git. The reports themselves (captures, `Player.log`, `junit.xml`) stay on
disk under `Tests/Pickle/Evidence/`, which git ignores; `AGENTS.md` and `TESTING.md` say what to keep
there and what to delete. A folder is deleted **after** its line is written, and never while
`STATUS.md` or a tracked file points at it: repoint the field to its line here first.

**No game run has happened for this mod.** The table stays empty until one does. An empty table is
the honest state, not a placeholder to fill.

| Date | Request | Revision | Pass | Language | Filter | `exitReason` | Played / discovered | Passed | Failed | Skipped | Flaky | Captures opened | Note |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |

How to fill a line: the request id from the dispatcher's `RUN_DONE`, the full or ten-character SHA of
the tree that was staged (a request carries none, so it is written in the request's label), the pass
map name and the language, the filter as given, then `exitReason` **read before** any count, played
against discovered, and the number of `@review` captures actually opened. A run that produced no
report is a line too: `no-report` in `exitReason`, and the cause in the note. That is infrastructure,
not a result.
