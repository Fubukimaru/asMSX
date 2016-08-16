filename "Mine Sweeper"

;PRUEBAS=1
;----------------------------------------------------------
; CLASSIC MINESWEEPER v.0.10
; 30st December 2004
; Mahon - Menorca - Spain
;---------------------------------------------------------
; A very simple game for MSX
;---------------------------------------------------------
; Assemble with asMSX v.0.11
; Generates a 8 KB ROM (7494 bytes used)
;---------------------------------------------------------
; Coded for Robsy's MSX Workshop
; OpenSource MSX Game Shrine
;---------------------------------------------------------
; (c) KAROSHI CORPORATION, 2004
;     Eduardo Robsy Petrus
;     Jon Cortazar Abraido
;---------------------------------------------------------
; INSTRUCTIONS
;---------------------------------------------------------
; Mark all the mines in the play field to complete level
; Use cursor/joystick to move cursor
; Space/Button 1: discover tile
; CTRL/Button 2: mark tile with flag/question mark
; Space+CTRL/Button 1+Button 2: discover group
;---------------------------------------------------------
;
;---------------------------------------------------------
; CONSTANTS
;---------------------------------------------------------
; VRAM addresses
        CHRTBL  equ     0000h
        NAMTBL  equ     1800h
        CLRTBL  equ     2000h
        SPRTBL  equ     3800h
        SPRATR  equ     1B00h
; BIOS routine - Turbo-R computers only!
        SETCPU  equ     0180h
; Constantes de la BIOS
        MSXID1  equ     002bh
        MSXID3  equ     002dh
; System variables addresses
        CLIKSW  equ     0f3DBh  ; Keyboard click sound
        FORCLR  equ     0f3e9h  ; Foreground colour
        RG9SAV  equ     0ffe8h  ; V9938 register copy
;----------------------------------------------------------

;----------------------------------------------------------
; ASSEMBLER DIRECTIVES
;----------------------------------------------------------
        .bios           ; Defines BIOS entry points
        .org 8800h ; page 2         ; Starts assembling at 8000h
        .basic ; rom            ; Defines output format

IFDEF PRUEBAS
        .cas      "Dubi"
        .wav     
ENDIF 

        db      "[KO02] CLASSIC MINESWEEPER 0.10",1Ah
                        ; Includes this text in the header
                        ; This is not MSX standard, but
                        ; most japanese carts do it.
        .start  MAIN    ; Points to the start address
;----------------------------------------------------------

;----------------------------------------------------------
; PROGRAM CODE
;----------------------------------------------------------
MAIN:
; Starts execution
;----------------------------------------------------------
; Initialisation
        call    INITIALISATION
; Copyright screen
        call    INIT_GRAPHICS
        call    COPYRIGHT_SCREEN
; Game loop
@@LOOP:
        call    KAROSHI_OPENSOURCE
; Game main menu
        call    INIT_GRAPHICS
        call    MAIN_MENU
; Action
        call    GAME_START
; Repeat
        jr      @@LOOP
;----------------------------------------------------------

;----------------------------------------------------------
MAIN_MENU:
; Present and control the main menu
;----------------------------------------------------------
; Clear and hide screen
        call    CLEAR_SCREENS
        call    DISSCR
; Defines the colour for the first font
        ld      hl,CLR_METAL
        ld      de,CLRTBL+32*8
        ld      b,64
        call    COPY_BLOCKS
; Defines the colour for the second font
        ld      hl,CLRTBL+97*8
        ld      bc,31*8
        ld      a,0F0h
        call    FILVRM
; Draws the logo
        ld      hl,SCREEN+32*5+8
        ld      a,128
        ld      b,4
@@LOOP1:
        push    bc
        ld      b,16
@@LOOP2:
        ld      [hl],a
        inc     hl
        inc     a
        djnz    @@LOOP2
        ld      bc,32-16
        add     hl,bc
        pop     bc
        djnz    @@LOOP1
; Prints "Karoshi Corp. presents" text
        ld      de,SCREEN+32*2+5
        ld      hl,TXT_PRESENTS
        ld      bc,22
        ldir
; Opensource message
        ld      hl,TXT_OPEN
        ld      de,SCREEN+32*22+3
        ld      bc,26
        ldir
; MSX Workshop text
        ld      hl,TXT_WORKSHOP
        ld      de,SCREEN+32*23+3
        ld      bc,26
        ldir
; Web page
        ld      hl,TXT_WEB
        ld      de,SCREEN+32*20+6
        ld      bc,20
        ldir
; Push button!
        ld      hl,TXT_BUTTON
        ld      de,SCREEN+15*32+10
        ld      bc,12
        ldir
; Show screen
        call    ENASCR
; Copy to screen
        call    SCROLL_IN
; Reset counter
        xor     a
        ld      [COUNTER],a
; Wait for button while text blinks
@@BUTTON:
        halt
        ld      hl,COUNTER
        inc     [hl]
        ld      a,[hl]
        cp      16
        jr      z,@@DRAW
        cp      32
        jr      z,@@ERASE
        call    GET_TRIGGER
        or      a
        jr      z,@@BUTTON
        jr      @@ACTION
; Draw the message
@@DRAW:
        ld      hl,SCREEN+15*32+10
        ld      de,NAMTBL+15*32+10
        ld      bc,12
        call    LDIRVM
        jr      @@BUTTON
; Erase the message
@@ERASE:
        ld      hl,NAMTBL+15*32+10
        ld      bc,12
        xor     a
        ld      [COUNTER],a
        call    FILVRM
        jr      @@BUTTON
; If button pressed       
@@ACTION:
; Sound
; Frequency for channel A
        ld      a,0
        ld      e,0
        call    WRTPSG
        ld      a,1
        ld      e,1
        call    WRTPSG
; Set envelope
        ld      a,8
        ld      e,16
        call    WRTPSG
; Envelope frequency
        ld      a,11
        ld      e,0
        call    WRTPSG
        ld      a,12
        ld      e,32
        call    WRTPSG
; Envelope shape (exponential decay)
        ld      a,13
        ld      e,0
        call    WRTPSG
@@RELEASED:
        call    GET_TRIGGER
        or      a
        jr      nz,@@RELEASED
; Level seletion
; Init cursor variable
        xor     a
        ld      [Y],a
; Show cursor
        ld      hl,ATR_CURSOR
        ld      de,SPRATR
        ld      bc,4
        call    LDIRVM
; Display level specifications
        ld      hl,TXT_LEVEL
        ld      de,SCREEN+32*12+9
        ld      b,6
@@LEVELS:
        push    bc
        push    hl
        push    de
        ld      bc,16
        ldir
        pop     hl
        ld      bc,32
        add     hl,bc
        ex      de,hl
        pop     hl
        ld      bc,16
        add     hl,bc
        pop     bc
        djnz    @@LEVELS
; Copy to visual screen
        call    COPY_SCREEN
; Selection menu loop
@@MENU:
; Read cursor keys or joystick
        call    GET_STICK
        or      a
        jr      nz,@@MOVEMENT
; Read space
        call    GET_TRIGGER
        or      a
        jr      z,@@MENU
; Button
@@SELECTION:
        call    GET_TRIGGER
        or      a
        jr      nz,@@SELECTION
; Sound
        ld      a,1
        ld      e,0
        call    WRTPSG
        ld      a,12
        ld      e,4
        call    WRTPSG
        ld      a,0
        ld      e,240
        call    WRTPSG
; Hand blinking
        ld      b,75
        ld      c,15
@@HAND:
        halt
        ld      a,b
        and     7
        jr      nz,@@CONTINUE
        ld      a,c
        xor     15
        ld      c,a
        push    bc
        ld      hl,SPRATR+3
        call    WRTVRM
; Higher!
        xor     a
        call    RDPSG
        sub     8
        ld      e,a
        xor     a
        call    WRTPSG
; Sound
        ld      a,13
        ld      e,4
        call    WRTPSG
        pop     bc
@@CONTINUE:
        djnz    @@HAND
; Quiet
        ld      a,8
        ld      e,0
        call    WRTPSG
; Scroll out
        call    SCROLL_OUT
        ret
; Move cursor
@@MOVEMENT:
; Sound
        push    af
        ld      a,1
        ld      e,1
        call    WRTPSG
        ld      a,12
        ld      e,4
        call    WRTPSG
        ld      a,13
        ld      e,0
        call    WRTPSG
        pop     af
        cp      1
        jr      nz,@@DOWN
        ld      a,[Y]
        or      a
        jr      nz,@@NOTOP
        ld      a,6
@@NOTOP:
        dec     a
        jr      @@DONE
@@DOWN:
        cp      5
        jp      nz,@@MENU
        ld      a,[Y]
        cp      5
        jr      nz,@@NOBOTTOM
        ld      a,0FFh
@@NOBOTTOM:
        inc     a
@@DONE:
        ld      [Y],a
        add     a
        add     a
        add     a
        add     95
        ld      hl,SPRATR
        call    WRTVRM
@@RELEASE:
        call    GET_STICK
        or      a
        jr      nz,@@RELEASE
        jp      @@MENU
;----------------------------------------------------------

;----------------------------------------------------------
SCROLL_IN:
; Curtain in from left to right
;----------------------------------------------------------
        ld      hl,NAMTBL
        ld      de,SCREEN
        ld      b,32
@@LOOP:
        push    bc
        halt
        ld      b,24
        push    hl
        push    de
@@COPY:
        push    bc
        push    hl
        push    de
        ld      a,[de]
        call    WRTVRM
        pop     hl
        ld      bc,32
        add     hl,bc
        ex      de,hl
        pop     hl
        add     hl,bc
        pop     bc
        djnz    @@COPY
        pop     de
        pop     hl
        inc     de
        inc     hl
        pop     bc
        djnz    @@LOOP
        ret
;----------------------------------------------------------

;----------------------------------------------------------
SCROLL_OUT:
; Curtain out from right to left
;----------------------------------------------------------
        ld      hl,NAMTBL+31
        ld      b,32
@@LOOP:
        halt
        push    bc
        push    hl
        ld      b,24
@@CLEAR:
        push    bc
        push    hl
        xor     a
        call    WRTVRM
        pop     hl
        ld      bc,32
        add     hl,bc
        pop     bc
        djnz    @@CLEAR
        pop     hl
        dec     hl
        pop     bc
        djnz    @@LOOP
        ret
;----------------------------------------------------------

;----------------------------------------------------------
GAME_START:
; Game procedure
;----------------------------------------------------------
; Hide screen
        call    DISSCR
; Defines the colour for the second font
        ld      hl,CLR_METAL
        ld      de,CLRTBL+97*8
        ld      b,31
        call    COPY_BLOCKS
; Defines the colour for the first font
        ld      hl,CLRTBL+32*8
        ld      bc,64*8
        ld      a,0F0h
        call    FILVRM
; Copy logo to top left corner
        ld      hl,SCREEN+32*5+8
        ld      de,SCREEN+1
        ld      bc,32*4
        ldir
; Erase the rest of the screen
        ld      hl,SCREEN+32*4
        ld      bc,32*20
@@ERASE:
        ld      [hl],0
        inc     hl
        dec     bc
        ld      a,b
        or      c
        jr      nz,@@ERASE
; Print the message "Generating..."
        ld      hl,TXT_RANDOM
        ld      de,SCREEN+32*11+3
        ld      bc,26
        ldir
; Erase sprites
        ld      a,208
        ld      hl,SPRATR
        call    WRTVRM
; Draw timer title
        ld      de,SCREEN+18
        ld      hl,TXT_TIMER
        ld      bc,12
        ldir
; Get the maximum
        ld      a,[Y]
        inc     a
        ld      b,a
        ld      hl,TXT_LEVEL+12-16
        ld      de,16
