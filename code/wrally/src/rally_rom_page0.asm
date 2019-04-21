; -----------------------------------------------------------------------------
; World Rally
; (c) 2014 theNestruo (Néstor Sancho Bejarano)
; -----------------------------------------------------------------------------
; Almacén de datos comprimidos (página 0)
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Descomprime mapa y eventos
UNPACK_MAP_PAGE0:
; Descomprime mapa y eventos
	ld	hl, MAP_TABLE
	ld	a, [current_stage]
	call	GET_HL_A_A_WORD
	ld	de, map
	jp	UNPACK

; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Descomprime la tabla de patrones ingame
; con las modificaciones al vuelo para poner las iniciales en la pancarta
UNPACK_CHRTBL_INGAME_PAGE0:
; Descomprime patrones ingame
	ld	hl, CHRTBL_INGAME_PACKED
	ld	de, unpack_buffer
	call	UNPACK

; Sobreescribe patrones específicos con las iniciales introducidas

; primera inicial
	ld	hl, initials
	call	@@LOCATE_CHAR
	ld	de, unpack_buffer + CHRTBL_INITIALS_INIT *8 +2
	push	de ; preserva el destino
	ld	bc, 4
	ldir
; parte izquierda de la segunda inicial
	ld	hl, initials + 1
	call	@@LOCATE_CHAR
	pop	de ; restaura el destino
	push	hl ; preserva el origen de la segunda inicial
	ld	b, 4
@@LEFT_LOOP:
; lee el origen en c
	ld	c, [hl]
	inc	hl
; trabaja con el destino en a
	ld	a, [de]
	and	$0f ; deja la primera inicial sólo en la derecha
	sla	a ; deja un pixel de margen
	rl	c ; a <- acumulador <- c (1 bit) x2
	rl	a
	rl	c
	rl	a
	ld	[de], a
	inc	de
	djnz	@@LEFT_LOOP

; tercera inicial
	ld	hl, initials + 2
	call	@@LOCATE_CHAR
	ld	de, unpack_buffer + (CHRTBL_INITIALS_INIT +1) *8 +2
	push	de ; preserva el destino
	ld	bc, 4
	ldir
; parte derecha de la segunda inicial
	pop	de ; restaura el destino
	pop	hl ; restaura el origen de la segunda inicial
	ld	b, 4
@@RIGHT_LOOP:
; lee el origen en c
	ld	c, [hl]
	inc	hl
; trabaja con el destino en a
	ld	a, [de]
	and	$f0 ; deja la tercera inicial sólo en la izquierda
	srl	a ; deja un pixel de margen
	rr	c ; 1 bit: c -> acumulador -> a
	rr	a
	rr	c
	rr	a
	ld	[de], a
	inc	de
	djnz	@@RIGHT_LOOP
	ret

; Localiza la definición de un caracter en fuente pequeña
; param hl: dirección que contiene el caracter a localizar
; ret hl: dirección de la definición del caracter
@@LOCATE_CHAR:
	ld	a, [hl]
	cp	$41 ; "A" ASCII
	jr	c, @@NUMBER
	sub	$41 - $30 - 10 ; "A" ASCII - "0" ASCII - 10
@@NUMBER:
	sub	$30 ; "0" ASCII
	add	a ; a *= 4
	add	a
	ld	hl, SMALL_FONT
	jp	ADD_HL_A
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Datos de mapas y eventos
MAP_TABLE:
	.dw	@@MAP_11_PACKED, @@MAP_12_PACKED, @@MAP_13_PACKED, $0000 ; $0000 = dummy para alinear
	.dw	@@MAP_21_PACKED, @@MAP_22_PACKED, @@MAP_23_PACKED, $0000
	.dw	@@MAP_31_PACKED, @@MAP_32_PACKED, @@MAP_33_PACKED, $0000
	.dw	@@MAP_41_PACKED, @@MAP_42_PACKED, @@MAP_43_PACKED, $0000
	.dw	@@MAP_51_PACKED, @@MAP_52_PACKED, @@MAP_53_PACKED, $0000

; 35º Rallye Sanremo - Rallye d'Italia
@@MAP_11_PACKED:
IFDEF DEBUG_WIPSTAGE
	.incbin	"data/map_wip.tmx.bin.plet5"
