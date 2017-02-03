/*
-----------------------------------------------------------
                         ROBOTS
-----------------------------------------------------------
 Enjoy the classic Robots game in your MSX computer system
-----------------------------------------------------------
HISTORY
-----------------------------------------------------------
In a near future, some Darwin award winner but unknown nerd
will code a nasty virus that will infect all Z80 based 
robots. All infected robots will become serial killers and
threaten mankind survival.

You've been trapped while trying to destroy one of those
psycho robot factories and now your only chance is fleeing!

Your weapons are useless, but you still have your reliable
but somehow risky 6502 based teleporter.

-----------------------------------------------------------
GAMEPLAY
-----------------------------------------------------------
Dodge the killer robots while trying to make them collide.

If they reach you, you're done. But remember that you carry
your personal teleporter with limited range. Mind that if
your teleport into rubble or robots, your flesh will be
combined at atomical level with a pile of molten metal,
fact extremely incompatible with life.

This game is turn-based, so take your time to decide your
next movement.

-----------------------------------------------------------
CONTROLS
-----------------------------------------------------------
Use cursor keys to move and space to teleport.

-----------------------------------------------------------
TRICKS 
-----------------------------------------------------------
Try to make a barricade of rubble and let the killer robots
smash themselves against it.
Avoid teleporting unless it is mandatory for survival.

-----------------------------------------------------------
GAME REQUIREMENTS 
-----------------------------------------------------------
- An MSX compatible computer with 8 KB RAM
- A human and/or second generation cylon player

-----------------------------------------------------------
CREDITS
-----------------------------------------------------------
Original game created by Tom Arnold.

MSX version created by Michel d'Alger for MSXdev'11

Assembled with asMSX / Linux

-----------------------------------------------------------
LICENCE
-----------------------------------------------------------
This is game is freeware and source code is published under
no licence whatsoever. Make whatever you want to, but it
would be nice from you to include my name into derivatives.
-----------------------------------------------------------

-----------------------------------------------------------
PERSONAL GOAL
-----------------------------------------------------------
My goal was to code a simple game for MSX in less that 1 KB
and to be able to enjoy it. As you will notice, code is not
highly optimized, but works pretty well. So, I guess that I
have more or less succeeded. Enjoy it.

And if you're really whant to share your thoughts about it,
do not hesitate to mail me at 

            micheldalger AD gmail DOT com

One last warning: this game has been fully developed and
tested in Linux, so no real MSX hardware has ever run this
software. If you find any compatibility issue, feel free to
contact me.

-----------------------------------------------------------
                                            23rd april 2011
-----------------------------------------------------------
                                             Michel d'Alger
-----------------------------------------------------------
*/

; full game source code
-----------------------------------------------------------
; system RAM constants
CLIKSW	equ	0F3DBh

-----------------------------------------------------------
; useful VRAM pointers
CHRTBL	equ	0800h
NAMTBL	equ	0000h

-----------------------------------------------------------
; comment next line to generate BIN, CAS and WAV files
MSXDEV=11

-----------------------------------------------------------
; asMSX directives
	.bios
ifdef MSXDEV
	.page	2
	.rom
	.start	INIT
else
	.basic
	.org	0E000h
	.cas	"Robots"
	.wav	"Robots"
endif

-----------------------------------------------------------
; code starts here
INIT:
; disable interrupts
	di

; set interrupt mode
	im	1

; setup stack pointer
	ld	sp,0F380h

; key off
	call	ERAFNK

; screen 0
	call	INITXT

; color 15,0,0
	ld	bc,0F007h
	call	WRTVDP

; screen ,,0 - key click off
	xor	a
	ld	[CLIKSW],a

; clear refresh register
	ld	r,a

; reset hi-score
	ld	hl,0000h
	ld	[BCD_HIGH],hl

; define graphic elements
	ld	hl,CHR_DATA
	ld	de,CHRTBL+8
	ld	bc,8*4
	call	LDIRVM

; copy data to RAM
	ld	hl,TXT_DATA
	ld	de,TXT_RAM
	ld	bc,41
	ldir

; main menu
MENU:

; init level counter and score
	xor	a
	ld	hl,NUM_LEVEL
	ld	b,4