@@SEARCH:
        add     hl,de
        djnz    @@SEARCH
        ld      de,SCREEN+32*2+28
        ld      bc,3
        ldir
; Mine counter
        ld      hl,TXT_MINES
        ld      de,SCREEN+32*2+18
        ld      bc,10
        ldir
; View screen
        call    ENASCR
        call    SCROLL_IN
; Determine the number of mines to set
        ld      a,[Y]
        ld      hl,MINE_TABLE
        ld      c,a
        ld      b,0
        add     hl,bc
        ld      a,[hl]
; Store the total of mines
        ld      [TOTAL],a
; Generate random mine field
        call    CREATE_FIELD
; Set up variables
        ld      a,15
        ld      [X],a
        ld      a,10
        ld      [Y],a
; View mine field
        call    DRAW_CURSOR
        call    VIEW_FIELD
; Start the timer
        call    CLOCK_START
; Ingame main loop
LOOP:
; Check movement
        call    GET_STICK
        or      a
        jr      nz,@@MOVEMENT
; Check button
        call    GET_TRIGGER
        cp      1
        jr      z,@@TURN
        cp      2
        jp      z,@@SET
        cp      3
        jp      z,@@TRICK
        jr      LOOP
; Move the cursor
@@MOVEMENT:
; Check movement table
        dec     a
        push    af
        call    DRAW_CURSOR
        pop     af
        add     a
        ld      c,a
        ld      b,0
        ld      hl,MOVEMENT_TABLE
        add     hl,bc
; Update position
        ex      de,hl
        ld      hl,[X]
        ld      a,[de]
        add     l
        ld      l,a
        inc     de
        ld      a,[de]
        add     h
        ld      h,a
; Check borders
        ld      a,h
        or      a
        jr      nz,@@NO_UP
        inc     h
@@NO_UP:
        cp      21
        jr      nz,@@NO_DOWN
        dec     h
@@NO_DOWN:
        ld      a,l
        or      a
        jr      nz,@@NO_LEFT
        inc     l
@@NO_LEFT:
        cp      31
        jr      nz,@@NO_RIGHT
        dec     l
@@NO_RIGHT:
        ld      [X],hl
        call    DRAW_CURSOR
        halt
        call    VIEW_FIELD
        ld      b,6
@@WAIT:
        halt
        push    bc
        call    GET_STICK
        pop     bc
        or      a
        jr      z,@@DONE
        djnz    @@WAIT
@@DONE:
        jr      LOOP

; Uncover the tile
@@TURN:
; Test which button
        call    GET_TRIGGER
        cp      1
        jr      z,@@TURN
        cp      3
        jp      z,@@TRICK
; Call recursive procedure
        call    DRAW_CURSOR
        call    CELL_ADDRESS
        ld      bc,SCREEN2
        add     hl,bc
        push    hl
; Go on
        call    @@RECURSIVE
        call    DRAW_CURSOR
        call    VIEW_FIELD
        pop     hl
        ld      a,[hl]
        cp      13
        jp      z,GAME_OVER
        jp      LOOP
; Recursive procedure to uncover
@@RECURSIVE:
        push    hl
        dec     h
        dec     h
        dec     h
        ld      a,[hl]
        cp      10
        pop     hl
        jr      nz,@@END_RECURSION
        call    @@BLOCK
        ld      a,[hl]
        cp      1
        jr      nz,@@END_RECURSION
        ld      bc,-33
        add     hl,bc
        call    @@RECURSIVE
        inc     hl
        call    @@RECURSIVE
        inc     hl
        call    @@RECURSIVE
        ld      bc,30
        add     hl,bc
        call    @@RECURSIVE
        inc     hl
        inc     hl
        call    @@RECURSIVE
        ld      bc,30
        add     hl,bc
        call    @@RECURSIVE
        inc     hl
        call    @@RECURSIVE
        inc     hl
        call    @@RECURSIVE
        ld      bc,-33
        add     hl,bc
@@END_RECURSION:
        ret      

; Copy block from real screen to view screen
@@BLOCK:
        push    hl
        ld      a,[hl]
        dec     h
        dec     h
        dec     h
        ld      [hl],a
        pop     hl
        ret

; Mark/unmark a tile
@@SET:
; Check if trick and wait until release
        call    GET_TRIGGER
        cp      2
        jr      z,@@SET
        cp      3
        jp      z,@@TRICK
; Calculations
        call    DRAW_CURSOR
        call    CELL_ADDRESS
        ld      bc,SCREEN
        add     hl,bc
; Update
        ld      a,[hl]
        cp      10
        jr      z,@@SUM
        cp      11
        jr      z,@@SUM
        cp      12
        jr      nz,@@OK
        ld      a,10
        jr      @@OK
@@SUM:
        inc     a
@@OK:
        ld      [hl],a
        call    DRAW_CURSOR
; Number of flags
        ld      hl,SCREEN+32
        ld      bc,32*20
        ld      de,0
        xor     a
        ld      [FLAGS],a
@@FLAGS:
        ld      a,[hl]
        cp      11
        jr      z,@@FLAG
        cp      27
        jr      nz,@@NO_FLAG
; If it is a flag, increase BCD count in DE
@@FLAG:
        ld      a,[FLAGS]
        inc     a
        ld      [FLAGS],a
        ld      a,e
        add     01h
        daa
        ld      e,a
        jr      nc,@@NO_FLAG
        ld      a,d
        add     01h
        daa
        ld      d,a
@@NO_FLAG:
        inc     hl
        dec     bc
        ld      a,b
        or      c
        jr      nz,@@FLAGS
; Convert to ASCII
        push    de
        ld      a,d
        call    BCD_TO_ASCII
        ld      hl,TXT_AUX
        ld      [hl],e
        pop     de
        ld      a,e
        call    BCD_TO_ASCII
        ld      hl,TXT_AUX+1
        ld      [hl],d
        inc     hl
        ld      [hl],e
; View field
        call    VIEW_FIELD
; Redraw number
        ld      hl,TXT_AUX
        ld      de,NAMTBL+32*2+24
        ld      bc,3
        call    LDIRVM
; Check if level completed
; Fist condition: right number of flags
        ld      a,[FLAGS]
        ld      b,a
        ld      a,[TOTAL]
        cp      b
        jp      nz,LOOP
; Check if mines are well positioned
        ld      hl,SCREEN
        ld      de,SCREEN2
        ld      bc,640
@@MATCH:
        ld      a,[hl]
        cp      11
        jr      z,@@YES
        cp      27
        jr      z,@@YES
@@CONTINUE:
        inc     hl
        inc     de
        dec     bc
        ld      a,b
        or      c
        jr      nz,@@MATCH
; Then level complete!
        jp      LEVEL_DONE
@@YES:
; Check if there is a mine
        ld      a,[de]
        cp      13
; If not, exit
        jp      nz,LOOP
        jp      @@CONTINUE

; Fast uncover when completed (Windows: left+right button)
@@TRICK:
; Wait until release
        call    GET_TRIGGER
        or      a
        jr      nz,@@TRICK
; Calculations
        call    CELL_ADDRESS
        ld      bc,SCREEN
        add     hl,bc
        ld      a,[hl]
        and     0fh
        cp      10
        jp      nc,LOOP
        dec     a
        jp      z,LOOP
        ld      c,a
        ld      b,0
        push    hl
        pop     ix
        ld      a,[ix-33]
        cp      11
        call    z,@@ADD_FLAG
        ld      a,[ix-32]
        cp      11
        call    z,@@ADD_FLAG
        ld      a,[ix-31]
        cp      11
        call    z,@@ADD_FLAG
        ld      a,[ix-1]
        cp      11
        call    z,@@ADD_FLAG
        ld      a,[ix+1]
        cp      11
        call    z,@@ADD_FLAG
        ld      a,[ix+31]
        cp      11
        call    z,@@ADD_FLAG
        ld      a,[ix+32]
        cp      11
        call    z,@@ADD_FLAG
        ld      a,[ix+33]
        cp      11
        call    z,@@ADD_FLAG
        ld      a,b
        cp      c
        jp      nz,LOOP
; If completed number of flags
        ld      bc,-33
        add     hl,bc
        call    @@TEST
        inc     hl
        call    @@TEST
        inc     hl
        call    @@TEST
        ld      bc,30
        add     hl,bc
        call    @@TEST
        inc     hl
        inc     hl
        call    @@TEST
        ld      bc,30
        add     hl,bc
        call    @@TEST
        inc     hl
        call    @@TEST
        inc     hl
        call    @@TEST
; View result
        call    VIEW_FIELD
; Return        
        jp      LOOP
; Test if properly done
@@TEST:
        ld      a,[hl]
        cp      11
        ret     z
        ld      bc,-SCREEN+SCREEN2
        add     hl,bc
        ld      a,[hl]
        cp      13
        jr      z,@@ERROR
        call    @@RECURSIVE
        ld      bc,-SCREEN2+SCREEN
        add     hl,bc
        ret
; Calculation of flags
@@ADD_FLAG:
        inc     b
        ret
; If error, then game over
@@ERROR:
        pop     af
        jp      GAME_OVER
;----------------------------------------------------------

;----------------------------------------------------------
LEVEL_DONE:
; Level finished
;----------------------------------------------------------
; Stop clock
        call    CLOCK_STOP
; Flash
        ld      d,20
        ld      bc,0f07h
@@FLASH:
        push    bc
        call    WRTVDP
        pop     bc
        ld      a,b
        xor     0fh
        ld      b,a
        halt
        halt
        halt
        dec     d
        jr      nz,@@FLASH
; Set game over text
        halt
        ld      hl,TXT_CLEAR
        ld      de,NAMTBL+18+32*2
        ld      bc,13
        call    LDIRVM
; Pause
        ld      b,240
@@WAIT:
        halt
        djnz    @@WAIT
; Clear
        call    SCROLL_OUT
        call    DISSCR
; Unpack and draw message
        ld      hl,RLE_CHR_CLEARED
        ld      de,CHRTBL
        call    DEPACK_VRAM
; CLEARED! colour
        ld      de,CLRTBL+32*3*8
        ld      hl,CLR_CLEARED
        ld      b,32
        call    COPY_BLOCKS
        ld      de,CLRTBL+32*4*8
        ld      hl,CLR_CLEARED+8
        ld      b,32
        call    COPY_BLOCKS
        ld      de,CLRTBL+32*5*8
        ld      hl,CLR_CLEARED+8*2
        ld      b,32
        call    COPY_BLOCKS
        ld      de,CLRTBL+32*6*8
        ld      hl,CLR_CLEARED+8*3
        ld      b,32
        call    COPY_BLOCKS
        ld      de,CLRTBL+32*7*8
        ld      hl,CLR_CLEARED+8*4
        ld      b,32
        call    COPY_BLOCKS
; MINEFIELD colour
        ld      a,0F0h
        ld      hl,CLRTBL
        ld      bc,32*3*8
        call    FILVRM
; Memory in screen
        xor     a
        ld      b,a
        ld      hl,SCREEN
        ld      de,SCREEN+512
@@CLEAR:
        ld      [de],a
        ld      [hl],a
        inc     de
        inc     hl
        djnz    @@CLEAR
; Draw logo
        ld      hl,SCREEN+256
        xor     a
        ld      b,a
@@DRAW:
        ld      [hl],a
        inc     hl
        inc     a
        djnz    @@DRAW
; Show screen
        call    ENASCR
        call    SCROLL_IN
; Blinking text
        ld      b,10
@@BLINK:
        halt
        push    bc
        call    GET_TRIGGER
        pop     bc
        or      a
        jr      nz,@@EXIT
        inc     b
        ld      a,b
        cp      20
        jr      z,@@OFF
        cp      40
        jr      z,@@ON
        jr      @@BLINK

@@ON:
        ld      hl,NAMTBL+32*11
        ld      bc,32*5
        xor     a
        call    FILVRM
        ld      b,0
        jr      @@BLINK
