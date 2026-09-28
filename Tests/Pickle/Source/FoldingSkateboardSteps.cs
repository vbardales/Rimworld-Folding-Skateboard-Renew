using System;
using System.Collections.Generic;
using System.Linq;
using HarmonyLib;
using RimWorks.Pickle;
using RimWorld;
using UnityEngine;
using Verse;

namespace FoldingSkateboard.PickleSteps
{
    /// <summary>
    /// The steps of the Folding Skateboard Renew suite. They reach the mod through the game's own types and the mod's
    /// defNames, never through a class of the mod's own, and they read the mod's behaviour where a player would meet
    /// it: the right-click menu the game builds, the traits on a pawn, the stat the game computes.
    ///
    /// Every step text starts with "Folding Skateboard Renew:". Pickle loads the steps of every active suite into one
    /// namespace, and two suites declaring the same text turn healthy scenarios into "Ambiguous step".
    ///
    /// The map is not known in advance, so nothing here names a cell of the fixture. A scenario asks for a YARD, a
    /// square of clear ground found near the middle of the map, and every other step speaks in offsets of that yard.
    ///
    /// What is deliberately NOT here: anything the offline tests already prove (the defs, the four flags the provider
    /// declares, the patch targets) and anything that is the game's own reaction to something the mod merely declares
    /// (whether the menu builder honours those flags, what the game does with a removed mod). See TESTING.md.
    /// </summary>
    [PickleSteps]
    public class FoldingSkateboardSteps
    {
        private const string BoardDefName = "Paddleboard";
        private const string HarmonyId = "nelim.foldingskateboard";

        // Keys of the four texts the mod owns, and the word each refusal is asked for by.
        private const string TakeKey = "FoldingSkateboard.TakeToInventory";
        private const string RefusalCarrying = "FoldingSkateboard.TakeAlreadyCarrying";
        private const string RefusalForbidden = "FoldingSkateboard.TakeForbidden";
        private const string RefusalNoPath = "FoldingSkateboard.TakeNoPath";

        /// <summary>Half the side of the yard. A 7 by 7 square: the rider, a ring of walls, and room to spare.</summary>
        private const int YardRadius = 3;

        // ------------------------------------------------------------------ what a scenario remembers

        /// <summary>
        /// Everything is remembered by NAME or by offset, never by reference: a save and a reload replace every object
        /// of the map, so a Thing or a Pawn held across one is stale and is found again where it should be.
        /// </summary>
        private sealed class Ledger
        {
            public bool HasYard;
            public IntVec3 Origin;                                            // the south-west cell of the yard
            public readonly Dictionary<string, float> Speeds = new Dictionary<string, float>();
            public readonly Dictionary<string, Pawn> Away = new Dictionary<string, Pawn>();   // riders that left the map
        }

        private static Ledger LedgerOf(PickleContext ctx)
        {
            Ledger ledger = null;
            try
            {
                ledger = ctx.Get<Ledger>();
            }
            catch (Exception)
            {
                // nothing remembered yet in this scenario
            }

            if (ledger == null)
            {
                ledger = new Ledger();
                ctx.Set(ledger);
            }

            return ledger;
        }

        // ------------------------------------------------------------------ finding things

        private static Map CurrentMap(PickleContext ctx)
        {
            ctx.Require(Current.Game != null && Find.CurrentMap != null, "load a save first");
            return Find.CurrentMap;
        }

        private static Pawn Colonist(PickleContext ctx, string nickname)
        {
            Map map = CurrentMap(ctx);
            Pawn pawn = map.mapPawns.FreeColonists.FirstOrDefault(p => p.Name is NameTriple triple && triple.Nick == nickname)
                        ?? map.mapPawns.FreeColonists.FirstOrDefault(p => p.LabelShort == nickname);
            if (pawn == null)
            {
                LedgerOf(ctx).Away.TryGetValue(nickname, out pawn);
            }

            ctx.Assert(pawn != null, $"no colonist nicknamed \"{nickname}\", on the map or off it");
            return pawn;
        }

