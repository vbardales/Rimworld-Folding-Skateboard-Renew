# Changelog

## [1.0.0] — unreleased

First release: a 1.6 port of SilkCircuit's Folding Skateboard, which declared 1.5 and nothing
further.

### Localization follow-up — 2026-09-13

- Pickup refusals now use complete English/French message templates with the item
  label as an argument, allowing translators to control the whole sentence.
- Resource checks validate nonempty, unique keys and item format arguments.

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

### Images

Both were made on 2026-09-12 for this port, with an image model under direction, and neither is
cut from SilkCircuit's art. Full-resolution renders are kept in `Art/`, outside the published
folder.

- `About/Preview.png`, a scene rather than a title card: a folded board lit by a standing lamp on
  paved ground, a colonist rolling away behind it, and the paving giving way to bare soil at one
  corner. 896×504, with the name engraved at that size. It replaces SilkCircuit's own 800×451
  title card, which this repository shipped until then and which carried his own lettering.
- `About/ModIcon.png`, the mascot this repository gives all its mods, with a folded board beside
  it, 128×128. An earlier icon, added and removed earlier in this same unreleased version, had
  been the mod's own item texture cropped square: an icon cut from the source mod's art makes the
  upstream author's work carry the port's identity, which a mascot does not.

### Unchanged

The item, the trait, the recipe, the research and skill gates, the speed bonus, the surfaces you
can ride on, the draw offsets, the four textures, and all three defNames.

## [0.1.0] — 2026-09-23

Creation of a publishIdFile. Prepublication: a first upload whose only purpose was to create the
Workshop item, private as Steam creates every new item, and to obtain `Mod/About/PublishedFileId.txt`,
which holds item `3806761118`. This entry does not say the mod is public or tested.

### Added

- `Mod/About/PublishedFileId.txt`, committed with this entry. Without it the next upload would
  create a second item instead of updating this one.

### Notes

- The upload contained `Mod/` as it stood in the working tree on 2026-09-23 at 16:32. That tree was
  ahead of the last commit (`39fb9b0`): the pickup refusal templates (`a4231ae`), the recomposed
  showcase (`d0321a7`) and the `(unofficial)` name and paragraph (`f9fd3b5`) were not yet committed.
  They are committed now, so the commit before this entry holds the uploaded tree, less the files
  below.
- Four `.dds` texture caches that the game had written beside the PNGs at 14:13, two hours earlier,
  were in the working tree, so the private item probably carries them. They are not in git and are
  now ignored. This repository has no publish workflow yet: an upload from a git checkout drops
  them, one from the working tree sends them again.
- The item's page was created from the `About.xml` description of that moment. That text says the
  port work involved "in-game testing", which has not happened, and ends on a bare URL. The
  repository's description is corrected under 1.0.0; the page keeps the earlier text until a publish
  sends the description or the page is edited by hand.
- The 1.0.0 changes above are still to come as a release. The `tested` and `prepublished` states
  have not been reached: see `STATUS.md`.