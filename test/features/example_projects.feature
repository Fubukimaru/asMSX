Feature: Running asMSX on some example games

  Scenario Outline: Build games
    Given I jump to folder <folder>
    And file <game> exists
    When I build <game>
    Then file <product> exists
    And <product> matches sha <hash>

  Examples: Games
      | folder  | game         | product      | hash                                     |
      | code    | g-monkey.asm | g-monkey.bin | 6f3d323d37f86f0d19e904519d578df12dc6b995 |
      | code    | g-monkey.asm | g-monkey.cas | b748628d5f788bb0f20c0b344145aaae3ff4fd4b |
      | code    | g-monkey.asm | g-monkey.wav | 50d3f10b83b72c0249c41bc9f5a19f97e7e0ef45 |
      | code    | pong.asm     | Pong.rom     | fee6b1579f08ca6a7376cb6db44e7aaead237464 |
      | code    | robots.asm   | robots.rom   | c1577863c6ac7aab87cc0c2d64cc0577e2e5e360 |
      | code    | zone.asm     | zone.bin     | 7c5084591bedb98bbf2a6830462144d0cbcd1eab |
      | code    | mine.asm     | Mine Sweeper.bin | ca02e7995cf0d7f0c8126d1e3527bda1653c0062 |
      | code/wrally | src/rally.asm     | src/rally.z80    | e52e8df2d07d3042b60eaf1022ab43c72214ecbc | 
