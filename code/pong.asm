;---------------------------------------------------------
; CLASSIC PONG v.0.15
; 14th December 2004
; Coventry - West Midlands - United Kingdom
;---------------------------------------------------------
; A very simple game for MSX
;---------------------------------------------------------
; Assemble with asMSX v.0.11
; Generates a 8 KB ROM (3969 bytes used)
;---------------------------------------------------------
; Coded for Robsy's MSX Workshop
; OpenSource MSX Game Shrine
;---------------------------------------------------------
; (c) KAROSHI CORPORATION, 2004
;     Eduardo Robsy Petrus
;     Jon Cortazar Abraido
;---------------------------------------------------------

;---------------------------------------------------------
; CONSTANTS
;---------------------------------------------------------
; VRAM addresses
        CHRTBL  equ     0000h   ; Pattern table
        NAMTBL  equ     1800h   ; Name table
        CLRTBL  equ     2000h   ; Colour table
        SPRTBL  equ     3800h   ; Sprite pattern table
        SPRATR  equ     1b00h   ; Sprite attributtes
; System variables
        CLIKSW  equ     0f3dbh  ; Keyboard sound
        FORCLR  equ     0f3e9h  ; Foreground colour
;---------------------------------------------------------
       
;---------------------------------------------------------
; ASSEMBLER DIRECTIVES (asMSX)
;---------------------------------------------------------
	.filename	"Pong"
        .bios           ; Defines MSX BIOS routines
        .page 2         ; Assembly starts at 8000h
        .rom            ; Selected format
        .db      "[RKOS01] CLASSIC PONG 0.15",1Ah
                        ; Text header - not MSX standard
        .start  INIT    ; Program start
;---------------------------------------------------------

;---------------------------------------------------------
INIT:
; Program start
;---------------------------------------------------------
; Calls different routines
; Initialisation
        call    INITIALISATION
; Main program loop
        call    INIT_GRAPHICS
        call    COPYRIGHT_SCREEN
MAIN:
        call    KAROSHI_OPENSOURCE
        call    INIT_GRAPHICS
        call    MENU_SCREEN
        call    READY_SCREEN
        call    GAME_SCREEN
        call    PLAY_GAME
        jr      MAIN
;---------------------------------------------------------

;---------------------------------------------------------
PLAY_GAME:
; Game procedure
;---------------------------------------------------------
; Init variables
        call    INIT_GAME
; Game loop
@@LOOP:
        call    MOVE_BATS
        call    CHECK_SERVE
        jr      nz,@@CALCULATIONS
        call    MOVE_BALL        
        call    REBOUND_BALL
        call    CONTACT_BAT
        call    CHECK_GOAL
@@CALCULATIONS:
        call    CALCULATE_POSITIONS
        call    DUMP_SPRITES
        jp      @@LOOP
;---------------------------------------------------------


;---------------------------------------------------------
GAME_OVER:
; Finishes game
;---------------------------------------------------------
; Determine winner
        ld      a,c
        cp      1
        jr      nz,@@WIN2
; If P1 wins
@@WIN1:
; Print score
        ld      hl,NAMTBL+11
        ld      a,49
        push    hl
        call    WRTVRM
        pop     hl
        inc     hl
        ld      a,48
        call    WRTVRM
; Acknowledge P1
        ld      hl,TXT_PLAYER1
        jr      @@GAMEOVER
@@WIN2:
; Print score
        ld      hl,NAMTBL+23
        ld      a,49
        push    hl
        call    WRTVRM
        pop     hl
        inc     hl
        ld      a,48
        call    WRTVRM
; Acknowledge P2
        ld      hl,TXT_PLAYER2
; GAME OVER
@@GAMEOVER:
        ld      de,NAMTBL+2*32+8
        ld      bc,16
        call    LDIRVM
; Erase sprites
        ld      a,208
        ld      hl,SPRATR+8*4
        call    WRTVRM
; Print GAME OVER
        ld      hl,TXT_GAMEOVER
        ld      de,NAMTBL+10*32+11
        ld      bc,10
        call    LDIRVM
; Wait
        ld      b,0
@@WHILE:
        halt
        djnz    @@WHILE
; Unload stack (!)
        pop     af
        pop     af
; Return to main loop
        ret
;---------------------------------------------------------

;---------------------------------------------------------
CHECK_GOAL:
; Checks if it is goal or not
;---------------------------------------------------------
; Check 2P goal
        ld      a,[BALL_X]
        or      a
        jr      nz,@@GOAL2
