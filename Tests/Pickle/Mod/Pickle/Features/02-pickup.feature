Feature: The pick-up entry of the right-click menu

  # TESTING.md scenarios 4 and 5. The menu is the one the game builds for a click, through every provider it
  # discovered, so the mod's provider is exercised as a player would meet it. What the game does with the four
  # flags the provider declares (undrafted only, one pawn, manipulation required) is not tested here: the
  # declaration is asserted offline, and the game's honouring of it is the game's.
  #
  # The refusals are asserted by the translation of the mod's own keys, so the same scenarios pass in English
  # and in French: the wording is whatever the pass's language file says, and a raw key or an English sentence
  # in a French pass fails the comparison.

  Background:
    Given the save "test-colony" is loaded
    And a colonist "Ada" exists
    And Folding Skateboard Renew: a clear yard is prepared
    And Folding Skateboard Renew: "Ada" is placed at (0, 0) of the yard

  Scenario: a colonist picks a board up and it goes into their inventory, not their hands
    Given Folding Skateboard Renew: a folding skateboard made of "WoodLog" lies at (3, 3) of the yard
    Then Folding Skateboard Renew: the menu for "Ada" on the board at (3, 3) of the yard offers to pick it up
    When Folding Skateboard Renew: "Ada" takes the pick-up option for the board at (3, 3) of the yard
    And I wait 600 ticks
    Then "Ada" is carrying 1 "Paddleboard"
    And "Ada" is wielding nothing

  Scenario: a colonist who already carries a board is refused, in words
    Given Folding Skateboard Renew: a folding skateboard made of "WoodLog" lies at (3, 3) of the yard
    And Folding Skateboard Renew: "Ada" carries a folding skateboard made of "Steel"
    Then Folding Skateboard Renew: the menu for "Ada" on the board at (3, 3) of the yard refuses with carrying

  Scenario: a forbidden board is refused, in words
    Given Folding Skateboard Renew: a folding skateboard made of "WoodLog" lies at (3, 3) of the yard
    And Folding Skateboard Renew: the folding skateboard at (3, 3) of the yard is forbidden
    Then Folding Skateboard Renew: the menu for "Ada" on the board at (3, 3) of the yard refuses with forbidden

  Scenario: a board no one can walk to is refused, in words
    Given Folding Skateboard Renew: a folding skateboard made of "WoodLog" lies at (3, 3) of the yard
    And Folding Skateboard Renew: the cell (3, 3) of the yard is walled off
    And I wait 30 ticks
    Then Folding Skateboard Renew: the menu for "Ada" on the board at (3, 3) of the yard refuses with unreachable
