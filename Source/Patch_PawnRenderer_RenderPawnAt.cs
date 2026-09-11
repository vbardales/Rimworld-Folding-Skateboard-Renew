using System.Collections.Generic;
using HarmonyLib;
using UnityEngine;
using Verse;

namespace FoldingSkateboard
{
    /// <summary>
    /// Draws the board: under the pawn while they ride it, folded on their back otherwise.
    /// </summary>
    /// <remarks>
    /// <para>
    /// <c>PawnRenderer.RenderPawnAt</c> survived the render-tree rework. In 1.6 it is still the
    /// method <c>PawnRenderer.DynamicDrawPhaseAt</c> calls for <c>DrawPhase.Draw</c>, once per
    /// frame per visible pawn, with the same <c>(Vector3 drawLoc, Rot4? rotOverride, bool
    /// neverAimWeapon)</c> signature it had in 1.5. Verified against the shipped 1.6 assembly
    /// before this was compiled: the mod never touched <c>PawnRenderNode</c> or
    /// <c>PawnRenderTree</c>, it draws its own quad after the pawn is drawn, and that hook is
    /// intact.
    /// </para>
    /// <para>
    /// The 1.5 mod split this across two Harmony patches on the same method, each with its own
    /// copy of the terrain list, each re-reading the private <c>pawn</c> field through
    /// <c>Traverse</c> - a reflection lookup per pawn per frame. One postfix, one field read, and
    /// the riding graphic and the on-back graphic can no longer both fire (see
    /// <see cref="SkateableTerrain"/>).
    /// </para>
    /// </remarks>
    [HarmonyPatch(typeof(PawnRenderer), nameof(PawnRenderer.RenderPawnAt))]
    public static class Patch_PawnRenderer_RenderPawnAt
    {
        private static void Postfix(PawnRenderer __instance, Vector3 drawLoc)
        {
            Pawn pawn = __instance.pawn;
            if (pawn?.Map == null)
            {
                return;
            }

            Thing board = SkateboardUtility.CarriedSkateboard(pawn);
            if (board == null)
            {
                return;
            }

            // Stuff-coloured: a wooden board and a steel one are not the same colour.
            Color color = board.DrawColor;

            bool riding = !pawn.Map.roofGrid.Roofed(pawn.Position)
                          && SkateableTerrain.CanSkateOn(pawn.Position.GetTerrain(pawn.Map));

            if (riding)
            {
                // The riding graphic is drawn up to half a cell south of the pawn. With a wall
                // there it would be drawn across it, so SilkCircuit suppressed it entirely.
                if (HasEdifice(pawn.Map, pawn.Position + IntVec3.South))
                {
                    return;
                }

                DrawRiding(drawLoc, pawn.Rotation, color);
            }
            else if (pawn.Rotation == Rot4.North)
            {
                // Only from behind: the board is strapped to the pawn's back.
                DrawOnBack(drawLoc, color);
            }
        }

        private static bool HasEdifice(Map map, IntVec3 cell)
        {
            if (!cell.InBounds(map))
            {
                return false;
            }

            List<Thing> things = map.thingGrid.ThingsListAt(cell);
            for (int i = 0; i < things.Count; i++)
            {
                ThingDef def = things[i].def;
                if (def.category == ThingCategory.Building && def.building != null && def.building.isEdifice)
                {
                    return true;
                }
            }

            return false;
        }

        private static void DrawRiding(Vector3 drawLoc, Rot4 rotation, Color color)
        {
            string texPath;
            Quaternion rotationQuat;
            Vector3 position = drawLoc;

            // Just under the pawn.
            position.y -= 0.01f;

            if (rotation == Rot4.North || rotation == Rot4.South)
            {
                position.z -= 0.2f;
                texPath = "Things/Item/FoldingSkateboard/Skateboard_NorthSouth";
                rotationQuat = Quaternion.identity;
            }
            else if (rotation == Rot4.East || rotation == Rot4.West)
            {
                position.z -= 0.5f;
                texPath = "Things/Item/FoldingSkateboard/Skateboard_EastWest";
                rotationQuat = Quaternion.Euler(0f, 270f, 0f);
            }
            else
            {
                return;
            }

            Graphics.DrawMesh(
                MeshPool.plane10,
                Matrix4x4.TRS(position, rotationQuat, new Vector3(1f, 1f, 2f)),
                MaterialPool.MatFrom(texPath, ShaderDatabase.Transparent, color),
                0,
                null,
                0,
                null,
                UnityEngine.Rendering.ShadowCastingMode.Off,
                false);
        }

        private static void DrawOnBack(Vector3 drawLoc, Color color)
        {
            Vector3 position = drawLoc;

            // Just over the pawn's body.
            position.y += 0.03f;

            Graphics.DrawMesh(
                MeshPool.plane10,
                Matrix4x4.TRS(position, Quaternion.identity, Vector3.one),
                MaterialPool.MatFrom(
                    "Things/Item/FoldingSkateboard/Skateboard_OnBack",
                    ShaderDatabase.Transparent,
                    color),
                0);
        }
    }
}