; Increase score
        ld      a,[GOALS2]
        inc     a
        ld      [GOALS2],a
; Test if it is 10
        cp      10
        ld      c,2
        call    z,GAME_OVER
        add     48
        ld      hl,NAMTBL+24
        call    WRTVRM
        jr      @@GOAL
; Check 1P goal
@@GOAL2:
        ld      a,[BALL_X]
        cp      252
        ret     nz
; Increase score
        ld      a,[GOALS1]
        inc     a
        ld      [GOALS1],a
; Test if it is 10
        cp      10
        ld      c,1
        call    z,GAME_OVER
        add     48
        ld      hl,NAMTBL+12
        call    WRTVRM
; Common routine for goal
@@GOAL:
; Goal sound
        ld      a,1
        ld      e,2
        call    WRTPSG
        ld      a,13
        ld      e,4
        call    WRTPSG
; Hide ball
        ld      a,208
        ld      [BALL_Y],a
; No speed
        xor     a
        ld      [SPEED_X],a
        ld      [SPEED_Y],a
; Ready to serve
        ld      a,55
        ld      [SERVE],a
; Return
        ret
;---------------------------------------------------------

;---------------------------------------------------------
DUMP_SPRITES:
; Dump sprite attributes to VRAM
;---------------------------------------------------------
; Sync with V-blank
        halt
; Redraw sprites
        ld      hl,SPRITES
        ld      de,SPRATR+4*4
        ld      bc,5*4
        call    LDIRVM
; Return
        ret
;---------------------------------------------------------

;---------------------------------------------------------
CALCULATE_POSITIONS:
; Calculate all sprite positions
;---------------------------------------------------------
; P1 bat
        ld      a,[BAT1]
        ld      [SPRITES+4*0],a
        add     16
        ld      [SPRITES+4*1],a
; P2 bat
        ld      a,[BAT2]
        ld      [SPRITES+4*2],a
        add     16
        ld      [SPRITES+4*3],a
; Ball
        ld      hl,SPRITES+4*4
        ld      a,[BALL_Y]
        ld      [hl],a
        inc     hl
        ld      a,[BALL_X]
        ld      [hl],a
; Return
        ret
;---------------------------------------------------------

;---------------------------------------------------------
REBOUND_BALL:
; Check rebound
;---------------------------------------------------------
@@TOP:
        cp      9
        jr      nc,@@BOTTOM
        jr      @@REBOUND
@@BOTTOM:
        cp      187
        ret     c
@@REBOUND:
; Revert speed
        ld      a,[SPEED_Y]
        ld      b,a
        xor     a
        sub     b
        ld      [SPEED_Y],a
; Rebound sound
; -Low frequency
        ld      a,1
        ld      e,8
        call    WRTPSG
; -Execute
        ld      a,13
        ld      e,0
        call    WRTPSG
; Return
        ret
;---------------------------------------------------------

;---------------------------------------------------------
MOVE_BALL:
; Move the ball
;---------------------------------------------------------
; Horizontal position
        ld      a,[BALL_X]
        ld      b,a
        ld      a,[SPEED_X]
        add     a,b
        ld      [BALL_X],a
; Vertical position
        ld      a,[BALL_Y]
        ld      b,a
        ld      a,[SPEED_Y]
        add     a,b
        ld      [BALL_Y],a
; Return
        ret
;---------------------------------------------------------

;---------------------------------------------------------
CHECK_SERVE:
; Determine serve time
; Output: Z-ball moving; NZ-ball not moving yet
;---------------------------------------------------------
; Check if there is a ball
        ld      a,[SERVE]
        or      a
        ret     z
        dec     a
        ld      [SERVE],a
        ret     nz
; If not, determine new serve
        ld      a,r
        and     0feh
        add     32
        ld      [BALL_Y],a
; Set vertical speed (upwards or downwards)
        and     2
        ld      a,2
        jr      nz,@@ONE
        ld      a,-2
@@ONE:
        ld      [SPEED_Y],a
; Set horizontal speed
        ld      b,4
        ld      a,[BALL_X]
        or      a
        jr      z,@@TWO
        ld      b,-4
@@TWO:
        ld      a,b
        ld      [SPEED_X],a
        xor     a
        ret
;---------------------------------------------------------

