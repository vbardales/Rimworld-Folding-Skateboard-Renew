using Verse;

namespace FoldingSkateboard
{
    /// <summary>
    /// One answer to "is this pawn carrying a board", used by the renderer and by the trait patch.
    /// </summary>
    /// <remarks>
    /// The 1.5 mod asked this question in four places with three different answers: two copies
    /// compared <c>item.def.defName == "Paddleboard"</c> string by string, a third used LINQ over
    /// the same, and the colour lookup checked equipped gear first even though the board is not
    /// equipment and cannot be equipped. A def reference compares by identity, and there is only
    /// one place to change if the def is ever renamed.
    /// </remarks>
    public static class SkateboardUtility
    {
        /// <summary>The board in the pawn's inventory, or null. Never more than one: stackLimit is 1.</summary>
        public static Thing CarriedSkateboard(Pawn pawn)
        {
            ThingOwner<Thing> inventory = pawn.inventory?.innerContainer;
            if (inventory == null)
            {
                return null;
            }

            for (int i = 0; i < inventory.Count; i++)
            {
                if (inventory[i].def == FoldingSkateboardDefOf.Paddleboard)
                {
                    return inventory[i];
                }
            }

            return null;
        }
    }
}
