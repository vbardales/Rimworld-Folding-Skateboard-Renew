using System.Collections.Generic;
using RimWorld;
using UnityEngine;
using Verse;
using Verse.AI;

namespace FoldingSkateboard
{
    /// <summary>
    /// Walk to a folding skateboard and put it in the pawn's inventory.
    /// </summary>
    /// <remarks>
    /// SilkCircuit's driver, minus the two <c>Log</c> lines it wrote on every successful pickup -
    /// a mod has no business writing to a log everyone else reads to find their own bugs - and
    /// with the toil failing rather than dropping the board on the floor when the inventory
    /// refuses it.
    /// </remarks>
    public class JobDriver_TakeSkateboardToInventory : JobDriver
    {
        public override bool TryMakePreToilReservations(bool errorOnFailed)
        {
            return pawn.Reserve(job.targetA, job, 1, job.count, null, errorOnFailed);
        }

        protected override IEnumerable<Toil> MakeNewToils()
        {
            this.FailOnDestroyedOrNull(TargetIndex.A);
            this.FailOnForbidden(TargetIndex.A);

            yield return Toils_Goto.GotoThing(TargetIndex.A, PathEndMode.ClosestTouch);

            Toil take = ToilMaker.MakeToil("TakeSkateboard");
            take.initAction = () =>
            {
                Thing skateboard = job.targetA.Thing;
                if (skateboard == null || pawn.inventory == null)
                {
                    return;
                }

                int count = Mathf.Min(job.count, skateboard.stackCount);
                Thing taken = skateboard.stackCount > count
                    ? skateboard.SplitOff(count)
                    : skateboard;

                if (taken.Spawned)
                {
                    taken.DeSpawn();
                }

                if (!pawn.inventory.innerContainer.TryAdd(taken))
                {
                    // A full inventory should not eat the board.
                    Log.Warning($"[Folding Skateboard] {pawn.LabelShort} could not carry {taken.LabelCap}; dropping it.");
                    GenPlace.TryPlaceThing(taken, pawn.Position, pawn.Map, ThingPlaceMode.Near);
                }
            };
            take.defaultCompleteMode = ToilCompleteMode.Instant;
            yield return take;
        }
    }
}