;---------------------------------------------------------
CONTACT_BAT:
; Check if the ball hits the bats
;---------------------------------------------------------
; Contact P1 bat
@@CONTACT1:
        ld      a,[SPEED_X]
        and     $80
        jr      z,@@CONTACT2
        ld      a,[BALL_X]
        cp      12
        jr      nz,@@CONTACT2
        ld      a,[BAT1]
        ld      b,a
        ld      a,[BALL_Y]
        sub     b
        cp      32
        jr      nc,@@CONTACT2
        jr      @@CONTACT
; Contact P2 bat
@@CONTACT2:
        ld      a,[SPEED_X]
        and     $80
        ret     nz
        ld      a,[BALL_X]
        cp      236
        ret     nz
        ld      a,[BAT2]
        ld      b,a
        ld      a,[BALL_Y]
        sub     b
        cp      32
        ret     nc
@@CONTACT:
; Adjust speed based on contact
; Values from the table
        ld      c,a
        ld      b,0
        ld      hl,TABLE_SPEED
        add     hl,bc
        ld      a,[hl]
        ld      [SPEED_Y],a
; Reverts horizontal speed
        ld      a,[SPEED_X]
        ld      b,a
        xor     a
        sub     b
        ld      [SPEED_X],a
; Sound
        ld      a,1
        ld      e,1
        call    WRTPSG
        ld      a,13
        ld      e,0
        call    WRTPSG
; Return
        ret
;---------------------------------------------------------

;---------------------------------------------------------
MOVE_BATS:
; Control bat movement
;---------------------------------------------------------
; Move P1 bat
; -Read cursor keys
        xor     a
        call    GTSTCK
        or      a
        jr      nz,@@PLAYER1
; -If not, read joystick 1
        ld      a,1
        call    GTSTCK
; Move P1 bat
@@PLAYER1:
; Check up
@@UP1:
        cp      1
        jr      nz,@@DOWN1
; Check top limit
        ld      a,[BAT1]
        cp      -24
        jr      z,@@PLAYER2
; Move up
        dec     a
        dec     a
        ld      [BAT1],a
        jr      @@PLAYER2
@@DOWN1:
        cp      5
        jr      nz,@@PLAYER2
; Check bottom limit
        ld      a,[BAT1]
        cp      190
        jr      z,@@PLAYER2
; Move down
        inc     a
        inc     a
        ld      [BAT1],a
; Move P2 bat
@@PLAYER2:
; Read joystick 2
        ld      a,2
        call    GTSTCK
; Check up
@@UP2:
        cp      1
        jr      nz,@@DOWN2
; Check top limit
        ld      a,[BAT2]
        cp      -24
        ret     z
; Move up
        dec     a
        dec     a
        ld      [BAT2],a
        ret
@@DOWN2:
        cp      5
        ret     nz
; Check bottom limit
        ld      a,[BAT2]
        cp      190
        ret     z
; Move down
        inc     a
        inc     a
        ld      [BAT2],a
; Return
        ret
;---------------------------------------------------------

;---------------------------------------------------------
INIT_GAME:
; Inits game variables
;---------------------------------------------------------
; -Scores
        xor     a
        ld      [GOALS1],a
        ld      [GOALS2],a
; -Bats position
        ld      a,84
        ld      [BAT1],a
        ld      [BAT2],a
; -Ball position
; -Horizontal: random - service system
        ld      a,r
        and     1
        jr      z,@@START2
; Serves P1
@@START1:
        xor     a
        ld      [BALL_X],a
        jr      @@CONTINUE
; Server P2
@@START2:
        ld      a,252
        ld      [BALL_X],a
@@CONTINUE:
; Time to start (1 second aprox)
        ld      a,55
        ld      [SERVE],a
; Hide ball
        ld      a,208
        ld      [BALL_Y],a
; Start sprite attributes
        ld      hl,ATR_START+4*4
        ld      de,SPRITES
        ld      bc,5*4
        ldir
; Return
        ret
;---------------------------------------------------------

;---------------------------------------------------------
GAME_SCREEN:
; Set game screen
;---------------------------------------------------------
; Hide screen
        call    DISSCR
; Erase screen
        ld      hl,NAMTBL
        ld      bc,768
        xor     a
        call    FILVRM
; Draw elements
; -Score
        ld      hl,TXT_SCORE
        ld      de,NAMTBL+7
        ld      bc,18
        call    LDIRVM
