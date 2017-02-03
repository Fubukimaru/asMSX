;-------------------------------------------------------------
; G-MONKEY
; An opensource Microsoft's GORILLAS clone
; Ready for the 2KBOS mini-game contest (June'08)
;-------------------------------------------------------------

;-------------------------------------------------------------
; COMPATIBILITY ISSUES
;-------------------------------------------------------------
; Not compatible with C-BIOS (MAPXYC/READC implementation)
;-------------------------------------------------------------

;-------------------------------------------------------------
; LEGAL NOTE
;-------------------------------------------------------------
; Presented by Karoshi Corporation, 2008
; Coded from scratch by Eduardo Robsy Petrus
; Original sprites from Konami's MONKEY ACADEMY (1984)
; Original game concept by Microsoft (1990)
; All rights reserved to their respective owners
; Program and code provided for learning purposes
;-------------------------------------------------------------

;-------------------------------------------------------------
; INSTRUCTIONS
;-------------------------------------------------------------
; Aim carefully and throw explosive bananas to knock your
; opponent out of the buildings. Of course, if you are clumsy
; enough, you could kill yourself.
; You can adjust both the angle and the speed for each banana.
; The first G-monkey to score 5 points wins.
;
; Controls:	PLAYER ONE (blue): CURSOR or JOYSTICK PORT A
;		PLAYER TWO (red):  CURSOR or JOYSTICK PORT B
;		<ESC>		   EXIT GAME from MAIN MENU
;
; Would you become the best G-Monkey ever?
;-------------------------------------------------------------

;-------------------------------------------------------------
; ASSEMBLING INSTRUCTIONS
;-------------------------------------------------------------
; Assemble this source code with asmsx v.0.15 or higher
; If the label TEST_VERSION is defined (see below) the 
; assembler will ; produce a ROM file. If this label is not
; defined (comment the following line) the assembler will 
; output a BASIC binary file (BIN), as the 2KBOS contest
; requires.

; TEST_VERSION:   ; Uncomment this line to produce a ROM file

;-------------------------------------------------------------

;-------------------------------------------------------------
; DEVELOPMENT TOOLS
;-------------------------------------------------------------
; Source code edited using kate/gedit
; Graphics edited with mtPaint for Linux
; Assembled with asmsx v.0.15 beta for Linux
; Debugged and tested with openMSX for Linux
; Coded in a wonderful eeePC 701!
;-------------------------------------------------------------

;-------------------------------------------------------------
; DEVELOPMENT NOTE
;-------------------------------------------------------------
; This program has been strongly optimized for code size
; No compression algorithms have been used
; This greatly reduces RAM overhead
;-------------------------------------------------------------

;-------------------------------------------------------------
; CONSTANTS
;-------------------------------------------------------------
; BIOS variables
;-------------------------------------------------------------
	CLIKSW	equ	0F3DBh	; Key click switch 0 = Disabled / 1 = Enabled
	BAKCLR	equ	0F3EAh	; Background colour
	RG1SAV	equ	0F3E0h	; Content of VDP(1) register (R#1)
	STATFL	equ	0F3E7h	; Content of VDP(8) register (MSX2- VDP status register 0  S#0)
	ATRBYT	equ	0F3F2h	; Color code in csing graphic
	HTIMI	equ	0FD9Fh	; Interrupt handler
;-------------------------------------------------------------
; VRAM addresses
;-------------------------------------------------------------
	NAMTBL	equ	1800h
	CHRTBL	equ	0000h
	CLRTBL	equ	2000h
	SPRTBL	equ	3800h
	SPRATR	equ	1B00h
;-------------------------------------------------------------

ifdef	TEST_VERSION
;-------------------------------------------------------------
; DIRECTIVES AND HEADER FOR ROM GENERATION (TESTING PURPOSES)
;-------------------------------------------------------------
	bios
	page	2
	rom
	start	INIT
	org	8010h
	db	"[RKOS03] G-MONKEY",1Ah
;-------------------------------------------------------------

;-------------------------------------------------------------
; ROM CODE LOADER
;-------------------------------------------------------------
INIT:
;-------------------------------------------------------------
; compatibility required
	di
	im      1
	ld      sp,0F380h

; copy ROM code to RAM
        ld      hl,CODE
        ld      de,0C000h
        ld      bc,0800h
        ldir

; execute code in RAM
        jp      0C000h

CODE:
        phase  0C000h

;-------------------------------------------------------------
; DIRECTIVES AND HEADER FOR BASIC GENERATION (CONTEST VERSION)
;-------------------------------------------------------------

else
        bios
        page   3
        basic
	wav	; generate WAV file to load in real MSX
	cas	; generate CAS file to load in emulators
endif
;-------------------------------------------------------------

;-------------------------------------------------------------
; PROGRAM SOURCE CODE
;-------------------------------------------------------------

;-------------------------------------------------------------
; INITIALIZATION
;-------------------------------------------------------------
; This code is run to set up the game environment
;-------------------------------------------------------------

; init R register - for random generators
	xor	a
	ld	r,a

; color ,0 - black background
	ld	hl,BAKCLR
	ld	[hl],a
	inc	hl
	ld	[hl],a

; screen ,,0 - disable keyboard click
	ld	[CLIKSW],a

; screen 2 - graphics mode
	call	INIGRP

; screen ,3 - set 16x16 magnified sprites
	ld	hl,RG1SAV
	ld	a,[hl]
        or      3
	ld	[hl],a

; disable screen for VRAM access
	call	DISSCR

; define sprites for 1P - looking right
	ld	hl,SPR_DATA
	ld	de,SPRTBL
	ld	bc,32*10

; store registers for code size optimization
	push	bc
	push	hl
	push	bc

; copy sprites to VRAM
	call	LDIRVM

; mirror sprites for 2P - looking left

; restore registers
	pop	bc
	pop	hl
	push	hl

; mirror each sprite byte
@@MIRROR:
        ld      a,[hl]
        push    bc
        ld      b,8
@@ROTATE:
        rla
        ld      e,a
        ld      a,d
        rra
        ld      d,a
        ld      a,e
        djnz    @@ROTATE
        ld      [hl],d
        inc     hl
        pop     bc
        dec     bc
        ld      a,b
        or      c
        jr      nz,@@MIRROR

; swap 8x16 sprite columns
        ld      b,10
        pop	hl
	push	hl
@@SWAP:
        push    bc
        push    hl
        ld      de,16
        add     hl,de
        ld      b,e
        pop     de
@@SHUFFLE:
        ld      c,[hl]
        ld      a,[de]
        ld      [hl],a
        ld      a,c
        ld      [de],a
        inc     hl
        inc     de
        djnz    @@SHUFFLE
        pop     bc
        djnz    @@SWAP

; define sprites for 2P - looking left
	pop	hl
	pop	bc
	ld	de,SPRTBL+32*32
	call	LDIRVM

; define font in upper tile bank
	ld	hl,CHR_FONT
	ld	de,CHRTBL+8
	ld	b,2
	call	LDIRVM
	
; define font colour
	ld	hl,CLRTBL
	ld	b,2
	ld	a,0F0h
	call	FILVRM

; Execution continues with main menu section
;-------------------------------------------------------------

;-------------------------------------------------------------
MAIN_MENU:
;-------------------------------------------------------------
; Manages the main menu of the game
;-------------------------------------------------------------

; intro sound - changing noise to tune and back
        ld      a,0B9h
        ld      [PSG_DATA+5],a
        call    PSG_SOUND
        ld      a,0ABh
        ld      [PSG_DATA+5],a

; clear top of the screen
	call	CLEAR_TOP

; enable screen
	call	ENASCR

; print copyright notice
	ld	hl,TXT_COPYRIGHT
	call	DISPLAY_TEXT

; print title - MONKEY
	ld	hl,TXT_TITLE
	call	DISPLAY_TEXT

; draw both monkeys
	ld	hl,ATR_MENU
	ld	de,SPRITES
        ld      bc,4*5+1
	ldir

; init game variables (PLAYER, SCOREs and ROUND)
        xor     a
	ld	hl,PLAYER
	ld	[hl],a
	inc	hl
	ld	[hl],a
	inc	hl
	ld	[hl],a
        inc     hl
        inc     a
        ld      [hl],a

; wait for button pressed while the monkeys dance

@@MAIN:

; wait 8 frames
        ld      b,8
@@WAIT:
	halt
	djnz	@@WAIT

; update monkey sprites to animate
	ld	b,4
	ld	hl,SPRITES+2
@@ANIMATE:
	ld	a,08h
	xor	[hl]
	ld	[hl],a
	inc	hl
	inc	hl
	inc	hl
	inc	hl
	djnz	@@ANIMATE

	call	UPDATE_SPRITES

; ESC key exits game - implemented for binary file only
ifdef   TEST_VERSION
; do nothing if it is a ROM
else
; check if ESC is pushed
	ld	a,7
	call	SNSMAT
	cp	0FBh
	ret	z
endif

; wait button
	call	GET_BUTTON
	jr	z,@@MAIN

; choose monkey
	ld	a,r
	and	01h
	ld	[PLAYER],a

; set normal sprite size
        call    SWITCH_SIZE

; clear screen top
	call	CLEAR_TOP

; print score info for both players
	ld	hl,TXT_SCORE_P1
	call	DISPLAY_TEXT

	ld	hl,TXT_SCORE_P2
	call	DISPLAY_TEXT

; program execution continues with level initialization 
;-------------------------------------------------------------

;-------------------------------------------------------------
INIT_LEVEL:
;-------------------------------------------------------------
; Init a game round
;-------------------------------------------------------------

; init angle and speed parameters for both players
	ld	a,9
	ld	hl,ANGLE
	ld	[hl],a
	inc	hl
	ld	[hl],a
	inc	a
	inc	hl
	ld	[hl],a
	inc	hl
	ld	[hl],a

; hide sprites
	ld	a,208
	ld	hl,SPRATR
	call	WRTVRM

; clear playfield
	call	CLEAR_PLAYFIELD

; determine round number
        ld      a,[ROUND]
        inc	a
        ld      [TXT_ROUND+7],a

; print round number
        ld      hl,TXT_ROUND
        call    DISPLAY_TEXT

; draw random buildings
	ld	hl,CLRTBL+0800h

@@BUILDING:

; define random width (32-56 pixels)
        ld      a,r
        ld      d,a
        and     38h
        or	20h
	ld	e,a

; width adjust
	add	l
	jr	nc,@@WIDTH_OK
	xor	a
	sub	l
	ld	e,a

@@WIDTH_OK:

; define random height (16-120 pixels)
        ld      a,d
        and     0Ch
        or      02h
	ld	d,a

	push	hl

; define random colour (red, yellow, green, blue)
	ld	a,r
	and	18h
	ld	ix,CHR_BRICK
	ld	iy,CLR_BRICK
	ld	c,a
	ld	b,0
	add	iy,bc
	
; adjust start
	ld	a,h
	add	10h
	sub	d
	ld	h,a
	
	ld	b,e
	ld	c,d
	
; render building

@@INNER:
	push	bc
	push	hl
	push	ix
	push	iy

; render building brick line

@@OUTER:

; draw colour
	ld	a,[iy]
	call	WRTVRM

; draw shape
        ld      a,h
        sub     20h
        ld      h,a
	ld	a,[ix]
	call	WRTVRM

; readjust pointers
        ld      a,h
        add     20h
        ld      h,a
	inc	hl
	inc	ix
	inc	iy
	ld	a,l

; check if pattern finished
	and	07h
	jr	nz,@@OK
	pop	iy
	pop	ix
	push	ix
	push	iy
@@OK:
	djnz	@@OUTER
	pop	iy
	pop	ix
	pop	hl
	inc	h
	pop	bc
	dec	c
	jr	nz,@@INNER

; check if building done
	pop	hl
	ld	a,e
	add	l
	ld	l,a

	jr	nz,@@BUILDING

; enter monkeys
        ld      hl,ATR_FALL
        ld      de,SPRITES
        ld      bc,4*5
        ldir
	
; monkey fall
@@FALL:

; redraw sprites
        halt
        call    UPDATE_SPRITES

; init monkeys
        ld      hl,SPRITES
        ld      bc,0200h

; individual monkey fall

@@CHECK:
	push	hl
        push    bc
	ld	e,[hl]
	inc	hl
	ld	d,[hl]
	ex	de,hl

; check if it the monkey is over a building
        ld      bc,0211h
	add	hl,bc
	call	GET_PIXEL

        pop     bc
	pop	hl
	jr	nz,@@CONTINUE

; move down the monkey

@@DOWN:
	inc	c
	inc	[hl]
	inc	[hl]
	inc	hl
	inc	hl
	inc	hl
	inc	hl
	inc	[hl]
	inc	[hl]

; next monkey
@@CONTINUE:	
	ld	hl,SPRITES+8

; check if both have contacted
	djnz	@@CHECK	

	ld	a,c
	or	a
	jr	nz,@@FALL

; done falling
@@DONE:


;-------------------------------------------------------------
CONTROL_SHOOT:
;-------------------------------------------------------------
; Control each shooting
;-------------------------------------------------------------

; select the other monkey
	call	SWITCH_MONKEY

; clean screen
	call	CLEAR_UPPER

; locate banana acording to the selected monkey
	ld	a,[PLAYER]
	ld	hl,SPRITES
	or	a
	jr	z,@@BANANA
	ld	hl,SPRITES+2*4
@@BANANA:
	ld	de,SPRITES+4*4
	ld	a,[hl]
	sub	16
	ld	[de],a
	inc	hl
	inc	de
	ld	a,[hl]
	ld	[de],a

; set the armed monkey sprite
        ld      e,b
	call	CHANGE_MONKEY

;        call    UPDATE_SPRITES

; parameter adjust loop
CONTROL_LOOP:

; update angle and speed values
	halt

; determine final screen position
	ld	hl,TXT_ANGLE
	ld	de,ANGLE
	ld	bc,2105h
	ld	a,2

; display parameter line
@@LINE:

; determine left or right side
	push	af
	push	hl
	ld	a,[PLAYER]
	or	a
	jr	z,@@OK
	ld	a,22
	add	b
	ld	b,a

; define string position
@@OK:
	ld	[hl],b
	
	ld	a,l
	add	7
	ld	l,a

; store value
	ld	a,[de]
	or	a
	ld	b,a
	ld	a,00h

; check if zero
	jr	z,@@DONE

; convert decimal to packed BCD

@@LOOP:
	add	c
	daa
	djnz	@@LOOP

@@DONE:

; print most significant digit
        ld      c,a
        rrca
        rrca
        rrca
        rrca
        and     0Fh
	inc	a

	ld	[hl],a
	inc	hl	

; print least significant digit
        ld      a,c
        and     0Fh
        inc     a
	ld	[hl],a

; display line
	pop	hl
	call	DISPLAY_TEXT

; next line
	pop	af
	ld	hl,TXT_SPEED
        ld      de,SPEED
        ld      bc,4101h

; check if done
        dec     a
        jr      nz,@@LINE

        ld      b,a

; read joystick button / spacebar
	call	GET_BUTTON
	jr	nz,SHOOT_BANANA

; read joystick position / cursor keys
	call	GET_STICK

; manage if button is already pressed
	ld	hl,FRAME_CONTROL
        or      a
        jr      nz,@@CONTINUE
        ld      [hl],2
@@CONTINUE:
	dec	[hl]
	jr	nz,CONTROL_LOOP

; init wait counter
        ld      [hl],10

	ld	hl,ANGLE

        ld      b,a
        ld      a,[PLAYER]
	or	a
	jr	z,@@NORMAL

; invert speed handling for 2P

	ld	a,b
	and	03h
	xor	03h
	jr	nz,@@NORMAL	
	ld	a,b
	xor	4
	ld	b,a	

; check for controls
@@NORMAL:

; check if up direction
        ld      a,b
	cp	1
	jr	nz,@@NO_UPS

; up direction - increase angle
	ld	a,[hl]
	cp	18
        jr      z,@@START
	inc	a

; update modified parameter

@@UPDATE:
	ld	[hl],a
@@START:
        jp      CONTROL_LOOP

; check if down direction

@@NO_UPS:
	cp	5
	jr	nz,@@NO_DOWN

; down direction - decrease angle
	ld	a,[hl]
	or	a
	jr	z,@@START
	dec	a
        jr      @@UPDATE

; check if right/left direction

@@NO_DOWN:
	inc	hl
	inc	hl
	cp	3
	jr	nz,@@NO_RIGHT

; right direction - increase speed
	ld	a,[hl]
	cp	25
	jr	z,@@START
	inc	a
        jr      @@UPDATE

; check if left/right direction

@@NO_RIGHT:
	cp	7
	jr	nz,@@START

; left direction - decrease speed
	ld	a,[hl]
	dec	a
	jr	z,@@START
        jr      @@UPDATE 
		
; Handle banana shooting

SHOOT_BANANA:

; determine angle
	ld	a,[ANGLE]
	ld	c,a

; read corresponding cos for the angle
@@DONE:
	ld	hl,TABLE_COS
	add	hl,bc
	push	bc
	ld	e,[hl]
	ld	d,b
	ld	h,b
	ld	l,b

; multiply cosinus by speed
	ld	a,[SPEED]
	ld	b,a
@@HORIZONTAL_SPEED:
	add	hl,de
	djnz	@@HORIZONTAL_SPEED

; invert horizontal speed for 2P
	ld	a,[PLAYER]
	or	a
	jr	z,@@OK_HORIZONTAL
	ex	de,hl
	ld	h,b
	ld	l,b
	sbc	hl,de

; store horizontal speed

@@OK_HORIZONTAL:
	ld	[BANANA_VX],hl

; read corresponding sin for the angle
; maths: sin(x)=cos(90-x) for 0<=x<=90
	pop	bc
	ld	hl,TABLE_COS+18
	sbc	hl,bc
	ld	e,[hl]
	ld	d,b
	ld	h,b
	ld	l,b

; multiply sinnus by speed
	ld	a,[SPEED]
	ld	b,a
@@VERTICAL_SPEED:
	xor	a
	sbc	hl,de
	djnz	@@VERTICAL_SPEED

; store vertical speed
	ld	[BANANA_VY],hl
	
; copy banana sprite coordinates to fixed-point coordinates
	ld	hl,BANANA_X
	xor	a
	ld	[hl],a
	inc	hl
	ld	a,[SPRITES+4*4+1]
	ld	[hl],a
	inc	hl
	xor	a
	ld	[hl],a
	inc	hl
	ld	a,[SPRITES+4*4]
	ld	[hl],a

; display throwing monkey
	ld	e,8
	call	CHANGE_MONKEY

; main calculation loop

LOOP:

; horizontal calculation
	ld	hl,[BANANA_X]
	ex	de,hl
	ld	hl,[BANANA_VX]
	add	hl,de
	ld	[BANANA_X],hl

; copy x coord to sprite table
	ld	a,h
	ld	[SPRITES+4*4+1],a

; vertical calculation
	ld	hl,[BANANA_AY]
	ex	de,hl
	ld	hl,[BANANA_VY]
	add	hl,de
	ld	[BANANA_VY],hl
	ex	de,hl
	ld	hl,[BANANA_Y]
	add	hl,de
	ld	[BANANA_Y],hl

; copy y coord to sprite table
	ld	a,h
	ld	[SPRITES+4*4],a

; set height as LSB frequency for channel C
        ld      e,a
        ld      a,4
        call    WRTPSG

; set amplitude for channel C
        ld      e,7
        ld      a,10
        call    WRTPSG

; determine frame number
        ld      hl,FRAME_CONTROL
	inc	[hl]
	ld	a,[hl]
	and	03h
	add	a
	add	a

        ld      hl,SPRITES
        add     l
        ld      l,a

        push    hl
        call    SWAP_PLANES

; dump sprites
	halt
        call    UPDATE_SPRITES

        pop     hl
        call    SWAP_PLANES

; check if sprite collision
	ld	a,[STATFL]
	and	20h
	jr	nz,@@IMPACT

; check if buildings are hit
        ld      hl,[SPRITES+4*4]
	push	hl
        ld      de,0707h
	add	hl,de
	call	GET_PIXEL
	pop	hl

; if not hit repeat calculation loop
        jp      z,LOOP

; building hit
	ld	b,16
@@DESTROY:

; stop if bottom of screen is reached
	ld	a,191
	cp	l
	jr	c,@@DONE
	
	push	bc
	push	hl

        ld      c,h
        ld      e,l

; fix transparent colour
        xor     a
	ld	[ATRBYT],a

; determine coords
        ld      d,a
        ld      b,a
	ld	h,a

; map coords to physical address
        call    MAPXYC

; draw a 16-pixel wide horizontal line
	ld	l,16
	ld	h,0
	call	NSETCX
	pop	hl
	pop	bc
	inc	l

; repeat until height is 16
	djnz	@@DESTROY

@@DONE:

; effects
        call    HIT_PROCESS

; next shoot
        jp      CONTROL_SHOOT

; monkey hit
@@IMPACT:
; standing monkey
        call    HIT_PROCESS

; erase banana
	ld	hl,SPRITES+4*4
	ld	a,208
	ld	[hl],a

; determine side of collision
	inc	hl
	ld	a,[hl]
	and	80h
	ld	de,NAMTBL+30
	ld	hl,SCORE+1
	jr	z,@@OK
	ld	a,1
	ld	e,5
	dec	hl
@@OK:
	push	af
	push	de
	push	hl

; change monkey to hurt position
	ld	hl,PLAYER
	ld	d,[hl]
	push	hl
	push	de
	ld	[hl],a
	ld	e,24
	call	CHANGE_MONKEY
	
	pop	af	
	pop	hl
	ld	[hl],a
		
; update sprites
;        call    UPDATE_SPRITES

; increase score
	pop	hl
	inc	[hl]
	ld	a,[hl]
	inc	a
	pop	hl
	call	WRTVRM

; wait some time (120 frames = 2 seconds at 60Hz)
	ld	b,120
@@WAIT:
	halt
	djnz	@@WAIT

; increase round number
	ld	hl,ROUND
	inc	[hl]

; test if game is over
	cp	6
	pop	bc
        jp      nz,INIT_LEVEL
	
; end of game
	ld	a,b
	ld	[PLAYER],a

; clear screen
	call	CLEAR_PLAYFIELD

; display sprites as at start
	ld	hl,ATR_MENU
	ld	de,SPRITES
        ld      c,4*4
	ldir

; set looser as hurt
	ld	e,24
	call	CHANGE_MONKEY

; set magnified sprites
	call	SWITCH_SIZE

; determine winner message
	call	SWITCH_MONKEY
	ld	a,[PLAYER]
	inc	a
	inc	a
        ld      [TXT_WINS+2],a
	ld	e,0

; restore positions
	call	CHANGE_MONKEY
;        call    UPDATE_SPRITES

; print who is the winner
	ld	hl,TXT_WINS
	call	DISPLAY_TEXT

; wait 256 frames (aprox. 4-5 seconds)
@@WAIT2:
	halt
	djnz	@@WAIT2

; back to main menu
        jp      MAIN_MENU
;-------------------------------------------------------------

;-------------------------------------------------------------
SWAP_PLANES:
;-------------------------------------------------------------
; convert to pointer
        ld      de,SPRITES+4*4
        ld      b,4
@@COPY:
        ld      a,[de]
        ld      c,[hl]
        ld      [hl],a
        ld      a,c
        ld      [de],a
        inc     hl
        inc     de
        djnz    @@COPY
        ret
;-------------------------------------------------------------

;-------------------------------------------------------------
HIT_PROCESS:
;-------------------------------------------------------------
; Common code for hits
;-------------------------------------------------------------
; Input:    none
; Output:   none
; Modifies: AF,BC,E,HL,EI
;-------------------------------------------------------------
; set standing monkey
	ld	e,16
	call	CHANGE_MONKEY
; replay exploding sound
        jr      PSG_SOUND
;-------------------------------------------------------------

;-------------------------------------------------------------
PSG_SOUND:
;-------------------------------------------------------------
; Copy a set of values to PSG registers
;-------------------------------------------------------------
; Input:    none
; Output:   none
; Modifies: AF,B,E,HL,EI
;-------------------------------------------------------------
; start at register 2 and copy 13 bytes
        ld      hl,PSG_DATA
        ld      a,2
        ld      b,13
@@LOOP:
; write to PSG register using BIOS
        ld      e,[hl]
        call    WRTPSG
        inc     hl
        inc     a
        djnz    @@LOOP
        ret
;-------------------------------------------------------------

;-------------------------------------------------------------
SWITCH_MONKEY:
;-------------------------------------------------------------
; Change player
;-------------------------------------------------------------
; Input:    none
; Output:   none
; Modifies: AF,BC,HL
;-------------------------------------------------------------
; switch player id
	ld	hl,PLAYER
	ld	a,1
	xor	[hl]
	ld	[hl],a
; exchange angle and speed parameters
	ld	hl,ANGLE
	ld	b,2
; swap two consecutive bytes
@@SWAP:
	ld	a,[hl]
	inc	hl
	ld	c,[hl]
	ld	[hl],a
	dec	hl
	ld	[hl],c
	inc	hl
	inc	hl
        djnz    @@SWAP
	ret
;-------------------------------------------------------------

;-------------------------------------------------------------
CHANGE_MONKEY:
;-------------------------------------------------------------
; Change current monkey sprite for animation
;-------------------------------------------------------------
; Input:    E= number of sprite plane
; Output:   none
; Modifies: AF,HL
;-------------------------------------------------------------
; define sprite plane for P1
	ld	hl,SPRITES+2
	ld	a,[PLAYER]
	or	a
	jr	z,@@OK
; define sprite plane for P2
	ld	hl,SPRITES+2+8
@@OK:
; read sprite pattern
	ld	a,[hl]
; keep direction
	and	80h
; add desired pattern
	or	e
; store to current plane
	ld	[hl],a
; adjust for next plane
	inc	hl
	inc	hl
	inc	hl
	inc	hl
	add	4
	ld	[hl],a
;-------------------------------------------------------------

;-------------------------------------------------------------
UPDATE_SPRITES:
;-------------------------------------------------------------
; Update sprite attribute table
;-------------------------------------------------------------
; Input:    none
; Output:   none
; Modifies: AF,BC,DE,HL,EI
;-------------------------------------------------------------
	ld	hl,SPRITES
	ld	de,SPRATR
	ld	bc,4*5+1
        jp      LDIRVM
;-------------------------------------------------------------

;-------------------------------------------------------------
DISPLAY_TEXT:
;-------------------------------------------------------------
; Print a text to screen
;-------------------------------------------------------------
; Input:    HL= pointer to formated text
; Output:   none
; Modifies: AF,DE,HL,EI
;-------------------------------------------------------------
; read screen destination
	ld	e,[hl]
	inc	hl
	ld	d,NAMTBL>>8
	ex	de,hl
; read and print every char

@@CHAR:
	ld	a,[de]
	or	a

; end if char 00h is found
	ret	z
	call	WRTVRM
	inc	hl
	inc	de
	jr	@@CHAR
;-------------------------------------------------------------
	
;-------------------------------------------------------------
GET_BUTTON:
;-------------------------------------------------------------
; Get space / button for current player
;-------------------------------------------------------------
; Input:    none
; Output:   A = direction code
; Modifies: AF,BC,EI
;-------------------------------------------------------------
; read spacebar
	xor	a
	call	GTTRIG
	ret	nz
; read joystick button
	ld	a,[PLAYER]
	inc	a
        jp      GTTRIG
;-------------------------------------------------------------

;-------------------------------------------------------------
GET_STICK:
;-------------------------------------------------------------
; Get cursor and joystick position for current player
;-------------------------------------------------------------
; Input:    none
; Output:   A = direction code
; Modifies: AF,B,DE,HL,EI
;-------------------------------------------------------------
; read cursor keys
	xor	a
	call	GTSTCK
	or	a
	ret	nz
; read joystick direction
	ld	a,[PLAYER]
	inc	a
        jp      GTSTCK
;-------------------------------------------------------------

;-------------------------------------------------------------
GET_PIXEL:
;-------------------------------------------------------------
; Get pixel colour
;-------------------------------------------------------------
; Input:    H= vertical position; L= horizontal position
; Output:   A= pixel colour
; Modifies: AF,BC,DE,HL,EI
;-------------------------------------------------------------
; check if lower limit
	ld	a,l
	and	0C0h
	ret	z

; copy coords
        ld      c,h
        ld      e,l
        xor     a
        ld      d,a
        ld      b,a

; set corresponding physical address
        call    MAPXYC

; read pixel colour
        call    READC

; done if not zero
        or	a
        ret     nz

; move to the right one pixel
        call    RIGHTC

; move down one pixel
        call    DOWNC

; read pixel colour
        call    READC
        or      a
        ret
;-------------------------------------------------------------

;-------------------------------------------------------------
SWITCH_SIZE:
;-------------------------------------------------------------
; Switch to 16x16 normal/magnified sprites
;-------------------------------------------------------------
; Input:    none
; Output:   none
; Modifies: AF,BC,EI
;-------------------------------------------------------------
; read VDP register #1 copy
        ld      a,[RG1SAV]

; change LSB
        ld      c,1
        xor     c
        ld      b,a

; write to VDP
        jp      WRTVDP
;-------------------------------------------------------------

;-------------------------------------------------------------
CLEAR_UPPER:
;-------------------------------------------------------------
; Erase lines 1-7
;-------------------------------------------------------------
; Input:    none
; Output:   none
; Modifies: AF,BC,HL,EI
;-------------------------------------------------------------	
; set parameters to c
	ld	hl,NAMTBL+32
	ld	bc,224

; erase VRAM
CLEANNING:
	xor	a
        jp      FILVRM

;-------------------------------------------------------------
CLEAR_TOP:
;-------------------------------------------------------------
; Erase lines 1-7
;-------------------------------------------------------------
; Input:    none
; Output:   none
; Modifies: AF,BC,HL,EI
;-------------------------------------------------------------	
	ld	hl,NAMTBL
	ld	bc,0100h
	jr	CLEANNING
;-------------------------------------------------------------
CLEAR_PLAYFIELD:
;-------------------------------------------------------------
; Clear middle and bottom thirds
;-------------------------------------------------------------
; Input:    none
; Output:   none
; Modifies: AF,BC,HL,EI
;-------------------------------------------------------------	
; clear character pattern table
	ld	hl,CHRTBL+0800h
	ld	bc,1000h
	push	bc
	call	CLEANNING

; clear character colour table
	pop	bc
	ld	hl,CLRTBL+0800h
        call    CLEANNING
        jr      CLEAR_UPPER
;-------------------------------------------------------------

;-------------------------------------------------------------
; CONSTANTS AND PREDEFINED VARIABLES
;-------------------------------------------------------------
; Mathematical data
;-------------------------------------------------------------
; cosine table from 0 to 90 degrees, step +5
TABLE_COS:
	angle=0
	rept	19
		db	(fix(0.2*cos(angle*pi/180.0)))&0FFh
		angle=angle+5
	endr

; vertical banana acceleration - g field
BANANA_AY:
	dw	fix(0.05)

;-------------------------------------------------------------
; Graphics
;-------------------------------------------------------------
; Namco arcade font
CHR_FONT:
	db 	01Ch,026h,063h,063h,063h,032h,01Ch,000h	;0
	db 	00Ch,01Ch,00Ch,00Ch,00Ch,00Ch,03Fh,000h	;1
	db 	03Eh,063h,007h,01Eh,03Ch,070h,07Fh,000h	;2
	db 	03Fh,006h,00Ch,01Eh,003h,063h,03Eh,000h	;3
	db 	00Eh,01Eh,036h,066h,07Fh,006h,006h,000h	;4
	db 	07Eh,060h,07Eh,003h,003h,063h,03Eh,000h	;5
	db 	01Eh,030h,060h,07Eh,063h,063h,03Eh,000h	;6
	db 	07Fh,063h,006h,00Ch,018h,018h,018h,000h	;7
	db 	03Eh,063h,063h,03Eh,063h,063h,03Eh,000h	;8
	db 	03Eh,063h,063h,03Fh,003h,006h,03Ch,000h	;9
	db 	000h,000h,000h,03Eh,000h,000h,000h,000h	;-
	db 	000h,000h,000h,000h,000h,00Ch,00Ch,000h	;.
	db 	030h,048h,048h,030h,000h,000h,000h,000h	;o
	db 	000h,000h,000h,07Ch,054h,054h,054h,000h	;m
	db 	03Ch,042h,099h,0A1h,0A1h,099h,042h,03Ch	;(c)
	db 	01Ch,036h,063h,063h,07Fh,063h,063h,000h	;A
	db 	01Eh,033h,060h,060h,060h,033h,01Eh,000h	;C
	db 	07Ch,066h,063h,063h,063h,066h,07Ch,000h	;D
	db 	07Fh,060h,060h,07Ch,060h,060h,07Fh,000h	;E
	db 	01Fh,030h,060h,067h,063h,033h,01Fh,000h	;G
	db 	063h,063h,063h,07Fh,063h,063h,063h,000h	;H
	db 	03Fh,00Ch,00Ch,00Ch,00Ch,00Ch,03Fh,000h	;I
	db 	063h,066h,06Ch,078h,07Ch,06Eh,067h,000h	;K
	db 	060h,060h,060h,060h,060h,060h,07Fh,000h	;L
	db 	063h,077h,07Fh,07Fh,06Bh,063h,063h,000h	;M
	db 	063h,073h,07Bh,07Fh,06Fh,067h,063h,000h	;N
	db 	03Eh,063h,063h,063h,063h,063h,03Eh,000h	;O
	db 	07Eh,063h,063h,063h,07Eh,060h,060h,000h	;P
	db 	07Eh,063h,063h,067h,07Ch,06Eh,067h,000h	;R
	db 	03Ch,066h,060h,03Eh,003h,063h,03Eh,000h	;S
	db 	063h,063h,063h,063h,063h,063h,03Eh,000h	;U
	db 	063h,063h,06Bh,07Fh,07Fh,036h,022h,000h	;W
	db 	033h,033h,033h,01Eh,00Ch,00Ch,00Ch,000h	;Y

; sprite patterns - looking right
SPR_DATA:
; 0 - armed monkey / blue
	db	01h,0Fh,1Eh,3Eh,2Eh,3Fh,37h,1Fh,0Fh,07h,67h,3Fh,07h,07h,00h,00h
	db	0E0h,00h,20h,00h,00h,00h,00h,0C0h,0F0h,0F8h,0F8h,0F8h,0F0h,0F8h,3Ch,00h

; 1 - armed monkey / white
	db	38h,00h,01h,01h,11h,00h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Ch
	db	00h,0D0h,0D0h,0FCh,0FEh,0FEh,0FEh,3Ch,00h,00h,00h,00h,02h,02h,02h,04h

; 2 - throwing monkey / blue
	db	03h,0Eh,3Ch,7Ch,4Ch,74h,76h,3Fh,1Fh,4Fh,4Fh,2Fh,1Fh,3Fh,20h,00h
	db	0C0h,10h,58h,38h,70h,0E0h,0E0h,0C0h,0E0h,0F0h,0F0h,0F0h,0E0h,0C0h,0C0h,00h

; 3 - throwing monkey / white
	db	00h,01h,03h,03h,33h,0Bh,08h,00h,00h,00h,00h,00h,00h,00h,40h,30h
	db	08h,0A8h,0A0h,0C0h,8Ch,1Ch,1Ch,38h,00h,00h,00h,00h,00h,00h,00h,0F0h

; 4 - standing monkey / blue
	db	03h,0Eh,3Ch,7Ch,4Ch,74h,66h,3Fh,1Dh,0Bh,0Ah,4Ah,3Dh,0Fh,18h,00h
	db	0C0h,00h,40h,00h,00h,00h,00h,80h,0E0h,70h,0F0h,0F0h,0E0h,0C0h,0C0h,00h

; 5 - standing monkey / white
	db	00h,01h,03h,03h,33h,0Bh,19h,00h,00h,00h,00h,00h,00h,00h,00h,1Eh
	db	00h,0A0h,0A0h,0F8h,0FCh,0FCh,0FCh,78h,00h,00h,00h,00h,00h,00h,00h,0F0h

; 6 - injured monkey / blue
	db	00h,3Fh,60h,0C0h,0C0h,0C0h,0E0h,30h,1Ch,0FFh,0FFh,5Fh,0Fh,3Fh,46h,03h
	db	00h,00h,00h,00h,00h,00h,00h,10h,70h,0E0h,0F0h,0F8h,0F8h,0BCh,1Ch,0Ch

; 7 - injured monkey / white
	db	00h,00h,1Fh,39h,3Dh,3Fh,1Fh,4Fh,0C3h,00h,00h,00h,00h,00h,00h,00h
	db	00h,00h,80h,00h,60h,0E0h,48h,48h,80h,00h,00h,02h,02h,42h,0C2h,80h

; 8 - banana
	db	00h,00h,00h,00h,00h,00h,00h,00h,00h,01h,07h,7Eh,7Dh,3Bh,17h,03h
	db	00h,3Eh,08h,0Ch,0Ch,16h,36h,76h,0EEh,0DEh,0BEh,7Ch,0FCh,0F8h,0F0h,0C0h

; 9 - G
	db	00h,01h,07h,0Fh,1Eh,3Ch,3Ch,78h,78h,78h,78h,7Ch,3Fh,1Fh,07h,00h
	db	00h,0F8h,0FCh,8Eh,07h,07h,00h,7Fh,7Fh,1Eh,3Eh,7Ch,0F8h,0F0h,80h,00h

; original sprite attributes for main menu
ATR_MENU:
	db	110,96,0,4
	db	110,96,4,14
	db	110,128,0+32*4,13
	db	110,128,4+32*4,14
        db      44,80,36,8
	db	208

; original sprite attributes for falling monkeys
ATR_FALL:
        db      -15,16,4*4,4
        db      -15,16,4*5,14
        db      -15,224,4*4+32*4,13
        db      -15,224,4*5+32*4,14
	db	192,0,8*4,10

; alternative colours for the bricks (red, blue, green, yellow)
CLR_BRICK:
	db	60h,80h,80h,90h,90h,90h,0F0h,00h
	db	40h,40h,050h,050h,70h,70h,0F0h,00h
	db	0C0h,20h,20h,30h,30h,0F0h,0F0h,00h
	db	0D0h,0A0h,0A0h,0B0h,0B0h,0E0h,0F0h,00h

; brick pattern
CHR_BRICK:
	db	77h,77h,77h,77h,77h,77h,77h,00h

;-------------------------------------------------------------
; Sound data
;-------------------------------------------------------------
PSG_DATA:
        db      100,0,0,0,31,0B9h,0,16,0,0,20,9

;-------------------------------------------------------------
; Text strings
;-------------------------------------------------------------
; game title
TXT_TITLE:
	db	32*7+14
	db	11,25,27,26,23,19,33,00h

; round title
TXT_ROUND:
	db	32*7+12
        db      29,27,31,26,18,99,1,00h

; player 1 score
TXT_SCORE_P1:
	db	1
	db	28,2,11,99,1,00h

; player 2 score
TXT_SCORE_P2:
	db	26
	db	28,3,11,99,1,00h

; copyright information
TXT_COPYRIGHT:
	db	6
	db	15,99,23,16,29,27,30,21,22,99,17,27,29,28,12,99,3,1,1,9,0

; player X wins
TXT_WINS:
	db	32*7+12
	db	28,1,99,99,32,22,26,30,00

; angle title and units
TXT_ANGLE:
	db	0,16,26,20,24,19,11,99,99,13,0

; speed title and units
TXT_SPEED:
	db	0,30,28,19,19,18,11,99,99,14,0


;-------------------------------------------------------------

;-------------------------------------------------------------
; VARIABLES
;-------------------------------------------------------------
; sprite attribute RAM table
SPRITES:
	ds	4*5+1

; game parameters
PLAYER:
	ds	1

SCORE:
	ds	2

ROUND:
        ds      1

FRAME_CONTROL:
	ds	1

ANGLE:
	ds	1

BACK_ANGLE:
	ds	1

SPEED:
	ds	1

BACK_SPEED:
	ds	1

; fixed point variables for parabolic calculations
BANANA_X:
	ds	2

BANANA_Y:
	ds	2

BANANA_VX:
	ds	2

BANANA_VY:
	ds	2
;-------------------------------------------------------------

;-------------------------------------------------------------
; PRINT INTERNAL INFORMATION - dumped to G-MONKEY.TXT
;-------------------------------------------------------------
printtext	"[RKOS03] G-MONKEY"
printtext	"(c) Karoshi Corp. 2008"

ifdef	TEST_VERSION
	printtext	"ROM format selected"
else
        printtext	"BASIC binary format selected"
endif

printtext	"Code size:"
print 		SPRITES-0C000h

printtext 	"Variable space:"
print 		$-SPRITES

printtext 	"Memory used including variables:"
print 		$-0C000h
;-------------------------------------------------------------

;-------------------------------------------------------------
; (end of source code)
;-------------------------------------------------------------