@@INIT:
	ld	[hl],a
	inc	hl
	djnz	@@INIT

; clear screen
	call	CLS

; print data
	ld	hl,TXT_RAM
	call	PRINT_TEXT

; init score counter
	ld	hl,TXT_RAM+18
	xor	a
	call	PRINT_BCD
	xor	a
	call	PRINT_BCD

; print title and copyright
	ld	hl,TXT_MENU
	call	PRINT_TEXT

LEVEL:

; advance to next level
	ld	hl,NUM_LEVEL
	inc	[hl]

; update on-screen level counter
	inc	hl
	ld	a,[hl]
	add	01h
	daa
	ld	[hl],a
	ld	hl,TXT_RAM+8
	call	PRINT_BCD

; wait for button
	call	GET_BUTTON

; clear level data
	ld	hl,BUFFER
	ld	de,BUFFER+940*2
@@CLEAR:
	ld	[hl],0
	inc	hl
	call	DCOMPR
	jr	nz,@@CLEAR

; generate pseudo-random positioned robots
	ld	hl,BUFFER+920
	ld	a,[NUM_LEVEL]
	ld	c,a
	add	a
	add	a
	add	c
	ld	b,a
@@PUT:
	ld	a,r
	ld	e,a
	ld	d,0
	add	hl,de
	ld	[hl],2
	ld	de,BUFFER+920*2
	call	DCOMPR
	jr	c,@@LOCATED
	ld	hl,BUFFER+920
@@LOCATED:
	djnz	@@PUT

; init main character position
	ld	hl,0B13h
	ld	[POSITION],hl
	ld	hl,BUFFER+920+12*40+19
	ld	[hl],0

; main loop
MAIN:

; print data
	ld	hl,TXT_RAM
	call	PRINT_TEXT

; copy from second to first buffer
	ld	hl,BUFFER+920
	ld	de,BUFFER
	ld	bc,920
	ldir

; clear second buffer
	ld	hl,BUFFER+920
	ld	de,BUFFER+921
	ld	bc,919
	ld	[hl],0
	ldir

; update man
	ld	hl,[POSITION]
	call	ENCODE

; check if position is already occupied
	ld	a,[hl]
	or	a
	ld	[hl],4
	push	af
	jr	nz,@@MAN	
	ld	[hl],1
@@MAN:

; wait vertical retrace
	halt

; dump to screen
	ld	hl,BUFFER
	ld	de,NAMTBL+40
	ld	bc,920
	call	LDIRVM

; check if dead
	pop	af
	jp	z,@@ALIVE

; dead sound
	ld	hl,PSG_DEAD
	call	DUMP_PSG

; print game over
	ld	hl,TXT_OVER
	call	PRINT_TEXT

	call	GET_BUTTON
	jp	MENU
	
@@ALIVE:

; check if level cleared
	ld	hl,BUFFER
	ld	bc,920
	ld	a,2
	cpir
	jr	z,@@CONTINUE

; print cleared message
	ld	hl,TXT_CLEARED
	call	PRINT_TEXT
	jp	LEVEL

@@CONTINUE:

; wait until cursor or space released
@@RELEASE:
	xor	a
	call	GTTRIG
	jr	nz,@@RELEASE
	call	GTSTCK
	or	a
	jr	nz,@@RELEASE

@@WAIT:
; wait for cursor key
	xor	a
	call	GTTRIG
	jp	nz,@@TELEPORT
	call	GTSTCK
	or	a
	jr	z,@@WAIT

; get position
	ld	hl,[POSITION]
	
; move up
	cp	1
	jr	nz,@@NO_UP
	ld	a,h
	or	a
	jr	z,@@DONE
	dec	h
	jr	@@UPDATE

; move right
@@NO_UP:
	cp	3
	jr	nz,@@NO_RIGHT
	ld	a,l
	cp	39
	jr	z,@@DONE
	inc	l
	jr	@@UPDATE

; move down
@@NO_RIGHT:
	cp	5
	jr	nz,@@NO_DOWN
	ld	a,h
	cp	22
	jr	z,@@DONE
	inc	h
	jr	@@UPDATE

; move left
@@NO_DOWN:
	cp	7
	jr	nz,@@DONE
	ld	a,l
	or	a
	jr	z,@@DONE
	dec	l
	jr	@@UPDATE