; -Top line
        ld      hl,NAMTBL+32*1
        ld      bc,32
        ld      a,96
        call    FILVRM
; -Bottom line
        ld      hl,NAMTBL+32*23
        ld      bc,32
        ld      a,99
        call    FILVRM
; -Top link
        ld      hl,NAMTBL+32*1+15
        ld      a,97
        call    WRTVRM
; -Bottom link
        ld      hl,NAMTBL+32*23+15
        ld      a,100
        call    WRTVRM
; -Middle line
        ld      hl,NAMTBL+32*2+15
        ld      b,21
@@LINE:
        push    bc
        push    hl
        ld      a,98
        call    WRTVRM
        ld      bc,32
        pop     hl
        add     hl,bc
        pop     bc
        djnz    @@LINE
; Show sprites
        ld      hl,ATR_START
        ld      de,SPRATR
        ld      bc,9*4
        call    LDIRVM
; Restore screen
        call    ENASCR
; Return
        ret
;---------------------------------------------------------

;---------------------------------------------------------
READY_SCREEN:
; Screen with READY? message
;---------------------------------------------------------
; Hide screen
        call    DISSCR
; Erase screen
        ld      hl,NAMTBL
        ld      bc,768
        xor     a
        call    FILVRM
; Print text
        ld      hl,TXT_READY
        ld      de,NAMTBL+11*32+13
        ld      bc,6
        call    LDIRVM
; Show screen
        call    ENASCR
; Wait 1 second
        ld      b,55
@@WAIT:
        halt
        djnz    @@WAIT
; Return
        ret
;---------------------------------------------------------

;---------------------------------------------------------
MENU_SCREEN:
; Main menu screen
;---------------------------------------------------------
; Hide screen
        call    DISSCR
; Hide sprites
        ld      hl,SPRATR
        ld      a,208
        call    WRTVRM
; Erase screen
; BASIC: CLS
        ld      hl,NAMTBL
        ld      bc,768
        xor     a
        call    FILVRM
; Print texts
; BASIC: LOCATE X,Y:PRINT T$
; Text: Robsy's MSX Workshop
        ld      hl,TXT_PRESENTS
        ld      de,NAMTBL+32*1+5
        ld      bc,22
        call    LDIRVM
; Text: 2 PLAYER
        ld      hl,TXT_2PLAYER
        ld      de,NAMTBL+32*11+7
        ld      bc,18
        call    LDIRVM
; Opensource message
        ld      hl,TXT_OPEN
        ld      de,NAMTBL+32*22+3
        ld      bc,26
        call    LDIRVM
; MSX Workshop text
        ld      hl,TXT_WORKSHOP
        ld      de,NAMTBL+32*23+3
        ld      bc,26
        call    LDIRVM
; Web page
        ld      hl,TXT_WEB
        ld      de,NAMTBL+32*20+6
        ld      bc,20
        call    LDIRVM
; Logo - 5 lines
        ld      hl,NAMTBL+4*32+8
        ld      b,5
        ld      a,101
@@LINE:
        push    bc
        ld      b,16
@@CHAR:
        call    WRTVRM
        inc     hl
        inc     a
        djnz    @@CHAR
        ld      bc,16
        add     hl,bc
        pop     bc
        djnz    @@LINE
; CLASSIC text
        ld      hl,TXT_CLASSIC
        ld      de,NAMTBL+8*32+11
        ld      bc,7
        call    LDIRVM
; Restore screen
        call    ENASCR
; Return
        xor     a
@@MENU:
        push    af
; Sync with V-blank interruption
        halt
; Check buttons
; Space bar:
        xor     a
        call    GTTRIG
        or      a
        jr      nz,@@READY
; Joystick 1
        ld      a,1
        call    GTTRIG
        or      a
        jr      nz,@@READY
; Joystick 2
        ld      a,2
        call    GTTRIG
        or      a
        jr      nz,@@READY
        pop     af
; Check if blink is needed
        inc     a
        ld      b,a
        and     0fh
        ld      a,b
        jr      nz,@@MENU
; Draws or erases the text
        push    af
        and     10h
        jr      z,@@ERASE
; Draws text PUSH BUTTON
        ld      hl,TXT_BUTTON
        ld      de,NAMTBL+32*15+9
        ld      bc,14
        call    LDIRVM        
        pop     af
        jr      @@MENU
; Erases text
@@ERASE:
        ld      hl,NAMTBL+32*15+9
        ld      bc,14
        xor     a
        call    FILVRM
        pop     af
        jr      @@MENU
