using HarmonyLib;
using RimWorld;
using Verse;

namespace FoldingSkateboard
{
    /// <summary>
    /// Grants the Shredder trait while a pawn stands on a skateable surface with a board on them,
    /// and takes it back off when they step indoors, onto soil, or lose the board.
    /// </summary>
    /// <remarks>
    /// <para>
    /// <c>Pawn.Tick</c> is still called every tick for every spawned pawn in 1.6. The 1.6 tick
    /// rework added <c>Thing.DoTick</c>, which calls <c>Entity.TickInterval</c> at a variable rate
    /// - but it calls <c>Entity.Tick</c> first, unconditionally, whenever the thing is spawned.
    /// Verified against the shipped assembly: the hook is intact.
    /// </para>
    /// <para>
    /// What was not intact is the cost. The 1.5 version allocated a 170-entry string array on
    /// every tick of every pawn on the map - animals and mechanoids included - and ran a linear
    /// string comparison down it. That is the whole of this patch's work, done sixty times a
    /// second per pawn. Here the list is resolved once at startup
    /// (see <see cref="SkateableTerrain"/>), pawns without a trait set are dropped before anything
    /// else, and the check runs on a hash interval so the cost is spread across pawns rather than
    /// paid by all of them on the same tick. A quarter of a second of lag on a movement bonus is
    /// not visible; the board's graphic still follows the terrain frame by frame.
    /// </para>
    /// </remarks>
    // "Tick" as a string, not nameof: Pawn.Tick is protected in 1.6, so the name is not
    // addressable from outside the assembly. Harmony patches it all the same.
    [HarmonyPatch(typeof(Pawn), "Tick")]
    public static class Patch_Pawn_Tick
    {
        private const int CheckIntervalTicks = 15;

        private static void Postfix(Pawn __instance)
        {
            // Animals and mechanoids have no trait set at all, and this is most of the map.
            if (__instance.story?.traits == null)
            {
                return;
            }

            if (!__instance.IsHashIntervalTick(CheckIntervalTicks))
            {
                return;
            }

            if (!__instance.Spawned || __instance.Map == null)
            {
                ShredderTrait.Remove(__instance);
                return;
            }

            bool skating = !__instance.Map.roofGrid.Roofed(__instance.Position)
                           && SkateableTerrain.CanSkateOn(__instance.Position.GetTerrain(__instance.Map))
                           && SkateboardUtility.CarriedSkateboard(__instance) != null;

            if (skating)
            {
                ShredderTrait.Grant(__instance);
            }
            else
            {
                ShredderTrait.Remove(__instance);
            }
        }
    }

    /// <summary>
    /// Gives a pawn the Shredder trait back to normal when they stop being spawned.
    /// </summary>
    /// <remarks>
    /// <c>Pawn.Tick</c> only runs while the pawn is spawned, so a pawn who left the map mid-ride -
    /// packed into a caravan, sent off in a shuttle, sold - kept +2 movement speed and had their
    /// fast walker trait held hostage until they were next put on a map. This is the missing half
    /// of the trait swap, and it is new: the 1.5 mod had nothing here.
    /// </remarks>
    [HarmonyPatch(typeof(Pawn), nameof(Pawn.DeSpawn))]
    public static class Patch_Pawn_DeSpawn
    {
        private static void Prefix(Pawn __instance)
        {
            if (__instance.story?.traits != null)
            {
                ShredderTrait.Remove(__instance);
            }
        }
    }

    /// <summary>
    /// The trait swap itself. Vanilla's fast walker / slowpoke trait is set aside while Shredder is
    /// on, so the two movement bonuses do not stack, and handed back afterwards.
    /// </summary>
    internal static class ShredderTrait
    {
        internal static void Grant(Pawn pawn)
        {
            TraitSet traits = pawn.story.traits;
            if (traits.HasTrait(FoldingSkateboardDefOf.Shredder))
            {
                return;
            }

            FoldingSkateboardGameComponent component = FoldingSkateboardGameComponent.Current;
            if (component == null)
            {
                return;
            }

            Trait speedTrait = traits.GetTrait(FoldingSkateboardDefOf.SpeedOffset);
            if (speedTrait != null && !component.suspendedSpeedTraits.ContainsKey(pawn.ThingID))
            {
                component.suspendedSpeedTraits[pawn.ThingID] = speedTrait;
                traits.RemoveTrait(speedTrait);
            }

            traits.GainTrait(new Trait(FoldingSkateboardDefOf.Shredder));
        }

        internal static void Remove(Pawn pawn)
        {
            TraitSet traits = pawn.story.traits;
            Trait shredder = traits.GetTrait(FoldingSkateboardDefOf.Shredder);
            if (shredder == null)
            {
                return;
            }

            traits.RemoveTrait(shredder);

            FoldingSkateboardGameComponent component = FoldingSkateboardGameComponent.Current;
            if (component == null)
            {
                return;
            }

            if (component.suspendedSpeedTraits.TryGetValue(pawn.ThingID, out Trait speedTrait))
            {
                traits.GainTrait(speedTrait);
                component.suspendedSpeedTraits.Remove(pawn.ThingID);
            }
        }
    }
}
