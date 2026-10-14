Feature: The trait's texts read as words in the pass's language

  # Closes the two checks of AUDIT.md 6.h and 8.i that no other scenario shows: the Shredder label and description
  # carry the French gender switch and the colonist's name, and a raw key or an unresolved token would reach the
  # screen without failing any other scenario. The same scenario passes in English and in French.

  Background:
    Given the save "test-colony" is loaded
    And a colonist "Ada" exists

  Scenario: the label and description of Shredder read as words for a colonist
    Then Folding Skateboard Renew: the label and description of the trait "Shredder" read as words for "Ada"
