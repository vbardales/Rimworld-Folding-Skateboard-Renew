Feature: The vanilla speed trait is put away while riding and given back

  # TESTING.md scenarios 11, 13 and 14. While Shredder is on, a fast walker or a slowpoke is taken off and parked
  # in the mod's own game component, so that the two bonuses do not stack, and handed back when the board folds.
  # The component is saved with the game, so a real save and reload in the middle of a ride is the scenario that
  # proves it comes back from the file. A rider who leaves the map has no Tick to fold the board: the mod answers
  # for its DeSpawn hook, and that is what "leaves the map" exercises. Forming a real caravan is the game's own
  # mechanism and is not played.

  Background:
    Given the save "test-colony" is loaded
    And a colonist "Ada" exists
    And Folding Skateboard Renew: a clear yard is prepared
    And Folding Skateboard Renew: the terrain at (3, 3) of the yard is "Concrete"
    And Folding Skateboard Renew: "Ada" carries a folding skateboard made of "Steel"
    And Folding Skateboard Renew: "Ada" is placed at (0, 0) of the yard
    And I draft "Ada"

  Scenario Outline: a speed trait of degree <degree> is set aside while riding and comes back on the ground
    Given Folding Skateboard Renew: the speed trait of "Ada" is set to degree <degree>
    When Folding Skateboard Renew: "Ada" is placed at (3, 3) of the yard
    And I wait 90 ticks
    Then "Ada" has trait "Shredder"
    And Folding Skateboard Renew: "Ada" does not have the trait "SpeedOffset"
    When Folding Skateboard Renew: "Ada" is placed at (0, 0) of the yard
    And I wait 90 ticks
    Then Folding Skateboard Renew: "Ada" does not have the trait "Shredder"
    And Folding Skateboard Renew: "Ada" has the trait "SpeedOffset" at degree <degree>

    Examples: a fast walker and a slowpoke, the two ends of the vanilla spectrum
      | degree |
      | 1      |
      | -1     |

  Scenario: a rider who leaves the map is given her speed trait back and loses Shredder
    Given Folding Skateboard Renew: the speed trait of "Ada" is set to degree 1
    When Folding Skateboard Renew: "Ada" is placed at (3, 3) of the yard
    And I wait 90 ticks
    Then "Ada" has trait "Shredder"
    When Folding Skateboard Renew: "Ada" leaves the map
    Then Folding Skateboard Renew: "Ada" does not have the trait "Shredder"
    And Folding Skateboard Renew: "Ada" has the trait "SpeedOffset" at degree 1
    When Folding Skateboard Renew: "Ada" returns at (0, 0) of the yard
    And I wait 90 ticks
    Then "Ada" is carrying 1 "Paddleboard"
    And Folding Skateboard Renew: "Ada" does not have the trait "Shredder"

  Scenario: a save and a reload in the middle of a ride keep the parked trait
    Given Folding Skateboard Renew: the speed trait of "Ada" is set to degree 1
    When Folding Skateboard Renew: "Ada" is placed at (3, 3) of the yard
    And I wait 90 ticks
    Then "Ada" has trait "Shredder"
    When I save and reload
    Then "Ada" has trait "Shredder"
    And Folding Skateboard Renew: "Ada" does not have the trait "SpeedOffset"
    When Folding Skateboard Renew: "Ada" is placed at (0, 0) of the yard
    And I wait 90 ticks
    Then Folding Skateboard Renew: "Ada" does not have the trait "Shredder"
    And Folding Skateboard Renew: "Ada" has the trait "SpeedOffset" at degree 1