; update man position
@@UPDATE:
	push	hl
	call	ENCODE
	ld	a,[hl]
	or	a
	pop	hl
	jr	nz,@@DONE
	ld	[POSITION],hl
@@DONE:

; move monsters
	ld	hl,BUFFER
	ld	bc,920
@@LOOP:

; check if there is a robot
	ld	a,[hl]
	or	a
	jr	z,@@READY
	dec	a
	jr	z,@@READY
	dec	a
	jr	z,@@ROBOT
	ld	de,920
	add	hl,de
	ld	a,[hl]
	ld	[hl],3
	sbc	hl,de
	cp	2
	jp	nz,@@READY
	push	bc
	push	hl
	jp	@@COLLISION
@@READY:
	inc	hl
	dec	bc
	ld	a,b
	or	c
	jr	nz,@@LOOP

	jp	MAIN

; move robot
@@ROBOT:
	push	bc
	push	hl
	call	DECODE

	ex	de,hl
	ld	hl,[POSITION]

	ld	a,e
	cp	l

	jr	z,@@VERTICAL
	jr	c,@@RIGHT
	dec	e
	jr	@@VERTICAL
@@RIGHT:
	inc	e
	
@@VERTICAL:
	ld	a,d
	cp	h

	jr	z,@@DONE_ROBOT
	jr	c,@@DOWN
	dec	d
	jr	@@DONE_ROBOT
@@DOWN:
	inc	d

@@DONE_ROBOT:
	ex	de,hl
	call	ENCODE
	ld	de,920
	add	hl,de

; check collision
	ld	a,[hl]
	or	a
	ld	[hl],2
	jr	z,@@OK
	ld	[hl],3

@@COLLISION:
; bomb sound
	ld	hl,PSG_BLAST
	call	DUMP_PSG

; increment score
	ld	hl,[BCD_SCORE]
	ld	a,l
	add	01h
	daa
	ld	l,a
	ld	a,h
	adc	00h
	daa
	ld	h,a
	ld	[BCD_SCORE],hl
	ex	de,hl
	ld	hl,TXT_RAM+18
	ld	a,d
	call	PRINT_BCD
	ld	a,e
	call	PRINT_BCD

; check if it is hi-score
	ld	hl,[BCD_HIGH]
	call	DCOMPR
	jr	nc,@@OK

	ex	de,hl
	ld	[BCD_HIGH],hl
	ex	de,hl
	ld	hl,TXT_RAM+34
	ld	a,d
	call	PRINT_BCD
	ld	a,e
	call	PRINT_BCD

@@OK:
	pop	hl
	pop	bc
	jr	@@READY

; teleport procedure
@@TELEPORT:
	ld	hl,PSG_TELEPORT
	call	DUMP_PSG

; generate new pseudo-random position
	ld	hl,0000h
	ld	a,r
	inc	a
	ld	d,0
	ld	e,a
	ld	a,r
	inc	a
	ld	b,a
@@SUM:
	add	hl,de
	djnz	@@SUM
	ld	de,920
	call	DCOMPR
	jr	nc,@@TELEPORT

; relocate man in new position
	ld	de,BUFFER
	add	hl,de
	call	DECODE
	ld	[POSITION],hl

; flash screen
	halt
	ld	bc,0FF07h
	call	WRTVDP
	halt
	ld	bc,0F007h
	call	WRTVDP

	jp	@@UPDATE

;----------------------------------------------------------
PRINT_BCD:
; print BCD value to screen buffer
;----------------------------------------------------------
; Input:  HL - buffer pointer
;         A - BCD data
;----------------------------------------------------------

; first digit
	ld	b,a
	rrca
	rrca
	rrca
	rrca
	and	0Fh
	add	30h
	ld	[hl],a

; second digit
	inc	hl
	ld	a,b
	and	0Fh
	add	30h
	ld	[hl],a
	inc	hl
	ret

;----------------------------------------------------------
DECODE:
; convert buffer coordinates to (H,L)
;----------------------------------------------------------
; Input:  HL - buffer pointer
; Output: HL - (H,L) coordinates 
;----------------------------------------------------------
	ld	bc,BUFFER
	sbc	hl,bc
	ld	bc,40
	ld	de,0