        private static IntVec3 Yard(PickleContext ctx, int dx, int dz)
        {
            Ledger ledger = LedgerOf(ctx);
            ctx.Require(ledger.HasYard, "prepare a yard first: \"Folding Skateboard Renew: a clear yard is prepared\"");
            IntVec3 cell = ledger.Origin + new IntVec3(dx, 0, dz);
            ctx.Assert(dx >= 0 && dz >= 0 && dx < 2 * YardRadius + 1 && dz < 2 * YardRadius + 1,
                $"({dx}, {dz}) is outside the yard, which runs from (0, 0) to ({2 * YardRadius}, {2 * YardRadius})");
            return cell;
        }

        private static ThingDef BoardDef(PickleContext ctx)
        {
            ThingDef def = DefDatabase<ThingDef>.GetNamed(BoardDefName, false);
            ctx.Assert(def != null, $"no ThingDef {BoardDefName}: the mod is not loaded");
            return def;
        }

        private static Thing BoardAt(PickleContext ctx, IntVec3 cell)
        {
            Map map = CurrentMap(ctx);
            Thing board = cell.GetThingList(map).FirstOrDefault(t => t.def.defName == BoardDefName);
            ctx.Assert(board != null,
                $"no {BoardDefName} at ({cell.x}, {cell.z}); the cell holds: " +
                string.Join(", ", cell.GetThingList(map).Select(t => t.def.defName)));
            return board;
        }

        // ------------------------------------------------------------------ the yard

        /// <summary>
        /// A square of ground with nothing on it that a test would trip over: standable, not roofed, not fogged, no
        /// building, no item, no pawn. Plants and filth do not disqualify a cell, they are cleared, because a meadow
        /// is where a test colony's open ground is.
        /// </summary>
        private static bool Clear(Map map, IntVec3 cell)
        {
            if (!cell.InBounds(map) || cell.Fogged(map) || cell.Roofed(map) || !cell.Standable(map) || cell.GetEdifice(map) != null)
            {
                return false;
            }

            foreach (Thing t in cell.GetThingList(map))
            {
                if (t.def.category == ThingCategory.Building || t.def.category == ThingCategory.Item || t.def.category == ThingCategory.Pawn)
                {
                    return false;
                }
            }

            return true;
        }

        [Given("Folding Skateboard Renew: a clear yard is prepared")]
        public void PrepareYard(PickleContext ctx)
        {
            Map map = CurrentMap(ctx);
            Ledger ledger = LedgerOf(ctx);
            TerrainDef soil = DefDatabase<TerrainDef>.GetNamed("Soil");

            foreach (IntVec3 centre in GenRadial.RadialCellsAround(map.Center, 60f, true))
            {
                bool fits = true;
                for (int dx = -YardRadius; dx <= YardRadius && fits; dx++)
                {
                    for (int dz = -YardRadius; dz <= YardRadius && fits; dz++)
                    {
                        fits = Clear(map, centre + new IntVec3(dx, 0, dz));
                    }
                }

                if (!fits)
                {
                    continue;
                }

                ledger.Origin = centre - new IntVec3(YardRadius, 0, YardRadius);
                ledger.HasYard = true;

                // Bare soil under a bare sky: the baseline that is NOT skateable, so a scenario adds what it needs.
                for (int dx = 0; dx <= 2 * YardRadius; dx++)
                {
                    for (int dz = 0; dz <= 2 * YardRadius; dz++)
                    {
                        IntVec3 cell = ledger.Origin + new IntVec3(dx, 0, dz);
                        map.terrainGrid.SetTerrain(cell, soil);
                        foreach (Thing t in cell.GetThingList(map).ToList())
                        {
                            if (t.def.category == ThingCategory.Plant || t.def.category == ThingCategory.Filth)
                            {
                                t.Destroy();
                            }
                        }
                    }
                }

                ctx.Attach("yard", $"south-west corner ({ledger.Origin.x}, {ledger.Origin.z}), {2 * YardRadius + 1} by {2 * YardRadius + 1}");
                return;
            }

            ctx.Assert(false, $"no {2 * YardRadius + 1} by {2 * YardRadius + 1} square of clear ground within 60 cells of the middle of the map");
        }