@@OFF:
        push    bc
        ld      hl,SCREEN+32*11
        ld      de,NAMTBL+32*11
        ld      bc,32*5
        xor     a
        call    LDIRVM
        pop     bc
        jr      @@BLINK
; Exit and return
@@EXIT:
        call    GET_TRIGGER
        or      a
        jr      nz,@@EXIT
; Remove screen
        call    SCROLL_OUT
        ret

;----------------------------------------------------------

;----------------------------------------------------------
GAME_OVER:        
; Game Over procedure
;----------------------------------------------------------
; Bomb noise!
; Deep frequency
        ld      a,6
        ld      e,31
        call    WRTPSG
; Envelope on for channel C
        ld      a,10
        ld      e,16
        call    WRTPSG
; Envelope frequency
        ld      a,11
        ld      e,0
        call    WRTPSG
        ld      a,12
        ld      e,64
        call    WRTPSG
; Envelope shape (exponential decay)
        ld      a,13
        ld      e,0
        call    WRTPSG
; Stop clock
        call    CLOCK_STOP
; Show other mines
        ld      hl,SCREEN2
        ld      de,SCREEN
        ld      bc,768
@@LOOP:
        ld      a,[de]
        cp      11
        jr      nz,@@NOSIGNAL
        ld      a,[hl]
        cp      13
        jr      z,@@DONE
        ld      a,14
        ld      [de],a
@@NOSIGNAL:
        ld      a,[hl]
        cp      13
        jr      nz,@@DONE
        ld      [de],a
@@DONE:
        inc     hl
        inc     de
        dec     bc
        ld      a,b
        or      c
        jr      nz,@@LOOP
        call    DRAW_CURSOR
; View screen
        call    VIEW_FIELD
; Flash
        ld      d,20
        ld      bc,0807h
@@FLASH:
        push    bc
        call    WRTVDP
        pop     bc
        ld      a,b
        xor     08h
        ld      b,a
        halt
        halt
        halt
        dec     d
        jr      nz,@@FLASH
; Remove timer and mine counter
        halt
        ld      hl,NAMTBL+17
        ld      b,4
@@ERASE:        
        push    bc
        push    hl
        ld      bc,15
        xor     a
        call    FILVRM
        pop     hl
        pop     bc
        ld      de,32
        add     hl,de
        djnz    @@ERASE
; Defines the colour for the second font
        halt
        ld      hl,CLR_RED
        ld      de,CLRTBL+97*8
        ld      b,31
        call    COPY_BLOCKS
; Set game over text
        ld      hl,TXT_GAME_OVER
        ld      de,NAMTBL+19
        ld      bc,9
        call    LDIRVM
; Wait and flash until button
        ld      b,200
@@TIME:
        halt
        push    bc
        call    GET_TRIGGER
        pop     bc
        or      a
        jr      nz,@@EXIT
        inc     b
        ld      a,b
        cp      10
        jr      z,@@DRAW
        cp      20
        jr      z,@@HIDE
        jr      @@TIME
; Set push button
@@DRAW:
        push    bc
        ld      hl,TXT_SPACE
        ld      de,NAMTBL+32*2+18
        ld      bc,12
        call    LDIRVM
        pop     bc
        jr      @@TIME
; Set push button
@@HIDE:
        push    bc
        ld      hl,NAMTBL+32*2+18
        xor     a
        ld      bc,12
        call    FILVRM
        pop     bc
        ld      b,0
        jr      @@TIME
; Exit and return
@@EXIT:
        call    GET_TRIGGER
        or      a
        jr      nz,@@EXIT
; Mute sound
        ld      a,10
        ld      e,0
        call    WRTPSG
; Remove screen
        call    SCROLL_OUT
        ret
;----------------------------------------------------------

;----------------------------------------------------------
GET_STICK:
; Get the cursor/joystick 1 state
;----------------------------------------------------------
        xor     a
        call    GTSTCK
        or      a
        ret     nz
        inc     a
        call    GTSTCK
        ret
;----------------------------------------------------------

;----------------------------------------------------------
GET_TRIGGER:
; Get the space bar+alt/button 1+button 2 state
;----------------------------------------------------------
        ld      hl,0001h
        xor     a
        call    GTTRIG
        or      a
        call    nz,@@MARK
        ld      a,1
        call    GTTRIG
        or      a
        call    nz,@@MARK
        ld      a,h
        inc     l
        ld      a,3
        call    GTTRIG
        or      a
        call    nz,@@MARK
        ld      a,6
        push    hl
        call    SNSMAT
        pop     hl
        cp      $fb
        call    z,@@MARK
        ld      a,h
        ret
@@MARK:
        ld      a,l
        or      h
        ld      h,a
        ret
;----------------------------------------------------------

;----------------------------------------------------------
DRAW_CURSOR:
; Draw or erase the cursor
;----------------------------------------------------------
        call    CELL_ADDRESS
        ld      bc,SCREEN
        add     hl,bc
        ld      a,10h
        xor     [hl]
        ld      [hl],a
        ret
;----------------------------------------------------------

;----------------------------------------------------------
CELL_ADDRESS:
; Returns the relative position of the current cell
;----------------------------------------------------------
        ld      a,[Y]
        ld      h,0
        ld      l,a
        add     hl,hl
        add     hl,hl
        add     hl,hl
        add     hl,hl
        add     hl,hl
        ld      a,[X]
        ld      c,a
        ld      b,0
        add     hl,bc
        ret
;----------------------------------------------------------

;----------------------------------------------------------
COPYRIGHT_SCREEN:
;----------------------------------------------------------
; Hide screen
        call    DISSCR
; Defines the colour for the first font
        ld      hl,CLRTBL+32*8
        ld      bc,64*8
        ld      a,0F0h
        call    FILVRM
; Defines the colour for the second font
        ld      hl,CLR_FIRE
        ld      de,CLRTBL+97*8
        ld      b,31
        call    COPY_BLOCKS
; Clear screens
        call    CLEAR_SCREENS
; Draw texts
        ld      hl,TXT_ORIGINAL
        ld      de,SCREEN+32*6+6
        ld      bc,20
        ldir
        ld      hl,TXT_MICROSOFT
        ld      de,SCREEN+32*8+3
        ld      bc,26
        ldir
        ld      hl,TXT_PROGRAMMERS
        ld      de,SCREEN+32*10+1
        ld      bc,30
        ldir
        ld      hl,TXT_MSX
        ld      de,SCREEN+32*13+4
        ld      bc,25
        ldir
        ld      hl,TXT_KAROSHI
        ld      de,SCREEN+32*15+4
        ld      bc,25
        ldir
; Show screen
        call    ENASCR
; Copy to visual screen
        call    SCROLL_IN
; Wait
        ld      b,0
@@WAIT:
        halt
        djnz    @@WAIT
; Button/Space release
@@RELEASE:
        call    GET_TRIGGER
        or      a
        jr      nz,@@RELEASE
; Return
        call    SCROLL_OUT
        ret
;----------------------------------------------------------

;----------------------------------------------------------
COPY_BLOCKS:
; Copies 8 byte blocks sequentially to VRAM
; Parameters: HL=origin; DE=destination; B=number of blocks
;----------------------------------------------------------
@@LOOP:
        push    bc
        push    hl
        push    de
        ld      bc,8
        call    LDIRVM
        pop     hl
        ld      bc,8
        add     hl,bc
        ex      de,hl
        pop     hl
        pop     bc
        djnz    @@LOOP
        ret
;----------------------------------------------------------

;----------------------------------------------------------
COPY_SCREEN:
; Copies the full memory screen
;----------------------------------------------------------
        ld      hl,SCREEN
        ld      de,NAMTBL
        ld      bc,768
        halt
        call    LDIRVM
        ret
;----------------------------------------------------------

;----------------------------------------------------------
VIEW_FIELD:
; Redraws the play field
;----------------------------------------------------------
        ld      hl,SCREEN+32*1+1
        ld      de,NAMTBL+32*4+1
        ld      b,20
        halt
@@COPY:
        push    bc
        push    hl
        push    de
        ld      bc,30
        call    LDIRVM
        ld      bc,32
        pop     hl
        add     hl,bc
        ex      de,hl
        pop     hl
        add     hl,bc
        pop     bc
        djnz    @@COPY
        ret
;----------------------------------------------------------

;----------------------------------------------------------
INITIALISATION:
; All previous initialization processes
;----------------------------------------------------------
; Sets R register to range 0-127
        xor     a
        ld      r,a
; Silent key click
        ld      [CLIKSW],a
; If Turbo-R is detected, switch to Z80 mode
        ld      a,[MSXID3]
        cp      3
        jr      nz,@@DONE
        ld      a,$80
        call    SETCPU
@@DONE:
; Determines screen frequency
        ld      b,60
        ld      a,[MSXID3]
        or      a
        jr      nz,@@MSX2
; First generation MSX
        ld      a,[MSXID1]
        rla
        jr      nz,@@OK
        ld      b,50
        jr      @@OK
; MSX2 or higher (V9938/V9958)
@@MSX2:
        ld      a,[RG9SAV]
        and     $02
        jr      z,@@OK
        ld      b,60
; Store frequency
@@OK:
        ld      a,b
        ld      [FREQUENCY],a
; Desactivate clock
        call    CLOCK_STOP
; Install interruption routine
        ld      hl,$fd9f
        ld      bc,INTERRUPTION
        ld      [hl],$c3
        inc     hl
        ld      [hl],c
        inc     hl
        ld      [hl],b             
; PSG presets
; PSG mixer: Channels A=tone; B=tone+noise; C=noise only
        ld      a,7
        ld      e,8Ch
        call    WRTPSG
; Envelope settings
        ld      a,8
        ld      e,0
        call    WRTPSG
        ld      a,9
        ld      e,0
        call    WRTPSG
        ld      a,10
        ld      e,0
        call    WRTPSG
; Return to main
        ret
;----------------------------------------------------------

;----------------------------------------------------------
CLOCK_STOP:
; Stop the clock
;----------------------------------------------------------
        xor     a
        ld      [CLOCK],a
        ret
;----------------------------------------------------------

;----------------------------------------------------------
CLOCK_START:
; Start the clock
;----------------------------------------------------------
        xor     a
        ld      [COUNTER],a
        ld      [SECONDS],a
        ld      [MINUTES],a
        inc     a
        ld      [CLOCK],a
        ld      hl,TXT_TIMER+7
        ld      de,TIMER
        ld      bc,5
        ldir
        ret
;----------------------------------------------------------

;----------------------------------------------------------
CLOCK_UPDATE:
; Updates clock if necesary
;----------------------------------------------------------
; Test if clock is on
        ld      a,[CLOCK]
        or      a
        ret     z
; Adjust frame counter
        ld      hl,COUNTER
        inc     [hl]
; If equal to frequency, update clock
        ld      a,[FREQUENCY]
        cp      [hl]
        ret     nz
; Init frame counter to zero
        xor     a
        ld      [hl],a
; Increase seconds
        ld      a,[SECONDS]
        add     01h
        daa
        ld      [SECONDS],a
        cp      60h
        jr      nz,@@UPDATE
; Increase minutes
        xor     a
        ld      [SECONDS],a
        ld      a,[MINUTES]
        add     01h
        daa
        ld      [MINUTES],a
@@UPDATE:
; Convert BCD variables to ASCII text
        ld      a,[SECONDS]
        call    BCD_TO_ASCII
        ld      hl,TIMER+4
        ld      [hl],e
        dec     hl
        ld      [hl],d
        ld      a,[MINUTES]
        call    BCD_TO_ASCII
        ld      hl,TIMER+1
        ld      [hl],e
        dec     hl
        ld      [hl],d
; Print text
        ld      hl,TIMER
        ld      de,NAMTBL+25
        ld      bc,5
        call    LDIRVM
        ret
