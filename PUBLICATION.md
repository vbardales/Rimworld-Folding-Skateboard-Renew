# Publication

What the Workshop page asks for and this repository holds nowhere else. Item `3806761118` exists:
it was created privately by the `0.1.0` pre-publication of 2026-09-23 (see `CHANGELOG.md`). The mod
is not `tested` and not `prepublished`; `STATUS.md` says what is missing.

## Steam description

The single source of the description, written once. The CI turns this block into the Steam BBCode
and into the plain-text `<description>` of `Mod/About/About.xml`; until a workflow exists, that
element is produced from it by `about-description.mjs` of `Rimworld-Release-Admin`, so the two
cannot drift. The block is fenced below only to delimit it: it holds no code fence of its own, and its last line is the source link.

```markdown
UNOFFICIAL. This mod is published without the original author's explicit consent. If the original author contacts me to request its removal, I undertake to take it down promptly.

A skateboard that boosts pawn movement speed while in use and conveniently folds up and straps to their back when they aren't shredding the gnar.

I am not the author of this mod. The idea, the artwork, the trait and the balance are SilkCircuit's; all I did was bring it forward to the latest RimWorld version, fix what the port turned up, and write the French. Credit goes to them; mistakes in the port are mine.

Original mod: [Folding Skateboard](https://steamcommunity.com/sharedfiles/filedetails/?id=3414678101) by SilkCircuit. Its About.xml declares 1.5 only and its page says 1.5+; neither names the latest RimWorld version.

**HOW IT WORKS**

Craft a folding skateboard at a crafting spot or a smithy - it needs Smithing research and Crafting 4 - then right-click it with a colonist selected and pick "Pick up folding skateboard". It goes into their inventory, not their hands, and stays there.

From then on, the board unfolds and folds automatically. Step onto an outdoor hard surface and the board unfolds under them: the colonist gains the Shredder trait and gains +2 movement speed. Step indoors, or onto soil, sand or grass, and the board folds back onto their back. Hard surface means a built floor - concrete, paving, wood plank, tiles, flagstone - a mined rock floor, or a bridge. Roofed counts as indoors, so a covered courtyard is not a skate park.

While Shredder is on, vanilla's fast walker / slowpoke trait is set aside so the two bonuses do not stack, and given back the moment the board folds up.

The board is made from stuff and takes the colour of what it was made from.

**WHAT CHANGED IN THE PORT**

One thing was actually broken by the move from 1.5, and it was fatal rather than quiet. Right-click menus were rebuilt in the latest version around FloatMenuOptionProvider, and the method the 1.5 mod patched to add its "pick up" option no longer exists. [Harmony](https://steamcommunity.com/sharedfiles/filedetails/?id=2009463077) would have thrown on startup, before the main menu - so the port would not have loaded at all. The option is now a provider, which is what the latest version wants and needs no patching.

Three things were broken before the port and are fixed here:

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

[Pickle](https://steamcommunity.com/sharedfiles/filedetails/?id=3791648678) (RimWorks) and [PickleTools](https://steamcommunity.com/sharedfiles/filedetails/?id=3806142401) were used to test this mod in the game: development tools only, never a dependency of the mod.

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

- The gallery, in the order it goes on the page (plan and subtitles below), each image opened and looked at. There is no
  capture yet: English in-game tests have been run, but full validation, including the French pass, remains pending.
- The answer to the mature-content boxes, once the gallery images exist.
- The thank-you message for the original author's page (a first contact, since the source is
  `silent`), and the register entry of `WORKSHOP_COMMENTS.md` for it; Harmony is already `posted`
  there, so only its `Covers` column moves.

## Release notes (the change note of each upload)

The block under `### <version>` is sent as the Steam change note, with the version alone on its first line
(`[b]1.0.0[/b]`, `../PUBLISHING.md`); the `## [<version>]` section of `CHANGELOG.md` goes into the GitHub
release instead.

### 1.0.0

```
[b]1.0.0[/b]
First public release. Brings SilkCircuit's Folding Skateboard forward to the latest RimWorld version: the "pick up" right-click option is rebuilt (the old one would have stopped the game from loading), every patch now applies once instead of twice, the board is no longer drawn twice on LTS floors, and a colonist who leaves the map mid-ride gets their speed trait back. Full French coverage is added. Requires Harmony. Incompatible with the original mod.
```

## Use This Instead comment (not posted)

