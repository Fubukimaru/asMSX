Feature: Test program functions

  Build a valid MSX tape file name from any input string
  Tape name must be lenght 6.
  Scenario Outline: Build tape file name
    Given I write the code to test.asm
      """
      .PAGE 2
      .ROM
      .CASSETTE <name>
      .START INIT
      INIT:
        ret
      """
    When I build test.asm
    Then cassette tape name equals <expect>

  Examples:
    | name         | expect   |
    | "123456"     | "123456" |
    | "1234567890" | "123456" |
    | "123   "     | "123   " |
    | "   e      " | "   e  " |
    | "'     "     | "'     " |
    |              | "test  " |

  Scenario Outline: Build tape with filename function
    Given I write the code to test.asm
      """
      .PAGE 2
      .ROM
      .FILENAME "<name>"
      .CASSETTE
      .START INIT
      INIT:
        ret
      """
    When I build test.asm
    Then file <name>.cas exists
    And cassette tape name equals <expect>

  Examples:
    | name     | expect   |
    | test2    | "test2 " |
    | test1234 | "test12" |

  Scenario: Test asMSX defined code
    Given I write the code to test.asm
      """
      IFDEF ASMSX
        PRINTTEXT "Hello ASMSX!"
      ELSE
        PRINTTEXT "Hello unknown assembler!"
      ENDIF
      .db "HELLO"
      """
    When I build test.asm
    Then text file contains Hello ASMSX
    And text file does not contain unknown assembler