; Return to main menu
@@READY:
        pop     af
; Set PSG envelope pattern
        ld      a,13
        ld      e,4
        call    WRTPSG
; Set frequency
        ld      a,12
        ld      e,6
        call    WRTPSG
; Modulated amplitude
        ld      a,8
        ld      e,16
        call    WRTPSG
; High pitch sound
        ld      a,1
        ld      e,1
        call    WRTPSG
        ret
;---------------------------------------------------------

;---------------------------------------------------------
INIT_GRAPHICS:
; Initialise the graphic mode and define graphic elements
;---------------------------------------------------------
; Set proper colours
; BASIC: COLOR 15,0,0
        ld      hl,FORCLR
        ld      [hl],15
        inc     hl
        ld      [hl],0
        inc     hl
        ld      [hl],0
; Set text mode II
; BASIC: SCREEN 1
        call    INIT32
; Erase all sprite data
        call    CLRSPR
; 16x16 Sprite mode
; BASIC: SCREEN ,2
        ld      bc,0e201h
        call    WRTVDP
; Hide screen
        call    DISSCR
; NAMCO font charset, court blocks and logo graphics
        ld      hl,RLE_FONT
        ld      de,CHRTBL+33*8
        call    DEPACK_VRAM
; Define sprites
; -Bat
        ld      hl,SPRTBL
        ld      bc,16
        ld      a,1fh
        call    FILVRM
; -Ball
        ld      hl,SPRTBL+32
        ld      bc,4
        ld      a,0f8h
        call    FILVRM
; Recover screen
        call    ENASCR
; Return to main program
        ret
;---------------------------------------------------------

;---------------------------------------------------------
INITIALISATION:
; One-time initialisation
;---------------------------------------------------------
; Disable keyboard click - system variable
; BASIC: SCREEN ,,0
        xor     a
        ld      [CLIKSW],a
; Init PSG registers
        call    GICINI
; Init memory refreshment register R - [0-127]
        xor     a
        ld      r,a
; Hide function keys
; BASIC: KEY OFF
        call    ERAFNK
; Return to main program
        ret
;---------------------------------------------------------

;----------------------------------------------------------
KAROSHI_OPENSOURCE:
; Shows the Karoshi Corp. OpenSource logo
;----------------------------------------------------------
; Set background and border color to white
        ld      hl,FORCLR+1
        ld      [hl],15
        inc     hl
        ld      [hl],15
; Erase sprites
        call    CLRSPR
; Set 8x8 sprites
        ld      bc,0E001h
        call    WRTVDP
; Init SCREEN 2 mode
        call    INIGRP
; Disable screen to copy data to VRAM
        call    DISSCR
; Unpack character data
        ld      hl,RLE_CHR
        ld      de,CHRTBL
        call    DEPACK_VRAM
; Unpack colour data
        ld      hl,RLE_CLR
        ld      de,CLRTBL
        call    DEPACK_VRAM
; Unpack sprite data
        ld      hl,RLE_SPR
        ld      de,SPRTBL
        call    DEPACK_VRAM
; Unpack attributtes
        ld      hl,RLE_ATR
        ld      de,SPRATR
        call    DEPACK_VRAM
; Restore screen
        call    ENASCR
; Wait
        ld      b,240
@@WAIT:
        halt
        djnz    @@WAIT
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

;---------------------------------------------------------
COPYRIGHT_SCREEN:
; Display the copyright information
;---------------------------------------------------------
; Disable screen
        call    DISSCR
; Copy VRAM to RAM - replicate font
        ld      hl,CHRTBL+65*8
        ld      de,0C000h
        ld      bc,28*8
        call    LDIRMV
; Copy again to VRAM
        ld      hl,0C000h
        ld      de,CHRTBL+97*8
        ld      bc,28*8
        call    LDIRVM
; Set gray colour
        ld      hl,CLRTBL+97/8
        ld      a,0E0h
        ld      bc,4
        call    FILVRM
; Copyright texts
        ld      hl,TXT_ARCADE
        ld      de,NAMTBL+32*6+9
        ld      bc,15
        call    LDIRVM
        ld      hl,TXT_ATARI
        ld      de,NAMTBL+32*8+4
        ld      bc,25
        call    LDIRVM
        ld      hl,TXT_MSX
        ld      de,NAMTBL+32*11+4
        ld      bc,25
        call    LDIRVM
        ld      hl,TXT_NEW
        ld      de,NAMTBL+32*13+4
        ld      bc,25
        call    LDIRVM