        [Given("Folding Skateboard Renew: the terrain at \\({int}, {int}\\) of the yard is {string}")]
        public void SetTerrain(PickleContext ctx, int dx, int dz, string terrainName)
        {
            TerrainDef terrain = DefDatabase<TerrainDef>.GetNamed(terrainName, false);
            ctx.Assert(terrain != null, $"no TerrainDef named \"{terrainName}\"");
            CurrentMap(ctx).terrainGrid.SetTerrain(Yard(ctx, dx, dz), terrain);
        }

        [Given("Folding Skateboard Renew: the roof over \\({int}, {int}\\) of the yard is {word}")]
        public void SetRoof(PickleContext ctx, int dx, int dz, string state)
        {
            ctx.Require(state == "built" || state == "removed", $"\"{state}\" is not a roof state: it is built or removed");
            IntVec3 cell = Yard(ctx, dx, dz);
            CurrentMap(ctx).roofGrid.SetRoof(cell, state == "built" ? RoofDefOf.RoofConstructed : null);
        }

        [Given("Folding Skateboard Renew: a wall stands at \\({int}, {int}\\) of the yard")]
        public void WallAt(PickleContext ctx, int dx, int dz)
        {
            SpawnWall(ctx, Yard(ctx, dx, dz));
        }

        [Given("Folding Skateboard Renew: the cell \\({int}, {int}\\) of the yard is walled off")]
        public void WalledOff(PickleContext ctx, int dx, int dz)
        {
            IntVec3 centre = Yard(ctx, dx, dz);
            for (int x = -1; x <= 1; x++)
            {
                for (int z = -1; z <= 1; z++)
                {
                    if (x != 0 || z != 0)
                    {
                        SpawnWall(ctx, centre + new IntVec3(x, 0, z));
                    }
                }
            }
        }

        private static void SpawnWall(PickleContext ctx, IntVec3 cell)
        {
            Map map = CurrentMap(ctx);
            Thing wall = ThingMaker.MakeThing(ThingDefOf.Wall, ThingDefOf.Steel);
            wall.SetFaction(Faction.OfPlayer);
            GenSpawn.Spawn(wall, cell, map);
        }

        // ------------------------------------------------------------------ boards and riders

        [Given("Folding Skateboard Renew: a folding skateboard made of {string} lies at \\({int}, {int}\\) of the yard")]
        public void BoardLies(PickleContext ctx, string stuffName, int dx, int dz)
        {
            ThingDef stuff = DefDatabase<ThingDef>.GetNamed(stuffName, false);
            ctx.Assert(stuff != null, $"no ThingDef \"{stuffName}\" to make the board of");
            Thing board = ThingMaker.MakeThing(BoardDef(ctx), stuff);
            GenSpawn.Spawn(board, Yard(ctx, dx, dz), CurrentMap(ctx));
        }

        [Given("Folding Skateboard Renew: the folding skateboard at \\({int}, {int}\\) of the yard is forbidden")]
        public void BoardForbidden(PickleContext ctx, int dx, int dz)
        {
            Thing board = BoardAt(ctx, Yard(ctx, dx, dz));
            CompForbiddable comp = board.TryGetComp<CompForbiddable>();
            ctx.Assert(comp != null, "the board carries no CompForbiddable");
            comp.Forbidden = true;
        }

        [Given("Folding Skateboard Renew: {string} carries a folding skateboard made of {string}")]
        public void Carries(PickleContext ctx, string nickname, string stuffName)
        {
            Pawn pawn = Colonist(ctx, nickname);
            ThingDef stuff = DefDatabase<ThingDef>.GetNamed(stuffName, false);
            ctx.Assert(stuff != null, $"no ThingDef \"{stuffName}\" to make the board of");
            Thing board = ThingMaker.MakeThing(BoardDef(ctx), stuff);
            ctx.Assert(pawn.inventory.innerContainer.TryAdd(board), $"{nickname}'s inventory refused the board");
        }

        [Given("Folding Skateboard Renew: {string} is placed at \\({int}, {int}\\) of the yard")]
        public void PlacePawn(PickleContext ctx, string nickname, int dx, int dz)
        {
            Pawn pawn = Colonist(ctx, nickname);
            IntVec3 cell = Yard(ctx, dx, dz);
            pawn.Position = cell;
            pawn.Notify_Teleported(true, true);
            pawn.pather?.StopDead();
        }

