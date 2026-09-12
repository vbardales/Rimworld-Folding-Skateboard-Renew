# Folding Skateboard Renew

A 1.6 port of **Folding Skateboard** by **SilkCircuit**
([Workshop 3414678101](https://steamcommunity.com/sharedfiles/filedetails/?id=3414678101)).

A skateboard that lives in a colonist's inventory. Step onto an outdoor hard surface and it
unfolds under them for +2 movement speed; step indoors or onto soil and it folds back onto their
back.

I am not the author. The idea, the artwork, the trait and the balance are SilkCircuit's. See
[ATTRIBUTION.md](ATTRIBUTION.md) for what was carried over, what 1.6 broke, and what was fixed
along the way.

## Layout

```
FoldingSkateboardRenew/
  Mod/          the published folder - this is what the NTFS junction into RimWorld/Mods points at
  Source/       C#, never published
  _tools/       the showcase page and the functional tests, never published
```

Steam publishes the junction's target directory as it stands, with no filtering
(`SteamUGC.SetItemContent`), so anything inside `Mod/` ships. That is why the sources live outside
it and why build intermediates are redirected to `.build/` by `Source/Directory.Build.props`.

## Building

```
dotnet build Source/FoldingSkateboard.csproj
```

The output goes straight to `Mod/Assemblies/FoldingSkateboard.dll`. Reference assemblies come from
NuGet (`Krafs.Rimworld.Ref`), so no RimWorld installation is needed to compile.

## Checks

```
powershell -NoProfile -ExecutionPolicy Bypass -File _tools/Run-Functional-Tests.ps1
```

Asks the installed game whether it still does what this mod hooks into, without launching it. Most
of what this port rests on fails silently when the game moves underneath it - a draw phase that
stops calling the method this mod postfixes, a float-menu sweep that stops finding providers, a
floor that gets renamed - and none of those throws anything a log would carry. It reads the
installed game's assembly, not the NuGet reference copy.

## Requirements

RimWorld 1.6 and [Harmony](https://steamcommunity.com/sharedfiles/filedetails/?id=2009463077). No
DLC.

Incompatible with SilkCircuit's original mod: both define the same defNames. Run one or the other.

## Licence

The port work in this repository is MIT ([LICENSE](LICENSE)). SilkCircuit's original mod declared
no licence at all; it is republished here under the Workshop's usual convention for abandoned
mods — full credit, a link to the original, and removal on request. See
[ATTRIBUTION.md](ATTRIBUTION.md).
