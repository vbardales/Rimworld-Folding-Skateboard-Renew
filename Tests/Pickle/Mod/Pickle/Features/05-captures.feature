@review
Feature: What a person has to look at: the board drawn

  # TESTING.md scenarios 3, 7, 8 and 12. Nothing here asserts a picture: a green screenshot step says a file was
  # written, not that the board is under the rider, that its colour follows its stuff or that it is folded on a
  # back. Each scenario asserts the STATE first (the trait is on, or off), takes the capture, and a person opens it.
  # The camera is as close as the game allows: a board is one cell, and at the default zoom it is a few pixels.
  # A drafted, idle colonist tracks the mouse cursor to aim (RimWorlds own idle-facing behaviour), which
  # overrode the facing set here and made west and north captures show Ada facing the camera instead (first run,
  # 2026-09-28). Undrafting after the Shredder assertion and before the photo removes drafted aim: the trait
  # check runs off the Tick patch, not the drafted state, so undrafting here changes nothing the scenario is
  # testing. Undrafting alone was not enough (second run, 2026-09-28): south then failed the same way, because the
  # camera-look-at and zoom steps still ran between the re-face and the photo, and real time passes ticks during
  # them in which idle facing can still drift. The facing step now runs last, right before the screenshot.

  Background:
    Given the save "test-colony" is loaded
    And a colonist "Ada" exists
    And Folding Skateboard Renew: a clear yard is prepared
    And Folding Skateboard Renew: the speed trait of "Ada" is set to degree 0
    And Folding Skateboard Renew: the terrain at (3, 3) of the yard is "Concrete"

  Scenario: three boards on the ground take the colour of what they are made of
    Given Folding Skateboard Renew: a folding skateboard made of "WoodLog" lies at (2, 3) of the yard
    And Folding Skateboard Renew: a folding skateboard made of "Steel" lies at (3, 3) of the yard
    And Folding Skateboard Renew: a folding skateboard made of "BlocksGranite" lies at (4, 3) of the yard
    When Folding Skateboard Renew: the camera looks at (3, 3) of the yard
    And I zoom all the way in
    And I take a screenshot "boards-by-stuff"
    Then no errors were logged

  Scenario: a rider facing south has the board drawn under her, on the camera side
    Given Folding Skateboard Renew: "Ada" carries a folding skateboard made of "Steel"
    And Folding Skateboard Renew: "Ada" is placed at (3, 3) of the yard
    And Folding Skateboard Renew: "Ada" faces south
    And I draft "Ada"
    When I wait 90 ticks
    Then "Ada" has trait "Shredder"
    And I undraft "Ada"
    When Folding Skateboard Renew: the camera looks at (3, 3) of the yard
    And I zoom all the way in
    And Folding Skateboard Renew: "Ada" faces south
    And I take a screenshot "rider-facing-south"
    Then Folding Skateboard Renew: "Ada" is facing south
    And no errors were logged

  Scenario: a rider facing west has the board drawn under her, side on
    Given Folding Skateboard Renew: "Ada" carries a folding skateboard made of "Steel"
    And Folding Skateboard Renew: "Ada" is placed at (3, 3) of the yard
    And Folding Skateboard Renew: "Ada" faces west
    And I draft "Ada"
    When I wait 90 ticks
    Then "Ada" has trait "Shredder"
    And I undraft "Ada"
    When Folding Skateboard Renew: the camera looks at (3, 3) of the yard
    And I zoom all the way in
    And Folding Skateboard Renew: "Ada" faces west
    And I take a screenshot "rider-facing-west"
    Then Folding Skateboard Renew: "Ada" is facing west
    And no errors were logged

  Scenario: off the hard ground the board is strapped to the back, and only seen from behind
    Given Folding Skateboard Renew: "Ada" carries a folding skateboard made of "Steel"
    And Folding Skateboard Renew: "Ada" is placed at (0, 0) of the yard
    And Folding Skateboard Renew: "Ada" faces north
    And I draft "Ada"
    When I wait 90 ticks
    Then Folding Skateboard Renew: "Ada" does not have the trait "Shredder"
    And I undraft "Ada"
    When Folding Skateboard Renew: the camera looks at (0, 0) of the yard
    And I zoom all the way in
    And Folding Skateboard Renew: "Ada" faces north
    And I take a screenshot "board-on-back-facing-north"
    Then Folding Skateboard Renew: "Ada" is facing north
    And no errors were logged

  Scenario: a wall directly south hides the board, and the rider keeps the trait and the speed
    Given Folding Skateboard Renew: "Ada" carries a folding skateboard made of "Steel"
    And Folding Skateboard Renew: a wall stands at (3, 2) of the yard
    And Folding Skateboard Renew: "Ada" is placed at (3, 3) of the yard
    And Folding Skateboard Renew: "Ada" faces south
    And I draft "Ada"
    When I wait 90 ticks
    Then "Ada" has trait "Shredder"
    And I undraft "Ada"
    When Folding Skateboard Renew: the camera looks at (3, 3) of the yard
    And I zoom all the way in
    And Folding Skateboard Renew: "Ada" faces south
    And I take a screenshot "wall-south-no-board"
    Then Folding Skateboard Renew: "Ada" is facing south
    And no errors were logged