;----------------------------------------------------------

;----------------------------------------------------------
BCD_TO_ASCII:
; Parameters: A=BCD number
; Output: DE=ASCII number
;----------------------------------------------------------
        ld      e,a
        srl     a
        srl     a
        srl     a
        srl     a
        ld      d,a
        ld      a,e
        and     0Fh
        ld      e,a
        ld      hl,3030h
        add     hl,de
        ex      de,hl
        ret
;----------------------------------------------------------

;----------------------------------------------------------
INTERRUPTION:
;----------------------------------------------------------
        push    af
        push    bc
        push    de
        push    hl
        call    CLOCK_UPDATE
        pop     hl
        pop     de
        pop     bc
        pop     af
        ret
;----------------------------------------------------------

;----------------------------------------------------------
INIT_GRAPHICS:
;----------------------------------------------------------
; Starts the graphic mode
        call    SET_GRAPHIC_MODE
; Defines the graphic blocks (twice)
        ld      hl,CHR_BLOCKS
        ld      de,CHRTBL
        ld      bc,15*8
        call    LDIRVM
        ld      hl,CHR_BLOCKS
        ld      de,CHRTBL+16*8
        ld      bc,15*8
        call    LDIRVM
; Defines colours for the first graphic set
        ld      hl,CLRTBL
        ld      de,CLR_BLOCKS
        ld      b,15
@@LOOP:
        push    bc
        ld      a,[de]
        inc     de
        push    de
        push    hl
        ld      bc,8
        call    FILVRM
        pop     hl
        ld      bc,8
        add     hl,bc
        pop     de
        pop     bc
        djnz    @@LOOP
; Defines colours for the second graphic set
        ld      hl,CLRTBL+16*8
        ld      bc,16*8
        ld      a,1Fh
        call    FILVRM
; Defines the colour for the exploded mine
        ld      hl,CLRTBL+(16+13)*8
        ld      bc,8
        ld      a,18h
        call    FILVRM
; Defines the text font
; First font set (complete)
        ld      hl,RLE_FONT
        ld      de,CHRTBL+33*8
        call    DEPACK_VRAM
; Second font set (only letters)
        ld      hl,CHRTBL+65*8
        ld      de,0C100h
        ld      bc,28*8
        call    LDIRMV
        ld      hl,0C100h
        ld      de,CHRTBL+97*8
        ld      bc,28*8
        call    LDIRVM
; Defines the game logo characters
        ld      hl,RLE_CHR_LOGO
        ld      de,CHRTBL+128*8
        call    DEPACK_VRAM
; Defines the game logo colours
        ld      hl,RLE_CLR_LOGO
        ld      de,CLRTBL+128*8
        call    DEPACK_VRAM
; Defines sprites
        ld      hl,SPR_HAND
        ld      de,SPRTBL
        ld      bc,24
        call    LDIRVM
; Returns
        ret
;----------------------------------------------------------

;----------------------------------------------------------
CLEAR_SCREENS:
; Clears the memory screens
;----------------------------------------------------------
        ld      hl,SCREEN
        ld      bc,768*2
@@LOOP:        
        ld      [hl],0
        inc     hl
        dec     bc
        ld      a,b
        or      c
        jr      nz,@@LOOP
        ret
;----------------------------------------------------------

;----------------------------------------------------------
CREATE_FIELD:
; Create the random mined field
; Parameters: A=number of mines to set
;----------------------------------------------------------
; Store value
        push    af
        call    CLEAR_SCREENS
; Starting positions
        pop     bc
@@LOOP:
; Column
        ld      a,r
        ld      hl,RAND_TABLE
        ld      e,a
        ld      d,0
        add     hl,de
        ld      a,[hl]
        ld      c,a        
; Row
        ld      a,r
        ld      hl,RAND_TABLE+128
        ld      e,a
        add     hl,de
        ld      a,[hl]
        ld      l,a
        ld      h,0
        add     hl,hl
        add     hl,hl
        add     hl,hl
        add     hl,hl
        add     hl,hl
; Locate in memory
        ld      de,SCREEN
        add     hl,de
        ld      e,c
        ld      d,0
        add     hl,de
; Check if free
        ld      a,[hl]
        or      a
        jr      nz,@@LOOP
        ld      [hl],1
        djnz    @@LOOP
; Check
        ld      hl,SCREEN2+32*1+1
        ld      ix,SCREEN+32*1+1
        ld      b,22
; Vertical
@@VERTICAL:
        push    bc
        ld      b,30
; Horizontal
@@HORIZONTAL:
; Mine count
        xor     a
        add     [ix+(-33)]
        add     [ix+(-32)]
        add     [ix+(-31)]
        add     [ix+(-1)]
        add     [ix+1]
        add     [ix+32-1]
        add     [ix+32]
        add     [ix+32+1]
        ld      [hl],a
        inc     hl
        inc     ix
        djnz    @@HORIZONTAL
; Avoid borders
        inc     hl
        inc     hl
        inc     ix
        inc     ix
        pop     bc
        djnz    @@VERTICAL
; Convert numbers into tiles
        ld      hl,SCREEN2
        ld      bc,768
@@NUMBERS:
        ld      a,[hl]
        inc     a
        ld      [hl],a
        inc     hl
        dec     bc
        ld      a,b
        or      c
        jr      nz,@@NUMBERS
; Set mines
        ld      de,SCREEN
        ld      hl,SCREEN2
        ld      bc,768
@@MINES:
        ld      a,[de]
        or      a
        jr      z,@@OK
        ld      [hl],13
@@OK:
        inc     hl
        inc     de
        dec     bc
        ld      a,c
        or      b
        jr      nz,@@MINES
; Draw borders
        ld      hl,SCREEN2
        ld      b,32
@@ONE:
        ld      [hl],2
        inc     hl
        djnz    @@ONE
        ld      hl,SCREEN2+21*32
        ld      b,32
@@TWO:
        ld      [hl],2
        inc     hl
        djnz    @@TWO
        ld      hl,SCREEN2
        ld      b,22
        ld      de,32
@@THREE:
        ld      [hl],2
        add     hl,de
        djnz    @@THREE
        ld      hl,SCREEN2+31
        ld      b,22
        ld      de,32
@@FOUR:
        ld      [hl],2
        add     hl,de
        djnz    @@FOUR
; Hide game screen
        ld      hl,SCREEN
        ld      bc,768
@@HIDE:
        ld      [hl],10
        inc     hl
        dec     bc
        ld      a,b
        or      c
        jr      nz,@@HIDE
; Return to main
        ret
;----------------------------------------------------------

;----------------------------------------------------------
SET_GRAPHIC_MODE:
; Starts the graphic mode with only one tile bank
;----------------------------------------------------------
; Hides screen
	call DISSCR
; Inits all VRAM to zero
	ld hl,0000h
	ld bc,4000h
	xor a
	call FILVRM
; Sets the VDP registers
	ld hl,VDP_REGS
	ld bc,0800h
@@LOOP:
	push bc
	ld a,[hl]
	inc hl
	ld b,a
	call WRTVDP
	pop bc
	inc c
        djnz @@LOOP
; Returns
        ret
; VDP register values
VDP_REGS:
        db      02h,22h,06h,9fh,00h,36h,07h,00h
;----------------------------------------------------------

;----------------------------------------------------------
KAROSHI_OPENSOURCE:
; Shows the Karoshi Corp. OpenSource logo
;----------------------------------------------------------
; Set background and border color to white
        ld      hl,FORCLR+1
        ld      [hl],15
        inc     hl
        ld      [hl],15
; Set 8x8 sprites
        ld      bc,0E001h
        call    WRTVDP
; Erase sprites
        call    CLRSPR
; Init SCREEN 2 mode
        call    INIGRP
; Disable screen to copy data to VRAM
        halt
        call    DISSCR
        di
; Unpack sprite data
        ld      hl,RLE_SPR
        ld      de,SPRTBL
        call    DEPACK_VRAM
; Unpack attributtes
        ld      hl,RLE_ATR
        ld      de,SPRATR
        call    DEPACK_VRAM
; Unpack character data
        ld      hl,RLE_CHR
        ld      de,CHRTBL
        call    DEPACK_VRAM
; Unpack colour data
        ld      hl,RLE_CLR
        ld      de,CLRTBL
        call    DEPACK_VRAM
; Restore screen
        call    ENASCR
; Wait
        ld      b,240
@@WAIT:
        halt
        push    bc
        call    GET_TRIGGER
        pop     bc
        or      a
        jr      nz,@@EXIT
        djnz    @@WAIT
; Wait if trigger/space
@@EXIT:
        call    GET_TRIGGER
        or      a
        jr      nz,@@EXIT
; Return to main screen
        ret
;----------------------------------------------------------

;----------------------------------------------------------
DEPACK_VRAM:
; Depacks RLE encoded data directly to VRAM
; Parameters: HL=RLE data source; DE=VRAM destination
;----------------------------------------------------------
; Set VDP to write to the given address
        ex      de,hl
        call    SETWRT
        ex      de,hl
; Depack run-length encoded data
@@LOOP:
        ld      a,[hl]
        inc     hl
; Test if is single byte
        cp      0C0h
        jr      c,@@SINGLE
; Adjust counter
        and     3Fh
        inc     a
        ld      b,a
; Read data byte
        ld      a,[hl]
        inc     hl
; Copy to VRAM
@@COPY:
        out     [98h],a
        djnz    @@COPY
        jr      @@LOOP
@@SINGLE:
        ld      c,a
; Test if end of data code (00h,00h)
        or      [hl]
        ld      a,c
        ret     z
        ld      b,1
        jr      @@COPY
;----------------------------------------------------------

