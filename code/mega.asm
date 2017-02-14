;----------------------------------------------------------
; MEGAROM EXAMPLE for asMSX v.0.12e
;----------------------------------------------------------
;---------------------------------------------------------
; (c) KAROSHI CORPORATION, 2006
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
        .bios
        .megarom        KonamiSCC
        .start          INIT
        .db             "[asMSX 0.12e] MegaROM example",1Ah

INIT:

        ld      sp,0E800h

; Locate another 32 KB
        .search

; BASIC: COLOR 15,0,0
        ld      hl,FORCLR
        ld      [hl],15
        inc     hl
        ld      [hl],0
        inc     hl
        ld      [hl],0

; BASIC: SCREEN 2
        call    INIT32

; BASIC: SCREEN ,2
        ld      bc,0e201h
        call    WRTVDP

; BASIC: KEY OFF
        call    ERAFNK

; Hide screen
        call    DISSCR

; NAMCO font charset
        ld      hl,RLE_FONT
        ld      de,CHRTBL+33*8
        call    DEPACK_VRAM

; Colour font
        ld      hl,CLRTBL
        ld      bc,16
        ld      a,0F0h
        call    FILVRM

; Draw texts
        ld      hl,TXT_LIST
        ld      de,NAMTBL+6+32*2
        ld      b,9
@@LOOP:
        push    bc
        push    hl
        push    de
        ld      bc,26
        call    LDIRVM
        pop     hl
        ld      bc,32*2
        add     hl,bc
        ex      de,hl
        pop     hl
        ld      bc,26
        add     hl,bc
        pop     bc
        djnz    @@LOOP

; Define sprite
        ld      hl,SPR_HAND
        ld      de,SPRTBL
        ld      bc,24
        call    LDIRVM

; Set sprite
        ld      hl,ATR_HAND
        ld      de,SPRATR
        ld      bc,4
        call    LDIRVM

; Show screen
        call    ENASCR

MAIN:

; Run game
        xor     a
        call    GTTRIG
        jr      nz,LAUNCH

; Move hand
        xor     a
        call    GTSTCK
        cp      1
        jr      nz,@@NO_UP

; Move up
        ld      hl,SPRATR
        call    RDVRM
        cp      14
        jr      z,MAIN
        sub     16
        call    WRTVRM
        jr      DONE

@@NO_UP:
        cp      5
        jr      nz,MAIN

; Move down
        ld      hl,SPRATR
        call    RDVRM
        cp      14+8*16
        jr      z,MAIN
        add     16
        call    WRTVRM

DONE:
        ld      b,15
@@WAIT:
        halt
        djnz    @@WAIT

        jr      MAIN

; Launch a game
LAUNCH:

; Determine cursor position
        ld      hl,SPRATR
        call    RDVRM

        sub     14

        srl     a
        srl     a
        srl     a
        srl     a

        inc     a

; Check if it is a 8 KB game or a 32 KB game
        cp      8

        jr      nc,COPY

; Select 8 KB game page
        SELECT a AT 8000h

; Boot game
        ld      hl,8002h
        ld      e,[hl]
        inc     hl
        ld      d,[hl]
        ex      de,hl
        jp      [hl]


; Copy boot process from ROM to RAM
COPY:
        push    af
        ld      hl,BOOT
        ld      de,0C000h
        ld      bc,END_BOOT-BOOT
        ldir
        jp      0C000h


; 32 KB game boot process

BOOT:

        .phase  0C000h

; Calculate page index
        pop     af
        sub     8
        add     a
        add     a
        add     8

; Select four 8 KB pages
        SELECT  a AT 4000h
        inc     a
        SELECT  a AT 6000h
        inc     a
        SELECT  a AT 8000h
        inc     a
        SELECT a AT 0A000h

; Boot the game
        ld      hl,4002h
        ld      e,[hl]
        inc     hl
        ld      d,[hl]
        ex      de,hl
        jp      [hl]

        .dephase

END_BOOT:

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
; DATA
;----------------------------------------------------------

; Game list
TXT_LIST:
db      "RKOS01 CLASSIC PONG       "
db      "RKOS02 CLASSIC MINESWEEPER"
db      "RK702 SNAIL MAZE          "
db      "RK703 DUCK HUNT           "
db      "RK704 SOUKOBAN POCKET     "
db      "RK705 FACTORY INFECTION   "
db      "RK706 PICTURE PUZZLE      "
db      "RK708 SAIMAZOOM           "
db      "RK709 GRIEL'S QUEST       "

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


; Hand sprite
SPR_HAND:
 db      0,$0f,$1f,$ff,$ff,$ff,$ff,$0f
 db      0,0,0,0,0,0,0,0
 db      0,0,$fe,$e0,$e0,$c0,$c0,$80

; Hand attributes
ATR_HAND:
 db 14,24,0,15
;---------------------------------------------------------

;---------------------------------------------------------
; INCLUDE ALL GAMES
;---------------------------------------------------------
; Includes all games in corresponding megaROM subpages


; Include CLASSIC PONG
SUBPAGE 1 AT 8000h

.incbin "PONG.ROM"

; Include MINE SWEEPER
SUBPAGE 2 AT 8000h

.incbin "MINE.ROM"

; Include SNAIL MAZE
SUBPAGE 3 AT 8000h

.incbin "MAZE.ROM"

; Include DUCK HUNT
SUBPAGE 4 AT 8000h

.incbin "DUCKHUNT.ROM"

; Include SOUKOBAN POCKET EDITION
SUBPAGE 5 AT 8000h

.incbin "SOUKOBAN.ROM"

; Include FACTORY INFECTION
SUBPAGE 6 AT 8000h

.incbin "FACTORY.ROM"

; Include PICTURE PUZZLE
SUBPAGE 7 AT 8000h

.incbin "PICTURE.ROM"

; Include SAIMAZOOM
SUBPAGE 8 AT 4000h

.incbin "SAIMAZOOM.ROM" SIZE 8192

SUBPAGE 9 AT 6000h

.incbin "SAIMAZOOM.ROM" SKIP 8192 SIZE 8192

SUBPAGE 10 AT 8000h

.incbin "SAIMAZOOM.ROM" SKIP 8192*2 SIZE 8192

SUBPAGE 11 AT 0A000h

.incbin "SAIMAZOOM.ROM" SKIP 8192*3 SIZE 8192

; Include GRIEL'S QUEST EXTENDED
SUBPAGE 12 AT 4000h

.incbin "GRIELEX.ROM" SIZE 8192

SUBPAGE 13 AT 6000h

.incbin "GRIELEX.ROM" SKIP 8192 SIZE 8192

SUBPAGE 14 AT 8000h

.incbin "GRIELEX.ROM" SKIP 8192*2 SIZE 8192

SUBPAGE 15 AT 0A000h

.incbin "GRIELEX.ROM" SKIP 8192*3 SIZE 8192
