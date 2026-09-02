Feature: Issue #142 - SYM file no crop 32 bits data for negative values

  Scenario: Negative label values should be cropped to 16 bits in SYM file
    Given I write the code to test.asm
      """
      .zilog
      .rom
      .start INIT

      INIT:
        nop

      PAGE 0
      db 0
      ORG 38h
      db 0C3h
      dw 0FD9Ah

      ;------------------------------------
      ; DATA
      ;------------------------------------
      LABEL:
        ds 100
      
      LABEL1 equ LABEL - 100
      """
    When I build test.asm
    Then file test.sym exists
    And sym contains LABEL1
    And sym address for LABEL1 should be FD9Ah