Register: `../USE_THIS_INSTEAD.md`, row 3414678101. The item 3806761118 is still private. Post by the owner on the [Use This Instead](https://steamcommunity.com/sharedfiles/filedetails/?id=3396308787) page, after the switch to public.

```
A replacement for [url=https://steamcommunity.com/sharedfiles/filedetails/?id=3414678101]Folding Skateboard[/url] (SilkCircuit; packageId silkcircuit.foldableskateboardmod; RimWorld 1.5): [url=https://steamcommunity.com/sharedfiles/filedetails/?id=3806761118]Folding Skateboard Renew (unofficial)[/url] (Nelim; packageId nelim.foldingskateboard), for the latest RimWorld version. It is unofficial: the original author has not been reached. Thank you for keeping this list :)
```

## Gallery plan (shootGallery, draft 2 in the queue)

Nothing in `Art/Gallery/` yet but `0-preview.png`. The five captures of `Tests/Pickle/Evidence/` are checks that a rider is drawn
facing the way it is named, taken in a plain test yard with the default colonist: they are evidence, not gallery images, and none
goes on the page. The gallery is one staged story, played on Nelim's Sanctuary (`SanctuaryBacklot`), with Nelim as its
protagonist and Shogun, her labrador, as her only company. The plan came first
(`GALLERY.md`, "La session est la metteuse en scène"), the scenarios in `08-gallery.feature` follow it, one scenario per image.

**The story, "an afternoon on the board".** The square of the calm zone, centre (200, 187), has no roof and no wall shadow. For the
story a patch of concrete is laid on it (the mod's own terrain step, removed with the scene), because the board only unfolds on a
built hard floor. Same corner every time, Nelim and Shogun the same two figures, three boards lying on the stone. Time of day
14:00, then five game minutes between images, clear weather, 20 degrees so that no face shows sweat.

| # | Time | Scene | Nelim | What the image says |
| --- | --- | --- | --- | --- |
| 1 | 14:00 | Three boards lie on the concrete: steel, wood, plasteel. Wide shot, zoom 5.5. | Stands behind them, small smile. Shogun awake, facing the camera (South). | The board is the colour of what it is made from. |
| 2 | 14:05 | Nelim on the concrete with a board in her pack, facing South. Close, zoom 4. | Wide smile, cheerful lids. Shogun at her side, facing South. | Step on hard ground and the board unfolds under her. |
| 3 | 14:10 | Same corner, Nelim facing West, side on. Zoom 4. | Smile, eyes ahead. Shogun in the background. | On the board she is faster than on foot (Shredder, +2 speed). |
| 4 | 14:20 | Nelim one step off the concrete onto the grass, facing North, seen from behind. Zoom 4. | Face not visible. Shogun faces South toward the camera. | Off hard ground the board folds onto her back. |

**Looks.** Nelim wears an ochre shirt (214, 163, 58) and the fixture's trousers dyed dark blue (45, 58, 92): warm against the grey
and silver boards. Hairstyle `Ponytails` (the game's name), hair colour left as the fixture has it, no hat. Her face follows the story: the fixture's
own face in 1, `MouthSmile` with `LidCheerful` in 2 and 3. Facial Animation recomputes the face every tick, so the face is set
last, after every wait. No new mod: the outfit, the hair and the faces come from vanilla and from the mods the Sanctuary pass map
already stages (Facial Animation and EyeGenes3, for her dark brown eyes). I looked for a skater clothing mod on the Workshop and
found none that is clearly for 1.6, so none is imported.

**Not in the story yet.** A fifth image, the right-click menu with "Pick up folding skateboard", is a menu capture (no subtitle).
It needs a step that draws the float menu on screen: the mod's own steps read the menu but do not draw it. To ask the PickleTools
session.

## Gallery subtitles

One line of English written at the bottom of each scene without an interface window, as a film subtitle (`GALLERY.md`,
"Sous-titres"). The originals stay clean in `Art/Gallery-clean/`; `Art/Gallery/` holds the subtitled images. The file names are
the planned ones: the table follows the final files after the captures are accepted and the indexes closed.

| Index | File | Subtitle |
| --- | --- | --- |
| 1 | `1-three-boards.jpg` | Three folding boards on the stone, each the colour of what it is made from. |
| 2 | `2-first-push.jpg` | Step onto hard ground and the board unfolds under her feet. |
| 3 | `3-side-on.jpg` | On the board she is faster than on foot. |
| 4 | `4-folds-away.jpg` | Back on the grass, the board folds and straps to her back. |