;----------------------------------------------------------
; DATA CONSTANTS
;----------------------------------------------------------
; Karoshi OpenSource screen graphic data
RLE_CHR:
 db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
 db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
 db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
 db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
 db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
 db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0CEh,0FFh
 db 0C0h,0CFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
 db 0F1h,0FFh,0C0h,0FEh,0C0h,0FCh,0C0h,0FAh
 db 0C0h,0F1h,0C0h,0E8h,0C0h,0D0h,0A7h,043h
 db 083h,027h,04Fh,05Fh,0BFh,07Fh,0FFh,0FFh
 db 0FFh,0FFh,0FFh,0FFh,0E9h,0FFh,0C0h,0FEh
 db 0C0h,0FCh,0C0h,0FAh,0C0h,0F4h,0C0h,0E8h
 db 0C0h,0C0h,0A0h,040h,081h,003h,007h,00Fh
 db 01Fh,03Fh,07Fh,0FFh,0FFh,0FFh,0FFh,0FFh
 db 0FFh,0E8h,0FFh,0C0h,0FEh,0C0h,0FDh,0C0h
 db 0FAh,0C0h,0F4h,0C0h,0E8h,0C0h,0D0h,080h
 db 040h,001h,003h,007h,00Fh,01Fh,03Fh,07Fh
 db 0FFh,0FFh,0F6h,0FFh,09Fh,00Eh,00Ch,008h
 db 0C1h,0FFh,001h,003h,03Fh,0C1h,01Fh,03Fh
 db 07Fh,0C2h,0FFh,0C0h,0F1h,0C0h,0E0h,0C1h
 db 0C0h,080h,084h,0C1h,00Eh,0C0h,0FFh,0C0h
 db 0FEh,0C1h,07Eh,0C1h,03Eh,0C1h,01Eh,0C3h
 db 0FFh,0C1h,01Fh,0C1h,0FFh,03Fh,01Fh,00Eh
 db 0C1h,00Ch,0C2h,008h,0C0h,0C1h,0C1h,0FFh
 db 008h,03Eh,0C1h,07Fh,0C0h,0FFh,0C0h,0FEh
 db 07Ch,038h,0C1h,018h,0C1h,008h,08Ch,0C3h
 db 0FFh,0C1h,07Fh,0C1h,0FFh,079h,0C1h,030h
 db 070h,0C2h,0F0h,070h,0C0h,0FEh,0C4h,0FCh
 db 0C1h,0FFh,079h,0C6h,030h,0D1h,0FFh,0C0h
 db 0FEh,0C0h,0FCh,0C0h,0F3h,0C0h,0E1h,0C0h
 db 0C2h,081h,080h,040h,001h,003h,007h,08Fh
 db 0C0h,0DFh,0C1h,07Fh,0FFh,0FFh,0FEh,0FFh
 db 001h,0C1h,0FFh,008h,00Ch,00Eh,09Fh,0C0h
 db 0FFh,0C1h,0FEh,07Ch,03Ch,0C1h,018h,03Ch
 db 0C0h,0FFh,0C1h,01Fh,0C1h,03Fh,0C1h,07Fh
 db 0C1h,0FFh,0C1h,00Eh,0C1h,086h,0C1h,0C2h
 db 0C0h,0E7h,0C2h,0FFh,018h,01Ch,01Eh,01Fh
 db 03Fh,0C0h,0FFh,018h,038h,03Ch,01Ch,00Eh
 db 00Fh,09Fh,0C0h,0FFh,0C1h,07Fh,03Eh,008h
 db 0C1h,0FFh,0C0h,0C1h,0C0h,0FFh,00Eh,00Fh
 db 01Fh,01Ch,038h,078h,0C0h,0FCh,0C1h,0FFh
 db 0C1h,0FCh,0C4h,0FFh,0C4h,030h,070h,0C0h
 db 0F9h,0C2h,0FFh,0C3h,0FCh,0C0h,0FEh,0C0h
 db 0FFh,0C5h,030h,079h,0C9h,0FFh,0C0h,0FEh
 db 0C0h,0FCh,0C0h,0F8h,0C0h,0F0h,0C0h,0E0h
 db 0C0h,0C0h,080h,03Fh,01Fh,00Fh,003h,007h
 db 00Fh,01Fh,03Fh,0BFh,07Fh,0FFh,0FFh,0FFh
 db 0FFh,0C6h,0FFh,09Fh,06Fh,07Fh,06Fh,09Fh
 db 0C2h,0FFh,0C0h,0CFh,0C2h,0B7h,0C0h,0CFh
 db 0C2h,0FFh,0C0h,0E3h,0C0h,0EDh,0C0h,0E3h
 db 0C1h,0EDh,0C2h,0FFh,0C0h,0F8h,0C0h,0FBh
 db 0C0h,0F8h,0C1h,0FBh,0C2h,0FFh,0C0h,0FEh
 db 07Dh,0C1h,0FDh,0C0h,0FEh,0C2h,0FFh,07Fh
 db 0C2h,0BFh,07Fh,0C2h,0FFh,01Fh,06Fh,01Fh
 db 0C1h,06Fh,0C2h,0FFh,0C0h,0CFh,0B7h,087h
 db 0C1h,0B7h,0C2h,0FFh,0C0h,0C1h,0C3h,0F7h
 db 0C2h,0FFh,0C4h,0F7h,0C2h,0FFh,0C0h,0F3h
 db 0C2h,0EDh,0C0h,0F3h,0C2h,0FFh,0C0h,0F6h
 db 0C0h,0F2h,0C0h,0F4h,0C1h,0F6h,0C4h,0FFh
 db 0C0h,0FEh,0C0h,0FCh,0C0h,0F8h,0C0h,0F3h
 db 0C0h,0E7h,080h,0C0h,0E0h,09Fh,007h,00Fh
 db 0C1h,0FFh,0C0h,0FEh,07Fh,0C5h,0FFh,0BFh
 db 0C6h,0FFh,0AFh,0C6h,0FFh,0C0h,0FEh,0FFh
 db 0FFh,0FAh,0FFh,09Fh,0C2h,06Fh,09Fh,0C2h
 db 0FFh,08Fh,0B7h,08Fh,0C1h,0BFh,0C2h,0FFh
 db 0C0h,0E1h,0C0h,0EFh,0C0h,0E3h,0C0h,0EFh
 db 0C0h,0E1h,0C2h,0FFh,0C0h,0FBh,0C0h,0F9h
 db 0C0h,0FAh,0C1h,0FBh,0C2h,0FFh,0C4h,07Fh
 db 0CAh,0FFh,08Fh,07Fh,09Fh,0C0h,0EFh,01Fh
 db 0C2h,0FFh,0C0h,0CFh,0C2h,0B7h,0C0h,0CFh
 db 0C2h,0FFh,0C3h,0DBh,0C0h,0E7h,0C2h,0FFh
 db 0C0h,0E3h,0C0h,0EDh,0C0h,0E3h,0C1h,0EDh
 db 0C2h,0FFh,0C0h,0F3h,0C0h,0EDh,0C0h,0EFh
 db 0C0h,0EDh,0C0h,0F3h,0C2h,0FFh,0C0h,0F0h
 db 0C0h,0F7h,0C0h,0F1h,0C0h,0F7h,0C0h,0F0h
 db 00Fh,0C6h,0FFh,055h,0C0h,0FAh,0C5h,0FFh
 db 055h,0AEh,0C5h,0FFh,055h,0ABh,0C5h,0FFh
 db 055h,0AFh,0C5h,0FFh,055h,0C6h,0FFh,0C0h
 db 0DDh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
 db 0FFh,0FFh,0FFh,0EFh,0FFh,078h,040h,070h
 db 0C1h,040h,0C2h,0FFh,061h,0C2h,091h,061h
 db 0C2h,0FFh,0C0h,0C0h,020h,0C0h,0C0h,0C1h
 db 020h,0C2h,0FFh,078h,040h,070h,040h,078h
 db 0C2h,0FFh,0C0h,0E1h,0C2h,091h,0C0h,0E0h
 db 0C2h,0FFh,021h,0C2h,022h,0C0h,0C1h,0C2h
 db 0FFh,083h,044h,007h,044h,084h,0C2h,0FFh
 db 03Eh,0C3h,088h,0C2h,0FFh,046h,0C2h,049h
 db 046h,0C2h,0FFh,012h,01Ah,016h,0C1h,012h
 db 0C2h,0FFh,018h,024h,03Ch,0C1h,024h,0C2h
 db 0FFh,0C3h,040h,078h,0C2h,0FFh,038h,024h
 db 038h,0C1h,020h,0C2h,0FFh,0C3h,048h,030h
 db 0C2h,0FFh,0C0h,0E1h,091h,0C0h,0E1h,0C1h
 db 091h,0C2h,0FFh,0C0h,0C1h,022h,0C0h,0C2h
 db 002h,001h,0C2h,0FFh,083h,044h,043h,040h
 db 087h,0C2h,0FFh,08Fh,008h,00Eh,088h,00Fh
 db 0C2h,0FFh,00Eh,010h,00Ch,002h,01Ch,0FFh
 db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
 db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
 db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
 db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
 db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
 db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
 db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
 db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
 db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0F1h
 db 0FFh,000h,000h

RLE_CLR:
 db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
 db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
 db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
 db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
 db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
 db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0CEh,0FFh
 db 0C0h,0F1h,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
 db 0F1h,0FFh,0C0h,0FEh,0C0h,0FBh,0C7h,0F1h
 db 0C0h,0F6h,0C0h,0F1h,0C0h,0F9h,0C0h,0F1h
 db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0E9h,0FFh
 db 0CEh,0F1h,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
 db 0E8h,0FFh,0CEh,0F1h,0FFh,0FFh,0F6h,0FFh
 db 0C3h,0F1h,0C1h,011h,0C6h,0F1h,0C2h,0FFh
 db 0C7h,0F1h,0C0h,0FFh,0C6h,0F1h,0C3h,011h
 db 0C1h,0F1h,0C1h,011h,0C8h,0F1h,0C1h,011h
 db 0C3h,0F1h,0C0h,0FFh,0C7h,0F1h,0C3h,011h
 db 0C1h,0F1h,0C1h,011h,0CDh,0F1h,0C1h,011h
 db 0C7h,0F1h,0D1h,0FFh,0C1h,0F1h,0C3h,0FBh
 db 0C6h,0F1h,0C0h,0FBh,0C0h,0F1h,0FFh,0FFh
 db 0FEh,0FFh,0C0h,0F1h,0C1h,011h,0C3h,0F1h
 db 0C0h,0FFh,0C6h,0F1h,0C0h,0FFh,0C5h,0F1h
 db 0C1h,0FFh,0C6h,0F1h,0C0h,0FFh,0C1h,011h
 db 0C4h,0F1h,0C0h,0FFh,0C6h,0F1h,0C0h,0FFh
 db 0C3h,0F1h,0C1h,011h,0C0h,0F1h,0C0h,0FFh
 db 0C6h,0F1h,0C0h,0FFh,011h,0C1h,0F1h,0C3h
 db 011h,0C0h,0FFh,0C6h,0F1h,0C0h,0FFh,0C1h
 db 011h,0C4h,0F1h,0C0h,0FFh,0C6h,0F1h,0C9h
 db 0FFh,0C6h,0F1h,0C2h,0B1h,0C4h,0F1h,0C1h
 db 0FBh,0FFh,0FFh,0FFh,0FFh,0C6h,0FFh,0C4h
 db 0F1h,0C2h,0FFh,0C4h,0F1h,0C2h,0FFh,0C4h
 db 0F1h,0C2h,0FFh,0C4h,0F1h,0C2h,0FFh,0C4h
 db 0F1h,0C2h,0FFh,0C4h,0F1h,0C2h,0FFh,0C4h
 db 0F1h,0C2h,0FFh,0C4h,0F1h,0C2h,0FFh,0C4h
 db 0F1h,0C2h,0FFh,0C4h,0F1h,0C2h,0FFh,0C4h
 db 0F1h,0C2h,0FFh,0C4h,0F1h,0C4h,0FFh,0C0h
 db 0F1h,0C2h,0FBh,0C1h,0F1h,0C1h,0B1h,0C1h
 db 0FBh,0C1h,0FFh,0C0h,0FEh,0C0h,0F1h,0C5h
 db 0FFh,0C0h,0FEh,0C6h,0FFh,0C0h,0FEh,0C6h
 db 0FFh,0C0h,0FEh,0FFh,0FFh,0F7h,0FFh,011h
 db 0C1h,0FFh,0C4h,0F1h,011h,0C1h,0FFh,0C4h
 db 0F1h,011h,0C1h,0FFh,0C4h,0F1h,011h,0C1h
 db 0FFh,0C4h,0F1h,011h,0C1h,0FFh,0C4h,0F1h
 db 011h,0C6h,0FFh,011h,0C1h,0FFh,0C4h,0F1h
 db 011h,0C1h,0FFh,0C4h,0F1h,011h,0C1h,0FFh
 db 0C4h,0F1h,011h,0C1h,0FFh,0C4h,0F1h,011h
 db 0C1h,0FFh,0C4h,0F1h,011h,0C1h,0FFh,0C5h
 db 0F1h,0C6h,0FFh,0C1h,0FEh,0C5h,0FFh,0C1h
 db 0FEh,0C5h,0FFh,0C1h,0FEh,0C5h,0FFh,0C1h
 db 0FEh,0C5h,0FFh,0C0h,0FEh,0C6h,0FFh,0C0h
 db 0FEh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
 db 0FFh,0FFh,0FFh,0EEh,0FFh,0C0h,0EEh,0C4h
 db 0FEh,0C0h,0EEh,0C0h,0FFh,0C0h,0EEh,0C4h
 db 0FEh,0C0h,0EEh,0C0h,0FFh,0C0h,0EEh,0C4h
 db 0FEh,0C0h,0EEh,0C0h,0FFh,0C0h,0EEh,0C4h
 db 0FEh,0C0h,0EEh,0C0h,0FFh,0C0h,0EEh,0C4h
 db 0FEh,0C0h,0EEh,0C0h,0FFh,0C0h,0EEh,0C4h
 db 0FEh,0C0h,0EEh,0C0h,0FFh,0C0h,0EEh,0C4h
 db 0FEh,0C0h,0EEh,0C0h,0FFh,0C0h,0EEh,0C4h
 db 0FEh,0C0h,0EEh,0C0h,0FFh,0C0h,0EEh,0C4h
 db 0FEh,0C0h,0EEh,0C0h,0FFh,0C0h,0EEh,0C4h
 db 0FEh,0C0h,0EEh,0C0h,0FFh,0C0h,0EEh,0C4h
 db 0FEh,0C0h,0EEh,0C0h,0FFh,0C0h,0EEh,0C4h
 db 0FEh,0C0h,0EEh,0C0h,0FFh,0C0h,0EEh,0C4h
 db 0FEh,0C0h,0EEh,0C0h,0FFh,0C0h,0EEh,0C4h
 db 0FEh,0C0h,0EEh,0C0h,0FFh,0C0h,0EEh,0C4h
 db 0FEh,0C0h,0EEh,0C0h,0FFh,0C0h,0EEh,0C4h
 db 0FEh,0C0h,0EEh,0C0h,0FFh,0C0h,0EEh,0C4h
 db 0FEh,0C0h,0EEh,0C0h,0FFh,0C0h,0EEh,0C4h
 db 0FEh,0C0h,0EEh,0C0h,0FFh,0C0h,0EEh,0C4h
 db 0FEh,0C0h,0EEh,0FFh,0FFh,0FFh,0FFh,0FFh
 db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
 db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
 db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
 db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
 db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
 db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
 db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
 db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
 db 0FFh,0FFh,0FFh,0F0h,0FFh,000h,000h

