Feature: Fix issue #5
  Scenario: .rom directive not suitable for 48kB ROM
    Given I write the code to test.asm
      """
      .page 1
      .rom
      .size 48
      .db "PAGE 1"
      .start INIT
      INIT:
      ret

      .page 2
      .db "PAGE 2"

      .page 0
      .db "PAGE 0"
      """
    When I build test.asm
    And file test.rom exists
    Then page 0 has no cartridge header
    And page 1 has cartridge header
    And sym contains INIT
    And stored init matches sym INIT

