# Folding Skateboard Renew — in-game test scenarios

Nothing in this mod has ever been seen running. The port was built by reading the 1.6 assembly, the
build is clean and the functional tests pass, but none of that exercises a single tick of the game.
This file is the list of what has to be watched, and what counts as a pass.

It is not shipped: it lives beside `Mod/`, never inside it, so Steam never receives it.

Run `_tools/Run-Functional-Tests.ps1` first. It settles, in seconds and without a colony, what the
mod hooks into and whether the game still does it — the patch targets, the draw-phase call, the
provider sweep, the floor names, the translation keys. A red line there explains a scenario below
that would have failed anyway. It proves nothing about what appears on screen, which is why the
seventeen below stand unchanged.

## What plays each scenario, and what `tested` asks

The seventeen scenarios below are the acceptance list. None of them is played by hand at the end:
`AUDIT.md` (step `done -> tested`) wants every one either automated and green, or listed here as not
applicable with its reason. This table says which, and it is also the justification of the Pickle
suite's scope: only what a running game alone can show is written in Gherkin, and what a test outside
the game can prove stays outside it.

| # | Scenario | Played by | Why |
|---|---|---|---|
| 1 | The mod loads, the patches apply | Any Pickle run, plus the load audit | A patch that throws at startup kills the game before the runner exists; the load audit reads the log for the rest |
| 2 | The recipe, its gates, its cost | **Offline**, `_tools/Run-Functional-Tests.ps1` (definitions test) | Static facts of the def. That the game refuses a bill below Crafting 4 is the game's own logic, not the mod's, and is not tested |
| 3 | The board takes its material's colour | Pickle, `@review` capture | Only a person can look at a colour |
| 4 | Picking one up | Pickle | The provider and the job run through the game's own callbacks |
| 5 | The three refusals, worded | Pickle | Conditions read game state; the wording is the four keys, in each language |
| 6 | The three silent gates | **Offline**, `_tools/Run-Functional-Tests.ps1` (provider-gates test) | The mod declares four flags: undrafted only, one pawn, manipulation required. That the game's menu builder honours them is the game's business and is not tested; the declaration is the mod's, and is read from the built class |
| 7 | Riding | Pickle, with a `@review` capture | The trait and the speed are asserted; the drawn board is looked at |
| 8 | Folding, indoors and off the hard ground | Pickle, with a `@review` capture | Same |
| 9 | The roof decides | Pickle | A roof placed over the cell |
| 10 | Mined rock, bridges, smooth stone | Pickle, one outline | Five terrains, one expectation each |
| 11 | Fast walker and slowpoke set aside and given back | Pickle | Trait swap, and the parked trait in the mod's game component |
| 12 | A wall directly south hides the board | Pickle, `@review` capture only | Nothing but the drawing changes, so nothing can be asserted, only looked at |
| 13 | Leaving the map mid-ride | Pickle, by despawning the pawn | The mod answers for its `DeSpawn` hook; forming a caravan is the game's own mechanism and is not tested |
| 14 | Save and reload mid-ride | Pickle, `I save and reload` | A real save, a real load, and the component comes back from the file |
| 15 | Removing the mod mid-ride | **Not applicable**, documented as a known limitation | What the game does with a trait whose mod is gone, and with a game component whose class is gone, is the engine's handling of a removed mod, which `AUDIT.md` says is not tested. The consequence is stated to players in the README instead |
| 16 | French | The same suite, played with `-Language French` | The language is fixed at launch, never switched inside a run |
| 17 | A full colony's tick cost | **Not applicable** as a test | A mean tick cost on a shared headless machine measures the vanilla colony far more than this mod: a threshold would never fail, or fail for a reason that is not ours. The claim is structural (the 1.5 mod allocated a list per pawn per tick; this one resolves the terrain names once and returns early for a pawn without a trait set) and is read in the code, not measured |