; Restore screen
        call    ENASCR
; Wait time
        ld      b,180
@@WAIT:
        halt
        djnz    @@WAIT
; Return 
        ret
;---------------------------------------------------------

;---------------------------------------------------------
; CONSTANTS
;---------------------------------------------------------
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

; Texts
TXT_CLASSIC:
        .db     "CLASSIC"
TXT_PRESENTS:
        .db     "KAROSHI CORP. PRESENTS"
TXT_OPEN:
        db      "OPENSOURCE MSX GAME SHRINE"
TXT_WORKSHOP:
        db      "ROBSY'S MSX WORKSHOP, 2004"
TXT_WEB:
        db      "HTTP://WWW.ROBSY.NET"
TXT_2PLAYER:
        .db     "2 PLAYER GAME ONLY"
TXT_BUTTON:
        .db     "-PUSH  BUTTON-"
TXT_READY:
        .db     "READY?"
TXT_SCORE:    
        .db     "1P- 00      2P- 00"
TXT_GAMEOVER:
        .db     "GAME",98," OVER"
TXT_PLAYER1:
        .db     "PLAYER ONE WINS!"
TXT_PLAYER2:
        .db     "PLAYER TWO WINS!"
TXT_ARCADE:     ;1234567890123456789012345
        db      "original arcade"
TXT_ATARI:
        db      "@ ATARI GAMES CORPORATION"
TXT_MSX:
        db      "msx opensource adaptation"
TXT_NEW:
        db      "KAROSHI CORPORATION, 2004"

; Initial sprite attributes
ATR_START:
; Sprites to hide on top
        .db     -9,0,0,0
        .db     -9,0,0,0
        .db     -9,0,0,0
        .db     -9,0,0,0
; P1 bat
        .db     84,7,0,15
        .db     100,7,0,15
; P2 bat
        .db     84,238,0,15
        .db     100,238,0,15
; Ball
        .db     208,0,4,15