ELSE
	.incbin "data/map_perinaldo.tmx.bin.plet5"
ENDIF
@@MAP_12_PACKED:
	.incbin "data/map_totip.tmx.bin.plet5"
@@MAP_13_PACKED:
	.incbin	"data/map_perinaldo.tmx.bin.plet5" ; FIXME Ospedaletti

; 61ème Rallye Automobile de Monte-Carlo
@@MAP_21_PACKED:
	.incbin "data/map_moulinon.tmx.bin.plet5"
@@MAP_22_PACKED:
	.incbin "data/map_sisteron.tmx.bin.plet5"
@@MAP_23_PACKED:
	.incbin "data/map_coldeturini.tmx.bin.plet5"

; 37ème Tour de Corse - Rallye de France
@@MAP_31_PACKED:
	.incbin	"data/map_perinaldo.tmx.bin.plet5" ; FIXME Tarzan
@@MAP_32_PACKED:
	.incbin	"data/map_perinaldo.tmx.bin.plet5" ; FIXME Vari
@@MAP_33_PACKED:
	.incbin	"data/map_perinaldo.tmx.bin.plet5" ; FIXME Kinetta

; 43th 1000 Lakes Rally
@@MAP_41_PACKED:
	.incbin "data/map_myhipaa.tmx.bin.plet5"
@@MAP_42_PACKED:
	.incbin "data/map_konivouri.tmx.bin.plet5"
@@MAP_43_PACKED:
	.incbin "data/map_laajavuori.tmx.bin.plet5"

; 29º Rallye Catalunya-Costa Brava
@@MAP_51_PACKED:
	.incbin	"data/map_perinaldo.tmx.bin.plet5" ; FIXME
@@MAP_52_PACKED:
	.incbin	"data/map_perinaldo.tmx.bin.plet5" ; FIXME
@@MAP_53_PACKED:
	.incbin	"data/map_perinaldo.tmx.bin.plet5" ; FIXME

; Charset ingame comprimido
CHRTBL_INGAME_PACKED:
	.incbin	"gfx/charset_color_ingame.pcx.chr.plet5"
CLRTBL_INGAME_PACKED:
	.incbin "gfx/charset_color_ingame.pcx.clr.plet5"

; Fuente pequeña (iniciales en la pancarta)
SMALL_FONT:
	.incbin "gfx/charset_bw_smallfont.pcx.chr"

; Sprites ingame comprimidos
SPRTBL_EVENTS_PACKED:
	.incbin	"spr/spr_events.pcx.spr.plet5"
	SPRTBL_EVENTS_SIZE equ 56 *32 ; Tamaño sin compresión
SPRTBL_OTHERS_START_PACKED:
	.incbin	"spr/spr_others_start.pcx.spr.plet5"
	SPRTBL_OTHERS_START_SIZE equ 20 *32 ; Tamaño sin compresión
SPRTBL_OTHERS_END_PACKED:
	.incbin	"spr/spr_others_end.pcx.spr.plet5"
	SPRTBL_OTHERS_END_SIZE equ 12 *32 ; Tamaño sin compresión
; -----------------------------------------------------------------------------

	.printtext	" ... packed ingame data (maps, gfx)"
	.printhex	$

; -----------------------------------------------------------------------------
MUSIC_TITLE:
	.incbin	"sfx/test.pt3.plet5"
	.incbin	"sfx/test.pt3.plet5"
	.incbin	"sfx/test.pt3.plet5"
	.incbin	"sfx/test.pt3.plet5"
MUSIC_STAGE_SELECT:
	.incbin	"sfx/test.pt3.plet5"
MUSIC_GAME_OVER:
	.incbin	"sfx/test.pt3.plet5"
	.incbin	"sfx/test.pt3.plet5"
MUSIC_ENDING:
	.incbin	"sfx/test.pt3.plet5"
	.incbin	"sfx/test.pt3.plet5"
	.incbin	"sfx/test.pt3.plet5"
	.incbin	"sfx/test.pt3.plet5"
; -----------------------------------------------------------------------------

	.printtext	" ... packed music"
	.printhex	$

; EOF