        // ------------------------------------------------------------------ the right-click menu, asked as the game asks it

        /// <summary>
        /// The menu the game builds for one selected pawn clicking one cell, through every provider it discovered:
        /// the mod's own is only one of them. A real click is a pointer over a cell, and this is what the click
        /// hands to the builder, without the pointer.
        /// </summary>
        private static List<FloatMenuOption> MenuFor(PickleContext ctx, Pawn pawn, IntVec3 cell)
        {
            FloatMenuContext context;
            List<FloatMenuOption> options = FloatMenuMakerMap.GetOptions(new List<Pawn> { pawn }, cell.ToVector3Shifted(), out context);
            ctx.Assert(options != null, "the game built no menu at all for that click");
            return options;
        }

        private static string Labels(List<FloatMenuOption> options)
        {
            return options.Count == 0 ? "(no entry)" : string.Join(" | ", options.Select(o => (o.Disabled ? "[disabled] " : "") + o.Label));
        }

        private static string RefusalKey(PickleContext ctx, string reason)
        {
            switch (reason)
            {
                case "carrying": return RefusalCarrying;
                case "forbidden": return RefusalForbidden;
                case "unreachable": return RefusalNoPath;
            }

            ctx.Require(false, $"\"{reason}\" is not a refusal: it is carrying, forbidden or unreachable");
            return null;
        }

        [Then("Folding Skateboard Renew: the menu for {string} on the board at \\({int}, {int}\\) of the yard offers to pick it up")]
        public void OffersPickUp(PickleContext ctx, string nickname, int dx, int dz)
        {
            Pawn pawn = Colonist(ctx, nickname);
            IntVec3 cell = Yard(ctx, dx, dz);
            Thing board = BoardAt(ctx, cell);
            string want = TakeKey.Translate(board.LabelShort).ToString();
            List<FloatMenuOption> options = MenuFor(ctx, pawn, cell);
            FloatMenuOption entry = options.FirstOrDefault(o => o.Label == want);
            ctx.Assert(entry != null, $"the menu has no entry reading \"{want}\"; it holds: {Labels(options)}");
            ctx.Assert(!entry.Disabled, $"the entry \"{want}\" is there and disabled, and it should be usable");
        }

        [Then("Folding Skateboard Renew: the menu for {string} on the board at \\({int}, {int}\\) of the yard refuses with {word}")]
        public void RefusesWith(PickleContext ctx, string nickname, int dx, int dz, string reason)
        {
            Pawn pawn = Colonist(ctx, nickname);
            IntVec3 cell = Yard(ctx, dx, dz);
            Thing board = BoardAt(ctx, cell);
            string want = RefusalKey(ctx, reason).Translate(board.LabelShort).ToString();
            List<FloatMenuOption> options = MenuFor(ctx, pawn, cell);
            FloatMenuOption entry = options.FirstOrDefault(o => o.Label == want);
            ctx.Assert(entry != null, $"the menu has no entry reading \"{want}\" (the {reason} refusal); it holds: {Labels(options)}");
            ctx.Assert(entry.Disabled, $"the entry \"{want}\" is there and usable, and a refusal should be greyed out");
            string pickUp = TakeKey.Translate(board.LabelShort).ToString();
            ctx.Assert(!options.Any(o => o.Label == pickUp), $"the menu offers \"{pickUp}\" as well as the refusal: {Labels(options)}");
        }

        [When("Folding Skateboard Renew: {string} takes the pick-up option for the board at \\({int}, {int}\\) of the yard")]
        public void TakesPickUp(PickleContext ctx, string nickname, int dx, int dz)
        {
            Pawn pawn = Colonist(ctx, nickname);
            IntVec3 cell = Yard(ctx, dx, dz);
            Thing board = BoardAt(ctx, cell);
            string want = TakeKey.Translate(board.LabelShort).ToString();
            List<FloatMenuOption> options = MenuFor(ctx, pawn, cell);
            FloatMenuOption entry = options.FirstOrDefault(o => o.Label == want);
            ctx.Assert(entry != null, $"the menu has no entry reading \"{want}\"; it holds: {Labels(options)}");
            ctx.Assert(!entry.Disabled, $"the entry \"{want}\" is disabled");
            ctx.Assert(entry.action != null, $"the entry \"{want}\" carries no action");
            entry.action();
        }

