# Folding Skateboard — attribution

A 1.6 port of **Folding Skateboard**, by **SilkCircuit**
([3414678101](https://steamcommunity.com/sharedfiles/filedetails/?id=3414678101)).

## Status: public

The source mod is **dead** — it declares 1.5 and nothing further — and **no licence is declared
anywhere**, checked at the four places one could be: no `LICENSE` file in the mod, no mention in
its `About.xml`, no linked repository (`<url>` points at a Steam profile, not a source repo), and
nothing in the body of the description on its Steam page. That last check is the one that matters:
it is the one that was skipped once on たたら製鉄, whose ban on redistribution turned out to be a
sentence in its description and nowhere else.

This is the usual convention for ports on the RimWorld Workshop: republished with **credit by
name** and **removal on request, without argument**. The `<author>` field reads
`SilkCircuit - 1.6 port: nelim`, and the removal clause is in the description.

## What was carried over

Everything the mod was: three defs, four textures, and the behaviour of about a thousand lines of
C#.

| def | type | what it is |
|---|---|---|
| `Paddleboard` | `ThingDef` | the board, an inventory item made from stuff |
| `Shredder` | `TraitDef` | +2.0 `MoveSpeed`, granted only while riding |
| `AddPaddleboardToInventory` | `JobDef` | walk to a board and pocket it |

The stats, the recipe, the research and skill gates, the speed bonus, the list of surfaces you can
ride on, the draw offsets and the four textures are SilkCircuit's, unchanged.

## The defNames were kept, deliberately

None of the three carries an author prefix, and `Shredder` is exactly the kind of name that
collides. It was checked rather than assumed, in three places:

- **Core and every DLC** — Core, Royalty, Ideology, Biotech, Anomaly, Odyssey. None of the three
  names appears anywhere in the game's own data.
- **Every subscribed Workshop mod.** `Shredder` turns up four times, and never as a `TraitDef`: a
  `RecipeDef` in two Combat Extended Halo ammo packs, a `CombatExtended.AmmoCategoryDef` in a
  third, and a `DamageDef` in Rimsenal. `DefDatabase` is keyed per def type, so none of them is a
  collision. `Paddleboard` and `AddPaddleboardToInventory` appear nowhere but the source mod.
- **This repository** — every other mod in it.

No collision, so no rename — and that is the right way round to decide it. `Paddleboard` is a
leftover: the mod grew out of a raft, and its textures still shipped as `CityLiving_Raft`. Renaming
it would be tidier and would take the board out of the inventory of every pawn in a save carried
over from the 1.5 mod, which is the only reason anyone would install this rather than the original.

## What 1.6 actually broke

The mod's weight is in its C#: 1006 lines across six files, of which 533 — more than half — are
two Harmony patches on the pawn renderer. That was the thing to check first, because
`PawnRenderer` was reworked into `PawnRenderNode` / `PawnRenderTree` and a 1.5 mod that hooked the
old drawing code would have nothing left to hook.

Every Harmony target was verified by reflection against the shipped 1.6 `Assembly-CSharp.dll`
before a line was compiled — reading the PE metadata rather than loading the assembly, which a
Unity build will not do outside the game. A patch whose target has moved does not fail to compile;
it fails at startup, and half a renderer patch means invisible pawns.

**The renderer survived intact.** `PawnRenderer.RenderPawnAt(Vector3, Rot4?, bool)` still exists in
1.6, with the same signature, and `PawnRenderer.DynamicDrawPhaseAt` still calls it once per frame
per visible pawn for `DrawPhase.Draw`. The reason is that this mod never touched the render tree:
it postfixes the whole-pawn draw and puts its own quad on screen next to it. The node rework moved
what happens *inside*; the entry point did not move. So the half of the mod that looked most at
risk needed no change at all.

**`Pawn.Tick` survived too**, which was not obvious. 1.6 replaced the flat tick loop with
`Thing.DoTick`, a variable-rate scheduler that calls `Entity.TickInterval(delta)` at an interval
that depends on how much the game cares about the thing. But it calls `Entity.Tick()` first,
unconditionally, for anything spawned — so a postfix on `Pawn.Tick` still runs every tick. It did
turn `protected`, so the patch addresses it by string rather than by `nameof`.

**`CaravanEnterMapUtility.Enter` survived**, with the exact six-argument signature the mod pinned.
It made no difference; see below.

**The right-click menu did not survive.** `FloatMenuMakerMap.ChoicesAtFor` is gone. In 1.6 the
menu is assembled from `FloatMenuOptionProvider` subclasses, which `FloatMenuMakerMap.Init`
discovers with `AllSubclassesNonAbstract` and instantiates. `AccessTools.Method` would have
returned null and Harmony would have thrown in the mod's static constructor — a mod that dies
before the main menu, not one that misbehaves quietly. This is now
`FloatMenuOptionProvider_TakeSkateboard`, and declaring the class is the whole of the registration:
there is no Harmony patch left in that part of the mod.

## What was broken before 1.6

Four defects that had nothing to do with the version, found while reading the code that had to be
touched anyway.

**Every patch was applied twice.** `CityLivingMod : Mod` called `harmony.PatchAll()` under
`com.citylivingmod.customrenderer`, and a separate `[StaticConstructorOnStartup]` class called it
again under `com.foldableskateboardmod.traitmanager`. Two Harmony instances with different ids both
take. The board was therefore drawn twice every frame and the terrain check ran twice per tick.
One instance now, one `PatchAll`, and no static-constructor bootstraps beside it.

**The board was drawn twice at once on LTS floors.** The terrain list existed in three copies: the
trait patch and the "draw the board under the pawn" patch each had all 170 names, and the "draw the
board folded on the back" patch had only the first 29 — the vanilla ones — and none of the 141
floors from LTS Systems' mods. On an LTS floor a pawn was therefore drawn riding the board *and*
wearing it on their back. There is one list now, in `SkateableTerrain`, and the two graphics are
mutually exclusive by construction.

**A pawn who left the map mid-ride kept the trait.** `Pawn.Tick` only runs while a pawn is spawned,
and the trait was only ever removed from there. A colonist packed into a caravan while standing on
concrete left with +2 movement speed and with their fast walker trait held in the mod's save data,
and got neither back until they were next put on a map. `Patch_Pawn_DeSpawn` is new and closes it.

**The caravan patch never ran.** `Patch_CaravanEnterMapUtility` declared its postfix with a
method-level `[HarmonyPatch]` on a class with no class-level `[HarmonyPatch]`, and `PatchAll`
skips such classes entirely — `PatchClassProcessor` returns before doing anything when the type
carries no Harmony attributes of its own. So only the prefix was ever applied, and all the prefix
did was copy references to every board in a caravan into a static dictionary that nothing ever
read or emptied. It was a slow leak with no feature attached. It is not in this port, and no
behaviour was lost with it: nothing observable ever depended on it.

## What else changed, and why

- **The per-tick cost.** The 1.5 trait patch allocated a fresh 170-entry `string[]` on every tick
  of every pawn on the map — animals and mechanoids included — and ran a linear string comparison
  down it. The names are now resolved to `TerrainDef` once at startup, pawns with no trait set are
  dropped before anything else, and the check runs on a hash interval so the cost is spread across
  pawns rather than paid by all of them on the same tick. The rules and the list are unchanged.
  The board's graphic still follows the terrain frame by frame; only the speed bonus can lag, by up
  to a quarter of a second.
- **`Traverse` in the render loop.** Both renderer patches read `PawnRenderer`'s private `pawn`
  field through Harmony's `Traverse` — a reflection lookup per pawn per frame. The field is
  publicised at build time instead, and only that field: publicising `Assembly-CSharp` wholesale
  turns protected virtual members public in the reference assembly, and then every
  `protected override` in the mod stops compiling.
- **Two `Log` lines on every successful pickup** are gone. A mod has no business writing to a log
  everyone else reads to find their own bugs.
- **A quantity slider that could never open** is gone, and with it a `Dialog_Slider` window
  duplicating the one `Verse` already has. It was offered for stacks larger than one, and the
  board's `stackLimit` is 1.
- **A "Force equip" filter that could never match** is gone. It removed float-menu options by
  looking for the English words "Force equip" in their labels — for an item that is not equipment
  and never had such an option.
- **Textures moved** from `Things/Item/CityLiving/CityLiving_Raft*` to
  `Things/Item/FoldingSkateboard/Skateboard*`. Texture paths are global across mods; the old path
  named a different mod of the same author's and would have been overridden by it silently. The
  images themselves are byte for byte SilkCircuit's.
- **Strings go through `.Translate()`**, with English and French keyed files and a French
  `DefInjected`. The two float-menu strings were hard-coded English.
- **One typo** in the item description: "When skating." became "While skating,".

## What was deliberately left alone

- **Smoothed stone floors are still not skateable.** Vanilla generates `{rock}_Rough`,
  `{rock}_RoughHewn` and `{rock}_Smooth` for every rock type; SilkCircuit's list has the first two
  and not the third, so a polished marble floor is not a skate park. That reads like an oversight,
  and it is also a balance call on someone else's mod. Adding it would be a change, not a port.
- **The item costs both a fixed cost and a stuff cost.** The `ThingDef` declares `costList` (10
  wood + 10 steel) *and* `costStuffCount` 30, and the generated recipe applies both. Left as
  priced.
- **The trait swap itself.** Granting and revoking a real `TraitDef` as a pawn walks on and off
  concrete is a heavy way to move a stat — `GainTrait` recalculates disabled work types, skill
  aptitudes and the pawn's graphics — and a `HediffDef` or a `StatPart` would do it for a fraction
  of the cost. It is also the mod's design, visible in the pawn's trait list, and replacing it
  would be a rewrite rather than a port.
- **The board disappears entirely with a wall directly south of the pawn.** The riding graphic is
  drawn up to half a cell south and would be painted across the wall, so SilkCircuit suppressed it;
  the folded graphic does not come back to cover the gap. Faithful to the original.

## Textures and images

The four textures are SilkCircuit's, byte for byte; only their file names and the folder they sit
in changed.

**`About/Preview.png` and `About/ModIcon.png` are ours, and neither is cut from anything of his.**
Both were made on 2026-09-12 with an image model under direction, and the full-resolution renders
are kept in `Art/`, outside the published folder.

The showcase is a scene rather than a title card: a folded board lit by a standing lamp on paved
ground, a colonist rolling away behind it, the paving giving way to bare soil at one corner —
which is the rule of the mod drawn rather than written. Cropped to 896×504, and the name engraved
over it at that size so the glyphs are never resampled. `_tools/preview.html` is how, and says why
it is cropped where it is.

It replaces SilkCircuit's own 800×451 title card, which this repository shipped until 2026-09-12.
That card carried his lettering and his title, and publishing it as the store image of a port
meant exhibiting his work under another author line. It stays in this repository's history, at the
import commit, and is used nowhere.

The icon is the mascot this repository gives all its mods, drawn for the occasion with a folded
board beside it. An earlier one, removed on 2026-09-11, had been the mod's own item texture
cropped square: an icon cut from the source mod's art makes the upstream author's work carry the
port's identity, and the icon is the one file of a port that is supposed to speak for the port
rather than for the mod it carries. That objection does not apply to a mascot.