RLE_SPR:
 db 004h,0C1h,00Eh,0C1h,01Fh,0C2h,000h,00Eh
 db 0C2h,01Fh,00Eh,0C2h,000h,0C3h,00Fh,000h
 db 000h

RLE_ATR:
 db 78,72,0,8
 db 76,103,1,2
 db 72,133,2,4,0,0

; Movement table
MOVEMENT_TABLE:
        db      0,-1
        db      1,-1
        db      1,0
        db      1,1
        db      0,1
        db      -1,1
        db      -1,0
        db      -1,-1

; Random number tables
RAND_TABLE:
rept 128
 db random (1Eh)+1
endr

rept 128
 db random (14h)+1
endr

MINE_TABLE:
        db      50,75,100,125,150,175

; Graphic blocks
CHR_BLOCKS:
        db 000h,000h,000h,000h,000h,000h,000h,000h
        db 001h,001h,001h,001h,001h,001h,001h,0FFh
        db 001h,011h,031h,011h,011h,011h,001h,0FFh
        db 001h,079h,005h,039h,041h,07Dh,001h,0FFh
        db 001h,079h,005h,019h,005h,079h,001h,0FFh
        db 001h,049h,049h,07Dh,009h,009h,001h,0FFh
        db 001h,07Dh,041h,079h,005h,079h,001h,0FFh
        db 001h,03Dh,041h,07Dh,045h,07Dh,001h,0FFh
        db 001h,07Dh,005h,009h,011h,011h,001h,0FFh
        db 001h,039h,045h,039h,045h,039h,001h,0FFh
        db 001h,001h,001h,001h,001h,001h,001h,0FFh
        db 001h,03Dh,03Dh,021h,021h,07Dh,001h,0FFh
        db 001h,039h,045h,009h,011h,001h,011h,0FFh
        db 001h,055h,039h,07Dh,039h,055h,001h,0FFh
        db 001h,045h,029h,011h,029h,045h,001h,0FFh

; Classic arcade font (Namco style)
RLE_FONT:
 db 00Ch,0C2h,01Eh,00Ch,000h,00Ch,000h,0C1h
 db 036h,024h,0C4h,000h,036h,07Fh,0C2h,036h
 db 07Fh,036h,000h,00Ch,01Fh,02Ch,01Eh,00Dh
 db 03Eh,00Ch,0C1h,000h,063h,066h,00Ch,018h
 db 033h,063h,000h,038h,0C1h,064h,038h,04Dh
 db 046h,03Bh,000h,0C1h,00Ch,008h,0C4h,000h
 db 006h,00Ch,0C2h,018h,00Ch,006h,000h,018h
 db 00Ch,0C2h,006h,00Ch,018h,0C1h,000h,00Ch
 db 02Dh,0C1h,01Eh,02Dh,00Ch,0C1h,000h,0C1h
 db 00Ch,03Fh,0C1h,00Ch,0C5h,000h,0C1h,00Ch
 db 004h,008h,0C2h,000h,03Eh,0C8h,000h,0C1h
 db 00Ch,0C1h,000h,003h,006h,00Ch,018h,030h
 db 060h,000h,01Ch,026h,0C2h,063h,032h,01Ch
 db 000h,00Ch,01Ch,0C3h,00Ch,03Fh,000h,03Eh
 db 063h,007h,01Eh,03Ch,070h,07Fh,000h,03Fh
 db 006h,00Ch,01Eh,003h,063h,03Eh,000h,00Eh
 db 01Eh,036h,066h,07Fh,0C1h,006h,000h,07Eh
 db 060h,07Eh,0C1h,003h,063h,03Eh,000h,01Eh
 db 030h,060h,07Eh,0C1h,063h,03Eh,000h,07Fh
 db 063h,006h,00Ch,0C2h,018h,000h,03Eh,0C1h
 db 063h,03Eh,0C1h,063h,03Eh,000h,03Eh,0C1h
 db 063h,03Fh,003h,006h,03Ch,0C1h,000h,0C1h
 db 00Ch,000h,0C1h,00Ch,0C2h,000h,0C1h,00Ch
 db 000h,0C1h,00Ch,004h,008h,006h,00Ch,018h
 db 030h,018h,00Ch,006h,0C2h,000h,03Eh,000h
 db 03Eh,0C2h,000h,030h,018h,00Ch,006h,00Ch
 db 018h,030h,000h,03Eh,063h,003h,00Eh,018h
 db 000h,018h,000h,03Ch,042h,099h,0C1h,0A1h
 db 099h,042h,03Ch,01Ch,036h,0C1h,063h,07Fh
 db 0C1h,063h,000h,07Eh,0C1h,063h,07Eh,0C1h
 db 063h,07Eh,000h,01Eh,033h,0C2h,060h,033h
 db 01Eh,000h,07Ch,066h,0C2h,063h,066h,07Ch
 db 000h,07Fh,0C1h,060h,07Ch,0C1h,060h,07Fh
 db 000h,07Fh,0C1h,060h,07Ch,0C2h,060h,000h
 db 01Fh,030h,060h,067h,063h,033h,01Fh,000h
 db 0C2h,063h,07Fh,0C2h,063h,000h,03Fh,0C4h
 db 00Ch,03Fh,000h,0C4h,003h,063h,03Eh,000h
 db 063h,066h,06Ch,078h,07Ch,06Eh,067h,000h
 db 0C5h,060h,07Fh,000h,063h,077h,0C1h,07Fh
 db 06Bh,0C1h,063h,000h,063h,073h,07Bh,07Fh
 db 06Fh,067h,063h,000h,03Eh,0C4h,063h,03Eh
 db 000h,07Eh,0C2h,063h,07Eh,0C1h,060h,000h
 db 03Eh,0C2h,063h,06Fh,066h,03Bh,000h,07Eh
 db 0C1h,063h,067h,07Ch,06Eh,067h,000h,03Ch
 db 066h,060h,03Eh,003h,063h,03Eh,000h,03Fh
 db 0C5h,00Ch,000h,0C5h,063h,03Eh,000h,0C2h
 db 063h,077h,03Eh,01Ch,008h,000h,0C1h,063h
 db 06Bh,0C1h,07Fh,036h,022h,000h,063h,077h
 db 03Eh,01Ch,03Eh,077h,063h,000h,0C2h,033h
 db 01Eh,0C2h,00Ch,000h,07Fh,007h,00Eh,01Ch
 db 038h,070h,07Fh,000h,07Ch,0C4h,060h,07Ch
 db 0C1h,000h,040h,020h,010h,008h,004h,0C1h
 db 000h,07Ch,0C4h,00Ch,07Ch,0C2h,000h,010h
 db 028h,044h,0C9h,000h,07Ch,000h,000h

; Minesweeper logo graphic
RLE_CHR_LOGO:
 db 0C0h,0FFh,0C2h,07Fh,0C1h,0FFh,078h,07Ch
 db 0C1h,0FFh,055h,0C2h,0FFh,00Fh,01Fh,0C1h
 db 0FFh,055h,0C2h,0FFh,0C1h,01Ch,0C1h,0FFh
 db 055h,0C2h,0FFh,0C1h,0E0h,0C5h,0FFh,0C1h
 db 063h,030h,048h,040h,048h,030h,0C0h,0FFh
 db 0C1h,0FCh,080h,0C2h,081h,0C0h,0F1h,0C0h
 db 0FFh,07Ch,0C0h,0FEh,0C0h,0C1h,022h,0C0h
 db 0E1h,020h,023h,0C0h,0FFh,0C1h,0C4h,0C0h
 db 0C3h,004h,083h,040h,087h,0C0h,0FFh,0C1h
 db 06Fh,087h,0C1h,002h,082h,007h,0C0h,0FFh
 db 0C1h,0E7h,00Ch,012h,010h,012h,00Ch,0C0h
 db 0FFh,0C1h,0F9h,0C5h,0FFh,0C0h,0FEh,0C2h
 db 0FFh,055h,0C2h,0FFh,0C1h,01Fh,0C1h,0FFh
 db 055h,0C2h,0FFh,0C1h,0FCh,0C1h,0FFh,055h
 db 0C5h,0FFh,0C2h,0FCh,0C1h,0FFh,0C0h,0F0h
 db 0C0h,0F8h,0C2h,07Ch,0C2h,07Eh,0C1h,076h
 db 0C2h,01Fh,0C2h,03Fh,0C1h,037h,0C7h,01Ch
 db 0C1h,0F0h,0C1h,0F8h,0C0h,0FCh,0C0h,0ECh
 db 0C0h,0EEh,0C0h,0E7h,0C7h,063h,0C2h,0FFh
 db 01Ch,0C0h,0FCh,0C0h,0E0h,0C1h,0FFh,0C0h
 db 0C6h,0C0h,0C0h,0C0h,0F8h,07Ch,00Eh,006h
 db 0C0h,0C6h,0C0h,0FEh,0C1h,0CEh,0C0h,0DEh
 db 0C1h,0DBh,0C0h,0FBh,0C0h,0F1h,0C0h,0E0h
 db 0C1h,06Ch,0C1h,06Fh,06Ch,0C1h,0ECh,0C0h
 db 0EFh,0C1h,006h,086h,0C0h,0E7h,067h,0C1h
 db 006h,086h,0C2h,001h,0C0h,0E1h,0C0h,0F9h
 db 039h,0C1h,001h,0C0h,0FFh,0C0h,0C3h,0C2h
 db 0C1h,0C0h,0C3h,0C1h,0FFh,09Fh,0C5h,09Ch
 db 01Fh,0C0h,0FCh,0C5h,0FFh,0C0h,0C0h,0C1h
 db 0FFh,0C4h,0F0h,0C0h,0FFh,0C1h,0FCh,07Ch
 db 0C2h,03Ch,07Ch,0C0h,0FCh,0C1h,077h,0C5h
 db 073h,0C1h,077h,0C3h,067h,0C1h,0E7h,0C7h
 db 01Ch,0C0h,0E7h,0C2h,0E3h,0C2h,0E1h,0C0h
 db 0E0h,0C1h,063h,0C0h,0E3h,0C4h,0E0h,03Ch
 db 0C0h,0FCh,0C0h,0C0h,007h,01Fh,03Fh,07Fh
 db 040h,07Ch,0C0h,0FFh,07Fh,01Fh,003h,00Fh
 db 007h,0C0h,0FFh,080h,07Eh,040h,07Eh,006h
 db 002h,07Eh,0C0h,0FFh,02Fh,0C0h,0FFh,0C0h
 db 0FEh,0C0h,0F8h,0C0h,0CFh,0C0h,0F0h,0C0h
 db 0E0h,0C0h,0FFh,0C0h,0E6h,0C1h,007h,0C0h
 db 0E0h,0C0h,0F8h,0C0h,0FCh,0C0h,0FEh,002h
 db 001h,081h,0C0h,0E1h,0C0h,0F9h,039h,0C2h
 db 001h,0C0h,0FEh,0C6h,0C0h,0C1h,01Fh,0C5h
 db 01Ch,0C1h,0FCh,07Ch,0C7h,0FFh,0C0h,0F3h
 db 0C1h,0F1h,0C1h,0F0h,0C0h,0F8h,0C0h,0F0h
 db 0C1h,0C0h,0C1h,0E0h,0C1h,0F0h,0C4h,071h
 db 0C1h,070h,0C0h,0FFh,0C4h,0C7h,0C1h,087h
 db 0C0h,0FFh,0C4h,01Ch,018h,010h,0C0h,0FFh
 db 0C2h,0E0h,0C0h,0C0h,081h,002h,0C1h,0FFh
 db 0C0h,0C0h,080h,0C0h,0FFh,00Ah,055h,0AAh
 db 044h,0C0h,0FFh,038h,007h,0C0h,0FFh,07Fh
 db 03Fh,08Fh,001h,0C3h,0FFh,060h,0C1h,0C0h
 db 080h,0C3h,0FFh,036h,016h,0C1h,01Bh,0C3h
 db 0FFh,0C1h,0FEh,0C2h,0FFh,01Ch,0C0h,0E1h
 db 001h,002h,00Ch,071h,082h,0C0h,0FFh,001h
 db 0C1h,0FFh,050h,0AAh,055h,022h,0C0h,0FFh
 db 0C1h,0C0h,040h,0C0h,0FFh,080h,040h,0C1h
 db 0FFh,0C2h,01Ch,0C2h,01Fh,0C4h,0FFh,0C0h
 db 0C0h,0C2h,0FCh,0C0h,0FFh,0C6h,0F0h,0C0h
 db 0FFh,070h,0C1h,078h,038h,0C1h,03Ch,01Ch
 db 0C0h,0FFh,000h,000h