        [Given("Folding Skateboard Renew: the speed trait of {string} is set to degree {int}")]
        public void SetSpeedTrait(PickleContext ctx, string nickname, int degree)
        {
            // A generated colonist may already carry a fast walker, a jogger or a slowpoke: the scenario decides
            // which one it starts from instead of hoping. Degree 0 means none at all.
            Pawn pawn = Colonist(ctx, nickname);
            TraitDef def = DefDatabase<TraitDef>.GetNamed("SpeedOffset");
            foreach (Trait existing in pawn.story.traits.allTraits.Where(x => x.def == def).ToList())
            {
                pawn.story.traits.RemoveTrait(existing);
            }

            if (degree != 0)
            {
                pawn.story.traits.GainTrait(new Trait(def, degree));
            }

            bool has = pawn.story.traits.HasTrait(def);
            ctx.Assert(has == (degree != 0), $"{nickname}'s speed trait could not be set to degree {degree}; their traits: " +
                string.Join(", ", pawn.story.traits.allTraits.Select(x => x.def.defName + "/" + x.Degree)));
        }

        [Given("Folding Skateboard Renew: {string} faces {word}")]
        public void Faces(PickleContext ctx, string nickname, string direction)
        {
            Pawn pawn = Colonist(ctx, nickname);
            Rot4 rot;
            switch (direction.ToLowerInvariant())
            {
                case "north": rot = Rot4.North; break;
                case "south": rot = Rot4.South; break;
                case "east": rot = Rot4.East; break;
                case "west": rot = Rot4.West; break;
                default:
                    ctx.Require(false, $"\"{direction}\" is not a direction: it is north, south, east or west");
                    return;
            }

            pawn.Rotation = rot;
        }
        // ------------------------------------------------------------------ the trait, the speed

        [Then("Folding Skateboard Renew: {string} does not have the trait {string}")]
        public void DoesNotHaveTrait(PickleContext ctx, string nickname, string traitName)
        {
            Pawn pawn = Colonist(ctx, nickname);
            TraitDef trait = DefDatabase<TraitDef>.GetNamed(traitName, false);
            ctx.Assert(trait != null, $"no TraitDef named \"{traitName}\"");
            ctx.Assert(!pawn.story.traits.HasTrait(trait),
                $"{nickname} has {traitName}, and should not; their traits: " + string.Join(", ", pawn.story.traits.allTraits.Select(t => t.def.defName + "/" + t.Degree)));
        }

        [Then("Folding Skateboard Renew: {string} has the trait {string} at degree {int}")]
        public void HasTraitAtDegree(PickleContext ctx, string nickname, string traitName, int degree)
        {
            Pawn pawn = Colonist(ctx, nickname);
            TraitDef trait = DefDatabase<TraitDef>.GetNamed(traitName, false);
            ctx.Assert(trait != null, $"no TraitDef named \"{traitName}\"");
            ctx.Assert(pawn.story.traits.HasTrait(trait, degree),
                $"{nickname} does not have {traitName} at degree {degree}; their traits: " + string.Join(", ", pawn.story.traits.allTraits.Select(t => t.def.defName + "/" + t.Degree)));
        }

        [When("Folding Skateboard Renew: I note the move speed of {string}")]
        public void NoteSpeed(PickleContext ctx, string nickname)
        {
            LedgerOf(ctx).Speeds[nickname] = Colonist(ctx, nickname).GetStatValue(StatDefOf.MoveSpeed, true, -1);
        }

        [Then("Folding Skateboard Renew: the move speed of {string} has changed by {float}")]
        public void SpeedChanged(PickleContext ctx, string nickname, float expected)
        {
            float noted;
            ctx.Assert(LedgerOf(ctx).Speeds.TryGetValue(nickname, out noted), $"no move speed was noted for {nickname}");
            float now = Colonist(ctx, nickname).GetStatValue(StatDefOf.MoveSpeed, true, -1);
            float delta = now - noted;
            ctx.Assert(Math.Abs(delta - expected) < 0.05f,
                $"the move speed of {nickname} went from {noted:0.00} to {now:0.00}, a change of {delta:0.00}, and {expected:0.00} was expected");
        }

