Feature: Test program functions

  Build a valid MSX tape file name from any input string
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
