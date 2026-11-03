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
#     start (203,187)) and Soren on foot (start (201,187)) both sent West to the finish pot (196,187) with a goto job; game paused when she
#     draws level with him (tick N tuned, estimate 45); Nelim smiling, Soren set face "angry" (effort, planned), Shogun at (199,189)
#     facing W. Needs a NEW step: "<name>" walks to (x, z) (asked of NPT 2026-11-03). All on concrete (x 196-204): board stays unfolded.
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
# and S4). The one missing step: "walks to (x, z)" (S3). Nothing asserts about the image: a person opens each one.
@requires:nelim.sanctuarybacklot @requires:nelim.pickletools.screenshotstudio @requires:nelim.pickletools.colonistrace @requires:nelim.pickletools.camerazoom @requires:vanillaexpanded.vappe
@review
Feature: gallery: an afternoon on the board

  Background:
    Given the save "Nelims-tribe" is loaded
    And game speed is paused
    And Nelim's Sanctuary: the animals are removed from the sanctuary "calm-zone"
    And Nelim's Sanctuary: I am at the sanctuary "calm-zone"
    And Nelim's Pickle Tools: all filth is cleaned
    And I set the hour to 14
    And I set the weather to "Clear"
    And Nelim's Pickle Tools: the temperature of the map is 20 degrees
    And Folding Skateboard Renew: the terrain of the cells from (196, 183) to (204, 191) is "Concrete"
    And Folding Skateboard Renew: the terrain of the cells from (196, 192) to (204, 194) is "Soil"
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_BasicShirt" dyed rgb (214, 163, 58)
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_Pants" dyed rgb (45, 58, 92)
    And Nelim's Pickle Tools: "Nelim" wears "VAE_Footwear_Shoes"
    And Nelim's Pickle Tools: "Nelim" hairstyle is "Ponytails"
    And a colonist "Kenji" exists
    And Nelim's Pickle Tools: "Kenji" gender is male
    And Nelim's Pickle Tools: "Kenji" body type is Male
    And Nelim's Pickle Tools: "Kenji" has no traits
    And Nelim's Pickle Tools: "Kenji" has the gene "Eyes_Blue"
    And Nelim's Pickle Tools: "Kenji" hairstyle is "ShortCut"
    And Nelim's Pickle Tools: "Kenji" wears "VAE_Apparel_Hoodie" dyed rgb (46, 139, 139)
    And Nelim's Pickle Tools: "Kenji" wears "VAE_Apparel_Shorts" dyed rgb (58, 58, 66)
    And Nelim's Pickle Tools: "Kenji" wears "VAE_Footwear_Shoes"
    And Nelim's Pickle Tools: "Kenji" wears "VAE_Headgear_BaseballCap" dyed rgb (200, 52, 48)

  Scenario: 1. three boards lie on the stone, each the colour of what it is made from
    Given Folding Skateboard Renew: a folding skateboard made of "Steel" lies on the cell (198, 187)
    And Folding Skateboard Renew: a folding skateboard made of "WoodLog" lies on the cell (200, 187)
    And Folding Skateboard Renew: a folding skateboard made of "Plasteel" lies on the cell (202, 187)
    And Nelim's Pickle Tools: "Nelim" stands at (200, 189) facing South
    And Nelim's Pickle Tools: "Kenji" stands at (197, 189) facing South
    And Nelim's Pickle Tools: an adult animal of kind "LabradorRetriever" named "Shogun" is spawned at (203, 189)
    And Nelim's Pickle Tools: the animal "Shogun" stands at (203, 189) facing South
    When Nelim's Pickle Tools: I let 60 ticks pass
    And Nelim's Pickle Tools: all filth is cleaned
    And Nelim's Pickle Tools: studio presentation mode is enabled
    And Nelim's Pickle Tools: I frame the cell (200, 188) at zoom 5.5
    And Nelim's Pickle Tools: "Nelim" stands at (200, 189) facing South
    And Nelim's Pickle Tools: "Kenji" stands at (197, 189) facing South
    And Nelim's Sanctuary: Nelim has her own face
    And Nelim's Pickle Tools: "Kenji" face kit is "calm"
    And Nelim's Pickle Tools: "Kenji" facial expression is "normal+blink"
    And Nelim's Pickle Tools: I let 5 frames pass
    And Nelim's Pickle Tools: "Nelim" face state is logged
    And Nelim's Pickle Tools: "Kenji" face state is logged
    And Nelim's Pickle Tools: the thermal state and thoughts of "Nelim" are logged
    Then I take a screenshot "gallery 1 - three boards on the stone"

  Scenario: 2. on hard ground the board unfolds under her feet
    Given Folding Skateboard Renew: "Nelim" carries a folding skateboard made of "Steel"
    And Nelim's Pickle Tools: "Nelim" stands at (201, 187) facing South
    And Nelim's Pickle Tools: "Kenji" stands at (198, 187) facing East
    And Nelim's Pickle Tools: an adult animal of kind "LabradorRetriever" named "Shogun" is spawned at (203, 189)
    And Nelim's Pickle Tools: the animal "Shogun" stands at (203, 189) facing South
    When Nelim's Pickle Tools: I let 208 ticks pass
    And Nelim's Pickle Tools: "Nelim" stands at (201, 187) facing South
    And Nelim's Pickle Tools: "Kenji" stands at (198, 187) facing East
    And I wait 60 ticks
    Then "Nelim" has trait "Shredder"
    When Nelim's Pickle Tools: all filth is cleaned
    And Nelim's Pickle Tools: studio presentation mode is enabled
    And Nelim's Pickle Tools: I frame the cell (200, 187) at zoom 4
    And Nelim's Pickle Tools: "Nelim" face kit is "neutral"
    And Nelim's Pickle Tools: "Nelim" brows are "BrowNormal"
    And Nelim's Pickle Tools: "Nelim" mouth is "MouthSmile"
    And Nelim's Pickle Tools: "Nelim" lids are "LidCheerful"
    And Nelim's Pickle Tools: "Nelim" facial expression is "normal+blink"
    And Nelim's Pickle Tools: "Kenji" face kit is "smile"
    And Nelim's Pickle Tools: "Kenji" facial expression is "normal+blink"
    And Folding Skateboard Renew: "Nelim" faces south
    And Folding Skateboard Renew: "Kenji" faces east
    And Nelim's Pickle Tools: I let 5 frames pass
    And Nelim's Pickle Tools: "Nelim" face state is logged
    And Nelim's Pickle Tools: "Kenji" face state is logged
    And Nelim's Pickle Tools: the thermal state and thoughts of "Nelim" are logged
    Then Folding Skateboard Renew: "Nelim" is facing south
    And Folding Skateboard Renew: "Kenji" is facing east
    And I take a screenshot "gallery 2 - the board unfolds under her feet"

  Scenario: 3. side on, the race: she is faster on the board
    Given Folding Skateboard Renew: "Nelim" carries a folding skateboard made of "Steel"
    And Nelim's Pickle Tools: "Nelim" stands at (198, 187) facing West
    And Nelim's Pickle Tools: "Kenji" stands at (203, 187) facing West
    And Nelim's Pickle Tools: an adult animal of kind "LabradorRetriever" named "Shogun" is spawned at (200, 189)
    And Nelim's Pickle Tools: the animal "Shogun" stands at (200, 189) facing West
    When Nelim's Pickle Tools: I let 417 ticks pass
    And Nelim's Pickle Tools: "Nelim" stands at (198, 187) facing West
    And Nelim's Pickle Tools: "Kenji" stands at (203, 187) facing West
    And I wait 60 ticks
    Then "Nelim" has trait "Shredder"
    And Folding Skateboard Renew: "Kenji" does not have the trait "Shredder"
    When Nelim's Pickle Tools: all filth is cleaned
    And Nelim's Pickle Tools: studio presentation mode is enabled
    And Nelim's Pickle Tools: I frame the cell (200, 187) at zoom 4
    And Nelim's Pickle Tools: "Nelim" face kit is "neutral"
    And Nelim's Pickle Tools: "Nelim" brows are "BrowNormal"
    And Nelim's Pickle Tools: "Nelim" mouth is "MouthSmile"
    And Nelim's Pickle Tools: "Nelim" lids are "LidCheerful"
    And Nelim's Pickle Tools: "Nelim" facial expression is "normal+blink"
    And Nelim's Pickle Tools: "Kenji" face kit is "angry"
    And Nelim's Pickle Tools: "Kenji" facial expression is "normal+blink"
    And Folding Skateboard Renew: "Nelim" faces west
    And Folding Skateboard Renew: "Kenji" faces west
    And Nelim's Pickle Tools: I let 5 frames pass
    And Nelim's Pickle Tools: "Nelim" face state is logged
    And Nelim's Pickle Tools: "Kenji" face state is logged
    And Nelim's Pickle Tools: the thermal state and thoughts of "Nelim" are logged
    Then Folding Skateboard Renew: "Nelim" is facing west
    And Folding Skateboard Renew: "Kenji" is facing west
    And I take a screenshot "gallery 3 - side on, the race"

  Scenario: 4. one step onto the grass, the board folds onto her back
    Given Folding Skateboard Renew: "Nelim" carries a folding skateboard made of "Steel"
    And Folding Skateboard Renew: "Kenji" carries a folding skateboard made of "WoodLog"
    And Nelim's Pickle Tools: "Nelim" stands at (200, 193) facing North
    And Nelim's Pickle Tools: "Kenji" stands at (198, 189) facing East
    And Nelim's Pickle Tools: an adult animal of kind "LabradorRetriever" named "Shogun" is spawned at (203, 190)
    And Nelim's Pickle Tools: the animal "Shogun" stands at (203, 190) facing South
    When Nelim's Pickle Tools: I let 833 ticks pass
    And Nelim's Pickle Tools: "Nelim" stands at (200, 193) facing North
    And Nelim's Pickle Tools: "Kenji" stands at (198, 189) facing East
    And I wait 60 ticks
    Then Folding Skateboard Renew: "Nelim" does not have the trait "Shredder"
    And "Kenji" has trait "Shredder"
    When Nelim's Pickle Tools: all filth is cleaned
    And Nelim's Pickle Tools: studio presentation mode is enabled
    And Nelim's Pickle Tools: I frame the cell (200, 191) at zoom 4
    And Nelim's Pickle Tools: "Kenji" face kit is "smug"
    And Nelim's Pickle Tools: "Kenji" facial expression is "normal+blink"
    And Folding Skateboard Renew: "Nelim" faces north
    And Folding Skateboard Renew: "Kenji" faces east
    And Nelim's Pickle Tools: I let 5 frames pass
    Then Folding Skateboard Renew: "Nelim" is facing north
    And Folding Skateboard Renew: "Kenji" is facing east
    And I take a screenshot "gallery 4 - the board folds onto her back"
