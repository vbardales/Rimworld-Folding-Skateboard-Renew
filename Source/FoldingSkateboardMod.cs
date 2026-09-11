using HarmonyLib;
using RimWorld;
using Verse;

namespace FoldingSkateboard
{
    /// <summary>
    /// Single entry point for the mod's Harmony patches.
    /// </summary>
    /// <remarks>
    /// The 1.5 mod applied every patch twice. It ran <c>PatchAll()</c> from the Mod constructor
    /// under the id "com.citylivingmod.customrenderer" and again from a
    /// <see cref="StaticConstructorOnStartupAttribute"/> class under
    /// "com.foldableskateboardmod.traitmanager". Two Harmony instances with different ids both
    /// take, so the board was drawn twice every frame and the trait check ran twice per tick.
    /// One instance, one PatchAll, and no static-constructor bootstraps beside it.
    /// </remarks>
    public class FoldingSkateboardMod : Mod
    {
        public FoldingSkateboardMod(ModContentPack content) : base(content)
        {
            new Harmony("nelim.foldingskateboard").PatchAll();
        }
    }

    [DefOf]
    public static class FoldingSkateboardDefOf
    {
        /// <summary>The board itself. The defName is SilkCircuit's; see ATTRIBUTION.md.</summary>
        public static ThingDef Paddleboard;

        /// <summary>Granted while riding, removed when the pawn steps off a skateable surface.</summary>
        public static TraitDef Shredder;

        public static JobDef AddPaddleboardToInventory;

        /// <summary>Vanilla's fast walker / slowpoke spectrum, set aside while Shredder is on.</summary>
        public static TraitDef SpeedOffset;

        static FoldingSkateboardDefOf()
        {
            DefOfHelper.EnsureInitializedInCtor(typeof(FoldingSkateboardDefOf));
        }
    }
}
