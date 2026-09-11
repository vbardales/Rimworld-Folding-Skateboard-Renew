using System.Collections.Generic;
using Verse;

namespace FoldingSkateboard
{
    /// <summary>
    /// The surfaces a pawn can ride the board on: constructed floors, mined rock floors, and
    /// bridges. SilkCircuit's list, unchanged.
    /// </summary>
    /// <remarks>
    /// Two changes to how it is used, neither to what is in it.
    /// <para>
    /// The 1.5 mod carried this list three times over: once in the trait patch, once in the
    /// renderer that draws the board under the pawn, and a third copy in the renderer that draws
    /// it folded on their back. The first two were identical; the third stopped at "Bridge" and
    /// left out all 141 LTS floors. On an LTS floor a pawn was therefore drawn riding the board
    /// AND wearing it on their back at the same time. One list, and the two graphics become
    /// mutually exclusive by construction.
    /// </para>
    /// <para>
    /// The names are resolved to <see cref="TerrainDef"/> once at startup instead of being
    /// compared as strings on every tick and every frame. Names belonging to mods that are not
    /// loaded simply resolve to nothing.
    /// </para>
    /// <para>
    /// Vanilla stone floors are generated defs, not XML: RimWorld builds "{rock}_Rough",
    /// "{rock}_RoughHewn" and "{rock}_Smooth" for each rock type at load time. The five rough and
    /// rough-hewn names below are real in 1.6; the smooth ones were never in the list, and are
    /// left out rather than added, because that is a balance call and not a port.
    /// </para>
    /// </remarks>
    [StaticConstructorOnStartup]
    public static class SkateableTerrain
    {
        // Vanilla: constructed floors, mined rock floors, bridges.
        private static readonly string[] VanillaNames =
        {
            "Concrete",
            "PavedTile",
            "WoodPlankFloor",
            "MetalTile",
            "SilverTile",
            "GoldTile",
            "SterileTile",
            "TileSandstone",
            "TileGranite",
            "TileLimestone",
            "TileSlate",
            "TileMarble",
            "FlagstoneSandstone",
            "FlagstoneGranite",
            "FlagstoneLimestone",
            "FlagstoneSlate",
            "FlagstoneMarble",
            "BrokenAsphalt",
            "Sandstone_Rough",
            "Sandstone_RoughHewn",
            "Granite_Rough",
            "Granite_RoughHewn",
            "Limestone_Rough",
            "Limestone_RoughHewn",
            "Slate_Rough",
            "Slate_RoughHewn",
            "Marble_Rough",
            "Marble_RoughHewn",
            "Bridge",
        };

