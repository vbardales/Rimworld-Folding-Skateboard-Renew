Feature: Folding Skateboard Renew loads clean and patches the game once

  # TESTING.md scenario 1. Nothing here needs a colony, so both scenarios run at the main menu, in seconds.
  # A patch that throws at startup kills the game before a runner exists: reaching this scenario at all is
  # already half of the proof. What is asserted is the other half.

  @requires:nelim.pickletools.loadaudit
  Scenario: the load of the mod leaves no error, warning or unresolved reference of its own
    Then Nelim's Pickle Tools: the load of the mod "nelim.foldingskateboard" is clean

  # The 1.5 mod ran PatchAll from two places under two ids, so every patch took twice and the board was drawn
  # twice per frame. Harmony's own registry says how many patches the mod's id owns on each target.
  Scenario: the board is defined and each of the mod's three patches is applied exactly once
    Then def "Paddleboard" exists
    And Folding Skateboard Renew: each of the mod's three patches is applied exactly once