Not applicable, with the reason: forming a real caravan or sending a shuttle (scenario 13, the
engine's mechanism); the game's refusal of a bill below Crafting 4 (scenario 2, the engine's rule);
the game's honouring of the provider's four flags (scenario 6, the engine's menu builder); removing the
mod from a running colony (scenario 15, the engine's handling of a removed mod, and a limitation the
README now states); switching language inside a session (scenario 16, a restart of the game, done by a
pass per language).

Where the Pickle scenarios live, in `Tests/Pickle/Mod/Pickle/Features/` (the suite is written and has never
run; its README lists what its first run has to confirm):

| Scenario | Feature |
| --- | --- |
| 1 | `01-load-and-patches` |
| 3, and the pictures of 7, 8 and 12 | `05-captures` (`@review`) |
| 4, 5 | `02-pickup` |
| 7, 8, 9, 10 | `03-riding` |
| 11, 13, 14 | `04-speed-trait` |
| 16 | every feature, played once per language |
| the declared incompatibility | `06-incompatible-original` (`@requires:silkcircuit.foldableskateboardmod`) |

## Passes

A mod is not validated by one run, and a `TESTING.md` that does not say how many is not a plan.

| Pass | What it establishes | Language |
|---|---|---|
| `sans-facultatifs` | The mod and Harmony alone: Core, the DLC, Harmony, RimLogging, Pickle and the mod. Every scenario except the ones that need something else | English, then French: two requests |
| `avec-lts` | The board rides on a floor from one of LTS Systems' mods, and does not on a floor it does not name. Scenarios tagged `@requires:` for that mod skip anywhere else | English |
| `incompat-original` | SilkCircuit's original mounted beside this mod, to see whether the declared incompatibility is still true. The documented symptom is asserted, so green means "behaves as declared" | English |

Not needed, and why: a pass without a DLC (no DLC is used, named or branched on); a separate
restart chain for scenario 14 (`I save and reload` restores the component from a real save file, and
nothing this mod keeps lives outside that file).

The pass `avec-lts` cannot be written until the Workshop mod that defines `LTS_PlankFloor` and its
141 siblings is identified: it is not known from this repository, and it is unverified whether one
mod or several supply them. That mod is also then thanked, since a tested integration is credited.

## What has to be true before `tested`

The rules of `AUDIT.md` for `done -> tested`, applied to this mod. None of it is true today.

- **No scenario is left `@wip`.** A scenario put aside is either repaired and replayed, or deleted with
  its reason written here. A remaining `@wip` is a scenario waiting, not a scenario passed.
- **Every conditional scenario has run.** Each `@requires:<packageId>` had its pass, on a map that
  mounts that mod, and its report was read: the suite name and the scenario names checked before it is
  cited, because the report folder is shared by the whole machine. A scenario skipped for want of its
  condition is not a scenario passed.
- **No manual test is left to tick.** Everything in the seventeen is automated and green, or is listed
  above as not applicable with its reason. The `@review` captures are still looked at, but that is
  reading an image a scenario has already proved to be in the intended state, not one more manual test.
- `exitReason` is read before any count; scenarios played are compared with features discovered; a
  green capture scenario is not read as a correct picture; a rerun that passes only on a retry counts
  as flaky, not as green.
- The log is read from the start of the game, not only the scenarios' own `no errors were logged`.
- English and French were each a pass of their own, and the raw-key check found no accented
  fallback text (developer mode turns a missing key into accented gibberish, which is how it shows).
- Every scenario that ever failed was replayed green on a build that contains its fix.

## Evidence to keep, and what to delete

Reports and captures stay **on disk** under `Tests/Pickle/Evidence/`, which git ignores. Launch each
request with `-EvidenceDir Tests/Pickle/Evidence/<date>-<pass>-<language>` so that the report is copied
out of the shared, rolling folder before another mod's run overwrites it, and give the request the
SHA in its label: a request carries none, and the tree is staged when its turn comes.

| Keep, per pass | Why |
|---|---|
| `summary.json` and `summary.md` | The verdict. Read `exitReason` first |
| `junit.xml` and `messages.ndjson` | The step outcomes and the failure messages |
| `Player.log` | Startup, load order, dropped mods, errors outside the scenarios |
| `evidence-complete.txt` or `no-report.txt` | Says the copy is whole, or that the launcher left no report: infrastructure, not a result |
| The `@review` captures and films the pass exists to produce, **as JPEG** | The human review. Never the PNGs: 2.4 to 5.5 MB each |
| One line per run in `docs/runs/` | The history, kept in git as text. Write it **before** deleting the folder |

| Delete | When |
|---|---|
| `screenshots/` copied whole from the shared folder | Never keep it: it holds other mods' captures |
| `report.html` | Once the verdict is recorded; it is the largest file of a text-only run |
| A report of a failed or infrastructure attempt | Once its line is in `docs/runs/` and its cause is in `STATUS.md` |
| A report superseded for the same scenario and the same revision | When the newer one exists, unless the older one is the only proof of a check the newer did not repeat (a language, a pass) |
| Any report on a superseded build | After the pass is repeated on the current one: it proves nothing about the current build |

**Never delete a report that a `STATUS.md` field or a tracked file points to**: repoint it to its line
in `docs/runs/` first. List what goes and what stays before deleting. The launcher's archive folder is a
reprieve of five runs, not storage; a session takes what it needs from the archive of its own run
and deletes that archive afterwards, and leaves every other one alone.
## Before starting

- RimWorld 1.6, Harmony active, Folding Skateboard Renew active, SilkCircuit's original **not**
  active — the two declare the same defNames and the About declares them incompatible.
- Development mode on, so that silent failures become red text.
- The log to read afterwards, and to attach to any report:
  `C:\Users\nelim\AppData\LocalLow\Ludeon Studios\RimWorld by Ludeon Studios\Player.log`
- A colonist with Crafting 4 or more, Smithing researched, and a crafting spot or a smithy. Debug
  actions → Spawn thing → `Paddleboard` is the shortcut; the defName is SilkCircuit's, kept so that
  a save from the 1.5 mod keeps its boards.
- A patch of built floor **outdoors and unroofed**, and a patch of soil or grass beside it. Concrete
  or paved tile is the simplest.

Useful conversions: 60 ticks is one second at normal speed. The surface check runs every 15 ticks,
so up to a quarter of a second passes between stepping onto a floor and the board unfolding. That
delay is expected and is not a fault.

## 1. The mod loads, and the three patches apply

1. Start or load a game with the mod active.
2. Read the log.

**Pass:** no red line naming FoldingSkateboard, no Harmony patching error, no
`Could not resolve cross-reference`. The main menu is reached at all — a patch aimed at a method
that no longer exists throws in a static constructor and takes the game down before it.

**Fail:** any `AmbiguousMatchException` or `null method` from Harmony. That is a patch target that
moved, and `_tools/Run-Functional-Tests.ps1` would have said which.

## 2. The recipe is where it should be, and gated as it should be

1. Select a crafting spot, then a fuelled smithy, then an electric smithy.
2. Open the bill list on each.

**Pass:** **Make folding skateboard** appears on all three, and only after Smithing is researched.
A colonist below Crafting 4 cannot be assigned the bill.

**Watch for:** the cost is **both** lists at once — 10 wood and 10 steel as fixed ingredients,
**and** 30 of the chosen stuff. That double charge is SilkCircuit's pricing, left alone deliberately;
it is not a bug to report.

Note the oddity, and leave it: the recipe's work speed reads **drug synthesis speed** and its work
skill is **Intellectual**, not Crafting. Also SilkCircuit's, also left alone.

## 3. The board takes the colour of what it is made of

1. Craft one from wood, one from steel, one from a granite block.

**Pass:** three boards, three colours, each following its material, on the ground and in the
inventory list. The texture is stuff-coloured, so a wooden board is pale and a steel one is grey.

## 4. Picking one up

1. Select one undrafted colonist.
2. Right-click a board on the ground.

**Pass:** the menu holds **Pick up folding skateboard**. Clicking it sends the colonist walking to
it, and the board lands in their **inventory** — the Gear tab, under the equipment and apparel, not
in their hands. Their job line reads *Picking up a folding skateboard.*

**Fail:** the board is equipped as a weapon, or held. The job driver puts it in the inventory
precisely so it stays there while they work.

## 5. The three refusals, in words

Each of these must give a **greyed entry that says why**, not a missing entry.

1. A colonist already carrying a board, right-clicking another → *Cannot pick up folding skateboard: already carrying one.*
2. A board marked forbidden → *Cannot pick up folding skateboard: forbidden.*
3. A board walled off with no route → *Cannot pick up folding skateboard: no path.*

Repeat all three in French: each refusal must use its complete French sentence from
Languages/French/Keyed/FoldingSkateboard.xml and include the localized item label.
No raw key or {0} placeholder should appear. These are now owned translations,
not fragments borrowed from vanilla.

## 6. The three gates, in silence

Here the entry must be **absent altogether**, with no greyed line:

1. The colonist is **drafted**.
2. **Two or more** colonists are selected at once.
3. The colonist has no working manipulation — both hands gone, or a mental state that takes
   manipulation away.

## 7. Riding, which is the mod

1. Give a colonist a board.
2. Walk them onto outdoor unroofed concrete.

**Pass:** within a quarter of a second, the board appears **under them, on the camera side**, and
the **Shredder** trait appears in their bio tab, described as always shredding the gnar. The Move
Speed line in their stats tab reads exactly **+2** more than it did a moment earlier.

**Fail:** the trait appears and no board is drawn, or the reverse. The two are decided by the same
test in the same tick; seeing them disagree means the renderer patch and the tick patch disagree
about the surface, which is the bug the port was supposed to have removed for good.

## 8. Folding, which is the other half

1. From the concrete, walk them onto soil, sand or grass.
2. Then walk them indoors, onto a built floor under a roof.

**Pass:** both times, the trait goes, the speed drops back, and the board is drawn **strapped to
their back** — but only while they are seen from behind. Turn them and the folded board is not
drawn at all. That is the original's own rule: there is one folded graphic and it is the back view.

## 9. The roof is what decides, not the walls

1. Lay built floor under an existing roof, outdoors — a covered courtyard, a floor under an
   overhanging rock roof.
2. Walk them across it.

**Pass:** the board stays folded. The condition in the code is the roof over that cell, nothing
else: a room with no roof rides, a courtyard with a roof does not.

## 10. Mined rock, and bridges

1. Walk them across a rough or rough-hewn stone floor in a mined-out area, unroofed.
2. Build a bridge over water and walk them across it.

**Pass:** both ride. Smooth stone floors do **not** — SilkCircuit's list has the rough and
rough-hewn names and not the smooth ones, and that was left as a balance decision rather than
corrected in a port.

## 11. Fast walker, and the trait that is put away

This is the part with saved state, and the part most likely to go wrong.

1. Find or make a colonist with **fast walker**. Note their Move Speed.
2. Give them a board and walk them onto concrete.

**Pass:** the fast walker trait **disappears from the bio tab** while Shredder is there, and the
speed rises by 2 and not by 2 plus their trait. Walk them off the floor: fast walker **comes back**,
Shredder goes, and the speed is exactly what it was in step 1.

Repeat with **slowpoke**, which is the same vanilla trait at another degree, and which must also
come back.

**Fail:** the trait does not come back, or comes back twice. It is parked in a dictionary keyed by
the pawn's ThingID and handed back on the way out; a failure here is a colonist permanently altered.

## 12. A wall directly south, where the board vanishes

1. Stand the riding colonist on a floor cell with a wall in the cell **directly south** of them.

**Pass:** no board is drawn at all — neither under them nor on their back — while the Shredder trait
stays and the speed stays. The riding graphic is drawn half a cell south and would be painted across
the wall, so the original suppressed it entirely and the port kept that. It looks like a bug and is
faithful.

## 13. Leaving the map in the middle of a ride

1. Put a riding colonist, board and all, into a caravan. Send it off.
2. Read their trait list from the world map.

**Pass:** Shredder is gone the moment they leave the map, their fast walker is back if they had one,
and their caravan speed is normal. Settle them again: the board is still in their inventory, and the
trait comes back only when they stand on a skateable floor.

**Fail:** a colonist who keeps +2 speed forever on the world map. That was the 1.5 mod's bug, fixed
here by a patch on DeSpawn, and it is the scenario that fix exists for.

## 14. Save and reload in the middle of a ride

1. While a colonist with **fast walker** is riding, save. Quit to the menu. Load the save.

**Pass:** they are still riding, still Shredder, still without their fast walker; and stepping off
the floor gives it back. The parked trait is written into the save by the mod's own game component,
so this is the scenario that proves the component saves and loads.

**Fail:** fast walker gone for good after the reload. Then the dictionary did not survive, and the
colonist is short a trait with nothing to say so.

## 15. Removing the mod, which is where a trait can be lost

**Not a test to play.** It is kept because it describes a real consequence of the design, and it is
stated to players in the README ("Known limitations"). What follows is what would be seen, not a step
of the plan.
Run this one on a **copy** of the save, and never on a colony that matters.

1. While a colonist with fast walker is riding, save.
2. Disable the mod and load that save.

**Expected:** RimWorld drops the Shredder trait with a warning in the log, because its TraitDef is
gone with the mod. The fast walker trait, however, was parked inside the mod's game component and
goes with it: **the colonist loses it permanently.**

This is worth knowing and worth stating in the description if it is confirmed. Stepping off the
board before saving avoids it entirely, which is the honest advice to give.

## 16. French

1. Restart in French, with the mod active.

**Pass:** the item, the trait and its description, and the job line are in French. The right-click
entry is in French, and so are the two other refusals — *interdit* and *aucun chemin* — since
those come from the game's own strings.

**Watch for:** an English word left in a French sentence. There are exactly four mod keys and no
borrowed ones; anything else in English means a DefInjected path is wrong, and on a
case-sensitive filesystem such as the Steam Deck's it would be silently wrong there and right here.

## 17. A full colony, and the cost of the check

**Not a test to play.** See the table at the top: a tick cost measured here would say more about the vanilla colony than about this mod. It stays as the thing to have in mind on the first real run, to look at the frame rate and the log by eye, and to report if something is plainly wrong; nothing decides pass or fail.

1. Load a colony of fifteen or more colonists with a herd of animals, none of them carrying a board.
2. Watch the frame rate and the log for a few in-game hours at three-times speed.

**Pass:** no stutter, and no repeated line in the log. The tick postfix returns immediately for
anything with no trait set — animals and mechanoids, which are most of a map — and the surface list
is resolved once at startup rather than compared as strings every tick. The 1.5 mod did the
opposite, and this is the scenario that says the rewrite was worth it.