RLE_CLR_LOGO:
 db 000h,050h,0C0h,0E0h,050h,0C1h,000h,040h
 db 050h,000h,055h,0C0h,0E8h,055h,0C1h,000h
 db 040h,050h,000h,055h,0C0h,0E8h,055h,0C1h
 db 000h,040h,050h,000h,055h,0C0h,0E8h,055h
 db 0C1h,000h,040h,050h,000h,055h,0C0h,0EEh
 db 055h,0C1h,000h,040h,050h,0C0h,0F0h,0C2h
 db 0E0h,0C0h,0F0h,000h,040h,050h,0C0h,0F0h
 db 0C2h,0E0h,0C0h,0F0h,000h,040h,050h,0C0h
 db 0F0h,0C2h,0E0h,0C0h,0F0h,000h,040h,050h
 db 0C0h,0F0h,0C2h,0E0h,0C0h,0F0h,000h,040h
 db 050h,0C0h,0F0h,0C2h,0E0h,0C0h,0F0h,000h
 db 040h,050h,0C0h,0F0h,0C2h,0E0h,0C0h,0F0h
 db 000h,040h,050h,000h,055h,0C0h,0EEh,055h
 db 0C1h,000h,040h,055h,000h,055h,0C0h,0E8h
 db 055h,0C1h,000h,040h,050h,000h,055h,0C0h
 db 0E8h,055h,0C1h,000h,040h,050h,000h,055h
 db 0C0h,0E8h,055h,0C1h,000h,044h,055h,000h
 db 050h,0C0h,0E0h,050h,0C1h,000h,040h,0CFh
 db 050h,070h,0C5h,050h,070h,0C0h,0F0h,0C4h
 db 050h,070h,0C0h,0F0h,070h,0C3h,050h,070h
 db 0C0h,0F0h,070h,050h,0C2h,000h,070h,0C0h
 db 0F0h,070h,0C1h,000h,0C2h,050h,070h,0C0h
 db 0F0h,070h,0C4h,050h,070h,0C0h,0F0h,070h
 db 0C4h,050h,070h,0C0h,0F0h,070h,0C5h,050h
 db 070h,0C0h,0F0h,070h,0C5h,050h,070h,0C0h
 db 0F0h,070h,055h,0C4h,050h,077h,0C0h,0FFh
 db 0C6h,050h,070h,050h,0C5h,000h,050h,0C1h
 db 055h,0C4h,050h,055h,0C7h,050h,070h,0C0h
 db 0F0h,070h,0C4h,050h,0C0h,0F0h,070h,0C5h
 db 050h,070h,0D8h,050h,0C4h,040h,054h,040h
 db 000h,0C4h,054h,044h,040h,090h,098h,086h
 db 0C1h,096h,065h,055h,040h,000h,0C4h,054h
 db 044h,0C3h,050h,0C2h,040h,054h,0C7h,050h
 db 070h,0C6h,050h,0C0h,0F0h,070h,0C5h,050h
 db 070h,0C0h,0F0h,070h,0C4h,000h,055h,077h
 db 0C0h,0FFh,070h,0C5h,050h,070h,0C0h,0F0h
 db 070h,0C8h,050h,040h,000h,0C5h,050h,040h
 db 000h,0C5h,050h,040h,000h,0C3h,050h,0C1h
 db 040h,0C1h,000h,050h,040h,000h,0C3h,040h
 db 000h,0C1h,054h,044h,0C2h,040h,050h,000h
 db 0C1h,044h,055h,0C3h,054h,000h,0C1h,044h
 db 055h,0C3h,054h,000h,0C1h,044h,055h,0C1h
 db 040h,0C1h,044h,000h,054h,0C2h,050h,0C2h
 db 040h,000h,050h,0C1h,000h,0C3h,040h,000h
 db 0C1h,050h,040h,000h,0C1h,040h,0C1h,000h
 db 0C4h,050h,040h,0C4h,000h,0C2h,050h,040h
 db 000h,0C5h,050h,040h,000h,0C5h,050h,040h
 db 000h,000h,000h

