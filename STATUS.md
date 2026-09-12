---
mod:          Folding Skateboard Renew
packageId:    nelim.foldingskateboardrenew
repo:         Rimworld-Folding-Skateboard-Renew
visibility:   public
detached:     yes
stage:        showcase
licence:      silent
licence_at:   four places, the About and the Steam page among them
dependencies: declared
showcase:     icon
tested_on:
workshop:
remaining:
  - unverified: never seen running, and no TESTING.md written to run from
  - defect: the icon is 1254 x 1254 and 1.2 MB for a slot that shows 32 px, and git does not track it yet
  - feature: no showcase image at all; PROMPT_FOLDINGSKATEBOARDRENEW.md, one folder up, holds the brief for it
session:      local_40bd9ed8-65bc-4776-8224-f7aa71edee50
updated:      2026-09-12, by the session that holds the mod
---

# Folding Skateboard Renew — status

Read by a sweep across every mod, rather than by asking each thread in turn. It lives at the
root, never inside `Mod/`, so Steam never receives it.

The sweep of 2026-09-12 read what it could off the disk and left four fields for whoever holds
this mod. They are answered now, and this is what they rest on.

- **`stage`** — one of `port`, `showcase`, `preTest`, `done`, `tested`, `published`. **`showcase`**:
  the port itself is finished and pushed, and what is left is the two images. The session group
  says the same thing.
- **`tested_on`** — the date of the last run in game. **Empty, and it means never.** The mod has
  never been loaded by RimWorld, here or anywhere: it was ported by reading the 1.6 assembly, not
  by running it. There is no `TESTING.md` either, so a first run would have to start by deciding
  what to look at.
- **`dependencies`** — **`declared`**, and it is the whole answer. Harmony is the only mod this one
  needs, and the About names it in `modDependencies`. The 1.6 assembly and Harmony are the only
  things the C# references. The ~170 terrain names in `SkateableTerrain` include floors from LTS
  Systems' mods, but a name belonging to a mod that is not loaded simply resolves to nothing: they
  are opportunities, not dependencies, and declaring them would be wrong.
- **`remaining`** — what is left, in three kinds: `feature` for something missing from a first
  release, `defect` for a known fault left unfixed, `unverified` for what could not be checked.

`workshop` stays empty because the mod has never been uploaded: there is no `PublishedFileId.txt`
in the folder, which is also why the `packageId` could still be renamed on 2026-09-12.

## Vocabulary

`licence`: `open` an explicit licence, `silent` no licence and a dead source, `alive` no licence
but a living source, `forbidden` a written refusal, `original` owing nothing to anyone — not a
name, not an idea traceable to one mod, not a value derived from its assets.

`showcase`, read off the disk: `none` neither image, `icon` or `preview` one of the two,
`complete` both. It says which files exist, never whether they are any good — this mod's icon
counts towards `icon` while being four times too wide and forty times too heavy.

## What this file is for, and the one way it goes wrong

It is read by sweeps that ask all 116 mods a question at once, and the answers are only worth
what the sheets are worth. A sheet that says `done` while a defect sits unwritten is worse than
no sheet: the sweep reports a clean mod and nobody looks again.

So the rule for keeping it is the same one the documents of this repository follow — **a line
that stops being true is a line to change, and the moment to change it is the commit that made
it false.** Not the next sweep, which will simply copy the lie forward.
