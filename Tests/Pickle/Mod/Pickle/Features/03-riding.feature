Feature: A rider on hard ground outdoors gains Shredder and its speed

  # TESTING.md scenarios 7 to 10. The surface check runs every 15 ticks, so 90 ticks is six chances. The colonist
  # is drafted so that she stands where she is put instead of walking off to a job. The speed is the stat the
  # game computes, noted before the board is under her and compared after: the trait's offset is +2.0.

  Background:
    Given the save "test-colony" is loaded
    And a colonist "Ada" exists
    And Folding Skateboard Renew: a clear yard is prepared
    And Folding Skateboard Renew: the speed trait of "Ada" is set to degree 0
    And Folding Skateboard Renew: "Ada" is placed at (0, 0) of the yard
    And I draft "Ada"

  Scenario Outline: a rider on <terrain> gains Shredder and +2 speed
    Given Folding Skateboard Renew: the terrain at (3, 3) of the yard is "<terrain>"
    And Folding Skateboard Renew: I note the move speed of "Ada"
    And Folding Skateboard Renew: "Ada" carries a folding skateboard made of "Steel"
    And Folding Skateboard Renew: "Ada" is placed at (3, 3) of the yard
    When I wait 90 ticks
    Then "Ada" has trait "Shredder"
    And Folding Skateboard Renew: the move speed of "Ada" has changed by 2.0

    Examples: constructed floors, mined rock and bridges
      | terrain         |
      | Concrete        |
      | WoodPlankFloor  |
      | Sandstone_Rough |
      | Bridge          |

  Scenario Outline: a rider on <terrain> does not
    Given Folding Skateboard Renew: the terrain at (3, 3) of the yard is "<terrain>"
    And Folding Skateboard Renew: I note the move speed of "Ada"
    And Folding Skateboard Renew: "Ada" carries a folding skateboard made of "Steel"
    And Folding Skateboard Renew: "Ada" is placed at (3, 3) of the yard
    When I wait 90 ticks
    Then Folding Skateboard Renew: "Ada" does not have the trait "Shredder"
    And Folding Skateboard Renew: the move speed of "Ada" has changed by 0.0

    Examples: ground that is not on the list, smooth stone among it
      | terrain          |
      | Soil             |
      | Sand             |
      | Sandstone_Smooth |

  Scenario: a roof over hard ground counts as indoors
    Given Folding Skateboard Renew: the terrain at (3, 3) of the yard is "Concrete"
    And Folding Skateboard Renew: the roof over (3, 3) of the yard is built
    And Folding Skateboard Renew: "Ada" carries a folding skateboard made of "Steel"
    And Folding Skateboard Renew: "Ada" is placed at (3, 3) of the yard
    When I wait 90 ticks
    Then Folding Skateboard Renew: "Ada" does not have the trait "Shredder"

  Scenario: the board folds when the rider steps off the hard ground, and unfolds when she steps back on
    Given Folding Skateboard Renew: the terrain at (3, 3) of the yard is "Concrete"
    And Folding Skateboard Renew: I note the move speed of "Ada"
    And Folding Skateboard Renew: "Ada" carries a folding skateboard made of "Steel"
    And Folding Skateboard Renew: "Ada" is placed at (3, 3) of the yard
    When I wait 90 ticks
    Then "Ada" has trait "Shredder"
    When Folding Skateboard Renew: "Ada" is placed at (0, 0) of the yard
    And I wait 90 ticks
    Then Folding Skateboard Renew: "Ada" does not have the trait "Shredder"
    And Folding Skateboard Renew: the move speed of "Ada" has changed by 0.0
    When Folding Skateboard Renew: "Ada" is placed at (3, 3) of the yard
    And I wait 90 ticks
    Then "Ada" has trait "Shredder"

  Scenario: a colonist with no board never gains Shredder, on any floor
    Given Folding Skateboard Renew: the terrain at (3, 3) of the yard is "Concrete"
    And Folding Skateboard Renew: "Ada" is placed at (3, 3) of the yard
    When I wait 90 ticks
    Then Folding Skateboard Renew: "Ada" does not have the trait "Shredder"
