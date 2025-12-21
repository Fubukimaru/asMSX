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

  # START and ROM directives have different behaviours
  # depending if you put them after or before PAGE 1
  Scenario: Expected ROM file size (#121) - 8k
    Given I write the code to test.asm
      """
      ZILOG
      BIOS
      PAGE 1
      START MAIN
      ROM
      MAIN:
        ld  A,1
      """
    When I build test.asm
    Then file test.rom exists
    And file test.rom size is 8k

  Scenario: Expected ROM file size (#121) - 24k
    Given I write the code to test.asm
      """
      ZILOG
      BIOS
      START MAIN
      ROM
      PAGE 1
      MAIN:
        ld  A,1
      """
    When I build test.asm
    Then file test.rom exists
    And file test.rom size is 24k

  Scenario: Issue #133 Change working directory to .asm file path (now works without -r)
    Given I create folder behave_test
    And I create folder behave_test/inc
    Given I write the code to behave_test/test.asm
      """
      START MAIN
      ROM
      INCLUDE "inc/inc.asm"	
      MAIN:
          ld	A,1
      """
    And I write the code to behave_test/inc/inc.asm
      """
          xor	A
      """
    When I build behave_test/test.asm
    Then file behave_test/test.rom exists
    
  Scenario: Issue #133 Change working directory to .asm file path (works)
    Given I create folder behave_test
    And I create folder behave_test/inc
    Given I write the code to behave_test/test.asm
      """
      START MAIN
      ROM
      INCLUDE "inc/inc.asm"	
      MAIN:
          ld	A,1
      """
    And I write the code to behave_test/inc/inc.asm
      """
          xor	A
      """
    When I build behave_test/test.asm with flag -r
    Then file behave_test/test.rom exists
    And file test.rom does not exist

  Scenario: Issue #132 Custom output file (File to Folder with -o folder/)
    Given I create folder behave_test
    Given I write the code to test.asm
      """
      START MAIN
      ROM
      MAIN:
          ld	A,1
      """
    When I build test.asm with flag -o behave_test/
    Then file behave_test/test.rom exists
    And file test.rom does not exist

  Scenario: Issue #132 Custom output file (Folder with -o folder/file)
    Given I create folder behave_test
    Given I write the code to test.asm
      """
      START MAIN
      ROM
      MAIN:
          ld	A,1
      """
    When I build test.asm with flag -o behave_test/test_name
    Then file behave_test/test_name.rom exists
    And file test_name.rom does not exist

  Scenario: Issue #132 Custom output file (File with .FILENAME pseudo)
    Given I create folder behave_test
    Given I write the code to test.asm
      """
      .FILENAME "test2"
      START MAIN
      ROM
      MAIN:
          ld	A,1
      """
    When I build test.asm
    Then file test2.rom exists
    And file test.rom does not exist

  Scenario: Issue #132 Custom output file (Folder with .FILENAME pseudo)
    Given I create folder behave_test
    Given I write the code to test.asm
      """
      .FILENAME "behave_test/test_name"
      START MAIN
      ROM
      MAIN:
          ld	A,1
      """
    When I build test.asm
    Then file behave_test/test_name.rom exists
    And file test_name.rom does not exist
