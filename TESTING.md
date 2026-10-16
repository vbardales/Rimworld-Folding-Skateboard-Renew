# Folding Skateboard Renew — in-game test scenarios

Mod never seen running. Port built by reading 1.6 assembly. Build clean, functional tests pass, but none exercise a single game tick.
This file = list of what must be watched, and what counts as pass.

Not shipped: lives beside `Mod/`, never inside, so Steam never receives it.

Run `scripts/Run-Functional-Tests.ps1` first. Settles in seconds, no colony, what mod hooks into and whether game still does it — patch targets, draw-phase call, provider sweep, floor names, translation keys. Red line there explains a scenario below that would have failed anyway. Proves nothing about what appears on screen, so the seventeen below stand unchanged.

## What plays each scenario, and what `tested` asks

Seventeen scenarios below = acceptance list. None played by hand at end: `AUDIT.md` (step `done -> tested`) wants every one either automated and green, or listed here as not applicable with reason. Table says which, and justifies Pickle suite scope: only what running game alone can show written in Gherkin, what test outside game can prove stays outside.

| # | Scenario | Played by | Why |
|---|---|---|---|
| 1 | The mod loads, the patches apply | Any Pickle run, plus the load audit | Patch that throws at startup kills game before runner exists; load audit reads log for rest |
| 2 | The recipe, its gates, its cost | **Offline**, `scripts/Run-Functional-Tests.ps1` (definitions test) | Static facts of def. Game refusing bill below Crafting 4 is game's own logic, not mod's, not tested |
| 3 | The board takes its material's colour | Pickle, `@review` capture | Only person can look at colour |
| 4 | Picking one up | Pickle | Provider and job run through game's own callbacks |
| 5 | The three refusals, worded | Pickle | Conditions read game state; wording is the four keys, in each language |
| 6 | The three silent gates | **Offline**, `scripts/Run-Functional-Tests.ps1` (provider-gates test) | Mod declares four flags: undrafted only, one pawn, manipulation required. Game's menu builder honouring them is game's business, not tested; declaration is mod's, read from built class |
| 7 | Riding | Pickle, with `@review` capture | Trait and speed asserted; drawn board looked at |
| 8 | Folding, indoors and off the hard ground | Pickle, with `@review` capture | Same |
| 9 | The roof decides | Pickle | Roof placed over cell |
| 10 | Mined rock, bridges, smooth stone | Pickle, one outline | Five terrains, one expectation each |
| 11 | Fast walker and slowpoke set aside and given back | Pickle | Trait swap, parked trait in mod's game component |
| 12 | A wall directly south hides the board | Pickle, `@review` capture only | Only drawing changes, nothing assertable, only looked at |
| 13 | Leaving the map mid-ride | Pickle, by despawning the pawn | Mod answers for its `DeSpawn` hook; forming caravan is game's own mechanism, not tested |
| 14 | Save and reload mid-ride | Pickle, `I save and reload` | Real save, real load, component comes back from file |
| 15 | Removing the mod mid-ride | **Not applicable**, documented as known limitation | What game does with trait whose mod is gone, and game component whose class is gone, is engine's handling of removed mod, which `AUDIT.md` says is not tested. Consequence stated to players in README instead |
| 16 | French | Same suite, played with `-Language French` | Language fixed at launch, never switched inside run |
| 17 | A full colony's tick cost | **Not applicable** as test | Mean tick cost on shared headless machine measures vanilla colony far more than this mod: threshold would never fail, or fail for reason not ours. Claim is structural (1.5 mod allocated list per pawn per tick; this one resolves terrain names once and returns early for pawn without trait set), read in code, not measured |