        // ------------------------------------------------------------------ leaving the map

        [When("Folding Skateboard Renew: {string} leaves the map")]
        public void LeavesTheMap(PickleContext ctx, string nickname)
        {
            Pawn pawn = Colonist(ctx, nickname);
            LedgerOf(ctx).Away[nickname] = pawn;
            pawn.DeSpawn();
        }

        [When("Folding Skateboard Renew: {string} returns at \\({int}, {int}\\) of the yard")]
        public void Returns(PickleContext ctx, string nickname, int dx, int dz)
        {
            Ledger ledger = LedgerOf(ctx);
            Pawn pawn;
            ctx.Assert(ledger.Away.TryGetValue(nickname, out pawn), $"{nickname} did not leave the map in this scenario");
            GenSpawn.Spawn(pawn, Yard(ctx, dx, dz), CurrentMap(ctx));
            ledger.Away.Remove(nickname);
        }

        // ------------------------------------------------------------------ what the game actually applied

        [Then("Folding Skateboard Renew: each of the mod's three patches is applied exactly once")]
        public void PatchesAppliedOnce(PickleContext ctx)
        {
            // The 1.5 mod ran PatchAll from two places under two ids, so every patch took twice and the board was
            // drawn twice per frame. Patch owners are counted, not the patches: two Harmony instances with the same
            // id would still be one owner, and that is why the id itself is asserted first.
            var expected = new[]
            {
                new { Type = typeof(Pawn), Method = "Tick", Kind = "postfix" },
                new { Type = typeof(Verse.PawnRenderer), Method = "RenderPawnAt", Kind = "postfix" },
                new { Type = typeof(Pawn), Method = "DeSpawn", Kind = "prefix" },
            };

            foreach (var e in expected)
            {
                var method = AccessTools.Method(e.Type, e.Method);
                ctx.Assert(method != null, $"{e.Type.Name}.{e.Method} does not exist in this build");
                Patches info = Harmony.GetPatchInfo(method);
                ctx.Assert(info != null, $"{e.Type.Name}.{e.Method} carries no patch at all");
                var list = e.Kind == "postfix" ? info.Postfixes : info.Prefixes;
                int mine = list.Count(p => p.owner == HarmonyId);
                ctx.Assert(mine == 1,
                    $"{e.Type.Name}.{e.Method} carries {mine} {e.Kind}(es) owned by \"{HarmonyId}\", and exactly one was expected; " +
                    "its owners: " + string.Join(", ", list.Select(p => p.owner)));
            }
        }

        // ------------------------------------------------------------------ looking

        [When("Folding Skateboard Renew: the camera looks at \\({int}, {int}\\) of the yard")]
        public void CameraLooksAt(PickleContext ctx, int dx, int dz)
        {
            CameraJumper.TryJump(Yard(ctx, dx, dz), CurrentMap(ctx));
        }

        // ------------------------------------------------------------------ the log

        /// <summary>
        /// Pickle's own log steps watch a scenario: an error written while the game was starting is before every
        /// scenario. A collision of two mods' defNames is such an error, so it is read from the game's log queue.
        /// </summary>
        [Then("Folding Skateboard Renew: the game log holds an error matching {string}")]
        public void LogHoldsError(PickleContext ctx, string text)
        {
            List<LogMessage> errors = Log.Messages.Where(m => m.type == LogMessageType.Error).ToList();
            bool found = errors.Any(m => m.text != null && m.text.IndexOf(text, StringComparison.OrdinalIgnoreCase) >= 0);
            ctx.Assert(found,
                $"no error of the game log mentions \"{text}\"; the log queue holds {errors.Count} error(s)" +
                (errors.Count == 0 ? "" : ", the first of them: " + Trim(errors[0].text)));
        }

        private static string Trim(string text)
        {
            return text == null ? "(empty)" : (text.Length > 200 ? text.Substring(0, 200) + "..." : text);
        }
    }
}
