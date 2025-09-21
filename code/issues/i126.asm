  .BIOS
  .BIOSVARS

  .FILENAME "TESTIFD.ROM"

  ;--------------------------------------------------------------------
  LABELEXIST:

  ;Case 1: The Label does not exist. The ELSE must be processed.
  IFDEF THISLABELNOTEXIST
      CONSTANT1:	EQU $01
      CONSTANT2:	EQU $02
  ELSE
  CONSTANT1	EQU $01
  CONSTANT2	EQU $02
  ENDIF

  ;Case 2: The Label exist. The ELSE does not have to be processed.
  IFDEF LABELEXIST
  CONSTANT3	EQU $03
  CONSTANT4	EQU $04
  ELSE
      CONSTANT3:	EQU $03
      CONSTANT4:	EQU $04
  ENDIF
  ;--------------------------------------------------------------------

  .PAGE	1
  .ROM

  MAIN:
    DI
    LD    SP,[HIMEM]	;($FC4A) Stack at the top of memory
    EI

  LOOP:		
    halt
      
    ld     A,7         
    call    SNSMAT
    sub     A,11111011B    ;ESC
    JR      Z,EXIT_HELP
      
    jp  LOOP

  EXIT_HELP:
    call 0

