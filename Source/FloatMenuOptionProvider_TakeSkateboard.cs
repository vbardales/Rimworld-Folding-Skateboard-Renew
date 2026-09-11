using System.Collections.Generic;
using RimWorld;
using Verse;
using Verse.AI;

namespace FoldingSkateboard
{
    /// <summary>
    /// Right-click a board on the ground with a colonist selected: "pick up folding skateboard".
    /// Nothing in vanilla puts a plain resource into a pawn's inventory, so this option is the only
    /// way to get on the board.
    /// </summary>
    /// <remarks>
    /// <para>
    /// This is the one part of the mod 1.6 actually broke. The 1.5 version postfixed
    /// <c>FloatMenuMakerMap.ChoicesAtFor</c> and appended to the returned list. That method is gone
    /// in 1.6: right-click menus are built by <c>FloatMenuOptionProvider</c> subclasses, which
    /// <c>FloatMenuMakerMap.Init</c> discovers with <c>AllSubclassesNonAbstract</c> and
    /// instantiates. <c>AccessTools.Method</c> would have returned null and Harmony would have
    /// thrown on startup - a mod that dies before the main menu, not one that misbehaves quietly.
    /// So there is no Harmony patch here at all any more: declaring the class is the whole of the
    /// registration.
    /// </para>
    /// <para>
    /// Two things from the 1.5 version are gone because they could never run. It offered a
    /// quantity slider - with its own <c>Dialog_Slider</c> window, duplicating the one Verse
    /// already has - for stacks larger than one, and the board's <c>stackLimit</c> is 1. And it
    /// stripped "Force equip" options by matching the English words in their labels, for an item
    /// that is not equipment and never had one.
    /// </para>
    /// </remarks>
    public class FloatMenuOptionProvider_TakeSkateboard : FloatMenuOptionProvider
    {
        protected override bool Drafted => false;

        protected override bool Undrafted => true;

        protected override bool Multiselect => false;

        protected override bool RequiresManipulation => true;

        public override IEnumerable<FloatMenuOption> GetOptionsFor(Thing clickedThing, FloatMenuContext context)
        {
            if (clickedThing.def != FoldingSkateboardDefOf.Paddleboard)
            {
                yield break;
            }

            Pawn pawn = context.FirstSelectedPawn;
            string label = "FoldingSkateboard.TakeToInventory".Translate(clickedThing.LabelShort);

            if (SkateboardUtility.CarriedSkateboard(pawn) != null)
            {
                yield return new FloatMenuOption(
                    label + ": " + "FoldingSkateboard.AlreadyCarrying".Translate(),
                    null);
                yield break;
            }

            if (clickedThing.IsForbidden(pawn))
            {
                yield return new FloatMenuOption(label + ": " + "ForbiddenLower".Translate(), null);
                yield break;
            }

            if (!pawn.CanReach(clickedThing, PathEndMode.ClosestTouch, Danger.Deadly))
            {
                yield return new FloatMenuOption(label + ": " + "NoPath".Translate(), null);
                yield break;
            }

            // DecoratePrioritizedTask turns this into a disabled "reserved by ..." option when
            // someone else has claimed the board, and adds the priority-click behaviour.
            yield return FloatMenuUtility.DecoratePrioritizedTask(
                new FloatMenuOption(label, () => TakeSkateboard(pawn, clickedThing)),
                pawn,
                clickedThing);
        }

        private static void TakeSkateboard(Pawn pawn, Thing skateboard)
        {
            Job job = JobMaker.MakeJob(FoldingSkateboardDefOf.AddPaddleboardToInventory, skateboard);
            job.count = 1;
            pawn.jobs.TryTakeOrderedJob(job, JobTag.Misc);
        }
    }
}
