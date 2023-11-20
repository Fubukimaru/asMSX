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
    And file test.rom size is 48k
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
    And file test.rom size is 512k

    Given I write the code to test.asm
      """
      .MEGAROM Konamiscc
      .SUBPAGE 64 AT 06000h
      """
    When I invalid build test.asm
    Then error code is 37
    # megaROM mapper subpage out of range

  Scenario: Issue #76 Sometimes undefined identifier
    Given I write the code to test.asm
      """
        ZILOG
        nop
        ;ld	A,(RUNEVENTS_EVENTSDONE)
      ;------------------------------------
      ; RAM
      ;------------------------------------
        PAGE	3
      ___RAM___:
      PILA0:
        ds	256
      PILA:	byte

        INCLUDE "runevents.ram"

      """
    Then I run command unix2dos test.asm
    Given I write to runevents.ram
      """
      ;RUNEVENTS Variables en RAM

      RUNEVENTS_MAX_EVENTSDONE	equ	EVENTS_TOTAL
      RUNEVENTS_EVENTSDONE:		ds	2 * RUNEVENTS_MAX_EVENTSDONE
      RUNEVENTS_EVENTSDONE_END:
      """
    Then I run command unix2dos runevents.ram
    When I invalid build test.asm
    Then error code is 13
    And build output should contain undefined identifier

  Scenario: Issue #92 Directive .FILENAME does not work
    Given I write the code to test.asm
      """
      .MSXDOS
      .BIOS
      .FILENAME "outfile"

      TERM0  EQU	$00	//Program terminate

        LD	A,1
        .CALLBIOS CHGMOD

        .CALLDOS TERM0
      """
    When I build test.asm
    Then file outfile.com exists
    And file outfile.sym exists

  Scenario: Issue #106 Include a file without newline breaks
    Given I write the code to test.asm
      """
      .db "HELLO"
      .INCLUDE "include.com"
      .db "BYE"
      """
    And I write to include.com
      """
      .db "WORLD"
      """
    When I build test.asm
    Then build output should contain Including file include.com

  Scenario: Issue #90 Conditional assembly does not avoid tag definitions
    Given I write the code to test.asm
      """
      USE_SCREEN=5
      ZILOG
      BIOS
      ROM
      START    GAME

      GAME:

      IF USE_SCREEN == 4
        call SCREEN4RENDER
      ENDIF

      IF USE_SCREEN == 5
        call SCREEN5RENDER
      ENDIF

      SCREEN5RENDER:
        ret
      """
    When I build test.asm
    Then file test.rom exists
    And sym does not contain SCREEN4RENDER
    And sym contains SCREEN5RENDER
    And build has no warnings

  Scenario: Issue #90 Label should not be registered
    Given I write the code to test.asm
      """
      VARIABLE = 1
      .zilog
      .rom
      .start INIT

      INIT:
        nop

      IF VARIABLE == 3
      LABEL1:
        .ds 8
      ENDIF

      LABEL2:
        .ds 8
        ret
      """
    When I build test.asm
    Then sym does not contain LABEL1
    And sym does not contain If it's a label, it may not be defined.
    And build has no warnings

  @wip
  Scenario: Issue #88 Local label semantics
    Given I write the code to test.asm
      """
      label1:
        jp @@local

      label2:
      @@local:
        jp @@local

      label3:
      @@local:
        jp @@local
      """
    When I invalid build test.asm

  @wip
  Scenario: Issue #81 Rework how labels work
    Given I write the code to test.asm
      """
      LOCO: MACRO #a, #b
          jpnz .nothing
          ld  a, #a
          ld  a, #b
      .nothing:
          xor a
      ENDMACRO

      LOCO 1, 2
      LOCO 3, 4
      ;
      """
    When I build test.asm
