@requires:limetreesnake.furnishing
Feature: A rider on a floor of [LTS]Furnishing gains Shredder and its speed

  # AUDIT.md 8.f, the pass avec-lts of TESTING.md. The mod lists 141 floor names of LimeTreeSnake's [LTS]Furnishing
  # (Workshop 2567438519, packageId LimeTreeSnake.Furnishing). Read offline on 2026-10-31 against that mod's v1.6
  # TerrainDefs: all 141 names are defined there, none is missing, and the mod defines exactly 141 terrain defs.
  # What a running game still has to show is that the names resolve at load and that a pawn rides on them: four
  # floors of four families, the same expectations as feature 03 (the trait, and +2 on the move speed).
  # This feature is skipped on every map that does not mount the mod, which is what @requires does.

  Background:
    Given the save "test-colony" is loaded
    And a colonist "Ada" exists
    And Folding Skateboard Renew: a clear yard is prepared
    And Folding Skateboard Renew: the speed trait of "Ada" is set to degree 0
    And Folding Skateboard Renew: "Ada" is placed at (0, 0) of the yard
    And I draft "Ada"

  Scenario Outline: a rider on the LTS floor <terrain> gains Shredder and +2 speed
    Given Folding Skateboard Renew: the terrain at (3, 3) of the yard is "<terrain>"
    And Folding Skateboard Renew: I note the move speed of "Ada"
    And Folding Skateboard Renew: "Ada" carries a folding skateboard made of "Steel"
    And Folding Skateboard Renew: "Ada" is placed at (3, 3) of the yard
    When I wait 90 ticks
    Then "Ada" has trait "Shredder"
    And Folding Skateboard Renew: the move speed of "Ada" has changed by 2.0

    Examples: four floors of four families of the mod's list
      | terrain         |
      | LTS_PlankFloor  |
      | LTS_Herringbone |
      | LTS_ChevronParquet |
      | LTS_GravelGranite |