; Cleared level graphic 
RLE_CHR_CLEARED:
 db 0E7h,000h,07Ch,0C1h,07Eh,0C3h,07Fh,07Bh
 db 000h,0C1h,001h,0C1h,003h,083h,087h,0C0h
 db 0C7h,0C6h,0F8h,078h,0C3h,03Fh,0C3h,007h
 db 0C3h,0F0h,0C3h,080h,0C1h,07Eh,0C4h,07Fh
 db 07Bh,0C3h,003h,0C1h,083h,0C1h,0C3h,0C7h
 db 0C0h,0C3h,0FFh,0C3h,0F0h,0C3h,0FEh,0C3h
 db 000h,0C7h,00Fh,0C3h,0FFh,0C3h,000h,0C3h
 db 0E7h,0C3h,000h,0C3h,0FEh,0C3h,0F0h,0C7h
 db 00Fh,0C3h,0FFh,0C3h,000h,0C3h,0E0h,0C3h
 db 000h,0C7h,0F0h,0C7h,000h,0C3h,03Fh,0C3h
 db 03Ch,0C0h,0F8h,0C2h,0FFh,00Fh,003h,001h
 db 0C2h,000h,080h,0C0h,0C0h,0C0h,0E0h,0C1h
 db 0F0h,0C0h,0F8h,0FFh,000h,0CFh,000h,0C1h
 db 07Bh,0C1h,079h,0C3h,078h,0C1h,0CFh,0C1h
 db 0FEh,0C1h,0FCh,0C9h,078h,0C7h,007h,0C7h
 db 080h,07Bh,0C1h,079h,0C4h,078h,0C1h,0E3h
 db 0C2h,0F3h,0C1h,07Bh,03Fh,0C7h,0C0h,0C0h
 db 0F0h,0C3h,0FFh,0C2h,0F0h,000h,0C3h,0FEh
 db 0C2h,000h,0C7h,00Fh,000h,0C3h,0FFh,0C3h
 db 000h,0C3h,080h,0C2h,000h,0C7h,0F0h,0C7h
 db 00Fh,000h,0C3h,0FFh,0C3h,000h,0C3h,0E0h
 db 0C2h,000h,0C7h,0F0h,0C7h,000h,0C7h,03Ch
 db 0C7h,000h,0C0h,0F8h,0C4h,078h,0C1h,0F8h
 db 0FFh,000h,0CFh,000h,0C6h,078h,000h,078h
 db 0C6h,000h,0C6h,078h,000h,0C2h,007h,0C3h
 db 03Fh,000h,0C2h,080h,0C3h,0F0h,000h,0C6h
 db 078h,000h,03Fh,0C1h,01Fh,0C1h,00Fh,0C1h
 db 007h,000h,0C6h,0C0h,000h,0C2h,0F0h,0C3h
 db 0FFh,0C3h,000h,0C3h,0FEh,000h,0C6h,00Fh
 db 0CBh,000h,0C3h,007h,000h,0C2h,0F0h,0C3h
 db 0FEh,000h,0C6h,00Fh,0C3h,000h,0C3h,0FFh
 db 0C3h,000h,0C3h,0E0h,000h,0C2h,0F0h,0C3h
 db 0FFh,0C3h,000h,0C3h,0FEh,000h,0C2h,03Ch
 db 0C3h,03Fh,000h,001h,003h,00Fh,0C2h,0FFh
 db 0C0h,0F8h,000h,0C1h,0F0h,0C0h,0E0h,0C0h
 db 0C0h,080h,0F6h,000h,003h,00Fh,03Fh,07Fh
 db 0C2h,000h,07Fh,0C3h,0FFh,0C2h,000h,0C0h
 db 0F0h,0C0h,0FEh,0C2h,0FFh,0C4h,000h,080h
 db 0C1h,0C1h,0C3h,000h,0C3h,0FFh,0C3h,000h
 db 0C3h,080h,0CBh,000h,0C1h,003h,0C1h,007h
 db 0C3h,000h,0C3h,0FFh,0C3h,000h,0C3h,0FFh
 db 0C3h,000h,0C2h,0FEh,0C0h,0FCh,0CBh,000h
 db 003h,0C1h,007h,00Fh,0C3h,000h,0C3h,0FFh
 db 0C3h,000h,0C2h,080h,0C0h,0C0h,0CBh,000h
 db 0C1h,03Fh,0C1h,07Fh,0C3h,000h,0C3h,0FFh
 db 0C3h,000h,0C0h,0F8h,0C2h,0FFh,0C5h,000h
 db 080h,0C0h,0C0h,0C3h,000h,0C1h,003h,0C1h
 db 007h,0C3h,000h,0C3h,0FFh,0C3h,000h,0C3h
 db 0FFh,0C3h,000h,0C2h,0FEh,0C0h,0FCh,0C3h
 db 000h,0C1h,007h,0C1h,00Fh,0C3h,000h,0C3h
 db 0FFh,0C3h,000h,0C0h,0FEh,0C2h,0FFh,0C4h
 db 000h,0C0h,0C0h,0C0h,0F0h,0C0h,0F8h,0CBh
 db 000h,007h,0C2h,00Fh,0C3h,000h,0C2h,0FCh
 db 0C0h,0F8h,000h,001h,003h,007h,0C1h,00Fh
 db 0C1h,01Fh,0C3h,0FFh,0C0h,0FEh,0C0h,0FCh
 db 0C0h,0F8h,0C0h,0F0h,0C1h,0FFh,0C0h,0C0h
 db 0C4h,000h,0C2h,0FFh,03Fh,00Fh,007h,003h
 db 000h,0C0h,0C1h,081h,0C2h,083h,003h,0C1h
 db 007h,0C3h,0FFh,0C3h,0FEh,0CFh,000h,0C1h
 db 007h,0C3h,00Fh,0C1h,01Fh,0C2h,0FFh,0C0h
 db 0FCh,0C3h,0F8h,0C2h,0FFh,0C4h,000h,0C2h
 db 0FCh,0CCh,000h,00Fh,0C1h,01Fh,03Fh,0C1h
 db 07Fh,0C9h,0FFh,0C5h,0C0h,0C1h,0E0h,0C5h
 db 000h,0C1h,001h,0C1h,07Fh,0C8h,0FFh,0C0h
 db 0C0h,0C3h,080h,0C2h,0FFh,07Fh,03Fh,0C2h
 db 01Fh,0C0h,0E0h,0C6h,0F0h,0C1h,007h,0C3h
 db 00Fh,0C1h,01Fh,0C2h,0FFh,0C0h,0FCh,0C3h
 db 0F8h,0C2h,0FFh,0C4h,000h,0C2h,0FCh,0C4h
 db 000h,0C1h,00Fh,0C3h,01Fh,0C1h,03Fh,0C2h
 db 0FFh,0C0h,0F8h,0C3h,0F0h,0C2h,0FFh,01Fh
 db 007h,003h,0C1h,001h,0C0h,0FCh,0C0h,0FEh
 db 0C5h,0FFh,0C4h,000h,0C2h,080h,0C1h,00Fh
 db 0C4h,01Fh,03Fh,0C1h,0F8h,0C3h,0F0h,0C1h
 db 0E0h,0C3h,03Fh,0C3h,07Fh,0C0h,0F0h,0C2h
 db 0E0h,0C3h,0C0h,0CFh,000h,0C1h,007h,0C4h
 db 00Fh,01Fh,0C3h,0FCh,0C3h,0F8h,0CFh,000h
 db 0C1h,01Fh,0C4h,03Fh,07Fh,0C6h,0FFh,0C0h
 db 0E0h,0C6h,0FFh,000h,0C2h,0E0h,0C3h,0C0h
 db 000h,001h,0C1h,003h,0C1h,007h,0C1h,00Fh
 db 01Fh,0C3h,0FFh,0C1h,0FEh,0C0h,0FCh,0C0h
 db 0F8h,0C1h,0BFh,03Fh,0C4h,01Fh,0C3h,0E0h
 db 0C3h,0F0h,0C1h,001h,0C4h,003h,007h,0C7h
 db 0FFh,0C1h,000h,001h,0C4h,0FFh,03Fh,07Fh
 db 0C3h,0FFh,0C0h,0FEh,0C0h,0F8h,0C0h,0F0h
 db 0C1h,0E0h,0C0h,0C0h,080h,0C2h,000h,0C1h
 db 01Fh,0C4h,03Fh,07Fh,0C6h,0FFh,0C0h,0E0h
 db 0C6h,0FFh,000h,0C2h,0E0h,0C3h,0C0h,000h
 db 0C1h,03Fh,0C4h,07Fh,0C0h,0FFh,0C3h,0E0h
 db 0C3h,0C0h,0C5h,000h,0C1h,001h,0C7h,0FFh
 db 0C5h,080h,0C1h,000h,0C4h,03Fh,0C2h,07Fh
 db 0C1h,0E0h,0C2h,0C0h,0C2h,080h,0C5h,07Fh
 db 0C1h,03Fh,0C3h,0C0h,0C1h,0E0h,0C0h,0F0h
 db 0C0h,0FCh,0C5h,000h,003h,00Fh,0C2h,000h
 db 018h,078h,0C0h,0F8h,0C1h,0F0h,0C2h,01Fh
 db 0C3h,03Fh,07Fh,0C3h,0F0h,0C2h,0E0h,0C0h
 db 0FFh,0C6h,000h,0C0h,0FFh,0C6h,000h,0C0h
 db 0E1h,0C2h,07Fh,0C4h,0FFh,0C3h,0C0h,0C2h
 db 080h,0C0h,0FFh,0C6h,000h,0C0h,0FFh,0C4h
 db 000h,0C1h,001h,083h,0C1h,03Fh,0C1h,07Fh
 db 0CAh,0FFh,080h,0C6h,0FFh,00Fh,0C2h,0F0h
 db 0C4h,0F8h,0C2h,007h,0C3h,00Fh,01Fh,0C1h
 db 0FFh,0C2h,0FCh,0C2h,0F8h,0C1h,0FFh,0C1h
 db 01Fh,0C1h,00Fh,0C1h,007h,0C0h,0F0h,0C1h
 db 0F8h,0C1h,0FCh,0C1h,0FEh,0C0h,0FFh,0C6h
 db 000h,001h,0C2h,07Fh,0C4h,0FFh,0C3h,0C0h
 db 0C2h,080h,0C0h,0FFh,0C6h,000h,0C0h,0FFh
 db 0C2h,000h,0C3h,001h,083h,0C7h,0FFh,0C3h
 db 080h,0C1h,000h,001h,0C0h,0FFh,0C1h,003h
 db 007h,00Fh,01Fh,03Fh,0C3h,0FFh,0C1h,0FEh
 db 0C0h,0FCh,0C1h,0F8h,0C0h,0F0h,0C6h,000h
 db 003h,0C1h,07Fh,0C1h,0FFh,0C2h,000h,0C0h
 db 0FFh,080h,0C6h,000h,03Fh,01Fh,0C1h,00Fh
 db 003h,001h,0C1h,000h,0C5h,0FFh,03Fh,000h
 db 0C5h,0FFh,0C0h,0F8h,000h,0C1h,0F0h,0C1h
 db 0E0h,0C0h,0C0h,0C2h,000h,0C2h,07Fh,0C2h
 db 0FFh,0C1h,000h,0C5h,0FFh,0C1h,000h,0C5h
 db 0FFh,0C1h,000h,0C1h,0E1h,0C0h,0C1h,0C2h
 db 0C3h,0C1h,000h,0C5h,0FFh,0C1h,000h,0C5h
 db 0FFh,0C1h,000h,0C5h,0FFh,0C1h,000h,083h
 db 087h,0C1h,00Fh,0C1h,01Fh,0C1h,000h,0C1h
 db 0FFh,0C1h,0FEh,0C1h,0FCh,0C9h,000h,0C2h
 db 00Fh,0C2h,007h,0C1h,000h,0C1h,0F8h,0C3h
 db 0FCh,0C1h,000h,0C2h,01Fh,0C2h,03Fh,0C1h
 db 000h,0C0h,0F8h,0C3h,0F0h,0C0h,0E0h,0C1h
 db 000h,0C1h,003h,0C1h,001h,0C3h,000h,0C4h
 db 0FFh,07Fh,0C1h,000h,001h,081h,0C0h,0C1h
 db 0C0h,0C3h,0C1h,0E3h,0C1h,000h,0C5h,0FFh
 db 0C1h,000h,0C5h,0FFh,0C1h,000h,0C5h,0FFh
 db 0C1h,000h,0C1h,083h,003h,0C2h,007h,0C1h
 db 000h,0C5h,0FFh,0C1h,000h,0C5h,0FFh,0C1h
 db 000h,0C2h,0FFh,0C0h,0FEh,0C0h,0F8h,080h
 db 0C1h,000h,0C0h,0E0h,0C0h,0C0h,0C5h,000h
 db 0C2h,003h,0C2h,007h,0C1h,000h,0C1h,0FFh
 db 0C3h,0FEh,0C9h,000h,000h,000h

; Colours for the graphic blocks
CLR_BLOCKS:
        db 000h,0FEh,0F2h,0F5h,0F9h,0FDh,0FAh,0F6h
        db 0F7h,0F1h,054h,06fh,047h,01Fh,0A6h

CLR_METAL:
        db 040h,050h,070h,070h,0f0h,0f0h,0e0h,0e0h

CLR_FIRE:
        db 060h,080h,090h,090h,0a0h,0a0h,0b0h,0b0h

CLR_RED:
        db 060h,080h,080h,090h,090h,0f0h,0f0h,0e0h

CLR_CLEARED:
        db $60,$60,$80,$80,$60,$80,$80,$90
        db $80,$90,$90,$90,$80,$90,$90,$a0
        db $90,$a0,$a0,$b0,$a0,$b0,$a0,$b0
        db $a0,$b0,$b0,$f0,$b0,$b0,$f0,$f0
        db $b0,$f0,$e0,$f0,$e0,$e0,$f0,$f0

; Text constants
TXT_WEB:
        db      "HTTP://WWW.ROBSY.NET"

TXT_ORIGINAL:    
        db      "original ibm pc game"

TXT_MICROSOFT:
        db      "@ 1981-2004 MICROSOFT CORP"

TXT_OPEN:
        db      "opensource msx game shrine"

TXT_PROGRAMMERS:
        db      "ROBERT DONNER AND CURT JOHNSON"

TXT_MSX:
        db      "msx opensource adaptation"

TXT_WORKSHOP:
        db      "2004, ROBSY'S MSX WORKSHOP"

TXT_PRESENTS:
        db      "KAROSHI CORP. PRESENTS"

TXT_KAROSHI:
        db      "KAROSHI CORPORATION, 2004"        

TXT_BUTTON:
        db "push  button"

TXT_LEVEL:      ;1234567890123456
        db      "very easy  [050]"
        db      "easy       [075]"
        db      "medium     [100]"
        db      "hard       [125]"
        db      "very hard  [150]"
        db      "impossible [175]"

TXT_RANDOM:
        db      "GENERATING RANDOM FIELD..."

TXT_TIMER:
        db      "timer  00:00"

TXT_MINES:
        db      "mines 000/"

TXT_GAME_OVER:
        db      "game over"

TXT_CLEAR:
        db      "LEVEL CLEAR! "

TXT_SPACE:
        db      "PUSH BUTTON!"

; Hand cursor pattern
SPR_HAND:
        db      0,$0f,$1f,$ff,$ff,$ff,$ff,$0f
        db      0,0,0,0,0,0,0,0
        db      0,0,$fe,$e0,$e0,$c0,$c0,$80

; Hand cursor attributes
ATR_CURSOR:
        db      95,54,0,15

; Dummy label
FINAL:

;----------------------------------------------------------
; VARIABLES
;----------------------------------------------------------
        .page   3

; Raster scan frequency
FREQUENCY:
        ds      1

; Frame counter
COUNTER:
        ds      1

; Clock enable
CLOCK:
        ds      1

; Elapsed seconds
SECONDS:
        ds      1

; Elapsed minutes
MINUTES:
        ds      1

; Timer (ASCII)
TIMER:
        ds      5

; Cursor positions
X:
        ds      1

Y:
        ds      1

; Total mines
TOTAL:
        ds      1

; Total flags
FLAGS:
        ds      1

; Text string
TXT_AUX:
        ds      3

; Offscreen buffers
SCREEN:
        ds      768

SCREEN2:
        ds      768
;----------------------------------------------------------

;---------------------------------------------------------
; ADDITIONAL INFORMATION - output MINE.TXT
;---------------------------------------------------------
.printtext      "CLASSIC MINESWEEPER v.0.10 is"
.print          (FINAL-8000h)
.printtext      "bytes long (including ROM header)"
;---------------------------------------------------------

