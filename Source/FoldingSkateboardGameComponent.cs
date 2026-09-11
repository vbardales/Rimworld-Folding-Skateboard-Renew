using System.Collections.Generic;
using RimWorld;
using Verse;

namespace FoldingSkateboard
{
    /// <summary>
    /// Holds the fast walker / slowpoke trait taken off a pawn while they are riding, so it can be
    /// given back when they step off. Keyed by <see cref="Thing.ThingID"/> and saved with the game.
    /// </summary>
    /// <remarks>
    /// GameComponents are instantiated for every subclass automatically; nothing declares this.
    /// </remarks>
    public class FoldingSkateboardGameComponent : GameComponent
    {
        public Dictionary<string, Trait> suspendedSpeedTraits = new Dictionary<string, Trait>();

        public FoldingSkateboardGameComponent(Game game)
        {
        }

        public override void ExposeData()
        {
            base.ExposeData();
            Scribe_Collections.Look(
                ref suspendedSpeedTraits,
                "OriginalSpeedOffsets",
                LookMode.Value,
                LookMode.Deep);

            if (Scribe.mode == LoadSaveMode.PostLoadInit && suspendedSpeedTraits == null)
            {
                suspendedSpeedTraits = new Dictionary<string, Trait>();
            }
        }

        /// <summary>Null outside a running game - during shutdown, or on the main menu.</summary>
        public static FoldingSkateboardGameComponent Current
        {
            get { return Verse.Current.Game?.GetComponent<FoldingSkateboardGameComponent>(); }
        }
    }
}