@@VERTICAL:
	xor	a
	sbc	hl,bc
	ld	a,h
	rlca
	jr	c,@@OK_VERTICAL
	inc	d	
	jr	@@VERTICAL

@@OK_VERTICAL:
	add	hl,bc
	ld	e,l
	ex	de,hl
	ret


;----------------------------------------------------------
ENCODE:
; convert (H,L) to buffer coordinates
;----------------------------------------------------------
; Input:  HL - (H,L) coordinates 
; Output: HL - buffer pointer
;----------------------------------------------------------

	inc	h
	ld	b,h
	ld	h,0
	ld	de,40
@@ADD:
	add	hl,de
	djnz	@@ADD

	ld	de,BUFFER-40
	add	hl,de
	ret	

;----------------------------------------------------------
PRINT_TEXT:
; Print positioned text
;----------------------------------------------------------
; Input:  HL - text pointer
;----------------------------------------------------------

	ld	e,[hl]
	inc	hl
	ld	d,[hl]
	inc	hl
	ex	de,hl

@@CHAR:
	ld	a,[de]
	inc	de
	or	a
	jr	z,@@CHECK
	call	WRTVRM
	inc	hl
	jr	@@CHAR
	
@@CHECK:
	ld	a,[de]
	inc	a
	ret	z
	ex	de,hl
	jr	PRINT_TEXT
	
;----------------------------------------------------------
GET_BUTTON:
;----------------------------------------------------------
; wait for release
@@RELEASE:
	xor	a
	call	GTTRIG
	jr	nz,@@RELEASE

; wait for button
@@WAIT:
	xor	a
	call	GTTRIG
	jr	z,@@WAIT

	ret

;----------------------------------------------------------
DUMP_PSG:
; Copy 14 bytes to PSG
;----------------------------------------------------------
; Input:  HL - PSG data pointer
;----------------------------------------------------------
	xor	a
	ld	c,0A1h
	ld	b,14
@@REGISTER:
	out	(0A0h),a
	inc	a
	outi  
	jr	nz,@@REGISTER
	ret

;----------------------------------------------------------
; graphic characters
CHR_DATA:
	db	20h,00h,70h,0A8h,20h,50h,50h,00h
	db	70h,0F8h,00h,0F8h,0F8h,0F8h,50h,00h
	db	00h,20h,10h,30h,78h,0F0h,78h,00h
	db	20h,20h,0F8h,20h,20h,20h,20h,00h

; menu texts
TXT_MENU:
	dw	40*8+17
	db	"ROBOTS",0
	dw	40*12+13
	db	"Push space bar",0
	dw	40*23+10
	db	"Michel d'Alger, 2011",0,0FFh

; level, score and hi-score data
TXT_DATA:
	dw	2
	db	"LEVEL 00  SCORE 00000  HI-SCORE 00000",0,0FFh

; game over
TXT_OVER:
	dw	40*9+15
	db	"GAME  OVER",0,0FFh

; cleared!
TXT_CLEARED:
	dw	40*9+16
	db	"CLEARED!",0,0FFh

; PSG blast sound
PSG_BLAST:
	db	0,0,0,0,0,0,1Fh,87h,10h,10h,10h,0,8,0

; PSG teleport sound
PSG_TELEPORT:
	db	0,0,0,0,0,0,1Fh,0B8h,10h,10h,10h,0,8,0

; PSG teleport sound
PSG_DEAD:
	db	0,1,0,2,0,4,1Fh,0B8h,10h,10h,10h,0,16,4

;----------------------------------------------------------
; print game size including header
print $-8000h

;----------------------------------------------------------
; RAM variables starting at 0E000h (for 8 KB computers)


ifdef MSXDEV
	.org	0E000h
endif

; level number
NUM_LEVEL:
	ds	1

; level BCD counter
BCD_LEVEL:
	ds	1

; BCD score
BCD_SCORE:
	ds	2

; BCD hi-score
BCD_HIGH:
	ds	2

; man position
POSITION:
	ds	2

; text for marker
TXT_RAM:
	ds	41

; game screen buffers (920x2 bytes)
BUFFER:
;----------------------------------------------------------
; (c) Michel d'Alger, 2011
;----------------------------------------------------------
