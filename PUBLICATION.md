# Publication

What the Workshop page asks for and this repository holds nowhere else. Item `3806761118` exists:
it was created privately by the `0.1.0` pre-publication of 2026-09-23 (see `CHANGELOG.md`). The mod
is not `tested` and not `prepublished`; `STATUS.md` says what is missing.

## Steam description

The single source of the description, written once. The CI turns this block into the Steam BBCode
and into the plain-text `<description>` of `Mod/About/About.xml`; until a workflow exists, that
element is produced from it by `about-description.mjs` of `Rimworld-Release-Admin`, so the two
cannot drift. The block holds no code fence, and its last line is the source link.

```markdown
UNOFFICIAL. This mod is published without the original author's explicit consent. If the original author contacts me to request its removal, I undertake to take it down promptly.

A skateboard that boosts pawn movement speed while in use and conveniently folds up and straps to their back when they aren't shredding the gnar.

I am not the author of this mod. The idea, the artwork, the trait and the balance are SilkCircuit's; all I did was bring it forward to 1.6, fix what the port turned up, and write the French. Credit goes to them; mistakes in the port are mine.

Original mod: [Folding Skateboard](https://steamcommunity.com/sharedfiles/filedetails/?id=3414678101) by SilkCircuit. Its About.xml declares 1.5 only and its page says 1.5+; neither names 1.6.

**HOW IT WORKS**

Craft a folding skateboard at a crafting spot or a smithy - it needs Smithing research and Crafting 4 - then right-click it with a colonist selected and pick "Pick up folding skateboard". It goes into their inventory, not their hands, and stays there.

From then on the board rides itself. Step onto an outdoor hard surface and the board unfolds under them: the colonist gains the Shredder trait and moves at +2 speed. Step indoors, or onto soil, sand or grass, and the board folds back onto their back. Hard surface means a built floor - concrete, paving, wood plank, tiles, flagstone - a mined rock floor, or a bridge. Roofed counts as indoors, so a covered courtyard is not a skate park.

While Shredder is on, vanilla's fast walker / slowpoke trait is set aside so the two bonuses do not stack, and given back the moment the board folds up.

The board is made from stuff and takes the colour of what it was made from.

**WHAT CHANGED IN THE PORT**

One thing was actually broken by 1.6, and it was fatal rather than quiet. Right-click menus were rebuilt in 1.6 around FloatMenuOptionProvider, and the method the 1.5 mod patched to add its "pick up" option no longer exists. [Harmony](https://steamcommunity.com/sharedfiles/filedetails/?id=2009463077) would have thrown on startup, before the main menu - so the port would not have loaded at all. The option is now a provider, which is what 1.6 wants and needs no patching.

Three things were broken before 1.6 and are fixed here:

- Every patch was applied twice. The mod ran Harmony's PatchAll from two places under two ids, so the board was drawn twice every frame and the terrain check ran twice per tick.
- On floors from LTS Systems' mods, a colonist was drawn riding the board AND wearing it on their back at the same time. The mod carried its terrain list three times over and one of the copies had not been kept up to date.
- A colonist who left the map mid-ride - packed into a caravan, sent off in a shuttle - kept the +2 speed and had their fast walker trait held hostage until they were next put on a map.

And the cost came down. The 1.5 version allocated a 170-entry list and searched it with string comparisons on every tick of every pawn on the map, animals included. Same rules, same list, resolved once at load.

Nothing else moved. The item, the trait, the recipe, the speed bonus, the four textures and the defNames are as SilkCircuit made them, so a save carried over from the 1.5 mod keeps its boards. The showcase picture and the mod icon are new. The two mods cannot run together: the original is declared incompatible. Run one or the other.

**CREDIT AND REMOVAL**

SilkCircuit declared no licence: no file in the mod, nothing in its About.xml, no linked repository, and nothing in the body of the description on its Steam page. It is republished here under the usual convention for abandoned mods - full credit, a link to the original, and removal on request. If SilkCircuit would rather this port did not exist, say so and it comes down: no argument, no delay.

**IF I GO QUIET**

If I do not answer within a reasonable time after being contacted, anyone may freely update this or any other of my mods, including publishing a continuation of it. All credit must be preserved.

**AI-GENERATED**

The port work - the code, the tests, the documentation and the French translation - was done with Claude Code (Anthropic), under human direction and review. The showcase picture and the mod icon were generated with OpenAI's gpt-image, under human direction; the lettering on the showcase was composed separately. Stated openly: designing with these tools is my job.

**THANKS**

SilkCircuit for the mod. Andreas Pardeike for [Harmony](https://steamcommunity.com/sharedfiles/filedetails/?id=2009463077).

Attribution and licence: see ATTRIBUTION.md and LICENSE, in the mod folder and in the repository.

[Source code on GitHub](https://github.com/vbardales/Rimworld-Folding-Skateboard-Renew)
```

## Dependencies and DLCs

Read from the sources on 2026-09-28, not from intent.

- **Hard dependency: Harmony** (`brrainz.harmony`, Workshop 2009463077), declared in `modDependencies`
  with its Workshop URL. The C# uses it to patch `Pawn.Tick`, `Pawn.DeSpawn` and
  `PawnRenderer.RenderPawnAt`.
- **No DLC.** Nothing in the code, the defs or the languages names one, and `supportedVersions` is
  `1.6` alone. There is no `LoadFolders.xml` and no XML patch.
- **Incompatible with SilkCircuit's original** (`silkcircuit.foldableskateboardmod`): both define the
  same defNames. Declared in `incompatibleWith`; `TESTING.md` plans the pass that goes and looks at
  whether that is still true.
- **Optional floors from LTS Systems' mods are not a dependency.** `SkateableTerrain` names 141 of
  their floors as strings, resolved once at load; a name whose mod is absent resolves to nothing.
  Declaring them would force a download on players who do not want them.

## Still to write before `prepublished`

None of these exists yet, and none is stubbed here, because an empty heading would read as a
decision. `AUDIT.md` (step `tested -> prepublished`) lists them.

- The gallery, in the order it goes on the page, each image opened and looked at. There is no
  capture yet: the mod has never been run.
- The answer to the mature-content boxes, once the gallery images exist.
- The thank-you message for the original author's page (a first contact, since the source is
  `silent`), and the register entry of `WORKSHOP_COMMENTS.md` for it; Harmony is already `posted`
  there, so only its `Covers` column moves.
- The Steam change note, `### 1.0.0`, whose first line is `[b]1.0.0[/b]`.