        // Floors from LTS Systems' furniture mods. Absent without them, and harmless.
        private static readonly string[] LtsNames =
        {
            "LTS_PlankFloor",
            "LTS_PlankFloorTwo",
            "LTS_PlankFloorLarge",
            "LTS_PlankFloorLargeTwo",
            "LTS_ChevronParquet",
            "LTS_DiagonalHerringbone",
            "LTS_DiamondPattern",
            "LTS_DoubleHerringbone",
            "LTS_Herringbone",
            "LTS_IndustrialFloor",
            "LTS_IndustrialTileFloor",
            "LTS_IndustrailDirtyFloor",
            "LTS_GratingHFloor",
            "LTS_GratingVFloor",
            "LTS_VinylFloor",
            "LTS_VinylFloorTinted",
            "LTS_VinylFloorDiamond",
            "LTS_VinylFloorSquare",
            "LTS_GratedFloor",
            "LTS_LightFloor",
            "LTS_PlatedFloor",
            "LTS_RuralSandstone",
            "LTS_RuralGranite",
            "LTS_RuralLimestone",
            "LTS_RuralSlate",
            "LTS_RuralMarble",
            "LTS_RuralClaystone",
            "LTS_RuralAndesite",
            "LTS_RuralSyenite",
            "LTS_RuralGneiss",
            "LTS_RuralQuartzite",
            "LTS_RuralSchist",
            "LTS_RuralGabbro",
            "LTS_RuralDiorite",
            "LTS_RuralDunite",
            "LTS_RuralPegmatite",
            "LTS_PatternEvenSandstone",
            "LTS_PatternEvenGranite",
            "LTS_PatternEvenLimestone",
            "LTS_PatternEvenSlate",
            "LTS_PatternEvenMarble",
            "LTS_PatternEvenClaystone",
            "LTS_PatternEvenAndesite",
            "LTS_PatternEvenSyenite",
            "LTS_PatternEvenGneiss",
            "LTS_PatternEvenQuartzite",
            "LTS_PatternEvenSchist",
            "LTS_PatternEvenGabbro",
            "LTS_PatternEvenDiorite",
            "LTS_PatternEvenDunite",
            "LTS_PatternEvenPegmatite",
            "LTS_PatternUnevenSandstone",
            "LTS_PatternUnevenGranite",
            "LTS_PatternUnevenLimestone",
            "LTS_PatternUnevenSlate",
            "LTS_PatternUnevenMarble",
            "LTS_PatternUnevenClaystone",
            "LTS_PatternUnevenAndesite",
            "LTS_PatternUnevenSyenite",
            "LTS_PatternUnevenGneiss",
            "LTS_PatternUnevenQuartzite",
            "LTS_PatternUnevenSchist",
            "LTS_PatternUnevenGabbro",
            "LTS_PatternUnevenDiorite",
            "LTS_PatternUnevenDunite",
            "LTS_PatternUnevenPegmatite",
            "LTS_GravelSandstone",
            "LTS_GravelGranite",
            "LTS_GravelLimestone",
            "LTS_GravelSlate",
            "LTS_GravelMarble",
            "LTS_GravelClaystone",
            "LTS_GravelAndesite",
            "LTS_GravelSyenite",
            "LTS_GravelGneiss",
            "LTS_GravelQuartzite",
            "LTS_GravelSchist",
            "LTS_GravelGabbro",
            "LTS_GravelDiorite",
            "LTS_GravelDunite",
            "LTS_GravelPegmatite",
            "LTS_RoughSquareDiagonalSandstone",
            "LTS_RoughSquareDiagonalGranite",
            "LTS_RoughSquareDiagonalLimestone",
            "LTS_RoughSquareDiagonalSlate",
            "LTS_RoughSquareDiagonalMarble",
            "LTS_RoughSquareDiagonalClaystone",
            "LTS_RoughSquareDiagonalAndesite",
            "LTS_RoughSquareDiagonalSyenite",
            "LTS_RoughSquareDiagonalGneiss",
            "LTS_RoughSquareDiagonalQuartzite",
            "LTS_RoughSquareDiagonalSchist",
            "LTS_RoughSquareDiagonalGabbro",
            "LTS_RoughSquareDiagonalDiorite",
            "LTS_RoughSquareDiagonalDunite",
            "LTS_RoughSquareDiagonalPegmatite",
            "LTS_RoughSquareStraightSandstone",
            "LTS_RoughSquareStraightGranite",
            "LTS_RoughSquareStraightLimestone",
            "LTS_RoughSquareStraightSlate",
            "LTS_RoughSquareStraightMarble",
            "LTS_RoughSquareStraightClaystone",
            "LTS_RoughSquareStraightAndesite",
            "LTS_RoughSquareStraightSyenite",
            "LTS_RoughSquareStraightGneiss",
            "LTS_RoughSquareStraightQuartzite",
            "LTS_RoughSquareStraightSchist",
            "LTS_RoughSquareStraightGabbro",
            "LTS_RoughSquareStraightDiorite",
            "LTS_RoughSquareStraightDunite",
            "LTS_RoughSquareStraightPegmatite",
            "LTS_RoughTileBaseHSandstone",
            "LTS_RoughTileBaseHGranite",
            "LTS_RoughTileBaseHLimestone",
            "LTS_RoughTileBaseHSlate",
            "LTS_RoughTileBaseHMarble",
            "LTS_RoughTileBaseHClaystone",
            "LTS_RoughTileBaseHAndesite",
            "LTS_RoughTileBaseHSyenite",
            "LTS_RoughTileBaseHGneiss",
            "LTS_RoughTileBaseHQuartzite",
            "LTS_RoughTileBaseHSchist",
            "LTS_RoughTileBaseHGabbro",
            "LTS_RoughTileBaseHDiorite",
            "LTS_RoughTileBaseHDunite",
            "LTS_RoughTileBaseHPegmatite",
            "LTS_RoughTileBaseVSandstone",
            "LTS_RoughTileBaseVGranite",
            "LTS_RoughTileBaseVLimestone",
            "LTS_RoughTileBaseVSlate",
            "LTS_RoughTileBaseVMarble",
            "LTS_RoughTileBaseVClaystone",
            "LTS_RoughTileBaseVAndesite",
            "LTS_RoughTileBaseVSyenite",
            "LTS_RoughTileBaseVGneiss",
            "LTS_RoughTileBaseVQuartzite",
            "LTS_RoughTileBaseVSchist",
            "LTS_RoughTileBaseVGabbro",
            "LTS_RoughTileBaseVDiorite",
            "LTS_RoughTileBaseVDunite",
            "LTS_RoughTileBaseVPegmatite",
        };

        private static readonly HashSet<TerrainDef> Skateable = new HashSet<TerrainDef>();

        static SkateableTerrain()
        {
            Add(VanillaNames);
            Add(LtsNames);
        }

        private static void Add(string[] defNames)
        {
            foreach (string defName in defNames)
            {
                TerrainDef terrain = DefDatabase<TerrainDef>.GetNamedSilentFail(defName);
                if (terrain != null)
                {
                    Skateable.Add(terrain);
                }
            }
        }

        public static bool CanSkateOn(TerrainDef terrain)
        {
            return terrain != null && Skateable.Contains(terrain);
        }
    }
}
