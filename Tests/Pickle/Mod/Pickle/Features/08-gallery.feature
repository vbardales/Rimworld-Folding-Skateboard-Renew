# Workshop gallery of Folding Skateboard Renew: one story, in one place, staged (PUBLISHING.md: every gallery capture is a
# staged photo). The plan is also in PUBLICATION.md, "Gallery plan", with the subtitle of each image.
#
# The story, "an afternoon on the board": on the cream square of Nelim's tribe (the calm zone: no roof, no torch, no wall
# shadow) a patch of concrete is laid for the story, because the board only unfolds on a built hard floor. Nelim and her
# labrador Shogun are the same two figures in every picture, the same corner, centre (200, 187). Clear weather, 20 degrees so
# that no face shows sweat, 14:00 and then five game minutes between images.
#   1. 14:00  Three boards lie on the concrete: steel, wood, plasteel. Nelim stands behind them with a small smile, Shogun awake
#             and turned to the camera (South). The image says the board is the colour of what it is made from.
#   2. 14:05  Nelim on the concrete facing South, a board in her pack, drawn under her feet. A wide smile. Shogun at her side,
#             facing South. The image says: step on hard ground and the board unfolds.
#   3. 14:10  The same corner, Nelim facing West, side on, the board drawn side on. Shogun in the background. The image says she
#             is faster on it (Shredder, +2 speed, asserted by 04, here only the trait is asserted before the photo).
#   4. 14:20  One step off the concrete onto soil, Nelim facing North, seen from behind, the board strapped to her back. Shogun
#             faces South toward the camera. The image says that off hard ground the board folds onto her back.
# Nelim wears an ochre shirt (214, 163, 58) and dark blue trousers (45, 58, 92), warm against the grey and silver boards; her
# hair is the Ponytails style. Her face follows the story: the fixture's own face in 1, a smile with cheerful lids in 2 and 3. The face
# is set last, after every wait, because Facial Animation recomputes it at every tick (SanctuaryBacklot, run 56b0).
# The only animal is a dog, awake at the hour used, shown facing the camera in 1, 2 and 4.
# Nothing asserts about the image: a person opens each one. What is asserted before a capture (the trait on or off) is only so
# that the image is worth opening.
@requires:nelim.sanctuarybacklot @requires:nelim.pickletools.screenshotstudio @requires:nelim.pickletools.colonistrace @requires:nelim.pickletools.camerazoom
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
    And Nelim's Pickle Tools: "Nelim" hairstyle is "Ponytails"

  Scenario: 1. three boards lie on the stone, each the colour of what it is made from
    Given Folding Skateboard Renew: a folding skateboard made of "Steel" lies on the cell (198, 187)
    And Folding Skateboard Renew: a folding skateboard made of "WoodLog" lies on the cell (200, 187)
    And Folding Skateboard Renew: a folding skateboard made of "Plasteel" lies on the cell (202, 187)
    And Nelim's Pickle Tools: "Nelim" stands at (200, 189) facing South
    And Nelim's Pickle Tools: an adult animal of kind "LabradorRetriever" named "Shogun" is spawned at (203, 189)
    And Nelim's Pickle Tools: the animal "Shogun" stands at (203, 189) facing South
    When Nelim's Pickle Tools: I let 60 ticks pass
    And Nelim's Pickle Tools: all filth is cleaned
    And Nelim's Pickle Tools: studio presentation mode is enabled
    And Nelim's Pickle Tools: I frame the cell (200, 188) at zoom 5.5
    And Nelim's Pickle Tools: "Nelim" stands at (200, 189) facing South
    And Nelim's Sanctuary: Nelim has her own face
    And Nelim's Pickle Tools: I let 5 frames pass
    And Nelim's Pickle Tools: "Nelim" face state is logged
    And Nelim's Pickle Tools: the thermal state and thoughts of "Nelim" are logged
    Then I take a screenshot "gallery 1 - three boards on the stone"

  Scenario: 2. on hard ground the board unfolds under her feet
    Given Folding Skateboard Renew: "Nelim" carries a folding skateboard made of "Steel"
    And Nelim's Pickle Tools: "Nelim" stands at (200, 187) facing South
    And Nelim's Pickle Tools: an adult animal of kind "LabradorRetriever" named "Shogun" is spawned at (203, 187)
    And Nelim's Pickle Tools: the animal "Shogun" stands at (203, 187) facing South
    When Nelim's Pickle Tools: I let 208 ticks pass
    And Nelim's Pickle Tools: "Nelim" stands at (200, 187) facing South
    And I wait 60 ticks
    Then "Nelim" has trait "Shredder"
    When Nelim's Pickle Tools: all filth is cleaned
    And Nelim's Pickle Tools: studio presentation mode is enabled
    And Nelim's Pickle Tools: I frame the cell (200, 187) at zoom 4
    And Folding Skateboard Renew: "Nelim" faces south
    And Nelim's Pickle Tools: "Nelim" face kit is "neutral"
    And Nelim's Pickle Tools: "Nelim" brows are "BrowNormal"
    And Nelim's Pickle Tools: "Nelim" mouth is "MouthSmile"
    And Nelim's Pickle Tools: "Nelim" lids are "LidCheerful"
    And Nelim's Pickle Tools: "Nelim" facial expression is "normal+blink"
    And Nelim's Pickle Tools: I let 5 frames pass
    And Nelim's Pickle Tools: "Nelim" face state is logged
    And Nelim's Pickle Tools: the thermal state and thoughts of "Nelim" are logged
    Then Folding Skateboard Renew: "Nelim" is facing south
    And I take a screenshot "gallery 2 - the board unfolds under her feet"

  Scenario: 3. side on, she is faster on the board
    Given Folding Skateboard Renew: "Nelim" carries a folding skateboard made of "Steel"
    And Nelim's Pickle Tools: "Nelim" stands at (200, 187) facing West
    And Nelim's Pickle Tools: an adult animal of kind "LabradorRetriever" named "Shogun" is spawned at (203, 190)
    And Nelim's Pickle Tools: the animal "Shogun" stands at (203, 190) facing South
    When Nelim's Pickle Tools: I let 417 ticks pass
    And Nelim's Pickle Tools: "Nelim" stands at (200, 187) facing West
    And I wait 60 ticks
    Then "Nelim" has trait "Shredder"
    When Nelim's Pickle Tools: all filth is cleaned
    And Nelim's Pickle Tools: studio presentation mode is enabled
    And Nelim's Pickle Tools: I frame the cell (200, 187) at zoom 4
    And Folding Skateboard Renew: "Nelim" faces west
    And Nelim's Pickle Tools: "Nelim" face kit is "neutral"
    And Nelim's Pickle Tools: "Nelim" brows are "BrowNormal"
    And Nelim's Pickle Tools: "Nelim" mouth is "MouthSmile"
    And Nelim's Pickle Tools: "Nelim" lids are "LidCheerful"
    And Nelim's Pickle Tools: "Nelim" facial expression is "normal+blink"
    And Nelim's Pickle Tools: I let 5 frames pass
    And Nelim's Pickle Tools: "Nelim" face state is logged
    And Nelim's Pickle Tools: the thermal state and thoughts of "Nelim" are logged
    Then Folding Skateboard Renew: "Nelim" is facing west
    And I take a screenshot "gallery 3 - side on, faster on the board"

  Scenario: 4. one step onto the grass, the board folds onto her back
    Given Folding Skateboard Renew: "Nelim" carries a folding skateboard made of "Steel"
    And Nelim's Pickle Tools: "Nelim" stands at (200, 193) facing North
    And Nelim's Pickle Tools: an adult animal of kind "LabradorRetriever" named "Shogun" is spawned at (203, 190)
    And Nelim's Pickle Tools: the animal "Shogun" stands at (203, 190) facing South
    When Nelim's Pickle Tools: I let 833 ticks pass
    And Nelim's Pickle Tools: "Nelim" stands at (200, 193) facing North
    And I wait 60 ticks
    Then Folding Skateboard Renew: "Nelim" does not have the trait "Shredder"
    When Nelim's Pickle Tools: all filth is cleaned
    And Nelim's Pickle Tools: studio presentation mode is enabled
    And Nelim's Pickle Tools: I frame the cell (200, 192) at zoom 4
    And Folding Skateboard Renew: "Nelim" faces north
    And Nelim's Pickle Tools: I let 5 frames pass
    Then Folding Skateboard Renew: "Nelim" is facing north
    And I take a screenshot "gallery 4 - the board folds onto her back"
