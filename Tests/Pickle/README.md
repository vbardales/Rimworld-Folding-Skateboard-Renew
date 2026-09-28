# Folding Skateboard Renew - Pickle suite

In-game functional tests, played by [Pickle](https://github.com/RimWorks/Rimworld-Pickle) in the headless
WSL install. **Written, never run.** `done` asks for the suite to be written with its scope justified;
running it, reading its captures and repeating it per language and per pass is `done -> tested`
(`AUDIT.md`). Everything below that says "asserts" is what the scenario is written to assert, not what a
run has shown.

Development only. Nothing in this folder is part of the Workshop payload: `Mod/` at the root of the
repository is, and this is `Tests/Pickle/Mod/`, a companion mod that only Pickle loads.

## What is here, and what is deliberately not

`TESTING.md` at the root lists seventeen scenarios and says which is played by what. This suite plays
the ones that only a running game can show: the menu the game builds for a click, the trait and the speed
the tick patch gives, the trait put away and given back across a real save and reload, a rider who leaves
the map, and the pictures a person has to look at.

Not here, and why:

- **What the XML says** (the recipe, its gates, its cost, the trait's offset) and **what the provider
  declares** (undrafted only, one pawn, manipulation required): asserted offline by
  `_tools/Run-Functional-Tests.ps1`, in seconds and with no colony. A scenario that restated them would
  hold the machine for nothing.
- **What the game does with a declaration**: whether its menu builder honours the provider's four flags,
  what it does with a bill below Crafting 4, how a caravan forms, what it does with a removed mod. Those
  are the engine's, and `AUDIT.md` says the engine is not tested.
- **A tick budget.** A mean tick cost on a shared headless machine measures the vanilla colony far more
  than this mod, so a threshold would either never fail or fail for a reason that is not ours. It is not
  asserted; see `TESTING.md` scenario 17.
- **Which of two colliding mods survives** in the incompatibility pass: not documented, not seen.

## Layout

```
Tests/Pickle/
  README.md                          this file
  Check-Steps.ps1                    the offline check of every step line; see below
  wsl-deps.sans-facultatifs.map      the mod, Harmony and the load-audit companion
  wsl-deps.incompat-original.map     SilkCircuit's original beside the mod
  Source/                            the C# of the steps (23 patterns) and its project
  Mod/                               the companion mod the staging copies
    About/About.xml                  nelim.foldingskateboard.pickletests
    Pickle/Features/*.feature        six features
    Pickle/Assemblies/*.dll          the built steps, tracked so a checkout can be staged
  Evidence/                          ignored by git: reports and captures, see TESTING.md
```

The steps assembly references nothing of the mod: it reaches the mod through the game's types, the
mod's defNames and Harmony's patch registry. It builds against `Krafs.Rimworld.Ref` and
`RimWorks.Pickle.Ref`, intermediates in `.build/pickle/`, outside the companion folder.

## The features

| Feature | Scenarios | Plays |
| --- | --- | --- |
| `01-load-and-patches` | 2 | The load audit finds nothing of the mod's own in the log; each of the three patches is owned once by the mod's Harmony id (the 1.5 mod patched twice). Main menu, no colony |
| `02-pickup` | 4 | The pick-up entry appears in the menu the game builds and its action puts the board in the inventory, not the hands; the three refusals read as the mod's own translated sentences, by comparison with the language file of the pass |
| `03-riding` | 2 outlines and 3 scenarios, 10 played | Shredder and exactly +2 move speed on concrete, wood plank, rough stone and a bridge; neither on soil, sand or smooth stone; not under a roof; folds and unfolds as the rider steps off and on; never without a board |
| `04-speed-trait` | 1 outline of two examples and 2 scenarios | A fast walker and a slowpoke are set aside while riding and come back; a rider who leaves the map is given hers back; a real save and reload mid-ride keeps the parked trait |
| `05-captures` (`@review`) | 5 | The pictures: boards coloured by their stuff, a rider facing south and west, the board strapped to a back seen from behind, a wall directly south hiding the board. The state is asserted, the picture is looked at |
| `06-incompatible-original` | 1 | `@requires:silkcircuit.foldableskateboardmod`. The documented collision on the board's defName, read from the game's log queue |

The map is not known in advance, so no step names a cell of the fixture: a scenario asks for a **yard**,
a 7 by 7 square of clear ground found near the middle of the map, and every other step speaks in offsets of
it. `(0, 0)` is its south-west corner, and the board and the rider are put at `(3, 3)`. Plants and filth
in the yard are cleared; anything else in the way disqualifies a spot.

## Passes

| Pass | Map | Filter | Language |
| --- | --- | --- | --- |
| `sans-facultatifs` | `wsl-deps.sans-facultatifs.map` | the whole suite | English, then French: two requests |
| `incompat-original` | `wsl-deps.incompat-original.map` | `06-incompatible-original` | English |
| `avec-lts` | **not written** | | English |

The feature `06` is skipped **by requirement** in the first pass, which is how it should read: the original
is not mounted there. The second pass names only that feature, because the other five would collide with the
original's own board.

**`avec-lts` cannot be written yet.** The 141 `LTS_...` floors the mod lists belong to some Workshop mod
of LTS Systems' that this repository does not name; one bounded read of the `About.xml` files for an author
or a name containing "LTS" found nothing before its time limit, which proves no absence. Until that mod is
identified there is no map to write, and the pass stays a planned one in `TESTING.md`. Identifying it is a
corpus search (`scripts/SEARCHING.md`), to be run when no other search is reading the disk.

## How to file a run

Never launch the game: file a request, and the dispatcher's worker plays it when the machine is free.
`<id>` is this session's `local_...` id; the request carries no SHA, so the label does.

```powershell
powershell.exe -ExecutionPolicy Bypass -File C:\Users\nelim\Documents\rimworld\Rimworld-Ticket-Dispatcher\scripts\Submit-PickleRun.ps1 `
  -Mod FoldingSkateboardRenew -Owner local_<id> -Label "sans-facultatifs English <sha>" `
  -DepMap wsl-deps.sans-facultatifs.map `
  -EvidenceDir FoldingSkateboardRenew/Tests/Pickle/Evidence/<date>-sans-facultatifs-en

# the same with -Language French and -EvidenceDir ...-fr

powershell.exe -ExecutionPolicy Bypass -File ...\Submit-PickleRun.ps1 `
  -Mod FoldingSkateboardRenew -Owner local_<id> -Label "incompat-original <sha>" `
  -DepMap wsl-deps.incompat-original.map -Filter '06-incompatible-original' `
  -EvidenceDir FoldingSkateboardRenew/Tests/Pickle/Evidence/<date>-incompat-original
```

Keep the tree of the mod frozen from the request to its `RUN_DONE`. Read `exitReason` before any count,
compare scenarios played with features discovered, open every `@review` capture, and keep only what
`TESTING.md` says to keep.

## The offline check

`Check-Steps.ps1` needs no game and runs in seconds. It compiles every step pattern with Pickle's own
expression engine, refuses a pattern declared twice, and resolves every step line of the features to
exactly one expression among this suite's, Pickle's installed vocabulary and the steps of every other suite
of the collection (all steps share one namespace). A Scenario Outline is expanded with every row of its
Examples tables before its lines are resolved. Its first run found two lines it wrongly called unresolved,
both `{int}` placeholders of an outline; it was made to expand outlines, and it now reports 167 step lines
in six files as resolved. Twenty scenario blocks, twenty-six scenarios once the outlines are expanded.

It was **seen to fail** on three faults injected one at a time in a copy: a step line that matches nothing,
a pattern with an unclosed brace, and a pattern copied from Pickle's own vocabulary (ambiguous).

It proves the lines resolve. It proves nothing about what a step does.

## What the first run has to confirm, and what it may break

Nothing below has been observed. Each is an assumption the suite makes, and a red on it means the
assumption was wrong before it means the mod is.

1. `FloatMenuMakerMap.GetOptions` returns an entry whose label equals the translation of
   `FoldingSkateboard.TakeToInventory` with the board's short label, and the entry's `action` starts the
   ordered job.
2. A drafted colonist put on a cell by assigning `Position` and calling `Notify_Teleported` stays there for
   the wait.
3. Ninety ticks give the surface check, which runs every 15, its six chances; the waits stay under the
   step limit at the 500 to 700 ticks per second the WSL install measured.
4. `GetStatValue(MoveSpeed)` moves by exactly 2.0 with the trait, within 0.05: no other stat part reacts to
   the change.
5. `Log.Messages` still holds the startup error of the defName collision, that is, the queue was not
   trimmed past it (feature `06`).
6. The fixture has a 7 by 7 square of clear ground within 60 cells of the middle of the map.
7. `Sandstone_Rough`, `Sandstone_Smooth`, `Sand`, `WoodPlankFloor`, `Bridge` and `BlocksGranite` exist as
   defs in this build.
8. `I save and reload` keeps the terrain, the walls and the colonist's nickname the scenario relies on.
9. The pick-up job completes within 600 ticks from a cell three away.
10. Pickle's own steps used here (`I draft`, `is wielding nothing`, `is carrying`, `I zoom all the way in`,
    `I take a screenshot`, `I wait`, `I save and reload`) behave as their catalogue says. `Check-Steps.ps1`
    confirmed that they exist in the installed build; it did not run them.
11. Pickle 4.9.1 is the installed build; the built-in catalogue read while writing this was a local checkout
    of 2026-09-21, not established as the same version.