; Vertical rebound speed table
TABLE_SPEED:
        .db     -4,-4,-3,-3,-3,-3,-3,-2,-2,-2,-2,-2,-2,-2,-1,-1
        .db     1,1,2,2,2,2,2,2,2,3,3,3,3,3,4,4

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
 db 028h,044h,0C9h,000h,07Ch,0C1h,0FFh,0C5h
 db 000h,0C1h,0FFh,003h,000h,0C2h,003h,000h
 db 0C2h,003h,000h,0C2h,003h,0C6h,000h,0C1h
 db 0FFh,0C2h,003h,000h,0C1h,003h,0C1h,0FFh
 db 0C1h,00Fh,0C5h,01Fh,0C0h,0C0h,0C0h,0E7h
 db 0C4h,0FFh,0C0h,0FEh,0C5h,0FFh,08Fh,007h
 db 080h,0C0h,0E0h,0C0h,0F0h,0C0h,0F8h,0C0h
 db 0FCh,0C0h,0FEh,0C1h,0FFh,0C2h,000h,001h
 db 003h,0C1h,007h,00Fh,007h,03Fh,0C4h,0FFh
 db 0C1h,0FEh,0C4h,0FFh,00Fh,007h,000h,0C0h
 db 0C0h,0C0h,0F0h,0C0h,0F8h,0C0h,0FCh,0C1h
 db 0FEh,0C0h,0FFh,00Fh,0C6h,01Fh,0C0h,0C1h
 db 0C0h,0E7h,0C4h,0FFh,0C0h,0FCh,0C5h,0FFh
 db 01Fh,00Fh,000h,0C0h,0C0h,0C1h,0F0h,0C1h
 db 0F8h,0C1h,0FCh,000h,003h,00Fh,01Fh,0C1h
 db 03Fh,0C1h,07Fh,0C5h,0FFh,0C0h,0F8h,0C0h
 db 0E0h,083h,0C0h,0E7h,0C4h,0FFh,07Fh,0C1h
 db 0F0h,0C5h,0F8h,0C7h,01Fh,0C0h,0FCh,0C2h
 db 0F8h,0C3h,0F0h,003h,0C1h,001h,0C4h,000h
 db 0C7h,0FFh,00Fh,0C6h,09Fh,0C0h,0FCh,0C1h
 db 0F8h,0C4h,0F0h,003h,0C1h,001h,0C4h,000h
 db 0C7h,0FFh,01Fh,0C6h,09Fh,0C1h,0F8h,0C5h
 db 0F0h,00Fh,0C6h,007h,0C7h,0FCh,07Fh,0C6h
 db 0FFh,0C0h,0E0h,0C1h,0C0h,0C4h,080h,03Fh
 db 0C1h,01Fh,0C4h,00Fh,0C7h,0F8h,0C7h,01Fh
 db 0C2h,0F8h,0C0h,0FCh,0C0h,0FEh,0C2h,0FFh
 db 000h,0C1h,001h,003h,007h,08Fh,0C6h,0FFh
 db 0C1h,0FEh,0C0h,0FCh,0C2h,09Fh,0C1h,00Fh
 db 0C1h,007h,003h,0C0h,0F0h,0C1h,0F8h,0C0h
 db 0FCh,0C0h,0FEh,0C2h,0FFh,000h,0C1h,001h
 db 003h,007h,00Fh,0C6h,0FFh,0C1h,0FEh,0C0h
 db 0FCh,0C2h,09Fh,0C4h,01Fh,0C7h,0F0h,0C7h
 db 007h,0C7h,0FCh,0C2h,0FFh,0C2h,07Fh,03Fh
 db 01Fh,080h,0C1h,0C0h,0C1h,0E0h,0C0h,0F8h
 db 0C1h,0FFh,00Fh,0C1h,01Fh,03Fh,07Fh,0C2h
 db 0FFh,0C7h,0F8h,0C7h,01Fh,0C1h,0FFh,0C0h
 db 0F7h,0C0h,0F1h,0C3h,0F0h,0C3h,0FFh,0C3h
 db 000h,0C0h,0F8h,0C0h,0F0h,0C0h,0E0h,080h
 db 0C3h,000h,001h,0C6h,000h,0C1h,0FFh,03Fh
 db 007h,0C3h,000h,0C2h,0FFh,0C0h,0FEh,0C3h
 db 000h,0C0h,0F8h,0C0h,0F0h,0C0h,0C0h,0C4h
 db 000h,0C1h,01Fh,00Fh,007h,0C3h,000h,0C1h
 db 0F0h,0C0h,0E0h,0C0h,0C0h,0C3h,000h,0C1h
 db 007h,003h,001h,0C3h,000h,0C1h,0FCh,0C0h
 db 0F8h,0C0h,0F0h,0C3h,000h,01Fh,00Fh,003h
 db 000h,03Fh,0C2h,07Fh,0C3h,0FFh,000h,0C1h
 db 080h,0C0h,0C0h,0C1h,0FFh,0C0h,0EFh,08Fh
 db 00Fh,0C1h,01Fh,03Fh,0C6h,0F8h,0C0h,0F0h
 db 0C4h,01Fh,0C1h,00Fh,000h,0C4h,0F0h,0C0h
 db 0E0h,0C0h,0C0h,0FFh,000h,0D0h,000h,0C1h
 db 07Fh,03Fh,01Fh,00Fh,003h,0C1h,000h,0C0h
 db 0F0h,0C4h,0FFh,07Fh,000h,0C5h,0FFh,0C0h
 db 0F8h,000h,0C1h,0F0h,0C0h,0E0h,0C0h,0C0h
 db 080h,0C2h,000h,000h,000h
;---------------------------------------------------------
FINAL:
;---------------------------------------------------------

;---------------------------------------------------------
; VARIABLES
;---------------------------------------------------------
        .page   3

; P1 bat position
BAT1:
        .ds     1

; P2 bat position
BAT2:
        .ds     1

; Ball position
BALL_X:
        .ds     1
BALL_Y:
        .ds     1

; Ball speed
SPEED_X:
        .ds     1
SPEED_Y:
        .ds     1

; P1 and P2 scores
GOALS1:
        .ds     1
GOALS2:
        .ds     1

; Service delay
SERVE:
        .ds     1

; Sprite attributes
SPRITES:
        .ds     5*4
;---------------------------------------------------------

;---------------------------------------------------------
; ADDITIONAL INFORMATION - output PONG.TXT
;---------------------------------------------------------
.printtext      "CLASSIC PONG v.0.15 is"
.print          (FINAL-8000h)
.printtext      "bytes long (including ROM header)"
;---------------------------------------------------------

