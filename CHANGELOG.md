# Changelog

## 1.0.0 — unreleased

First release: a 1.6 port of SilkCircuit's Folding Skateboard, which declared 1.5 and nothing
further.

### Fixed for 1.6

- The right-click "pick up" option. `FloatMenuMakerMap.ChoicesAtFor`, which the 1.5 mod patched,
  does not exist in 1.6 — Harmony would have thrown on startup, before the main menu. The option
  is now a `FloatMenuOptionProvider`, which is how 1.6 builds float menus, and needs no patch.

Everything else survived the version. `PawnRenderer.RenderPawnAt` still exists with the same
signature and is still called once per frame per visible pawn; `Pawn.Tick` is still called every
tick despite the new variable-rate tick scheduler, though it turned `protected`. Both were
verified by reflection against the shipped 1.6 assembly before anything was compiled.

### Fixed, and not because of 1.6

- Every Harmony patch was applied twice: `PatchAll` ran from two places under two different ids.
  The board was drawn twice per frame and the terrain check ran twice per tick.
- On floors from LTS Systems' mods, the board was drawn under the pawn *and* on their back at the
  same time. The mod carried its terrain list in three copies and one had not kept up.
- A pawn who left the map while riding kept the +2 movement speed, and their fast walker /
  slowpoke trait stayed held in the mod's save data until they were next spawned.
- The caravan patch never ran at all: its postfix was declared on a class `PatchAll` skips. Its
  prefix leaked a `Thing` reference per board per caravan arrival, forever. Removed; nothing
  observable depended on it.
- Two `Log` lines written on every successful pickup.

### Changed

- The terrain list is resolved to `TerrainDef` once at load instead of being rebuilt as a
  170-entry `string[]` and searched by string comparison on every tick of every pawn.
- `PawnRenderer.pawn` is read directly rather than through `Traverse` once per pawn per frame.
- Textures moved out of the shared `Things/Item/CityLiving/` path, which named a different mod.
- All displayed strings go through `.Translate()`. English and French included.
- Removed a quantity slider, and its duplicate `Dialog_Slider` window, for an item whose
  `stackLimit` is 1; and a "Force equip" filter matching English label text on an item that is not
  equipment.

### Removed

- `About/ModIcon.png`, the mod's own item texture cropped square and scaled to 128 px, added
  earlier in this same unreleased version. An icon cut from the source mod's art makes the
  upstream author's work carry the port's identity, and the icon is the one file of a port that is
  supposed to speak for the port rather than for the mod it carries. The mod ships without one;
  RimWorld does not require it.

### Unchanged

The item, the trait, the recipe, the research and skill gates, the speed bonus, the surfaces you
can ride on, the draw offsets, the four textures, and all three defNames.
