@requires:silkcircuit.foldableskateboardmod
Feature: SilkCircuit's original mod beside this one

  # The About.xml declares the original incompatible, and a declaration ages: the other mod may have been fixed,
  # rewritten or removed. This pass mounts it beside the mod (wsl-deps.incompat-original.map) to go and look. Green
  # means "still behaves as declared", so the documented symptom is ASSERTED, not expected as a red: both mods
  # define a ThingDef named Paddleboard, and the game logs the collision while it loads, before any scenario, which
  # is why the log is read from its queue and the scenario is @allow-errors.
  #
  # Which of the two survives the collision is NOT asserted: it is not documented and has not been seen.

  @allow-errors
  Scenario: the two mods still collide on the board's defName
    Then mod "silkcircuit.foldableskateboardmod" is loaded
    And mod "nelim.foldingskateboard" is loaded
    And Folding Skateboard Renew: the game log holds an error matching "Paddleboard"
