# SHOTLIST (2026-11-03, replaces the Kenji draft of 2026-10-16). Plan first, scenarios follow (one scenario = one image). The scenarios
# below are still the OLD draft (Kenji): they are rewritten from this plan before any ticket. Table with scores: STATUS.md, "shotlist".
#
# THE STORY, "an afternoon on the board": Nelim (protagonist, NSB) shows her friend Soren (NSB, her male alter ego, constant face; no
# other colonist) what a folding board does, on the cream square of the tribe (calm-zone: no roof, no wall shadow) where a patch of
# concrete is laid, because the board only unfolds on a built hard floor, with a soil strip south of it. Shogun (her labrador, NSB) tags
# along. One afternoon, Clear, 20 degrees (no sweat). Clock: 14:00, then 5 game minutes between images (cumulative waits, 208 ticks per 5
# min), closing at 17:00 in warm light (hour set, same day). The mod's whole offer is shown: the three materials (S1), the right-click
# pick-up into the pack (S1, S4), unfold + trait Shredder on hard ground (S2), +2 speed (S3), fold onto the back on soft ground (S5).
# Outfits do not change all day: Nelim ochre shirt (214,163,58), dark blue trousers (45,58,92), VAE shoes, hair Ponytails, bare head
# (no hat: the hat-hair rule does not apply); Soren VAE red baseball cap (200,52,48), teal hoodie (46,139,139), grey shorts (58,58,66),
# VAE shoes, hair ShortCut, eyes Eyes_SkyBlue (a skater look, chosen for the story); Shogun with the default leather dog collar.
# Faces: Nelim smiles (face kit neutral, then MouthSmile + LidCheerful, normal+blink, set last, no sweat), except where written.
# Shots (all with a subtitle, no interface window), decor = PlantPot with Plant_Daylily fully grown, TorchLamp lit; removed after each:
#  S1 workshop-1-three-boards  14:00 WIDE, frame (200,188) zoom 4.5. Boards on concrete: steel (198,187) dark, wood (200,187) brown,
#     plasteel (202,187) light blue. Nelim starts at (200,191), no board in her pack, and has JUST set off to take the steel board (pick-up
#     job given, game paused ~20 ticks later, mid-stride facing N); Soren (196,189) faces her, smiling, hands in pockets; Shogun faces the
#     camera (S) at (203,189). Decor: pot + daylily at (196,184) and (204,184) behind the boards. Instant: she just decided to try one.
#     Says: three boards, three materials. Subtitle: "Three boards: steel, wood, plasteel."
#  S2 workshop-2-it-unfolds    14:05 MEDIUM, frame (200,190) zoom 3.5, Nelim off-centre left. Nelim, board in her pack, has JUST finished
#     taking the board lying on the concrete edge (200,191) (pick-up job from the soil strip; pause 2 ticks after "carrying 1 Paddleboard";
#     N tuned in the first run, estimate 150), on the concrete facing S, board drawn under her feet, wide smile; trait Shredder asserted
#     before the photo. Shogun in front of her facing the camera (S) at (200,192) (animal seen from the front); Soren behind her at
#     (203,188) facing W, smiling. Decor: pot + daylily (204,185). Instant: the board has just unfolded. Subtitle: "Step onto hard ground
#     and the board unfolds."
#  S3 workshop-3-the-race      14:10 WIDE along E-W, frame (199,185) zoom 4, track in the lower third. Nelim on the board (steel in pack,
#     start (203,187)) and Soren on foot (start (201,187)) both sent West to the finish pot (196,187) with a forced-walk job; game paused when she
#     draws level with him (I let N ticks pass, then "time is paused for the capture"; N tuned, estimate 25 to 40); Nelim smiling, Soren set face "angry" (effort, planned), Shogun at (199,189)
#     facing W. Step exists (NPT, 2026-11-03): `Nelim's Pickle Tools: "<name>" is forced to walk to (x, z)`, never `stands at ... facing` on the walker after it starts; written, not played. All on concrete (x 196-204): board stays unfolded.
#     Decor: pot + daylily (196,185) as the finish. Says: she is faster on the board. Subtitle: "Hers has wheels."
#  S4 workshop-4-his-turn      14:15 TIGHT, frame (199,187) zoom 3.2. Soren (no board yet) walks to the wood board at (199,187) (pick-up
#     job, pause ~15 ticks, mid-stride facing W), smug grin (kit smug, planned: he is about to win a board); Nelim rides beside him on the
#     concrete at (201,187) facing W, smiling, waiting; Shogun faces the camera (S) at (199,189). Decor: pot + daylily (204,185). Instant:
#     he has just started toward the wood board. Subtitle: "His turn: he takes the wood one."
#  S5 workshop-5-soft-ground   17:00 MEDIUM, light warm, frame (200,192) zoom 4. Nelim has JUST taken the board lying on soil at (200,193)
#     (pick-up job from the concrete, pause 2 ticks after "carrying"), on the soil facing S, board folded on her back, smiling; trait
#     gone (asserted); Soren in the background right on the concrete, riding (wood board in pack), small in
#     frame (204,188), smile; Shogun follows her, at (199,194) facing S. Decor: TorchLamp lit (198,190) and (202,190). Says: off the
#     concrete it folds away; closes the day. Subtitle: "Soft ground: it folds onto her back."
# DepMap: the SanctuaryBacklot map as base, nothing challenged, plus screenshotstudio, camerazoom, colonistrace, stagedecor, vappe.
# Steps: Nelim's Sanctuary (frame, animals kept out, own face), NPT (studio mode, frame at zoom, face kit/parts, facing, decor, apparel,
# apparel policy 4ca133c for the VAE garments, animal spawn), this mod's "takes the pick-up option" (pick-up job, never to completion in S1
# and S4). No missing step. Nothing asserts about the image: a person opens each one.
@requires:nelim.sanctuarybacklot @requires:nelim.pickletools.screenshotmode @requires:nelim.pickletools.stagedecor @requires:nelim.pickletools.screenshotstudio @requires:nelim.pickletools.colonistrace @requires:nelim.pickletools.camerazoom @requires:vanillaexpanded.vappe
@review
Feature: gallery: an afternoon on the board

  Background:
    Given the save "Nelims-tribe" is loaded
    And game speed is paused
    And Nelim's Pickle Tools: the animals except "Shogun" are kept out of the area from (190, 178) to (216, 198)
    And Nelim's Sanctuary: I am at the sanctuary "calm-zone"
    And Nelim's Pickle Tools: all filth is cleaned
    And I set the weather to "Clear"
    And Nelim's Pickle Tools: the temperature of the map is 20 degrees
    And Folding Skateboard Renew: the terrain of the cells from (196, 183) to (204, 191) is "Concrete"
    And Folding Skateboard Renew: the terrain of the cells from (196, 192) to (204, 194) is "Soil"
    And Nelim's Pickle Tools: the colonist "Nelim" follows an apparel policy that allows everything
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_BasicShirt" dyed rgb (214, 163, 58)
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_Pants" dyed rgb (45, 58, 92)
    And Nelim's Pickle Tools: "Nelim" wears "VAE_Footwear_Shoes"
    And Nelim's Pickle Tools: "Nelim" hairstyle is "Ponytails"
    And a colonist "Soren" exists
    And Nelim's Pickle Tools: the colonist "Soren" follows an apparel policy that allows everything
    And Nelim's Pickle Tools: "Soren" gender is male
    And Nelim's Pickle Tools: "Soren" body type is Male
    And Nelim's Pickle Tools: "Soren" has no traits
    And Nelim's Pickle Tools: "Soren" has the gene "Eyes_SkyBlue"
    And Nelim's Pickle Tools: "Soren" hairstyle is "ShortCut"
    And Nelim's Pickle Tools: "Soren" wears "VAE_Apparel_Hoodie" dyed rgb (46, 139, 139)
    And Nelim's Pickle Tools: "Soren" wears "VAE_Apparel_Shorts" dyed rgb (58, 58, 66)
    And Nelim's Pickle Tools: "Soren" wears "VAE_Footwear_Shoes"
    And Nelim's Pickle Tools: "Soren" wears "VAE_Headgear_BaseballCap" dyed rgb (200, 52, 48)

  Scenario: 1. three boards: Nelim sets off to take the steel one
    Given I set the hour to 14
    And Folding Skateboard Renew: a folding skateboard made of "Steel" lies on the cell (198, 187)
    And Folding Skateboard Renew: a folding skateboard made of "WoodLog" lies on the cell (200, 187)
    And Folding Skateboard Renew: a folding skateboard made of "Plasteel" lies on the cell (202, 187)
    And Nelim's Pickle Tools: I place the decor "PlantPot" holding "Plant_Daylily" fully grown at (196, 184)
    And Nelim's Pickle Tools: I place the decor "PlantPot" holding "Plant_Daylily" fully grown at (204, 184)
    And Nelim's Pickle Tools: "Soren" stands at (196, 189) facing East
    And Nelim's Pickle Tools: the animal "Shogun" stands at (203, 189) facing South
    And Nelim's Pickle Tools: "Nelim" stands at (200, 191) facing North
    When Folding Skateboard Renew: "Nelim" takes the pick-up option for the board on the cell (198, 187)
    And Nelim's Pickle Tools: I let 20 ticks pass
    And Nelim's Pickle Tools: studio presentation mode is enabled
    And Nelim's Pickle Tools: I frame the cell (200, 188) at zoom 4.5
    And Nelim's Pickle Tools: "Soren" face kit is "smile"
    And Nelim's Pickle Tools: "Soren" facial expression is "normal+blink"
    And Nelim's Pickle Tools: "Nelim" face kit is "neutral"
    And Nelim's Pickle Tools: "Nelim" brows are "BrowNormal"
    And Nelim's Pickle Tools: "Nelim" mouth is "MouthSmile"
    And Nelim's Pickle Tools: "Nelim" lids are "LidCheerful"
    And Nelim's Pickle Tools: "Nelim" facial expression is "normal+blink"
    And Nelim's Pickle Tools: time is paused for the capture
    And Nelim's Pickle Tools: I let 5 frames pass
    And Nelim's Pickle Tools: "Nelim" face state is logged
    And Nelim's Pickle Tools: the thermal state and thoughts of "Nelim" are logged
    Then I take a screenshot "gallery 1 - three boards"
    When Nelim's Pickle Tools: the decor is removed

  Scenario: 2. the board unfolds under her feet
    Given I set the hour to 14
    And Folding Skateboard Renew: a folding skateboard made of "WoodLog" lies on the cell (200, 191)
    And Nelim's Pickle Tools: I place the decor "PlantPot" holding "Plant_Daylily" fully grown at (204, 187)
    And Nelim's Pickle Tools: the animal "Shogun" stands at (202, 192) facing South
    And Nelim's Pickle Tools: "Soren" stands at (203, 188) facing West
    And Nelim's Pickle Tools: "Nelim" stands at (200, 194) facing North
    When Nelim's Pickle Tools: I let 208 ticks pass
    And Nelim's Pickle Tools: "Nelim" stands at (200, 194) facing North
    And Nelim's Pickle Tools: "Soren" stands at (203, 188) facing West
    And Folding Skateboard Renew: "Nelim" takes the pick-up option for the board on the cell (200, 191)
    And Nelim's Pickle Tools: I let 90 ticks pass
    And Nelim's Pickle Tools: "Nelim" stands at (199, 190) facing South
    And Nelim's Pickle Tools: "Soren" stands at (203, 188) facing West
    And Nelim's Pickle Tools: the animal "Shogun" stands at (200, 192) facing South
    And Nelim's Pickle Tools: I let 10 ticks pass
    Then "Nelim" has trait "Shredder"
    When Nelim's Pickle Tools: studio presentation mode is enabled
    And Nelim's Pickle Tools: I frame the cell (200, 190) at zoom 3.5
    And Nelim's Pickle Tools: "Soren" face kit is "smile"
    And Nelim's Pickle Tools: "Soren" facial expression is "normal+blink"
    And Nelim's Pickle Tools: "Nelim" face kit is "neutral"
    And Nelim's Pickle Tools: "Nelim" brows are "BrowNormal"
    And Nelim's Pickle Tools: "Nelim" mouth is "MouthSmile"
    And Nelim's Pickle Tools: "Nelim" lids are "LidCheerful"
    And Nelim's Pickle Tools: "Nelim" facial expression is "normal+blink"
    And Nelim's Pickle Tools: time is paused for the capture
    And Nelim's Pickle Tools: I let 5 frames pass
    Then I take a screenshot "gallery 2 - the board unfolds"
    When Nelim's Pickle Tools: the decor is removed

  Scenario: 3. the race: she draws level with him
    Given I set the hour to 14
    And Folding Skateboard Renew: "Nelim" carries a folding skateboard made of "Steel"
    And Nelim's Pickle Tools: I place the decor "PlantPot" holding "Plant_Daylily" fully grown at (196, 186)
    And Nelim's Pickle Tools: the animal "Shogun" stands at (199, 190) facing West
    And Nelim's Pickle Tools: "Nelim" stands at (203, 187) facing West
    And Nelim's Pickle Tools: "Soren" stands at (201, 187) facing West
    When Nelim's Pickle Tools: I let 417 ticks pass
    And Nelim's Pickle Tools: "Nelim" stands at (203, 187) facing West
    And Nelim's Pickle Tools: "Soren" stands at (201, 187) facing West
    And Nelim's Pickle Tools: "Nelim" is forced to walk to (196, 187)
    And Nelim's Pickle Tools: "Soren" is forced to walk to (196, 187)
    And Nelim's Pickle Tools: I let 45 ticks pass
    Then "Nelim" has trait "Shredder"
    And Folding Skateboard Renew: "Soren" does not have the trait "Shredder"
    When Nelim's Pickle Tools: studio presentation mode is enabled
    And Nelim's Pickle Tools: I frame the cell (199, 188) at zoom 4
    And Nelim's Pickle Tools: "Soren" face kit is "angry"
    And Nelim's Pickle Tools: "Soren" facial expression is "normal+blink"
    And Nelim's Pickle Tools: "Nelim" face kit is "neutral"
    And Nelim's Pickle Tools: "Nelim" brows are "BrowNormal"
    And Nelim's Pickle Tools: "Nelim" mouth is "MouthSmile"
    And Nelim's Pickle Tools: "Nelim" lids are "LidCheerful"
    And Nelim's Pickle Tools: "Nelim" facial expression is "normal+blink"
    And Nelim's Pickle Tools: time is paused for the capture
    And Nelim's Pickle Tools: I let 5 frames pass
    Then I take a screenshot "gallery 3 - the race"
    When Nelim's Pickle Tools: the decor is removed

  Scenario: 4. his turn: Soren sets off to take the wood board
    Given I set the hour to 14
    And Folding Skateboard Renew: a folding skateboard made of "WoodLog" lies on the cell (199, 187)
    And Folding Skateboard Renew: "Nelim" carries a folding skateboard made of "Steel"
    And Nelim's Pickle Tools: I place the decor "PlantPot" holding "Plant_Daylily" fully grown at (204, 185)
    And Nelim's Pickle Tools: the animal "Shogun" stands at (199, 189) facing South
    And Nelim's Pickle Tools: "Nelim" stands at (201, 189) facing West
    And Nelim's Pickle Tools: "Soren" stands at (202, 187) facing West
    When Nelim's Pickle Tools: I let 625 ticks pass
    And Nelim's Pickle Tools: "Nelim" stands at (201, 189) facing West
    And Nelim's Pickle Tools: "Soren" stands at (202, 187) facing West
    And Folding Skateboard Renew: "Soren" takes the pick-up option for the board on the cell (199, 187)
    And Nelim's Pickle Tools: I let 25 ticks pass
    And Nelim's Pickle Tools: studio presentation mode is enabled
    And Nelim's Pickle Tools: I frame the cell (199, 187) at zoom 3.2
    And Nelim's Pickle Tools: "Soren" face kit is "smug"
    And Nelim's Pickle Tools: "Soren" facial expression is "normal+blink"
    And Nelim's Pickle Tools: "Nelim" face kit is "neutral"
    And Nelim's Pickle Tools: "Nelim" brows are "BrowNormal"
    And Nelim's Pickle Tools: "Nelim" mouth is "MouthSmile"
    And Nelim's Pickle Tools: "Nelim" lids are "LidCheerful"
    And Nelim's Pickle Tools: "Nelim" facial expression is "normal+blink"
    And Nelim's Pickle Tools: time is paused for the capture
    And Nelim's Pickle Tools: I let 5 frames pass
    Then I take a screenshot "gallery 4 - his turn"
    When Nelim's Pickle Tools: the decor is removed

  Scenario: 5. soft ground: the board folds onto her back
    Given I set the hour to 17
    And Folding Skateboard Renew: a folding skateboard made of "WoodLog" lies on the cell (200, 193)
    And Folding Skateboard Renew: "Soren" carries a folding skateboard made of "WoodLog"
    And Nelim's Pickle Tools: I place the decor "TorchLamp" at (198, 190)
    And Nelim's Pickle Tools: I place the decor "TorchLamp" at (202, 190)
    And Nelim's Pickle Tools: the decor "TorchLamp" at (198, 190) is lit
    And Nelim's Pickle Tools: the decor "TorchLamp" at (202, 190) is lit
    And Nelim's Pickle Tools: the animal "Shogun" stands at (199, 194) facing South
    And Nelim's Pickle Tools: "Soren" stands at (204, 188) facing West
    And Nelim's Pickle Tools: "Nelim" stands at (200, 191) facing South
    When Nelim's Pickle Tools: I let 60 ticks pass
    And Nelim's Pickle Tools: "Soren" stands at (204, 188) facing West
    And Nelim's Pickle Tools: "Nelim" stands at (200, 191) facing South
    And Folding Skateboard Renew: "Nelim" takes the pick-up option for the board on the cell (200, 193)
    And Nelim's Pickle Tools: I let 60 ticks pass
    And Nelim's Pickle Tools: "Nelim" stands at (200, 193) facing South
    And Nelim's Pickle Tools: "Soren" stands at (204, 189) facing West
    And Nelim's Pickle Tools: the animal "Shogun" stands at (199, 194) facing South
    And Nelim's Pickle Tools: I let 10 ticks pass
    Then Folding Skateboard Renew: "Nelim" does not have the trait "Shredder"
    And "Soren" has trait "Shredder"
    When Nelim's Pickle Tools: studio presentation mode is enabled
    And Nelim's Pickle Tools: I frame the cell (201, 191) at zoom 3.5
    And Nelim's Pickle Tools: "Soren" face kit is "smile"
    And Nelim's Pickle Tools: "Soren" facial expression is "normal+blink"
    And Nelim's Pickle Tools: "Nelim" face kit is "neutral"
    And Nelim's Pickle Tools: "Nelim" brows are "BrowNormal"
    And Nelim's Pickle Tools: "Nelim" mouth is "MouthSmile"
    And Nelim's Pickle Tools: "Nelim" lids are "LidCheerful"
    And Nelim's Pickle Tools: "Nelim" facial expression is "normal+blink"
    And Nelim's Pickle Tools: time is paused for the capture
    And Nelim's Pickle Tools: I let 5 frames pass
    Then I take a screenshot "gallery 5 - soft ground"
    When Nelim's Pickle Tools: the decor is removed
