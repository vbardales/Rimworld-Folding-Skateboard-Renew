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

1. A colonist already carrying a board, right-clicking another → *Pick up folding skateboard:
   already carrying one.*
2. A board marked forbidden → the entry says **forbidden**, in the game's own wording.
3. A board walled off with no route → the entry says **no path**, again in the game's wording.

Those last two strings are borrowed from the game rather than shipped, so they must appear in the
game's language, not in English inside a French game.

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
entry is in French, and so are the two borrowed refusals — *interdit* and *aucun chemin* — since
those come from the game's own strings.

**Watch for:** an English word left in a French sentence. There are exactly two mod keys and two
borrowed ones; anything else in English means a DefInjected path is wrong, and on a
case-sensitive filesystem such as the Steam Deck's it would be silently wrong there and right here.

## 17. A full colony, and the cost of the check

1. Load a colony of fifteen or more colonists with a herd of animals, none of them carrying a board.
2. Watch the frame rate and the log for a few in-game hours at three-times speed.

**Pass:** no stutter, and no repeated line in the log. The tick postfix returns immediately for
anything with no trait set — animals and mechanoids, which are most of a map — and the surface list
is resolved once at startup rather than compared as strings every tick. The 1.5 mod did the
opposite, and this is the scenario that says the rewrite was worth it.