Not applicable, with reason: forming real caravan or sending shuttle (scenario 13, engine's mechanism); game's refusal of bill below Crafting 4 (scenario 2, engine's rule); game's honouring of provider's four flags (scenario 6, engine's menu builder); removing mod from running colony (scenario 15, engine's handling of removed mod, limitation README now states); switching language inside session (scenario 16, game restart, done by pass per language).

Where Pickle scenarios live, in `Tests/Pickle/Mod/Pickle/Features/` (suite written, never run; its README lists what first run must confirm):

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

One run does not validate a mod, and `TESTING.md` that does not say how many is not a plan.

| Pass | What it establishes | Language |
|---|---|---|
| `sans-facultatifs` | Mod and Harmony alone: Core, DLC, Harmony, RimLogging, Pickle, mod. Every scenario except ones needing something else | English, then French: two requests |
| `avec-lts` | Board rides on floor from one of LTS Systems' mods, does not on floor it does not name. Scenarios tagged `@requires:` for that mod skip anywhere else | English |
| `incompat-original` | SilkCircuit's original mounted beside this mod, to see whether declared incompatibility still true. Documented symptom asserted, so green means "behaves as declared" | English |

Not needed, and why: pass without DLC (no DLC used, named or branched on); separate restart chain for scenario 14 (`I save and reload` restores component from real save file, nothing this mod keeps lives outside that file).

Pass `avec-lts` cannot be written until Workshop mod defining `LTS_PlankFloor` and its 141 siblings identified: not known from this repository, unverified whether one mod or several supply them. That mod then also thanked, since tested integration credited.

## What has to be true before `tested`

`AUDIT.md` rules for `done -> tested`, applied to this mod. None true today.

- **No scenario left `@wip`.** Scenario put aside either repaired and replayed, or deleted with reason written here. Remaining `@wip` = scenario waiting, not scenario passed.
- **Every conditional scenario has run.** Each `@requires:<packageId>` had its pass, on map mounting that mod, report read: suite name and scenario names checked before cited, because report folder shared by whole machine. Scenario skipped for want of condition not scenario passed.
- **No manual test left to tick.** Everything in the seventeen automated and green, or listed above as not applicable with reason. `@review` captures still looked at, but that is reading image scenario already proved in intended state, not one more manual test.
- `exitReason` read before any count; scenarios played compared with features discovered; green capture scenario not read as correct picture; rerun that passes only on retry counts as flaky, not green.
- Log read from start of game, not only scenarios' own `no errors were logged`.
- English and French each a pass of their own, raw-key check found no accented fallback text (developer mode turns missing key into accented gibberish, which is how it shows).
- Every scenario that ever failed replayed green on build containing its fix.

## Evidence to keep, and what to delete

Reports and captures stay **on disk** under `Tests/Pickle/Evidence/`, git ignores. Launch each request with `-EvidenceDir Tests/Pickle/Evidence/<date>-<pass>-<language>` so report copied out of shared, rolling folder before another mod's run overwrites it, and give request the SHA in its label: request carries none, tree staged when its turn comes.

| Keep, per pass | Why |
|---|---|
| `summary.json` and `summary.md` | Verdict. Read `exitReason` first |
| `junit.xml` and `messages.ndjson` | Step outcomes and failure messages |
| `Player.log` | Startup, load order, dropped mods, errors outside scenarios |
| `evidence-complete.txt` or `no-report.txt` | Says copy whole, or launcher left no report: infrastructure, not result |
| The `@review` captures and films the pass exists to produce, **as JPEG** | Human review. Never PNGs: 2.4 to 5.5 MB each |
| One line per run in `docs/runs/` | History, kept in git as text. Write **before** deleting folder |

| Delete | When |
|---|---|
| `screenshots/` copied whole from shared folder | Never keep: holds other mods' captures |
| `report.html` | Once verdict recorded; largest file of text-only run |
| Report of failed or infrastructure attempt | Once its line in `docs/runs/` and cause in `STATUS.md` |
| Report superseded for same scenario and same revision | When newer exists, unless older is only proof of check newer did not repeat (language, pass) |
| Any report on superseded build | After pass repeated on current one: proves nothing about current build |

**Never delete report that `STATUS.md` field or tracked file points to**: repoint to its line in `docs/runs/` first. List what goes and what stays before deleting. Launcher's archive folder = reprieve of five runs, not storage; session takes what it needs from archive of its own run, deletes that archive afterwards, leaves every other one alone.
## Before starting

- RimWorld 1.6, Harmony active, Folding Skateboard Renew active, SilkCircuit's original **not** active — both declare same defNames, About declares them incompatible.
- Development mode on, so silent failures become red text.
- Log to read afterwards, attach to any report:
  `C:\Users\nelim\AppData\LocalLow\Ludeon Studios\RimWorld by Ludeon Studios\Player.log`
- Colonist with Crafting 4 or more, Smithing researched, crafting spot or smithy. Debug actions → Spawn thing → `Paddleboard` is shortcut; defName is SilkCircuit's, kept so save from 1.5 mod keeps its boards.
- Patch of built floor **outdoors and unroofed**, patch of soil or grass beside it. Concrete or paved tile simplest.

Useful conversions: 60 ticks = one second at normal speed. Surface check runs every 15 ticks, so up to quarter second passes between stepping onto floor and board unfolding. Delay expected, not fault.

## 1. The mod loads, and the three patches apply

1. Start or load game with mod active.
2. Read log.

**Pass:** no red line naming FoldingSkateboard, no Harmony patching error, no `Could not resolve cross-reference`. Main menu reached at all — patch aimed at method that no longer exists throws in static constructor, takes game down before it.

**Fail:** any `AmbiguousMatchException` or `null method` from Harmony. Patch target moved, `scripts/Run-Functional-Tests.ps1` would have said which.

## 2. The recipe is where it should be, and gated as it should be

1. Select crafting spot, then fuelled smithy, then electric smithy.
2. Open bill list on each.

**Pass:** **Make folding skateboard** appears on all three, only after Smithing researched. Colonist below Crafting 4 cannot be assigned bill.

**Watch for:** cost is **both** lists at once — 10 wood and 10 steel fixed ingredients, **and** 30 of chosen stuff. Double charge is SilkCircuit's pricing, left alone deliberately; not bug to report.

Note oddity, leave it: recipe work speed reads **drug synthesis speed**, work skill is **Intellectual**, not Crafting. Also SilkCircuit's, also left alone.

## 3. The board takes the colour of what it is made of

1. Craft one from wood, one from steel, one from granite block.

**Pass:** three boards, three colours, each following its material, on ground and in inventory list. Texture stuff-coloured, so wooden board pale, steel one grey.

## 4. Picking one up

1. Select one undrafted colonist.
2. Right-click board on ground.

**Pass:** menu holds **Pick up folding skateboard**. Clicking sends colonist walking to it, board lands in their **inventory** — Gear tab, under equipment and apparel, not in their hands. Job line reads *Picking up a folding skateboard.*

**Fail:** board equipped as weapon, or held. Job driver puts it in inventory precisely so it stays there while they work.

## 5. The three refusals, in words

Each must give **greyed entry saying why**, not missing entry.

1. Colonist already carrying board, right-clicking another → *Cannot pick up folding skateboard: already carrying one.*
2. Board marked forbidden → *Cannot pick up folding skateboard: forbidden.*
3. Board walled off with no route → *Cannot pick up folding skateboard: no path.*

Repeat all three in French: each refusal must use complete French sentence from
Languages/French/Keyed/FoldingSkateboard.xml and include localized item label.
No raw key or {0} placeholder should appear. Now owned translations,
not fragments borrowed from vanilla.

## 6. The three gates, in silence

Entry must be **absent altogether**, no greyed line:

1. Colonist **drafted**.
2. **Two or more** colonists selected at once.
3. Colonist has no working manipulation — both hands gone, or mental state taking manipulation away.

## 7. Riding, which is the mod

1. Give colonist board.
2. Walk onto outdoor unroofed concrete.

**Pass:** within quarter second, board appears **under them, on camera side**, **Shredder** trait appears in bio tab, described as always shredding the gnar. Move Speed line in stats tab reads exactly **+2** more than moment earlier.

**Fail:** trait appears and no board drawn, or reverse. Both decided by same test in same tick; seeing them disagree means renderer patch and tick patch disagree about surface, the bug port was supposed to remove for good.

## 8. Folding, which is the other half

1. From concrete, walk onto soil, sand or grass.
2. Then walk indoors, onto built floor under roof.

**Pass:** both times, trait goes, speed drops back, board drawn **strapped to their back** — but only while seen from behind. Turn them and folded board not drawn at all. Original's own rule: one folded graphic, the back view.

## 9. The roof is what decides, not the walls

1. Lay built floor under existing roof, outdoors — covered courtyard, floor under overhanging rock roof.
2. Walk across it.

**Pass:** board stays folded. Condition in code is roof over that cell, nothing else: room with no roof rides, courtyard with roof does not.

## 10. Mined rock, and bridges

1. Walk across rough or rough-hewn stone floor in mined-out area, unroofed.
2. Build bridge over water, walk across.

**Pass:** both ride. Smooth stone floors do **not** — SilkCircuit's list has rough and rough-hewn names, not smooth ones, left as balance decision rather than corrected in port.

## 11. Fast walker, and the trait that is put away

Part with saved state, part most likely to go wrong.

1. Find or make colonist with **fast walker**. Note Move Speed.
2. Give board, walk onto concrete.

**Pass:** fast walker trait **disappears from bio tab** while Shredder there, speed rises by 2, not 2 plus their trait. Walk off floor: fast walker **comes back**, Shredder goes, speed exactly what it was in step 1.

Repeat with **slowpoke**, same vanilla trait at another degree, must also come back.

**Fail:** trait does not come back, or comes back twice. Parked in dictionary keyed by pawn's ThingID, handed back on way out; failure here = colonist permanently altered.

## 12. A wall directly south, where the board vanishes

1. Stand riding colonist on floor cell with wall in cell **directly south** of them.

**Pass:** no board drawn at all — neither under them nor on back — while Shredder trait stays and speed stays. Riding graphic drawn half cell south, would be painted across wall, so original suppressed it entirely, port kept that. Looks like bug, is faithful.

## 13. Leaving the map in the middle of a ride

1. Put riding colonist, board and all, into caravan. Send off.
2. Read trait list from world map.

**Pass:** Shredder gone the moment they leave map, fast walker back if they had one, caravan speed normal. Settle again: board still in inventory, trait comes back only when they stand on skateable floor.

**Fail:** colonist keeping +2 speed forever on world map. That was 1.5 mod's bug, fixed here by patch on DeSpawn, scenario that fix exists for.

## 14. Save and reload in the middle of a ride

1. While colonist with **fast walker** riding, save. Quit to menu. Load save.

**Pass:** still riding, still Shredder, still without fast walker; stepping off floor gives it back. Parked trait written into save by mod's own game component, so scenario proves component saves and loads.

**Fail:** fast walker gone for good after reload. Then dictionary did not survive, colonist short a trait with nothing to say so.

## 15. Removing the mod, which is where a trait can be lost

**Not a test to play.** Kept because describes real consequence of design, stated to players in README ("Known limitations"). What follows is what would be seen, not step of plan.
Run on **copy** of save, never on colony that matters.

1. While colonist with fast walker riding, save.
2. Disable mod, load that save.

**Expected:** RimWorld drops Shredder trait with warning in log, because its TraitDef gone with mod. Fast walker trait, however, was parked inside mod's game component and goes with it: **colonist loses it permanently.**

Worth knowing and worth stating in description if confirmed. Stepping off board before saving avoids it entirely, honest advice to give.

## 16. French

1. Restart in French, with mod active.

**Pass:** item, trait and its description, job line in French. Right-click entry in French, so are two other refusals — *interdit* and *aucun chemin* — since those come from game's own strings.

**Watch for:** English word left in French sentence. Exactly four mod keys, no borrowed ones; anything else in English means DefInjected path wrong, and on case-sensitive filesystem such as Steam Deck's silently wrong there, right here.

## 17. A full colony, and the cost of the check

**Not a test to play.** See table at top: tick cost measured here would say more about vanilla colony than this mod. Stays as thing to have in mind on first real run, to look at frame rate and log by eye, report if something plainly wrong; nothing decides pass or fail.

1. Load colony of fifteen or more colonists with herd of animals, none carrying board.
2. Watch frame rate and log for few in-game hours at three-times speed.

**Pass:** no stutter, no repeated line in log. Tick postfix returns immediately for anything with no trait set — animals and mechanoids, most of map — and surface list resolved once at startup rather than compared as strings every tick. 1.5 mod did opposite, scenario that says rewrite worth it.