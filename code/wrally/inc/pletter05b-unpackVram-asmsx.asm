;-----------------------------------------------------------
; Pletter v0.5b VRAM Depacker v1.1 - 16 Kb version
; HL = RAM/ROM source 
; DE = VRAM destination
;-----------------------------------------------------------
DEPLET:
	di

; VRAM address setup
	ld	a,e
	out	(099h),a
	ld	a,d
	or	040h
	out	(099h),a

; Initialization
	ld	a,[hl]
	inc	hl
	exx
	ld	de,0
	add	a,a
	inc	a
	rl	e
	add	a,a
	rl	e
	add	a,a
	rl	e
	rl	e
	ld	hl,modes
	add	hl,de
	ld	e,[hl]
	ld	ixl,e
	inc	hl
	ld	e,[hl]
	ld	ixh,e
	ld	e,1
	exx
	ld	iy,loop

; Main depack loop
literal:
	ld	c,098h
	outi
	inc	de
loop:	
	add	a,a
	call	z,getbit
	jr	nc,literal

; Compressed data
	exx
	ld	h,d
	ld	l,e
getlen:
	add	a,a
	call	z,getbitexx
	jr	nc,lenok
lus:
	add	a,a
	call	z,getbitexx
	adc	hl,hl
	ret	c
	add	a,a
	call	z,getbitexx
	jr	nc,lenok
	add	a,a
	call	z,getbitexx
	adc	hl,hl
	jp	c,Depack_out
	add	a,a
	call	z,getbitexx
	jp	c,lus
lenok:
	inc	hl
	exx
	ld	c,[hl]
	inc	hl
	ld	b,0
	bit	7,c
	jp	z,offsok
	jp	ix

mode7:
	add	a,a
	call	z,getbit
	rl	b
mode6:
	add	a,a
	call	z,getbit
	rl	b
mode5:
	add	a,a
	call	z,getbit
	rl	b
mode4:
	add	a,a
	call	z,getbit
	rl	b
mode3:
	add	a,a
	call	z,getbit
	rl	b
mode2:
	add	a,a
	call	z,getbit
	rl	b
	add	a,a
	call	z,getbit
	jr	nc,offsok
	or	a
	inc	b
	res	7,c
offsok:
	inc	bc
	push	hl
	exx
	push	hl
	exx
	ld	l,e
	ld	h,d
	sbc	hl,bc
	pop	bc
	push	af
@@loop:	
	ld	a,l
	out	(099h),a
	ld	a,h
	nop			; VDP timing
	out	(099h),a
	nop			; VDP timing
	in	a,(098h)
	ex	af,af'
	ld	a,e
	nop			; VDP timing
	out	(099h),a
	ld	a,d
	or	040h
	out	(099h),a
	ex	af,af'
	nop			; VDP timing
	out	(098h),a
	inc	de
	cpi
	jp	pe,@@loop
	pop	af
	pop	hl
	jp	iy

getbit:
	ld	a,[hl]
	inc	hl
	rla
	ret

getbitexx:
	exx
	ld	a,[hl]
	inc	hl
	exx
	rla
	ret

; Depacker exit
Depack_out:
	ei
	ret

modes:
	dw	offsok
	dw	mode2
	dw	mode3
	dw	mode4
	dw	mode5
	dw	mode6
	dw	mode7

;-----------------------------------------------------------