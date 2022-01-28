Feature: Fixing issues
  Scenario: Issue #5 .rom directive not suitable for 48kB ROM
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

  Scenario: Issue #52 MegaROM Konami SCC big than 512k
    Given I write the code to test.asm
      """
      .MEGAROM Konamiscc
      .SUBPAGE 63 AT 06000h
      """
    When I build test.asm
    Then file test.rom exists

    Given I write the code to test.asm
      """
      .MEGAROM Konamiscc
      .SUBPAGE 64 AT 06000h
      """
    When I invalid build test.asm
    Then error code is 37
    # megaROM mapper subpage out of range
