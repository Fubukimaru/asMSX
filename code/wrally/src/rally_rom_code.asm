; -----------------------------------------------------------------------------
; World Rally
; (c) 2014 theNestruo (Néstor Sancho Bejarano)
; -----------------------------------------------------------------------------
; Código (páginas 1 y 2)
; -----------------------------------------------------------------------------

;
; =============================================================================
; 	Código principal
; =============================================================================
;

; -----------------------------------------------------------------------------
; Punto de entrada de la ROM.
; Inicialización del sistema: stack pointer, slots, RAM, CPU, VDP, PSG, etc.
INIT:
; Re-inicializa el modo de interrupciones y el stack pointer
; (por si la ROM no es lo primero que se ejecuta)
	di
	im	1
	ld	sp, [HIMEM]

; Busca automáticamente slot y subslot de la página 2
	; .search ; (se reemplaza por SETPAGES32K/SETPAGES48K)
	call	SETPAGES48K
	call	RESTOREBIOS
	ei

; RAM: verifica disponibilidad de 16kB
	ld	hl, ram_start
	ld	a, [hl]
	cpl
	ld	[hl], a
	xor	[hl]
	jr	z, @@RAM_OK ; sí

; no: screen 1 y muestra el texto de aviso
	call	INIT32
	ld	hl, TXT_16KB_RAM_REQUIRED
	ld	de, NAMTBL + (SCR_WIDTH - TXT_16KB_RAM_REQUIRED_LENGTH) /2 + 11 *SCR_WIDTH
	ld	bc, TXT_16KB_RAM_REQUIRED_LENGTH
	call	LDIRVM
; bloquea la ejecución
	di
	halt

@@RAM_OK:
; CPU: fuerza el modo Z80
	ld	a, [MSXID3]
	; ld	[msx_version_palette], a
	cp	3 ; 3 = MSX turbo R
	jr	nz, @@CPU_OK
; MSX turbo R: pasa a modo Z80
	ld	a, $80 ; desactiva el LED junto al R800
	call	CHGCPU

@@CPU_OK:
; elige el origen de datos correcto (50Hz o 60Hz)
	ld	a, [MSXID1]
	bit	7, a ; 0=60Hz, 1=50Hz
; Variables dependientes del framerate
	call	BLIT_FRAME_RATE

; VDP: color 15,1,1
	; ld	a, 15
	; ld	[FORCLR], a ; ¿Innecesario?
	ld	a, 1
	; ld	[BAKCLR], a ; ¿Innecesario?
	ld	[BDRCLR], a
; VDP: screen 2
	call	INIGRP
	call	DISSCR
; screen ,2
	ld	hl, RG1SAV
	set	1, [hl]
; screen ,,0
	xor	a
	ld	[CLIKSW], a

; PSG: silencio y copia inicial de los registros
	call	GICINI_BUFFER

; preserva la rutina de interrupción que pudiera existir
	ld	hl, HTIMI
	ld	de, old_htimi_hook
	ld	bc, HOOK_SIZE
	ldir

; Inicializa variables globales (una única vez; se actualizarán según se juege)
	ld	hl, HI_SCORES_0
	ld	de, hi_scores
	ld	bc, HI_SCORES_SIZE
	ldir
; ------VVVV----falls through--------------------------------------------------

; -----------------------------------------------------------------------------
; Bucle principal
MAIN:
; Carga el charset por defecto
	call	INIT_MAIN_CHARSET_SPRTBL

; Pantalla de bienvenida y créditos iniciales
	call	CLS_NAMTBL
	ld	hl, TXT_CREDITS
	ld	de, namtbl_buffer + CREDITS_Y *SCR_WIDTH
	call	PRINT_FULL_TXT

; fundido de entrada y pausa
	call	ENASCR_FADE_IN
	call	TRIGGER_PAUSE_FOUR_SECONDS
	call	DISSCR_FADE_OUT

; Inicia la reprodución de música
	ld	hl, MUSIC_TITLE
	call	INIT_REPLAYER

; Variable temporal para el attract mode
	xor	a
	ld	[tmp_byte], a

@@LOOP:
; attract mode: animación
	call	ATTRACT_MODE_CUTSCENE
	jr	nz, @@SKIP_CUTSCENE
	call	DISSCR
	call	RESTORE_FONT_BANK1
; pantalla de título
	call	ATTRACT_MODE_TITLE_SCREEN
	jr	@@CUTSCENE_OK
@@SKIP_CUTSCENE:
	call	DISSCR_NO_FADE
	call	RESTORE_FONT_BANK1
	call	TITLE_SCREEN
@@CUTSCENE_OK:
	jr	nz, @@DONE
	call	DISSCR_FADE_OUT

; attract mode: información del rally
	call	ATTRACT_MODE_INFO
	jr	nz, @@SKIP_INFO
	call	DISSCR_FADE_OUT
; pantalla de título
	call	ATTRACT_MODE_TITLE_SCREEN
	jr	@@INFO_OK
@@SKIP_INFO:
	call	DISSCR_NO_FADE
	call	TITLE_SCREEN
@@INFO_OK:
	jr	nz, @@DONE
	call	DISSCR_FADE_OUT

; attract mode: tabla de records
	call	CLS_PRINT_TITLE_HI_SCORES
	call	ENASCR_FADE_IN
	call	TRIGGER_PAUSE_FOUR_SECONDS
	jr	z, @@BEST_DRIVERS_OK
; pantalla de título sólo si se pulsó espacio
	call	DISSCR_NO_FADE
	call	TITLE_SCREEN
	jr	nz, @@DONE
@@BEST_DRIVERS_OK:
	call	DISSCR_FADE_OUT

; deja apuntando al siguiente rally para el siguiente bucle
	ld	a, [tmp_byte]
	inc	a
	cp	NUM_RALLIES
	jr	nz, @@A_OK
	xor	a
@@A_OK:
	ld	[tmp_byte], a
; siguiente iteración
	jr	@@LOOP

@@DONE:
; parpadeo
	ld	b, TIMES_BLINK
@@BLINK_LOOP:
	push	bc ; preserva el contador
; elimina el texto
	ld	hl, namtbl_buffer + PUSH_SPACE_Y *SCR_WIDTH
	call	CLEAR_LINE
; volcado y pausa
	call	LDIRVM_NAMTBL
	ld	b, FRAMES_BLINK
	call	WAIT_FRAMES
; texto "Game start"
	ld	hl, TXT_GAME_START
	ld	de, namtbl_buffer + PUSH_SPACE_Y *SCR_WIDTH
	call	PRINT_TXT
; volcado y pausa
	call	LDIRVM_NAMTBL
	ld	b, FRAMES_BLINK
	call	WAIT_FRAMES

	pop	bc ; restaura el contador
	djnz	@@BLINK_LOOP
	call	DISSCR_FADE_OUT
	call	REPLAYER_DONE
; ------VVVV----falls through--------------------------------------------------

; -----------------------------------------------------------------------------
; Comienza una nueva partida
NEW_GAME:
	ld	hl, GLOBALS_0
	ld	de, globals
	ld	bc, GLOBALS_SIZE
	ldir
IFDEF DEBUG_GAMEOVERDEMO
	call	ENASCR
	jp	GAME_OVER
ENDIF
IFDEF DEBUG_ENDDEMO
	call	ENASCR
	jp	CHAMPIONSHIP_OVER
ENDIF
; ------VVVV----falls through--------------------------------------------------

; -----------------------------------------------------------------------------
; Pantalla de introducción de iniciales
NAME_ENTRY:
; inicializa la pantalla
	call	CLS_NAMTBL
	ld	hl, TXT_NAME_ENTRY
	ld	de, namtbl_buffer + 10 *SCR_WIDTH
	call	PRINT_TXT
	call	BLIT_INITIALS
	ld	hl, SPRATR_NAME_ENTRY_0
	ld	de, spratr_buffer
	ld	bc, SPRATR_NAME_ENTRY_0_LENGTH
	ldir

; fundido de entrada y sprites
	call	ENASCR_FADE_IN
	call	LDIRVM_SPRATR

; variables
	xor	a
	ld	[tmp_byte], a ; índice de inicial marcada
	ld	[tmp_frame], a ; no hay pausa inicial porque hay fundido

@@LOOP:
	halt
; Comprueba disparador
IFDEF DEBUG_QUICKPLAY
	jr	@@TRIGGER
ENDIF
	call	GET_TRIGGER
	jr	nz, @@TRIGGER
; Comprueba pausa
	ld	hl, tmp_frame
	ld	a, [hl]
	or	a
	jr	nz, @@PAUSE
; Comprueba cambio de opción
	call	GET_STICK
	cp	5
	jr	z, @@DOWN
	cp	1
	jr	nz, @@LOOP
	; jr	@@UP ; falls through
@@UP:
	call	GET_INITIAL
; sube una letra
	cp	$5a ; "Z" ASCII
	jr	nz, @@INC_NO_Z
	ld	a, $30 ; "0" ASCII
	jr	@@A_OK
@@INC_NO_Z:
	cp	$39 ; "9" ASCII
	jr	nz, @@INC_NO_9
	ld	a, $41 ; "A" ASCII
	jr	@@A_OK
@@INC_NO_9:
	inc	a
	jr	@@A_OK
@@DOWN:
	call	GET_INITIAL
; baja una letra
	cp	$41 ; "A" ASCII
	jr	nz, @@DEC_NO_A
	ld	a, $39 ; "9" ASCII
	jr	@@A_OK
@@DEC_NO_A:
	cp	$30 ; "0" ASCII
	jr	nz, @@DEC_NO_0
	ld	a, $5a ; "Z" ASCII
	jr	@@A_OK
@@DEC_NO_0:
	dec	a
	; jr	@@A_OK ; falls through
@@A_OK:
; refresca el cambio de letra
	ld	[hl], a
	call	BLIT_INITIALS
	call	LDIRVM_SPRATR
	call	LDIRVM_NAMTBL
; pausa para evitar un movimiento del cursor demasiado rápido
	ld	a, FRAMES_INPUT_PAUSE
	ld	[tmp_frame], a
	jr	@@LOOP

@@PAUSE:
	; ld	hl, tmp_frame ; innecesario
	dec	[hl]
	jr	@@LOOP

@@TRIGGER:
; ¿es la última inicial?
	ld	hl, tmp_byte
	ld	a, [hl]
	cp	2
	jr	z, NEW_RALLY
; no: fija la letra y mueve el sprite
	inc	[hl] ; cambia la inicial apuntada
	ld	a, [spratr_buffer_menu + 1]
	add	16 ; moverá el sprite 16 píxeles
	ld	[spratr_buffer_menu + 1], a
	call	LDIRVM_SPRATR
	jr	@@LOOP
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Pantalla de selección de rally
NEW_RALLY:
; Restura el charset por defecto (podía haber una animación en el banco central)
	call	RESTORE_RALLIES_FONT_BANK1

	call	CLS_NAMTBL
	ld	hl, TXT_RALLY_SELECT
	ld	de, namtbl_buffer + (RALLY_OPTIONS_Y -2) *SCR_WIDTH
	call	PRINT_TXT
	ld	hl, SPRATR_RALLY_SELECT_0
	ld	de, spratr_buffer
	ld	bc, SPRATR_RALLY_SELECT_0_LENGTH
	ldir
; logotipos de los rallies
	ld	a, CHRTBL_RALLIES_INIT
	ld	b, NUM_RALLIES
	ld	de, rally_status
	ld	hl, namtbl_buffer + RALLY_OPTIONS_X + RALLY_OPTIONS_Y *SCR_WIDTH
@@PRINT_LOOP:
	push	bc ; preserva contador
; selecciona el logotipo activado / desactivado
	push	af ; preserva caracter a utilizar
	ld	a, [de]
	and	RALLY_FLAG_FINISHED | RALLY_FLAG_LOCKED
	jr	nz, @@DISABLED
; logo activado
	pop	af ; restaura caracter a utilizar
	call	PRINT_RALLY_LOGO_A_OK
	add	16 ; salta la versión desactivada
	jr	@@NEXT
@@DISABLED:
; logo desactivado
	pop	af ; restaura caracter a utilizar
	add	16 ; salta a la versión desactivada
	call	PRINT_RALLY_LOGO_A_OK
@@NEXT:
; siguiente rally
	inc	de
	ld	bc, SCR_WIDTH -8 + SCR_WIDTH
	add	hl, bc
	pop	bc ; restaura contador
	djnz	@@PRINT_LOOP

; fundido de entrada y sprites
	ld	hl, MUSIC_STAGE_SELECT
	call	INIT_REPLAYER
	call	LDIRVM_NAMTBL_FADE_INOUT
	call	LDIRVM_SPRATR

; Selecciona un rally
	xor	a
	ld	[tmp_byte], a ; opción marcada
	ld	[tmp_frame], a ; no hay pausa inicial porque hay fundido
@@LOOP:
	ld	bc, (NUM_RALLIES -1) * 256 + 24 ; NUM_RALLIES opciones, saltos de 24 píxeles
	call	GET_CURSOR_OPTION
; Comprueba si la selección es válida
	ld	hl, tmp_byte
	ld	b, 0
	ld	c, [hl] ; en c además se preserva tmp_byte
	ld	hl, rally_status ; hl = rally_status + tmp_byte
	add	hl, bc
	ld	a, [hl]
	and	RALLY_FLAG_FINISHED | RALLY_FLAG_LOCKED
	jr	nz, @@LOOP

; Selección válida: la guarda como nivel actual
	ld	a, c ; a = c*4
	add	a
	add	a
	ld	[current_stage], a

; Parpadeo
	call	BLINK_CURSOR

; Resetea los tiempos del rally actual
	ld	a, $ff
	ld	hl, current_rally_stage_times
	ld	de, current_rally_stage_times +1
	ld	bc, CURRENT_RALLY_STAGE_TIMES_LENGTH -1
	ld	[hl], a
	ldir
	xor	a
	ld	[current_rally_total_time], a
	ld	[current_rally_total_time +1], a

	call	REPLAYER_DONE
; ------VVVV----falls through--------------------------------------------------

; -----------------------------------------------------------------------------
; Empieza un nuevo tramo: muestra pantalla de información,
; lo carga y muestra la animación inicial
NEW_STAGE:
; Pantalla de presentación del tramo
	call	CLS_NAMTBL
	ld	a, SPAT_OB
	ld	[spratr_buffer], a
; indicador de rally y tramo
	ld	a, [current_stage]
	ld	de, namtbl_buffer + TXT_SPECIAL_STAGE_X + 12 *SCR_WIDTH
	call	PRINT_STAGE_ID
; logotipo del rally
	ld	hl, namtbl_buffer + 12 + 9 * SCR_WIDTH
	ld	a, [current_stage]
	sra	a
	sra	a
	call	PRINT_RALLY_LOGO
; límite de tiempo
	ld	hl, TXT_TIME_LIMIT
	ld	de, namtbl_buffer + TXT_TIME_LIMIT_X + 14 *SCR_WIDTH
	ld	bc, TXT_TIME_LIMIT_LENGTH
	ldir
	ld	a, [seconds_per_stage]
	add	$30 ; "0" ASCII
	ld	[namtbl_buffer + TXT_TIME_LIMIT_X + TXT_TIME_LIMIT_OFFSET + 14 *SCR_WIDTH], a

; Fundido de entrada, pausa y fundido de salida
	call	LDIRVM_NAMTBL_FADE_INOUT
	call	WAIT_FOUR_SECONDS
	call	DISSCR_FADE_OUT
	call	REPLAYER_DONE

; Deja preparado el mixer para los sonidos ingame
	call	GICINI_BUFFER
	ld	a, 070o ; 111 (noise) - 000 (tone)
	call	SET_PSG_MIXER
	call	WRTPSG_BUFFER
	halt

; Descomprime mapa y eventos
	call	UNPACK_MAP

; Vuelca los patrones y descomprime colores ingame
	call	UNPACK_CHRTBL_INGAME
	call	LDIRVM_CHRTBL
	ld	hl, CLRTBL_INGAME_PACKED
	call	UNPACK_PAGE0_AWARE
	call	LDIRVM_CLRTBL

; Valores iniciales de variables
	ld	hl, INGAME_DATA_0
	ld	de, ingame_data
	ld	bc, INGAME_DATA_0_LENGTH
	ldir
	ld	hl, events
	ld	[current_event_addr], hl

; Descomprime todos los patrones de eventos en el buffer
	ld	hl, SPRTBL_EVENTS_PACKED
	call	UNPACK_PAGE0_AWARE
; Vuelca a SPRTBL los eventos usados en este mapa
	ld	ix, events
	ld	de, SPRTBL + 1024 ; a partir del sprite anterior a la mitad de SPRTBL
@@SPRTBL_EVENTS_LOOP:
	ld	a, [ix + EVENT_TYPE]
	bit	7, a ; 7 = $80 = EVENT_FLAG_FINISH
	jr	nz, @@DONE
	and	EVENT_MASK_SPECIAL
	jr	nz, @@NEXT_EVENT
@@ADD_EVENT_SPRTBL:
; vuelca el sprite del evento correcto
	ld	hl, unpack_buffer
	ld	b, [ix + EVENT_PATTERN] ; bc = patrón
	ld	c, 0
	sra	b ; bc *= 32
	rr	c
	sra	b
	rr	c
	sra	b
	rr	c
	add	hl, bc ; hl = unpack_buffer + patrón *32
; volcado
	ld	bc, 32 ; tamaño de un sprite
	push	bc ; preserva el tamaño de un sprite
	push	de ; preserva el destino
	call	LDIRVM
; avance de punteros
	pop	hl ; restaura el destino
	pop	bc ; restaura el tamaño de un sprite
	add	hl, bc ; avanza el destino
	ex	de, hl
@@NEXT_EVENT:
	ld	bc, EVENT_SIZE
	add	ix, bc
	jr	@@SPRTBL_EVENTS_LOOP
@@DONE:

; Secuencia inicial del nivel
; Limpia los sprites del temporizador (la parte derecha no se sobreescriben)
	ld	hl, SPRTBL + NUM_SPRITES_CAR *32
	ld	bc, NUM_SPRITES_TIMER *32
	xor	a
	call	FILVRM
; Sprites para la salida
; (antes de los datos ingame porque el buffer comparte RAM)
	ld	hl, SPRTBL_OTHERS_START_PACKED
	call	UNPACK_PAGE0_AWARE
	ld	hl, unpack_buffer
	ld	de, SPRTBL + ((NUM_SPRITES_CAR + NUM_SPRITES_TIMER) * 32)
	ld	bc, SPRTBL_OTHERS_START_SIZE
	call	LDIRVM
; Inicializa el scroll
	call	INIT_SCROLL
	call	BLIT_NAMTBL_WITH_OFFSET

; Animación inicial
	call	STAGE_INTRO

; "Ready?"
	ld	hl, SPRATR_INTRO_READY
	ld	de, spratr_buffer_shadow
	ld	bc, SPRATR_INTRO_READY_LENGTH
	ldir
	call	LDIRVM_SPRATR
	call	WRTPSG_BUFFER
IFDEF DEBUG_QUICKPLAY
ELSE
	call	WAIT_TWO_SECONDS
ENDIF
; se muestra el temporizador
	ld	a, TIMER_Y
	ld	[spratr_buffer_timer], a
	ld	[spratr_buffer_timer +4], a
	ld	[spratr_buffer_timer +8], a
	ld	[spratr_buffer_timer +12], a
; "Tres": se vuelca de SPRATR_INTRO_3_2_1
	ld	hl, SPRATR_INTRO_3_2_1
	ld	de, spratr_buffer_countdown
	ld	bc, SPRATR_INTRO_3_2_1_LENGTH
	ldir
	call	LDIRVM_SPRATR
IFDEF DEBUG_QUICKPLAY
ELSE
	call	WAIT_ONE_SECOND
ENDIF
; "Dos", "uno": cambia el patrón
	ld	b, 2
@@COUNTDOWN_LOOP:
	ld	a, [spratr_buffer_countdown +2]
	add	8
	ld	[spratr_buffer_countdown +2], a
	add	4
	ld	[spratr_buffer_countdown +6], a
	push	bc ; preserva b
	call	LDIRVM_SPRATR
IFDEF DEBUG_QUICKPLAY
ELSE
	call	WAIT_ONE_SECOND
ENDIF
	pop	bc ; restaura b
	djnz	@@COUNTDOWN_LOOP
; "Go!": se vuelca de SPRATR_INTRO_GO
	ld	hl, SPRATR_INTRO_GO
	ld	de, spratr_buffer_countdown
	ld	bc, SPRATR_INTRO_GO_LENGTH
	ldir
	call	LDIRVM_SPRATR

; Inicializa las variables necesarias en el bucle principal
	ld	de, [car_xy]
	call	GET_ROAD_PROPERTIES
	ld	[road_properties], a
; ------VVVV----falls through--------------------------------------------------

; -----------------------------------------------------------------------------
; Bucle principal del juego
INGAME_LOOP:
; volcado de VDP y PSG
	call	PREPARE_BLIT_SPRTBL ; pre-halt
IFDEF DEBUG_BDRCLR
	ld	b, 1
	call	SUB_DEBUG_BDRCLR ; parte libre del frame
ENDIF
	halt
IFDEF DEBUG_BDRCLR
	ld	b, 9
	call	SUB_DEBUG_BDRCLR ; volcado de sprites
ENDIF
	call	BLIT_SPRITES ; post-halt
IFDEF DEBUG_BDRCLR
	ld	b, 6
	call	SUB_DEBUG_BDRCLR ; volcado de namtbl
ENDIF
	call	BLIT_NAMTBL_WITH_OFFSET
IFDEF DEBUG_BDRCLR
	ld	b, 3
	call	SUB_DEBUG_BDRCLR ; volcado de PSG
ENDIF
	call	WRTPSG_BUFFER
; lectura del teclado/joystick
IFDEF DEBUG_BDRCLR
	ld	b, 12
	call	SUB_DEBUG_BDRCLR ; control del juego
ENDIF
	call	GET_LR_STRICK
	call	GET_TRIGGER
; control del coche
	ld	hl, scroll_status
	res	SCROLL_BIT_CAR, [hl] ; resetea este flag antes de la actualización del coche
	ld	hl, UPDATE_CAR_JUMP_TABLE
	ld	a, [car_status]
	call	JP_TABLE_A_OK
; colisiones, eventos, temporizador
	call	CHECK_COLLISION
	call	UPDATE_EVENT
	call	UPDATE_TIMER
; scroll, atributos de sprites, sonido para el próximo frame
IFDEF DEBUG_BDRCLR
	ld	b, 7
	call	SUB_DEBUG_BDRCLR ; scroll
ENDIF
	call	UPDATE_CAMERA
IFDEF DEBUG_BDRCLR
	ld	b, 4
	call	SUB_DEBUG_BDRCLR ; preparación de datos para el siguiente frame
ENDIF
	call	UPDATE_CAR_SPRATR
	call	UPDATE_SOUND

IFDEF DEBUG_CHEATS
	call	GET_STICK
	cp	1
	jr	z, @@FINISHING
	cp	5
	jp	z, @@TIME_OVER
ENDIF

; comprueba salida del bucle por "Finish!"
	ld	a, [car_status]
	cp	CAR_FINISH
	jr	z, @@FINISHING ; sí

; comprueba salida del bucle por "Time over"
	ld	a, [time]
	ld	hl, seconds_time_over
	cp	[hl]
	jr	c, INGAME_LOOP ; no

; Mensaje de "Time over" antes de salir de la pantalla de juego
@@TIME_OVER:
; Sustituye los sprites para la salida por los sprites para el final
	call	INIT_INGAME_SPRTBL_END
; "Time over"
	ld	hl, SPRATR_TIME_OVER
	ld	de, spratr_buffer_timer ; sustituye al timer
	ld	bc, SPRATR_TIME_OVER_LENGTH
	ldir
	halt
	call	LDIRVM_SPRATR
; Silencio, pausa y a la pantalla de "Game over"
	call	GICINI_BUFFER
	call	WAIT_FOUR_SECONDS
	call	DISSCR
; Carga el charset por defecto antes de ir a "Game over"
	call	INIT_MAIN_CHARSET_SPRTBL
IFDEF TIME_OVER_GAME_OVER
	jp	GAME_OVER
ELSE
	jp	CONTINUE
ENDIF

; Secuencia de acciones cuando se llega a meta
; y mensaje de "Finish" antes de salir de la pantalla de juego
@@FINISHING:
; ¿se ha excedido el límite de tiempo?
	ld	a, [time]
	ld	hl, seconds_per_stage
	cp	[hl]
	jp	nc, @@FINISHING_LOOP ; sí
; no: restaura el color verde en el temporizador por si había cambiado (últimos segundos)
	ld	a, 2
	call	SET_TIMER_COLOR
@@FINISHING_LOOP:
; Réplica reducida del bucle principal
	halt
; volcado de VDP y PSG
	call	BLIT_SPRITES
	call	BLIT_NAMTBL_WITH_OFFSET
	call	WRTPSG_BUFFER
; control del coche: decelera
	ld	bc, 0 << 8 | DECEL_FINISHING
	call	UPDATE_SPEED_DECELERATE
	ld	a, [speed]
	or	a
	jr	z, @@FINISH ; (el coche ya ha parado)
; atributos de sprites, sonido para el próximo frame
	call	UPDATE_CAR_SPRATR
	call	UPDATE_SOUND
	jr	@@FINISHING_LOOP

@@FINISH:
; Sustituye los sprites para la salida por los sprites para el final
	call	INIT_INGAME_SPRTBL_END
; "Finish"
	ld	hl, SPRATR_FINISH
	ld	de, spratr_buffer_event ; mantiene el timer
	ld	bc, SPRATR_FINISH_LENGTH
	ldir
	halt
	call	LDIRVM_SPRATR

; Silencio, pausa y a la pantalla de fin de tramo
	call	GICINI_BUFFER
	call	WAIT_FOUR_SECONDS
	call	DISSCR
; ------VVVV----falls through--------------------------------------------------

; -----------------------------------------------------------------------------
; Pantalla tras la finalización de un tramo
STAGE_OVER:
; Carga el charset por defecto
	call	INIT_MAIN_CHARSET_SPRTBL

; preserva el tiempo total del rally (para restaurarlo si se continúa)
	ld	hl, current_rally_total_time
	ld	de, current_rally_total_time_backup
	ldi
	ldi

; acumula el tiempo del tramo
	ld	hl, time
; localiza el tiempo del tramo actual
	ld	a, [current_stage]
	and	$03
	add	a
	ld	de, current_rally_stage_times
	add	e ; de += a
	ld	e, a
	adc	d
	sub	e
	ld	d, a
; volcado: primer byte pude tener acarreo a minutos
	ld	a, [hl]
	cp	$06 ; (se puede hacer directamente porque time no almacena minutos)
	jr	c, @@NC_1
; acarrea segundos a minutos
	add	$04
	daa
@@NC_1:
	ld	[de], a
	inc	hl ; time +1
	inc	de ; current_rally_stage_times[i] +1
; volcado: segundo byte tal cual
	ldi

; Suma el tiempo al tiempo total del rally
	ld	hl, current_rally_total_time +1
	dec	de ; current_rally_stage_times[i] +1
	ex	de, hl
; suma: segundo byte
	ld	a, [de]
	add	[hl]
	daa
	ld	[de], a
	dec	de ; current_rally_total_time
	dec	hl ; current_rally_stage_times[i]
; suma: primer byte
	ld	a, [de]
	adc	[hl]
	daa
	ld	[de], a
; verifica acarreo a minutos
	and	$0f
	cp	$06
	jr	c, @@NC_2
; acarrea segundos a minutos
	add	$04
	daa
	ld	[de], a
@@NC_2:

; Pantalla de final de tramo
	ld	a, [current_stage]
	sra	a
	sra	a
	call	CLS_PRINT_RALLY_LOGO
	ld	hl, TXT_STAGE_STANDINGS
	ld	de, namtbl_buffer + (BEST_TIMES_RALLY_Y +3) * SCR_WIDTH
	call	PRINT_TXT

; Textos y tiempos de los tres tramos del rally
	ld	hl, current_rally_stage_times
	ld	de, namtbl_buffer + STAGE_TIMES_X + STAGE_TIMES_Y * SCR_WIDTH
	ld	a, [current_stage]
	and	$fc ; empezamos por el primer rally
	ld	b, 3
@@LOOP:
	push	bc ; preserva el contador
	push	af ; preserva el número de stage
	push	hl ; preserva puntero a información de tiempos
	call	PRINT_STAGE_ID ; Número de tramo
	pop	hl ; restaura puntero a información de tiempos
	inc	de ; separador
	inc	de
	inc	de
	call	PRINT_TIME ; tiempo del trampo
	ex	de, hl
	ld	bc, 2 * SCR_WIDTH - 26
	add	hl, bc
	ex	de, hl
	pop	af ; restaura el número de stage
	inc	a ; siguiente tramo
	pop	bc ; restaura el contador
	djnz	@@LOOP

; Texto y tiempo acumulado total
	ex	de, hl
	ld	bc, SCR_WIDTH
	add	hl, bc
	ex	de, hl
	ld	hl, TXT_TOTAL_TIME
	call	PRINT_TXT_DE_OK
	ex	de, hl ; separador
	ld	bc, SCR_WIDTH - STAGE_TIMES_X - STAGE_TIMES_X - 5 - TXT_NO_TIME_LENGTH ; FIXME!!!
	add	hl, bc
	ex	de, hl
	ld	hl, current_rally_total_time ; tiempo total
	call	PRINT_TIME

; Fundido de entrada y pausa
	call	ENASCR_FADE_IN
	call	WAIT_ONE_SECOND

; ¿se ha excedido el límite de tiempo?
	ld	a, [time]
	ld	hl, seconds_per_stage
	cp	[hl]
	jp	nc, TIME_LIMIT_EXCEEDED ; sí

; no
	ld	hl, TXT_EXTENDED_PLAY
	ld	de, namtbl_buffer + 18 *SCR_WIDTH
	call	PRINT_TXT
; Muestra con fundido y pausa
	call	LDIRVM_NAMTBL_FADE_INOUT
	call	WAIT_FOUR_SECONDS

IFDEF DEMO_VERSION
	call	DISSCR_FADE_OUT
	jp	GAME_OVER
ENDIF

IFDEF DEBUG_RALLYOVERDEMO
ELSE
; Avanza al siguiente tramo
	ld	hl, current_stage
	inc	[hl]
; ¿Comprueba si es fin de rally?
	ld	a, [current_stage]
	and	$03
	cp	$03
	jp	nz, NEW_STAGE ; no: siguiente tramo
ENDIF
; ------VVVV----falls through--------------------------------------------------

; -----------------------------------------------------------------------------
; Finalización de un rally.
RALLY_OVER:
; Inicializa la animación previa a "Final standings" con la secuencia por defecto
	call	DISSCR_FADE_OUT
	ld	hl, CUTSCENE_RALLYOVER
	call	CLS_INIT_CUTSCENE_FIRST_FRAME

; Comprueba si el tiempo total del rally entra en el high score
; puntero a la tabla de records
	ld	a, [current_stage]
	sra	a
	sra	a
	call	LOCATE_BEST_TIMES
	push	hl ; preserva el puntero al principio de la tabla
; prepara el bucle
	ld	b, NUM_HIGH_SCORES ; para saber cuándo dejar de comparar
	ld	c, HI_SCORES_SIZE ; para saber cuántos bytes mover
@@COMPARE_LOOP:
; comparación
	push	hl ; preserva el puntero a la entrada
	inc	hl ; ignoramos las iniciales
	inc	hl
	inc	hl
; primer byte
	ld	de, current_rally_total_time
	ld	a, [de]
	cp	[hl]
	jr	c, @@BEST_TIME ; se mejora el tiempo
	jr	nz, @@NEXT ; no se mejora el tiempo
; segundo byte
	inc	de
	ld	a, [de]
	inc	hl
	cp	[hl]
	jr	c, @@BEST_TIME ; se mejora el tiempo
	jr	z, @@BEST_TIME ; tiempo igual, se da por mejorado
@@NEXT:
; no se mejora el tiempo
	pop	hl ; restaura el puntero
	push	bc ; preserva contadores
	ld	bc, HI_SCORE_ENTRY_SIZE ; avanza al siguiente dato
	add	hl, bc
	pop	bc ; restaura contadores
	ld	a, -HI_SCORE_ENTRY_SIZE ; una entrada menos a copiar
	add	c
	ld	c, a
	djnz	@@COMPARE_LOOP
; no se mejora ningún tiempo
	pop	hl ; deja la pila en estado consistente
	jr	@@NO_BEST_TIME

@@BEST_TIME:
; preserva la posición (5 = mejor, 0 = peor)
	ld	a, 5
	sub	b
	ld	[last_rally_position], a
; saca el segundo valor de la pila (el puntero al principio de la tabla)
	pop	hl
	ex	[sp], hl
; comprueba si hay que mover puntuaciones
	ld	a, c
	or	a
	jr	z, @@NO_MOVE
; mueve puntuaciones
	ld	b, 0
	push	bc ; preserva número de bytes
	ld	bc, HI_SCORES_SIZE
	add	hl, bc
	dec	hl ; hl = último byte de la tabla
	ld	d, h ; de = hl
	ld	e, l
	ld	bc, -HI_SCORE_ENTRY_SIZE
	add	hl, bc ; hl = último byte de la penúltima entrada de la tabla
	pop	bc ; restaura número de bytes
	lddr
@@NO_MOVE:
; vuelca las iniciales y la puntuación actual
	pop	de ; restaura puntero a la entrada (en de porque vamos a escribir)
	ld	hl, initials
	ldi
	ldi
	ldi
	ld	hl, current_rally_total_time
	ldi
	ldi

; Determina la secuencia alternativa correcta
	ld	hl, CUTSCENE_RALLYOVER_SEQ_TABLE
	ld	a, [last_rally_position]
	call	GET_HL_A_A_WORD
; Selecciona la secuencia alternativa
	ld	[cutscene_pointer], hl
	call	CUTSCENE_CURRENT_FRAME_OK

@@NO_BEST_TIME:

; Reproduce la animación previa a "Final standings"
	call	ENASCR_NO_FADE
	call	CUTSCENE_PLAY_FOUR_SECONDS
	call	DISSCR

; Restura el charset por defecto
	call	RESTORE_RALLIES_FONT_BANK1

; Pantalla de final de rally ("Final standings")
	ld	a, [current_stage]
	sra	a
	sra	a
	call	CLS_PRINT_RALLY_LOGO_BEST_TIMES
	ld	hl, TXT_RALLY_STANDINGS
	ld	de, namtbl_buffer + (BEST_TIMES_RALLY_Y +3) * SCR_WIDTH
	call	PRINT_TXT

; Fundido de entrada y pausa
	call	ENASCR_FADE_IN
	call	WAIT_FOUR_SECONDS

; Marca el rally actual como completado
	ld	a, [current_stage]
	sra	a
	sra	a
	ld	hl, rally_status
	add	l
	ld	l, a
	adc	h
	sub	l
	ld	h, a
	set	RALLY_BIT_FINISHED, [hl]

; Comprueba qué rallies quedan
	ld	hl, rally_status
	ld	b, NUM_RALLIES
	xor	a
@@CHECK_ENDING_LOOP:
	add	[hl] ; cada bit incrementará
	inc	hl
	djnz	@@CHECK_ENDING_LOOP

; ¿Están todos finalizado?
	ld	b, a ; preserva a
	and	RALLY_FLAG_FINISHED * $0f ; máscara del nibble
	cp	RALLY_FLAG_FINISHED * NUM_RALLIES ; valor que tiene que alcanzar
	jp	z, CHAMPIONSHIP_OVER ; sí

; ¿Se han finalizado los suficientes para desbloquear?
	cp	RALLY_FLAG_FINISHED * WHEN_TO_UNLOCK ; valor que tiene que alcanzar
	jp	nz, NEW_RALLY ; no
; sí: debloquea el resto de rallies
	ld	hl, rally_status
	ld	b, NUM_RALLIES
@@UNLOCK_LOOP:
	res	RALLY_BIT_LOCKED, [hl]
	inc	hl
	djnz	@@UNLOCK_LOOP
	jp	NEW_RALLY
; ------VVVV----falls through--------------------------------------------------

; -----------------------------------------------------------------------------
CHAMPIONSHIP_OVER:
; Comprueba si el tiempo total del rally entra en el high score
; puntero a la tabla de records
	ld	hl, hi_scores
; prepara el bucle
	ld	b, NUM_HIGH_SCORES ; para saber cuándo dejar de comparar
	ld	c, HI_SCORES_SIZE ; para saber cuántos bytes mover
@@COMPARE_LOOP:
; comparación
	push	hl ; preserva el puntero a la entrada
	inc	hl ; ignoramos las iniciales
	inc	hl
	inc	hl
; primer byte
	ld	de, championship_score
	ld	a, [de]
	cp	[hl]
	jr	c, @@NEXT ; no se mejora la puntuación
	jr	nz, @@HI_SCORE ; se mejora la puntuación
; segundo byte
	inc	de
	ld	a, [de]
	inc	hl
	cp	[hl]
	jr	nc, @@HI_SCORE ; se mejora la puntuación
@@NEXT:
; no se mejora la puntuación
	pop	hl ; restaura el puntero
	push	bc ; preserva contadores
	ld	bc, HI_SCORE_ENTRY_SIZE ; avanza al siguiente dato
	add	hl, bc
	pop	bc ; restaura contadores
	ld	a, -HI_SCORE_ENTRY_SIZE ; una entrada menos a copiar
	add	c
	ld	c, a
	djnz	@@COMPARE_LOOP
; no se mejora ninguna puntuación
	jr	@@NO_HI_SCORE

@@HI_SCORE:
; comprueba si hay que mover puntuaciones
	ld	a, c
	or	a
	jr	z, @@NO_MOVE
; mueve puntuaciones
	ld	hl, hi_scores + HI_SCORES_SIZE -HI_SCORE_ENTRY_SIZE -1 ; hl = último byte de la penúltima entrada de la tabla
	ld	de, hi_scores + HI_SCORES_SIZE -1 ; de = último byte de la tabla
	ld	b, 0 ; bc = cuántos bytes mover
	lddr
@@NO_MOVE:
; vuelca las iniciales y la puntuación
	pop	de ; restaura puntero a la entrada (en de porque vamos a escribir)
	ld	hl, initials
	ldi
	ldi
	ldi
	ld	hl, championship_score
	ldi
	ldi

@@NO_HI_SCORE:

; Pantalla de final de rally
	call	CLS_PRINT_TITLE_HI_SCORES
	call	LDIRVM_NAMTBL_FADE_INOUT
	call	WAIT_FOUR_SECONDS
	call	DISSCR_FADE_OUT
; ------VVVV----falls through--------------------------------------------------

; -----------------------------------------------------------------------------
ENDING:
; Inicia la reprodución de música
	ld	hl, MUSIC_ENDING
	call	INIT_REPLAYER

; Preparada la animación del ending
	ld	hl, CUTSCENE_ENDING
	call	CLS_INIT_CUTSCENE_FIRST_FRAME
	call	ENASCR_NO_FADE

; Prepara los punteros de escritura del texto
	ld	hl, TXT_ENDING
	ld	de, namtbl_buffer + CUTSCENE_TEXT_Y *SCR_WIDTH
	call	INIT_PRINTCHAR

@@LOOP:
; Texto
	call	PRINTCHAR_HAS_NEXT
	call	nz, PRINTCHAR_NEXT

	push	hl ; preserva el origen del texto
	push	de ; preserva el destino del texto

; Animación
	call	CUTSCENE_HAS_NEXT
	call	nz, CUTSCENE_CURRENT_FRAME

; volcado del fotograma
	halt
	call	LDIRVM_NAMTBL

	pop	de ; restaura el destino del texto
	pop	hl ; restaura el origen del texto

	jr	@@LOOP

@@EXIT:
; (hay que restaurar el stack)
	pop	hl
	pop	de

	call	WAIT_FOUR_SECONDS
	call	DISSCR_FADE_OUT
	jp	MAIN
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
TIME_LIMIT_EXCEEDED:
; Mensaje de tiempo excedido
	ld	hl, TXT_TIME_LIMIT_EXCEEDED
	ld	de, namtbl_buffer + TXT_TIME_LIMIT_EXCEEDED_X + 18 *SCR_WIDTH
	ld	bc, TXT_TIME_LIMIT_EXCEEDED_LENGTH
	ldir
	ld	a, [seconds_per_stage]
	add	$30 ; "0" ASCII
	ld	[namtbl_buffer + TXT_TIME_LIMIT_EXCEEDED_X + 18 *SCR_WIDTH], a
; Muestra con fundido y pausa
	call	LDIRVM_NAMTBL_FADE_INOUT
	call	WAIT_FOUR_SECONDS
	call	DISSCR_FADE_OUT
; ------VVVV----falls through--------------------------------------------------

; -----------------------------------------------------------------------------
CONTINUE:
; ¿Quedan más créditos?
	ld	hl, credits
	ld	a, [hl]
	or	a
	jr	z, GAME_OVER ; no
; sí: consume un crédito
	dec	[hl]

; Animación "Continue?"
	ld	hl, CUTSCENE_CONTINUE
	call	CLS_INIT_CUTSCENE_FIRST_FRAME
	ld	hl, TXT_CONTINUE
	ld	de, namtbl_buffer + TXT_CONTINUE_X + CUTSCENE_TEXT_Y *SCR_WIDTH
	ld	bc, TXT_CONTINUE_LENGTH
	ldir
	call	ENASCR_FADE_IN

; Cuenta atrás
	ld	b, 9
@@LOOP:
	push	bc ; preserva el contador de segundos
	ld	a, $30 ; "0" ASCII
	add	b
	ld	[namtbl_buffer + TXT_CONTINUE_X + TXT_CONTINUE_OFFSET + CUTSCENE_TEXT_Y *SCR_WIDTH], a

; reproduce la animación (durante un segundo)
	call	CUTSCENE_PLAY_TRIGGER_ONE_SECOND
	jr	nz, @@TRIGGER ; disparador: continúa
; decrementa un segundo
	pop	bc ; restaura el contador de segundos
	djnz	@@LOOP

; No continúa
	call	@@CLEAR_CONTINUE
; reproduce la animación de "no continúa"
	ld	hl, CUTSCENE_CONTINUE_SEQ_NO
	ld	[cutscene_pointer], hl
	xor	a
	ld	[cutscene_frames], a
	call	CUTSCENE_PLAY_FOUR_SECONDS
; fundido y game over
	call	DISSCR_FADE_OUT
	jr	GAME_OVER

@@TRIGGER:
; Continúa
	call	@@CLEAR_CONTINUE
	call	LDIRVM_NAMTBL
; restaura el tiempo total del rally
	ld	hl, current_rally_total_time_backup
	ld	de, current_rally_total_time
	ldi
	ldi
; reproduce la animación de "continúa"
	ld	hl, CUTSCENE_CONTINUE_SEQ_YES
	ld	[cutscene_pointer], hl
	xor	a
	ld	[cutscene_frames], a
	call	CUTSCENE_PLAY_FOUR_SECONDS
; fundido, restaura el charset por defecto y repite el tramo
	call	DISSCR_FADE_OUT
	call	RESTORE_RALLIES_FONT_BANK1 ; NEW_STAGE espera el charset restaurado
	call	CLS_NAMTBL ; NEW_STAGE espera la pantalla habilitada
	call	LDIRVM_NAMTBL
	call	ENASCR
	jp	NEW_STAGE

@@CLEAR_CONTINUE:
; Elimina el texto "Continue?"
	ld	hl, namtbl_buffer + CUTSCENE_TEXT_Y *SCR_WIDTH
	jp	CLEAR_LINE
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
GAME_OVER:
; Inicia la reprodución de música
	ld	hl, MUSIC_GAME_OVER
	call	INIT_REPLAYER

; Animación de game over
	ld	hl, CUTSCENE_GAMEOVER
	call	CLS_INIT_CUTSCENE_FIRST_FRAME
	ld	hl, TXT_GAME_OVER
	ld	de, namtbl_buffer + CUTSCENE_TEXT_Y *SCR_WIDTH
	call	PRINT_TXT
	call	ENASCR_NO_FADE
	call	CUTSCENE_PLAY
	call	DISSCR
	jp	MAIN
; -----------------------------------------------------------------------------

;
; =============================================================================
;	Animaciones de inicio de tramo
; =============================================================================
;

; -----------------------------------------------------------------------------
; Animación inicial en función de la posición en el rally anterior
STAGE_INTRO:
	ld	a, [last_rally_position]
	or	a
	jp	z, STAGE_INTRO_SPECIAL
	; jp	STAGE_INTRO_NORMAL ; falls through
; ------VVVV----falls through--------------------------------------------------

; -----------------------------------------------------------------------------
; Animación inicial tipo "Drift Out" con dos coches saliendo antes
STAGE_INTRO_NORMAL:
; Inicializa las variables
	xor	a
	ld	[intro_car_speed], a
	ld	[intro_car_dist_to_move], a

; Inicializa los sprites: spratr
	ld	hl, CAR_SPAT_Y_0 << 8 + CAR_SPAT_X_0 +32 ; +32 por el bit early clock
	ld	[intro_car_xy], hl
	ld	de, spratr_buffer_car
	ld	c, SPAT_EC | OPPONENT_COLOR
	call	SET_INTRO_CAR_SPRATR
	
	ex	de, hl ; puntero al siguiente coche
	ld	hl, INTRO_CAR_SPAT_Y_0 << 8 + INTRO_CAR_SPAT_X_0
	ld	[intro_car2_xy], hl
	ld	c, OPPONENT2_COLOR
	call	SET_INTRO_CAR_SPRATR
	
	ld	a, SPAT_END
	ld	[hl], a
; Inicializa los sprites: sprtbl
	call	PREPARE_BLIT_SPRTBL
; Inicializa los sprites: volcado a VRAM
	call	BLIT_SPRITES

; Inicializa el sonido fijo del segundo coche a mínima velocidad
	ld	hl, 2560 ; GET_ENGINE_SOUND_DECCELERATE(0) = 2560
	ld	[psg_frequency_channel_a], hl
	ld	a, ENGINE_VOLUME
	ld	[psg_volume_channel_a], a
; Activa la pantalla
	halt
	call	ENASCR
	
; Salida del primer coche
	call	@@DO_INTRO
	
; Reinicializa las variables
	xor	a
	ld	[intro_car_speed], a
	ld	[intro_car_dist_to_move], a
; Cambia de sitio en la spratr el segundo coche y prepara el tercero (el del jugador)
	ld	hl, CAR_SPAT_Y_0 << 8 + CAR_SPAT_X_0 +32 ; +32 por el bit early clock
	ld	[intro_car_xy], hl
	ld	de, spratr_buffer_car
	ld	c, SPAT_EC | CAR_COLOR
	call	SET_INTRO_CAR_SPRATR
	
	ex	de, hl ; puntero al siguiente coche
	ld	hl, INTRO_CAR_SPAT_Y_0 << 8 + INTRO_CAR_SPAT_X_0
	ld	[intro_car2_xy], hl
	ld	c, OPPONENT_COLOR
	call	SET_INTRO_CAR_SPRATR
	
; Salida del segundo coche
@@DO_INTRO:
	halt
	call	LDIRVM_SPRATR
	call	WRTPSG_BUFFER
	xor	a
	ld	[tmp_byte], a ; marca para saber si ha habido animaciones
	call	INTRO_ANIMATE_CAR
	call	INTRO_ANIMATE_CAR2
; sonido (en el canal b)
	ld	a, [intro_car_speed]
	srl	a ; debería normalizarse con /4, pero queda más efectivo /2
	call	GET_ENGINE_SOUND_ACCELERATE
	ld	[psg_frequency_channel_b], hl
	ld	a, [spratr_buffer_intro +13] ; x del sprite de abajo a la derecha
	srl	a
	srl	a
	srl	a
	srl	a
	srl	a ; a = [0..7]
	neg	; a = [255..248]
	add	$0f ; a = [15..8]
	ld	[psg_volume_channel_b], a
; ¿han acabado todas las animaciones?
	ld	a, [tmp_byte]
	or	a
	jr	nz, @@DO_INTRO ; no
; sí: silencia el canal b
	; xor	a ; innecesario (a es cero)
	ld	[psg_volume_channel_b], a
; ajusta el sprite del coche (elimina bit EC) y finaliza
	jr	STAGE_INTRO_END
	; ld	hl, INTRO_CAR_SPAT_Y_0 << 8 + INTRO_CAR_SPAT_X_0
	; ld	de, spratr_buffer_car
	; ld	c, CAR_COLOR
	; jp	SET_INTRO_CAR_SPRATR
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Animación inicial tipo "Sega Rally - Forest" con pájaros volando
STAGE_INTRO_SPECIAL:
; Inicializa las variables
	xor	a
	ld	[tmp_frame], a
	
; Inicializa los sprites
	ld	hl, CAR_SPAT_Y_0 << 8 + CAR_SPAT_X_0 +32 ; +32 por el bit early clock
	ld	[intro_car_xy], hl
	ld	de, spratr_buffer_car
	ld	c, SPAT_EC | CAR_COLOR
	call	SET_INTRO_CAR_SPRATR
	
	ex	de, hl
	ld	hl, SPRATR_INTRO_SPECIAL_0
	ld	bc, SPRATR_INTRO_SPECIAL_0_LENGTH
	ldir
; Inicializa los sprites: sprtbl
	call	PREPARE_BLIT_SPRTBL
; Inicializa los sprites: volcado a VRAM
	call	BLIT_SPRITES

; Activa la pantalla
	halt
	call	ENASCR
	
; Bucle de la intro
@@DO_INTRO:
	halt
	call	LDIRVM_SPRATR
	xor	a
	ld	[tmp_byte], a ; marca para saber si ha habido animaciones
	call	INTRO_ANIMATE_CAR
	ld	de, SPECIAL_INTRO_DATA_0
	ld	ix, spratr_buffer_intro
	call	INTRO_ANIMATE_BIRD
	inc	de ; SPECIAL_INTRO_DATA_0 +1
	ld	ix, spratr_buffer_intro +4
	call	INTRO_ANIMATE_BIRD
	inc	de ; SPECIAL_INTRO_DATA_0 +2
	ld	ix, spratr_buffer_intro +8
	call	INTRO_ANIMATE_BIRD
	ld	hl, tmp_frame
	inc	[hl]
; ¿han acabado todas las animaciones?
	ld	a, [tmp_byte]
	or	a
	jr	nz, @@DO_INTRO ; no
; sí
; ------VVVV----falls through--------------------------------------------------

; -----------------------------------------------------------------------------
; Ajusta el sprite del coche (elimina bit EC) y finaliza
STAGE_INTRO_END:
	ld	hl, INTRO_CAR_SPAT_Y_0 << 8 + INTRO_CAR_SPAT_X_0
	ld	de, spratr_buffer_car
	ld	c, CAR_COLOR
	jp	SET_INTRO_CAR_SPRATR
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Animación del segundo coche (el que va al punto de partida)
INTRO_ANIMATE_CAR:
; comprueba si ya está en el punto de partida
	ld	hl, [intro_car_xy]
	ld	a, (INTRO_CAR_SPAT_X_0 +32) & 0xff ; +32 por el bit early clock
	cp	l
	ret	z ; sí: ha finalizado la animación
; no: desplaza un píxel
	dec	h ; y--
	inc	l ; x++
	ld	[intro_car_xy], hl
	ld	de, spratr_buffer_car
	ld	a, [spratr_buffer_car + SPR_CAR_SIZE_0 *4 -1] ; preserva bit EC y color
	ld	c, a
	call	SET_INTRO_CAR_SPRATR
; marca que hay animación
	ld	hl, tmp_byte
	inc	[hl]
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Animación del primer coche (el que empieza la carrera)
INTRO_ANIMATE_CAR2:
; comprueba si ya está oculto
	ld	a, [spratr_buffer_intro]
	cp	SPAT_OB
	ret	z ; sí: ha finalizado la animación
	ld	hl, tmp_byte
	inc	[hl] ; marca que hay animación
; no: actualiza la velocidad
	ld	hl, intro_car_speed
	ld	a, [hl] ; carga en a la velocidad
	cp	INTRO_MAX_SPEED
; velocidad >= marca: no acelera más
	jr	nc, @@NO_INC_SPEED
	inc	a
	ld	[hl], a ; almacena la nueva velocidad
@@NO_INC_SPEED:
	inc	hl ; hl = intro_car_dist_to_move
	add	[hl] ; a = intro_car_dist_to_move + intro_car_speed
; mueve el coche
	ld	hl, [intro_car2_xy]
@@LOOP:
	cp	$10
	jr	c, @@HL_OK ; a < $10, no hay (más) movimiento
; avanza un píxel
	dec	h ; y--
	inc	l ; x++
	sub	$10
	jr	@@LOOP
@@HL_OK:
	ld	[intro_car_dist_to_move], a ; almacena intro_car_dist_to_move
	ld	[intro_car2_xy], hl
; ¿ha salido de la pantalla?
	ld	a, 32 ; (h+32 < 16) equivale a (h < -16)
	add	h
	cp	16
	jr	nc, @@APPLY_HL ; no
; sí: oculta el coche
	ld	a, SPAT_OB
	ld	[spratr_buffer_intro], a
	ld	[spratr_buffer_intro + 4], a
	ld	[spratr_buffer_intro + 8], a
	ld	[spratr_buffer_intro + 12], a
	ld	[spratr_buffer_intro + 16], a
	ret
@@APPLY_HL:
; no: mueve el coche a la nueva posición
	ld	de, spratr_buffer_intro
	ld	a, [spratr_buffer_intro + SPR_CAR_SIZE_0 *4 -1] ; preserva bit EC y color
	ld	c, a
	; jr	SET_INTRO_CAR_SPRATR ; falls through
; ------VVVV----falls through--------------------------------------------------

; -----------------------------------------------------------------------------
; Modifica color, bit EC y la posición de un coche en pantalla
; param hl: xy en las que colocar los sprites del coche
; param de: puntero al inicio de la spratr del coche
; param c: bit EC y color
; ret hl: puntero al siguiente inicio de la spratr
SET_INTRO_CAR_SPRATR:
	push	bc ; preserva bit EC y color
	push	hl ; preserva coordenadas
	push	de ; preserva puntero
; vuelca los datos de la spratr de la animación
	ld	a, DIR_UR * 2
	ld	hl, SPRATR_CAR_TABLE
	call	GET_HL_A_WORD
	ld	bc, SPR_CAR_SIZE_0 * 4
	ldir
; actualizacion de coordenadas
	pop	hl ; restaura puntero en hl
	pop	de ; restaura coordenadas en de
	pop	bc ; restaura bit EC y color
	ld	b, SPR_CAR_SIZE_0
@@LOOP:
; y += d
	ld	a, d
	add	[hl]
	cp	SPAT_END
	jr	nz, @@Y_OK
; evita poner SPAT_END y utiliza SPAT_OB
	ld	a, SPAT_OB
@@Y_OK:
	ld	[hl], a
	inc	hl
; x+= e
	ld	a, e
	add	[hl]
	ld	[hl], a
	inc	hl
; salta patrón
	inc	hl
; color: ¿era blanco?
	ld	a, 15
	cp	[hl]
	ld	a, c
	jr	z, @@COLOR_OK ; sí
; no: negro: actualiza sólo bit EC
	and	SPAT_EC
	or	1 ; mantiene el negro
@@COLOR_OK:
	ld	[hl], a
	inc	hl
	djnz	@@LOOP
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Animación de cada uno de los pájaros
; param ix: puntero a spratr_buffer_intro del pájaro correspondiente
; param de: puntero a SPECIAL_INTRO_DATA_0 del pájaro correspondiente
INTRO_ANIMATE_BIRD:
; comprueba si ya está oculto
	ld	a, [ix]
	cp	SPAT_OB
	ret	z ; sí
	ld	hl, tmp_byte
	inc	[hl] ; marca que hay animación
; no: comprueba si hay que ocultar
	cp	-16 -1
	jr	nz, @@NO_HIDE ; no
; sí: oculta el sprite y finaliza
	ld	[ix], SPAT_OB
	ret

@@NO_HIDE:
; comprueba si ya está en movimiento
	ld	a, [ix +2]
	cp	$6c ; frame de pájaro quieto
	jr	nz, @@MOVE ; sí
; no: comprueba si empezar a mover
	ld	a, [de]
	ld	hl, tmp_frame
	cp	[hl]
	ret	nz ; no

; sí: empieza a mover
	ld	[ix +2], $70 ; frame de pájaro en movimiento
@@MOVE:
	dec	[ix] ; y
	dec	[ix +1] ; x
	dec	[ix +1]
; ¿cambio de frame?
	ld	a, [tmp_frame]
	and	$07
	ret	nz ; no
; sí
	ld	a, 4 ; $70<->$74
	xor	[ix +2]
	ld	[ix +2], a
	ret
; -----------------------------------------------------------------------------

;
; =============================================================================
;	Control del coche
; =============================================================================
;

; -----------------------------------------------------------------------------
; Tabla de saltos para la rutina de control del coche
; en función del estado
UPDATE_CAR_JUMP_TABLE:
	.dw	UPDATE_CAR_STOPPED		; CAR_STOPPED		equ 0
	.dw	UPDATE_CAR_NORMAL		; CAR_NORMAL		equ 2
	.dw	UPDATE_CAR_JUMP			; CAR_JUMP		equ 4
	.dw	UPDATE_CAR_DRIFT_LEFT		; CAR_DRIFT_L		equ 6
	.dw	UPDATE_CAR_DRIFT_RIGHT		; CAR_DRIFT_R		equ 8
	.dw	UPDATE_CAR_DRIFT_END_LEFT	; CAR_DRIFT_END_L	equ 10
	.dw	UPDATE_CAR_DRIFT_END_RIGHT	; CAR_DRIFT_END_R	equ 12
	.dw	UPDATE_CAR_SLIDE_LEFT		; CAR_SLIDE_L		equ 14
	.dw	UPDATE_CAR_SLIDE_RIGHT		; CAR_SLIDE_R		equ 16
	.dw	UPDATE_CAR_SPIN_LEFT		; CAR_SPIN_L		equ 18
	.dw	UPDATE_CAR_SPIN_RIGHT		; CAR_SPIN_R		equ 20
	; .dw	0 ; UPDATE_CAR_FINISH		; CAR_FINISH		equ 22
	; .dw	0 ; UPDATE_CAR_CRASH 		; CAR_CRASH		equ 24
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Coche detenido
UPDATE_CAR_STOPPED:
	ld	a, [trigger]
	or	a
	ret	z
; Arranca
	ld	a, CAR_NORMAL
	ld	[car_status], a
; ------VVVV----falls through--------------------------------------------------

; -----------------------------------------------------------------------------
; Control del coche en estado normal
UPDATE_CAR_NORMAL:
	ld	a, [trigger]
	ld	b, SPEED_MAX
	call	UPDATE_SPEED
	ld	a, [stick]
	cp	3
	jp	z, @@RIGHT
	cp	7
	jp	z, @@LEFT
; ¿Hay intención de giro y dirección no octogonal?
	ld	hl, car_direction
	ld	a, [hl]
	add	a
	add	a
	add	a
	add	a
	or	HEADING_SUB_ZERO ; ahora se puede comparar con heading
	dec	hl ; hl = car_heading
	cp	[hl]
	ret	z ; no: heading = direction
; sí: desliza y resetea intención de giro
	jr	c, @@FROM_RIGHT ; heading > direction
	call	MOVE_CAR_LEFT
	ld	hl, car_heading
	inc	[hl]
	ret
@@FROM_RIGHT:
	call	MOVE_CAR_RIGHT
	ld	hl, car_heading
	dec	[hl]
	ret

; Tecla derecha
@@RIGHT:
; Añade giro y, si es octogonal, lo setea como dirección efectiva
	ld	hl, car_heading
	inc	[hl]
	bit	4, [hl] ; bit 4 = HEADING_FLAG_HALF
	call	z, @@SET_CAR_DIRECTION
; ¿Curvatura a derecha?
	ld	hl, road_properties
	bit	TILE_BIT_RIGHT, [hl]
	jp	z, MOVE_CAR_RIGHT ; no: desplaza transversalmente
; ; sí: empieza a derrapar
	; ld	a, CAR_DRIFT_R
	; ld	[car_status], a
	; ret
	
; sí: ¿punto de derrape?
	ld	a, [hl]
	add	a
	add	a
	add	a
	add	a
	or	HEADING_SUB_ZERO ; ahora se puede comparar con heading
	ld	hl, car_heading
	cp	[hl]
	ret	z ; no: road = heading 	
	ret	nc ; no: heading <= road
@@ZZZ:
	ld	a, CAR_DRIFT_R
	ld	[car_status], a
	ret

; Tecla izquierda
@@LEFT:
; Añade giro y, si es octogonal, lo setea como dirección efectiva
	ld	hl, car_heading
	dec	[hl]
	bit	4, [hl] ; bit 4 = HEADING_FLAG_HALF
	call	z, @@SET_CAR_DIRECTION
; ¿Curvatura a izquierda?
	ld	hl, road_properties
	bit	TILE_BIT_LEFT, [hl]
	jp	z, MOVE_CAR_LEFT ; no: desplaza transversalmente
; sí: empieza a derrapar
	ld	a, CAR_DRIFT_L
	ld	[car_status], a
	ret

@@SET_CAR_DIRECTION:
	; ld	hl, car_heading ; innecesario
	ld	a, [hl]
	rrca	; Convierte una dirección tipo byte en una tipo DIR_*
	rrca
	rrca
	rrca
	and	$0f
	inc	hl ; hl = car_direction
	ld	[hl], a
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Control del coche saltando
UPDATE_CAR_JUMP:
; Mantiene la velocidad (simula trigger y velocidad máxima igual a la actual)
	ld	a, 1
	ld	hl, speed
	ld	b, [hl]
	call	UPDATE_SPEED
; ¿Ha finalizado el salto?
	ld	hl, frames_to_control
	inc	[hl]
	ld	a, [hl]
	cp	CAR_JUMP_Y_OFFSET_LENGTH
	jr	nc, @@END_JUMP ; sí
; no: calcula el desplazamiento vertical
	ld	hl, CAR_JUMP_Y_OFFSET
	add	l ; hl += a
	ld	l, a
	adc	h
	sub	l
	ld	h, a
; vuelca la coordenada
	ld	de, car_offset_y_jump
	ldi
	ret

@@END_JUMP:
; Compara la dirección efectiva con la dirección a la que apunta el coche
	ld	hl, car_heading
	ld	a, [hl]
	and	HEADING_MASK_DIR ; Convierte una dirección tipo byte en una tipo DIR_*
	rrca
	rrca
	rrca
	rrca
	inc	hl ; hl = car_direction
	cp	[hl]
	jr	z, @@NORMAL ; car_heading == car_direction -> estado normal
	jr	c, @@SPIN_L ; car_direction > car_heading -> trompo a la izquierda

; car_direction <= car_heading: trompo a la derecha
	ld	a, CAR_SPIN_R
	jr	@@A_OK

; derrape a la derecha
@@SPIN_L:
	ld	a, CAR_SPIN_L
	jr	@@A_OK

; estado normal
@@NORMAL:
	ld	a, CAR_NORMAL
	; jr	@@A_OK ; falls through
@@A_OK:
	ld	[car_status], a
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Control del coche derrapando (sobreviraje) a la izquierda
UPDATE_CAR_DRIFT_LEFT:
	ld	a, [trigger]
	ld	b, SPEED_DRIFT
	call	UPDATE_SPEED
; ¿Tecla izquierda?
	ld	a, [stick]
	cp	7
	jp	nz, SLIDE_UNDRIFT_FROM_LEFT ; no

; sí: ¿margen para aumentar derrape?
	ld	a, [road_properties]
	ld	b, a ; preserva [road_properties] en b
	sub	DRIFT_MARGIN
	add	a
	add	a
	add	a
	add	a
	or	HEADING_SUB_ZERO ; ahora se puede comparar con heading
	ld	hl, car_heading
	cp	[hl]
	jr	c, @@INC_DRIFT ; sí: aumenta el derrape
; no: ¿se sigue en curvatura a izquierda?
	bit	TILE_BIT_LEFT, b
	ret	nz ; sí
; no: ¿mantener el derrape?
	ld	hl, frames_to_control
	dec	[hl]
	ld	a, [hl]
	or	a
	ret	nz ; sí
; no: empieza a acabar el derrape
	ld	a, CAR_DRIFT_END_L
	ld	[car_status], a
	ret

@@INC_DRIFT:
; sí: aumenta el derrape, dirección la de la carretera
	ld	a, [hl]
	sub	FAST_TURN_DRIFT
	ld	[hl], a
; si ha aumentado hasta dirección ortogonal, cambia tamién la dirección efectiva
; (evita poner demasiado pronto la nueva dirección efectiva)
	and	HEADING_FLAG_HALF
	ret	nz ; no
	ld	a, b ; restaura road_properties
	and	TILE_MASK_DIR
	ld	[car_direction], a
; ¿se sigue en curvatura a izquierda?
	bit	TILE_BIT_LEFT, b
	ret	z ; no
; sí: reinicia el contador de frames de derrape
	ld	a, CONTROL_DRIFT_DELAY
	ld	[frames_to_control], a
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Control del coche finalizando un derrape a la izquierda
UPDATE_CAR_DRIFT_END_LEFT:
	ld	a, [trigger]
	ld	b, SPEED_DRIFT
	call	UPDATE_SPEED
; ¿Tecla izquierda o derecha?
	ld	a, [stick]
	cp	7
	jr	z, @@LEFT ; tecla izquierda
	cp	3
	jp	nz, UNDRIFT_FROM_LEFT ; no: resetea intención de giro

; Tecla derecha ¿Curvatura a derecha?
	ld	hl, road_properties
	bit	TILE_BIT_RIGHT, [hl]
	jp	z, SLIDE_UNDRIFT_FROM_LEFT ; no: desliza y resetea intención de giro
; sí: gira rápidamente
	ld	hl, car_heading
	ld	a, [hl]
	add	FAST_TURN_DRIFT
	ld	[hl], a
; ¿Ya ha alcanzado el nuevo giro?
	ld	a, [road_properties]
	add	a
	add	a
	add	a
	add	a
	or	HEADING_SUB_ZERO ; ahora se puede comparar con heading
	ld	hl, car_heading
	cp	[hl]
	jr	z, @@COUNTERSTEER ; sí (car_heading = road_direction)
	ret	nc ; no (car_heading <= road_direction)
; sí: cambia el lado del derrape y reinicia el contador de frames
@@COUNTERSTEER:
	ld	a, CAR_DRIFT_R
	jr	@@SET_DRIFT

; Tecla izquierda
@@LEFT:
; ¿Curvatura a izquierda?
	ld	hl, road_properties
	bit	TILE_BIT_LEFT, [hl]
	jp	z, UNDRIFT_FROM_LEFT ; no: resetea intención de giro
; sí: vuelve al modo derrape
	ld	a, CAR_DRIFT_L
	; jr	@@SET_DRIFT ; falls through

; Vuelve a ponerse en modo derrape y reinicia el contador de frames
@@SET_DRIFT:
	ld	[car_status], a
	ld	a, CONTROL_DRIFT_DELAY
	ld	[frames_to_control], a
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Control del coche derrapando (sobreviraje) a la derecha
UPDATE_CAR_DRIFT_RIGHT:
	ld	a, [trigger]
	ld	b, SPEED_DRIFT
	call	UPDATE_SPEED
; ¿Tecla derecha?
	ld	a, [stick]
	cp	3
	jp	nz, SLIDE_UNDRIFT_FROM_RIGHT ; no

; sí: ¿margen para aumentar derrape?
	ld	a, [road_properties]
	ld	b, a ; preserva [road_properties] en b
	add	DRIFT_MARGIN
	add	a
	add	a
	add	a
	add	a
	or	HEADING_SUB_ZERO ; ahora se puede comparar con heading
	ld	hl, car_heading
	cp	[hl]
	jr	c, @@KEEP_DRIFT ; no (car_heading > road_direction+2)
	jr	z, @@KEEP_DRIFT ; no (car_heading = road_direction+2)

; sí: aumenta el derrape, dirección la de la carretera
	ld	a, [hl]
	add	FAST_TURN_DRIFT
	ld	[hl], a
; si ha aumentado hasta dirección ortogonal, cambia tamién la dirección efectiva
; (evita poner demasiado pronto la nueva dirección efectiva)
	and	HEADING_FLAG_HALF
	ret	nz ; no
	ld	a, b ; restaura road_properties
	and	TILE_MASK_DIR
	ld	[car_direction], a
; ¿se sigue en curvatura a derecha?
	bit	TILE_BIT_RIGHT, b
	ret	z ; no
; sí: reinicia el contador de frames de derrape
	ld	a, CONTROL_DRIFT_DELAY
	ld	[frames_to_control], a
	ret

@@KEEP_DRIFT:
; no: ¿se sigue en curvatura a derecha?
	bit	TILE_BIT_RIGHT, b
	ret	nz ; sí
; no: ¿mantener el derrape?
	ld	hl, frames_to_control
	dec	[hl]
	ld	a, [hl]
	or	a
	ret	nz ; sí
; no: empieza a acabar el derrape
	ld	a, CAR_DRIFT_END_R
	ld	[car_status], a
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Control del coche finalizando un derrape a la derecha
UPDATE_CAR_DRIFT_END_RIGHT:
	ld	a, [trigger]
	ld	b, SPEED_DRIFT
	call	UPDATE_SPEED
; ¿Tecla izquierda o derecha?
	ld	a, [stick]
	cp	3
	jr	z, @@RIGHT ; tecla derecha
	cp	7
	jp	nz, UNDRIFT_FROM_RIGHT ; no: resetea intención de giro

; Tecla izquierda ¿Curvatura a izquierda?
	ld	hl, road_properties
	bit	TILE_BIT_LEFT, [hl]
	jp	z, SLIDE_UNDRIFT_FROM_RIGHT ; no: desliza y resetea intención de giro
; sí: gira rápidamente
	ld	hl, car_heading
	ld	a, [hl]
	sub	FAST_TURN_DRIFT
	ld	[hl], a
; ¿Ya ha alcanzado el nuevo giro?
	ld	a, [road_properties]
	add	a
	add	a
	add	a
	add	a
	or	HEADING_SUB_ZERO ; ahora se puede comparar con heading
	ld	hl, car_heading
	cp	[hl]
	ret	c ; no (car_heading > road_direction)
; sí: cambia el lado del derrape y reinicia el contador de frames
	ld	a, CAR_DRIFT_L
	jr	@@SET_DRIFT

; Tecla derecha
@@RIGHT:
; ¿Curvatura a derecha?
	ld	hl, road_properties
	bit	TILE_BIT_RIGHT, [hl]
	jp	z, UNDRIFT_FROM_RIGHT ; no: resetea intención de giro
; sí: vuelve al modo derrape
	ld	a, CAR_DRIFT_R
	; jr	@@SET_DRIFT ; falls through

; Vuelve a ponerse en modo derrape y reinicia el contador de frames
@@SET_DRIFT:
	ld	[car_status], a
	ld	a, CONTROL_DRIFT_DELAY
	ld	[frames_to_control], a
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Coche deslizando a la izquierda o derecha,
; forzado por una colisión lateral
UPDATE_CAR_SLIDE_LEFT:
; Deslizando a la izquierda
	call	MOVE_CAR_LEFT
	jr	UPDATE_CAR_SLIDE
UPDATE_CAR_SLIDE_RIGHT:
; Deslizando a la derecha
	call	MOVE_CAR_RIGHT
	; jr	UPDATE_CAR_SLIDE ; falls through
UPDATE_CAR_SLIDE:
; Avanza, decelera
	xor	a
	call	UPDATE_SPEED
; Cuando se recupere el control del coche...
	ld	hl, frames_to_control
	dec	[hl]
	ret	nz
; ...restaura el estado normal
	ld	a, CAR_NORMAL
	ld	[car_status], a
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Coche trompeando a la izquierda / derecha
UPDATE_CAR_SPIN_LEFT:
; Avanza, decelera
	ld	bc, SPEED_SPIN << 8 | DECEL_SPINING
	call	UPDATE_SPEED_DECELERATE
; Gira rápidamente
	ld	b, -FAST_TURN_SPIN
	jr	UPDATE_CAR_SPIN
UPDATE_CAR_SPIN_RIGHT:
; Avanza, decelera
	ld	bc, SPEED_SPIN << 8 | DECEL_SPINING
	call	UPDATE_SPEED_DECELERATE
; Gira rápidamente
	ld	b, FAST_TURN_SPIN
	; jr	UPDATE_CAR_SPIN ; falls through
UPDATE_CAR_SPIN:
; Gira rápidamente (lo que indique b)
	ld	hl, car_heading
	ld	a, [hl]
	add	b
	ld	[hl], a
; ¿Coincide con la dirección efectiva? (ignorando intención de giro)
	and	HEADING_MASK_DIR
	or	HEADING_SUB_ZERO
	ld	b, a ; preserva heading (sin intención de giro)
	rrca	; Convierte una dirección tipo byte en una tipo DIR_*
	rrca
	rrca
	rrca
	and	$0f
	inc	hl ; hl = car_direction
	cp	[hl]
	ret	nz ; no
; sí: ¿ha frenado lo suficiente?
	ld	a, [speed]
	cp	SPEED_SPIN +1
	ret	nc ; no
; sí: restaura el estado normal
	dec	hl ; hl = car_heading
	ld	[hl], b
	ld	a, CAR_NORMAL
	ld	[car_status], a
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Actualiza la velocidad del coche en función del trigger
; param a: trigger
; param b: velocidad máxima
UPDATE_SPEED:
; Si se está pulsando el acelerador, compara con la velocidad máxima
	or	a ; prepara los flags
	ld	hl, speed
	ld	a, [hl] ; carga en a la velocidad
	jr	nz, @@COMPARE
; Si no, comparará con la velocidad mínima
	ld	b, SPEED_MIN
@@COMPARE:
	cp	b
; velocidad < marca: acelera
	jr	c, @@INC_SPEED
; velocidad = marca: mantiene la velocidad
	jr	z, UPDATE_SPEED_OK
; velocidad > marca: decelera
	dec	a
	jr	UPDATE_SPEED_OK
@@INC_SPEED:
	inc	a
	; jr	UPDATE_SPEED_OK ; falls through
; Punto de entrada especial para reusar desde UPDATE_SPEED_DECELERATE
; param a: velocidad actualizada
; param hl: speed
UPDATE_SPEED_OK:
	ld	[hl], a
; ¿Se ha alcanzado el momento de mover el coche?
	inc	hl ; hl = dist_to_move
	ld	b, a
	ld	a, [hl]
	sub	b
	jr	c, @@MOVE ; sí
; no
	ld	[hl], a
	ret
@@MOVE:
	add	MOVE_WHEN
	ld	[hl], a
; ¿Estamos en medio de un salto?
	ld	a, [car_status]
	cp	CAR_JUMP
	jr	z, @@NO_VIBRATION ; sí: no hay vibración aleatoria
; no: vibración aleatoria
	ld	a, r ; r = 0..127
	and	$7f
	cp	b ; b = speed = 0..96 (0..SPEED_MAX)
	jr	nc, @@NO_VIBRATION ; sí: r >= b
; no: desplazamiento
	ld	a, 1
	jr	@@VIBRATION_OK
@@NO_VIBRATION:
	xor	a
@@VIBRATION_OK:
	ld	[car_offset_y_vibration], a
; Actualiza la posición del coche
	ld	de, [car_xy]
	ld	hl, @@JUMP_TABLE
	ld	a, [car_direction]
	and	DIR_NO -2 ; (elimina también el bit más bajo)
	call	JP_TABLE_A_OK ; evita sra a / add a
	ld	[car_xy], de
; Marca que ha habido desplazamiento de coche en este frame
	ld	hl, scroll_status
	set	SCROLL_BIT_CAR, [hl]
; Refresca el valor de road_properties
	call	GET_ROAD_PROPERTIES
	ld	[road_properties], a
	ret

@@JUMP_TABLE:
	.dw	@@DOWN_LEFT
	.dw	@@LEFT
	.dw	@@UP_LEFT
	.dw	@@UP
	.dw	@@UP_RIGHT
	.dw	@@RIGHT
	.dw	@@DOWN_RIGHT
	.dw	@@DOWN

@@DOWN_LEFT:
	inc	d
	; falls through
@@LEFT:
	dec	e
	ret

@@UP_LEFT:
	dec	e
	; falls through
@@UP:
	dec	d
	ret

@@UP_RIGHT:
	dec	d
	; falls through
@@RIGHT:
	inc	e
	ret

@@DOWN_RIGHT:
	inc	e
	; falls through
@@DOWN:
	inc	d
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Actualiza la velocidad del coche con deceleración forzada (trompo, meta...)
; param b: velocidad máxima
; param c: deceleración
UPDATE_SPEED_DECELERATE:
	ld	hl, speed
	ld	a, [hl]
	sub	c
; ¿Se ha alcanzado/sobrepasado la velocidad máxima?
	jr	c, @@MINIMUM ; sí: speed < 0 (caso especial, cp 0 no activa nc)
	cp	b
	jr	nc, UPDATE_SPEED_OK ; no: speed > velocidad máxima
@@MINIMUM:
; sí: deja el valor fijado en la máxima
	ld	a, b
	jr	UPDATE_SPEED_OK
; -----------------------------------------------------------------------------

;
; =============================================================================
;	Detección y reacción a colisiones
; =============================================================================
;

; -----------------------------------------------------------------------------
; Rutina que detecta la colisión del coche con el entorno
; y actúa en consecuencia
CHECK_COLLISION:
; resetea el flag de colisión, que se guardará en el stack
	xor	a
	push	af
; ¿Colisión frontal izquierda?
	call	CHECK_FIRST_COLLISION
	jr	c, @@FRONT_LEFT_FLAG_OK
; Activa el flag
	pop	af
	or	COLL_FLAG_FL
	push	af
@@FRONT_LEFT_FLAG_OK:
; ¿Colisión frontal derecha?
	call	CHECK_NEXT_COLLISION
	jr	c, @@FRONT_RIGHT_FLAG_OK
; Activa el flag
	pop	af
	or	COLL_FLAG_FR
	push	af
@@FRONT_RIGHT_FLAG_OK:
; ¿Colisión trasera izquierda?
	call	CHECK_NEXT_COLLISION
	jr	c, @@REAR_LEFT_FLAG_OK
; Activa el flag
	pop	af
	or	COLL_FLAG_RL
	push	af
@@REAR_LEFT_FLAG_OK:
; ¿Colisión trasera derecha?
	call	CHECK_NEXT_COLLISION
	jr	c, @@REAR_RIGHT_FLAG_OK
; Activa el flag
	pop	af
	or	COLL_FLAG_RR
	jr	@@FLAGS_OK
@@REAR_RIGHT_FLAG_OK:
	pop	af
	or	a ; (para disponer de flags)
@@FLAGS_OK:
; Si no hay colisión, finaliza
	ret	z
; Hay colisión
	ld	b, a ; preserva los flags de colisión en b
; La dirección efectiva será la de la carretera (común a todo tipo de colisión)
	ld	a, [road_properties]
	and	TILE_MASK_DIR
	ld	[car_direction], a
; Elimina posible salto
	xor	a
	ld	[car_offset_y_jump], a
; Determina acciones en función del estado
	ld	a, [car_status]
; ; ¿Colisión cuando ya estaba accidentado?
	; cp	CAR_CRASH
	; jp	z, KEEP_CRASH ; car_status = CAR_CRASH
; ¿Colisión cuando ya estaba trompeando?
	cp	CAR_SPIN_L
	jp	nc, KEEP_SPIN ; car_status >= CAR_SPIN_L
; Colisión nueva
	ld	a, b ; restaura los flags de colisión
	ld	hl, @@JUMP_TABLE
	jp	JP_TABLE ; (en función de los flags de colisión)
@@JUMP_TABLE:
	.dw	0				; __ __ __ __
	.dw	NEW_FRONT_LEFT_COLLISION	; __ __ __ FL
	.dw	NEW_FRONT_RIGHT_COLLISION	; __ __ FR __
	.dw	NEW_FRONT_COLLISION 		; __ __ FR FL
	.dw	NEW_SIDE_LEFT_COLLISION		; __ RL __ __
	.dw	NEW_SIDE_LEFT_COLLISION		; __ RL __ FL
	.dw	NEW_FRONT_RIGHT_COLLISION	; __ rl FR __
	.dw	NEW_FRONT_COLLISION 		; __ rl FR FL
	.dw	NEW_SIDE_RIGHT_COLLISION	; RR __ __ __
	.dw	NEW_FRONT_LEFT_COLLISION	; rr __ __ FL
	.dw	NEW_SIDE_RIGHT_COLLISION	; RR __ FR __
	.dw	NEW_FRONT_COLLISION 		; rr __ FR FL
	.dw	NEW_REAR_COLLISION		; RR RL __ __
	.dw	NEW_FRONT_LEFT_COLLISION	; rr rl __ FL
	.dw	NEW_SIDE_RIGHT_COLLISION	; RR rl FR __
	.dw	NEW_FRONT_COLLISION 		; rr rl FR FL
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Subrutina que obtiene la atravesabilidad / colisión
; en función de las coordenadas base y un offset
; param hl: se inicializa en la primera llamada
; ret hl: se devuelve el valor a usar en la siguiente llamada
; ret nc/c: el caracter es sólido / atravesable
; touches a, bc, de
; Apunta a la parte correcta de la tabla de offsets en función de la dirección
CHECK_FIRST_COLLISION:
	ld	hl, CHECK_COLLISION_OFFSETS
	ld	a, [car_heading]
	and	$f0
	srl	a ; a = múltiplo de 8
	add	l ; hl += a
	ld	l, a
	adc	h
	sub	l
	ld	h, a
CHECK_NEXT_COLLISION:
; Se parte de la coordenada tile del coche
	ld	de, [car_xy]
; x
	ld	a, [hl]
	ld	b, a
	ld	a, [car_offset_x]
	add	b ; car_offset_x + offset_x
	sra	a ; ... /= 8
	sra	a
	sra	a
	add	e ; ... += x
	ld	e, a
	inc	hl ; para y
; y
	ld	a, [hl]
	ld	b, a
	ld	a, [car_offset_y]
	add	b ; car_offset_y + offset_y
	sra	a ; ... /= 8
	sra	a
	sra	a
	add	d
	ld	d, a ; ... += y
	inc	hl ; para la siguiente x
; Comprueba atravesabilidad / colisión
	push	hl ; preserva hl
	call	GET_TILE_VALUE
	cp	$80 ; flag de tile reflejado
	push	af ; preserva a y el nc/c de tile reflejado
; ¿Es un tile válido?
	and	$7f ; elimina el flag de tile reflejado
	cp	VALID_TILES
	jr	c, @@WALKABLE ; sí
; no: el flag de acarreo es nc: no atravesable
	pop	hl ; restaura el estado del stack sin modificar el flag de acarreo
	pop	hl ; restaura hl
	ret
@@WALKABLE:
; sí: ¿es un tile reflejado?
	pop	af ; restaura a y el nc/c de tile reflejado
	jr	nc, @@MIRROR ; sí
; no
	call	@@PREPARE
@@LOOP:
	rl	a
	djnz	@@LOOP
; En el flag de acarreo está la atravesabilidad
	pop	hl ; restaura hl
	ret
@@MIRROR:
	and	$7f ; elimina el flag de tile reflejado
	call	@@PREPARE
@@MIRROR_LOOP:
	rr	a
	djnz	@@MIRROR_LOOP
; En el flag de acarreo está la atravesabilidad
	pop	hl ; restaura hl
	ret
@@PREPARE:
; Obtiene el desplazamiento hasta el tile correcto
	ld	b, 0 ; bc = a * 8
	ld	c, a
	sla	c
	; rl	b ; innecesario: la primera vez nunca puede haber acarreo (a <= $7f)
	sla	c
	rl	b
	sla	c
	rl	b
; Obtiene el desplazamiento hasta la línea correcta
	ld	a, d ; d = y
	and	COORD_MASK_CHAR ; .char
	add	c ; bc += a
	ld	c, a
; Apunta hl a la información del tile y lo lee
	ld	hl, TILE_WALKABILITY
	add	hl, bc
	ld	a, [hl]
	push	af ; preserva el byte leído
; Carga en b el número de rotaciones que hay que hacer
	ld	a, e ; e = y
	and	COORD_MASK_CHAR ; .char
	inc	a
	ld	b, a
	pop	af ; restaura a (el byte leído)
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Colisión cuando el coche ya estaba accidentado
KEEP_CRASH:
	; ??? TODO
; ------VVVV----falls through--------------------------------------------------

; -----------------------------------------------------------------------------
; Colisión cuando el coche ya estaba trompeando
KEEP_SPIN:
; Devuelve el coche a los tiles atravesables
	ld	hl, @@DIR_DIFF_TABLE
	ld	a, b ; a = flags de colisión
	add	l ; hl += a
	ld	l, a
	adc	h
	sub	l
	ld	h, a
; "Empuja" el coche hacia car_heading + direction_diff_table[i]
	ld	a, [car_heading]
	add	[hl]
; Convierte en una dirección utilizable con MOVE_CAR_JUMP_TABLE
	and	HEADING_MASK_DIR & ~HEADING_FLAG_HALF
	rrca	; Convierte una dirección tipo byte en una tipo DIR_*
	rrca
	rrca
	rrca
	and	$0f
	ld	hl, MOVE_CAR_JUMP_TABLE
	call	JP_TABLE_A_OK ; evita sra a / add a
; La dirección efectiva será la de la carretera
	ld	a, [road_properties]
	and	TILE_MASK_DIR
	ld	[car_direction], a
	ret
; Tabla con la modificación a aplicar a la dirección
; para empujar el coche hacia los tiles atravesables
@@DIR_DIFF_TABLE:
	.db	 0 *$10 ; __ __ __ __: ??? (adelante)
	.db	 6 *$10 ; __ __ __ FL: atrás derecha
	.db	10 *$10 ; __ __ FR __: atrás izquierda
	.db	 8 *$10 ; __ __ FR FL: atrás
	.db	 2 *$10 ; __ RL __ __: adelante derecha
	.db	 4 *$10 ; __ RL __ FL: derecha
	.db	10 *$10 ; __ rl FR __: ??? (atrás izquierda)
	.db	 6 *$10 ; __ rl FR FL: atrás derecha
	.db	14 *$10 ; RR __ __ __: adelante izquierda
	.db	 6 *$10 ; rr __ __ FL: ??? (detrás derecha)
	.db	12 *$10 ; RR __ FR __: izquierda
	.db	10 *$10 ; rr __ FR FL: atrás izquierda
	.db	 0 *$10 ; RR RL __ __: adelante
	.db	 2 *$10 ; rr rl __ FL: adelante derecha
	.db	14 *$10 ; RR rl FR __: adelante izquierda
	.db	 0 *$10 ; rr rl FR FL: ??? (delante)
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Nueva colisión con la parte frontal izquierda;
; empieza a trompear hacia ese lado
NEW_FRONT_LEFT_COLLISION:
; La dirección aparente gira a la izquierda
	ld	a, [car_heading]
	sub	$10
	ld	[car_heading], a
; Inicializa el trompo a la izquierda
	ld	a, CAR_SPIN_L
	ld	[car_status], a
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Nueva colisión con la parte frontal derecha;
; empieza a trompear hacia ese lado
NEW_FRONT_RIGHT_COLLISION:
; La dirección aparente gira a la derecha
	ld	a, [car_heading]
	add	$10
	ld	[car_heading], a
; Inicializa el trompo a la derecha
	ld	a, CAR_SPIN_R
	ld	[car_status], a
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Nueva colisión frontal; accidente
NEW_FRONT_COLLISION:
	; ??? TODO car_status = CAR_CRASH (¿sólo si speed>X?)
	jr	NEW_FRONT_LEFT_COLLISION
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Nueva colisión lateral; desliza hacia el lado contrario
NEW_SIDE_LEFT_COLLISION:
; Inicializa el deslizamiento a la izquierda
	ld	a, CAR_SLIDE_R
	jr	NEW_SIDE_COLLISION
NEW_SIDE_RIGHT_COLLISION:
; Inicializa el deslizamiento a la izquierda
	ld	a, CAR_SLIDE_L
	; jr	NEW_SIDE_COLLISION ; falls through
NEW_SIDE_COLLISION:
; (almacena el estado)
	ld	[car_status], a
	ld	a, CONTROL_SLIDE_DELAY
	ld	[frames_to_control], a
; La dirección aparente será también la de la carretera
	ld	a, [road_properties]
	and	TILE_MASK_DIR
	add	a
	add	a
	add	a
	add	a
	or	HEADING_SUB_ZERO ; ahora se puede comparar con heading
	ld	[car_heading], a
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Colisión en la parte trasera
NEW_REAR_COLLISION:
	; ??? TODO
	ret
; -----------------------------------------------------------------------------

;
; =============================================================================
;	Subrutinas auxiliares de movimiento del coche
; =============================================================================
;

; -----------------------------------------------------------------------------
; Mueve el coche un píxel hacia la izquierda
; en función de su dirección efectiva
MOVE_CAR_LEFT:
	ld	hl, MOVE_CAR_LEFT_JUMP_TABLE
	ld	a, [car_direction]
	jp	JP_TABLE_A_OK
; -----------------------------------------------------------------------------

; ; -----------------------------------------------------------------------------
; ; Mueve el coche un píxel hacia delante
; ; en función de su dirección efectiva
; MOVE_CAR_AHEAD:
	; ld	hl, MOVE_CAR_JUMP_TABLE
	; ld	a, [car_direction]
	; jp	JP_TABLE_A_OK
; ; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Mueve el coche un píxel hacia la derecha
; en función de su dirección efectiva
MOVE_CAR_RIGHT:
	ld	hl, MOVE_CAR_RIGHT_JUMP_TABLE
	ld	a, [car_direction]
	jp	JP_TABLE_A_OK
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Tablas de saltos para desplazar el coche un píxel
; hacia adelante o hacia alguno de los lados
; en función de la dirección.
MOVE_CAR_LEFT_JUMP_TABLE:
	.dw	OFFSET_DOWN_RIGHT	; 12
	.dw	OFFSET_DOWN		; 14
MOVE_CAR_JUMP_TABLE:
	.dw	OFFSET_DOWN_LEFT	; 00 00
	.dw	OFFSET_LEFT		; 02 02
MOVE_CAR_RIGHT_JUMP_TABLE:
	.dw	OFFSET_UP_LEFT		; 04 04 04
	.dw	OFFSET_UP		; 06 06 06
	.dw	OFFSET_UP_RIGHT		; 08 08 08
	.dw	OFFSET_RIGHT		; 10 10 10
	.dw	OFFSET_DOWN_RIGHT	;    12 12
	.dw	OFFSET_DOWN		;    14 14
	.dw	OFFSET_DOWN_LEFT	;       00
	.dw	OFFSET_LEFT		;       01
OFFSET_DOWN_LEFT:
	call	OFFSET_DOWN ; (down)
	; falls through (left)
OFFSET_LEFT:
	ld	a, [car_offset_x]
	cp	-(TILE_WIDTH - 1)
	ld	hl, car_offset_x
	jr	z, @@TILE_LEFT
; Aumenta el offset hacia la izquierda
	dec	[hl]
	ret
@@TILE_LEFT:
; Completa el movimiento de un tile hacia la izquierda
	ld	[hl], 0 ; (car_offset_x)
	ld	hl, car_x
	dec	[hl]
	ret
OFFSET_UP_LEFT:
	call	OFFSET_LEFT ; (left)
	; falls through (up)
OFFSET_UP:
	ld	a, [car_offset_y]
	cp	-(TILE_WIDTH - 1)
	ld	hl, car_offset_y
	jr	z, @@TILE_UP
; Aumenta el offset hacia arriba
	dec	[hl]
	ret
@@TILE_UP:
; Completa el movimiento de un tile hacia arriba
	ld	[hl], 0 ; (car_offset_y)
	ld	hl, car_y
	dec	[hl]
	ret
OFFSET_UP_RIGHT:
	call	OFFSET_UP ; (up)
	; falls through (right)
OFFSET_RIGHT:
	ld	a, [car_offset_x]
	cp	(TILE_WIDTH - 1)
	ld	hl, car_offset_x
	jr	z, @@TILE_RIGHT
; Aumenta el offset hacia la derecha
	inc	[hl]
	ret
@@TILE_RIGHT:
; Completa el movimiento de un tile hacia arriba
	ld	[hl], 0
	ld	hl, car_x
	inc	[hl]
	ret
OFFSET_DOWN_RIGHT:
	call	OFFSET_RIGHT ; (right)
	; falls through (down)
OFFSET_DOWN:
	ld	a, [car_offset_y]
	cp	(TILE_WIDTH - 1)
	ld	hl, car_offset_y
	jr	z, @@TILE_DOWN
; Aumenta el offset hacia abajo
	inc	[hl]
	ret
@@TILE_DOWN:
; Completa el movimiento de un tile hacia abajo
	ld	[hl], 0
	ld	hl, car_y
	inc	[hl]
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Desliza y resetea intención de giro estando derrapando hacia la izquierda
SLIDE_UNDRIFT_FROM_LEFT:
	call	MOVE_CAR_RIGHT
UNDRIFT_FROM_LEFT:
	ld	hl, car_heading
	inc	[hl]
; ¿Queda intención de giro?
	ld	b, [hl] ; preserva car_heading
	inc	hl ; hl = car_direction
	ld	a, [hl]
	add	a
	add	a
	add	a
	add	a
	or	HEADING_SUB_ZERO ; ahora se puede comparar con heading
	cp	b
	jr	z, @@NORMAL ; no (car_heading = car_direction)
	ret	nc ; sí (car_heading <= car_direction)
; no: vuelve al estado normal
@@NORMAL:
	ld	a, CAR_NORMAL
	ld	[car_status], a
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Desliza y resetea intención de giro estando derrapando hacia la derecha
SLIDE_UNDRIFT_FROM_RIGHT:
	call	MOVE_CAR_LEFT
UNDRIFT_FROM_RIGHT:
	ld	hl, car_heading
	dec	[hl]
; ¿Queda intención de giro?
	ld	b, [hl] ; preserva car_heading
	inc	hl ; hl = car_direction
	ld	a, [hl]
	add	a
	add	a
	add	a
	add	a
	or	HEADING_SUB_ZERO ; ahora se puede comparar con heading
	cp	b
	ret	c ; sí (car_heading > car_direction)
; no: vuelve al estado normal
@@NORMAL:
	ld	a, CAR_NORMAL
	ld	[car_status], a
	ret
; -----------------------------------------------------------------------------

;
; =============================================================================
;	Eventos
; =============================================================================
;

; -----------------------------------------------------------------------------
; Rutina que actualiza el evento actual
; y/o dispara uno nuevo si procede
UPDATE_EVENT:
; ¿Hay un evento actualmente?
	ld	hl, frames_current_event
	ld	a, [hl]
	or	a
	call	nz, UPDATE_CURRENT_EVENT ; sí
; ¿Se ha disparado el evento?
	call	CHECK_EVENT
	ret	z ; no
; sí: ¿Es un evento especial?
	ld	ix, [current_event_addr]
	ld	a, [ix + EVENT_TYPE]
	and	EVENT_MASK_SPECIAL
	jr	nz, @@NEW_SPECIAL_EVENT ; sí
; no: oculta el evento previo
	call	HIDE_CURRENT_EVENT
; no: color de fondo del evento
	ld	hl, EVENT_COLORS
	ld	a, [ix + EVENT_COLOR]
	add	a ; ... *8
	add	a
	add	a
	add	l ; hl += a
	ld	l, a
	adc	h
	sub	l
	ld	h, a
	ld	[current_event_colortable], hl ; puntero a la tabla
	ld	a, [hl] ; aplica el primer color de la tabla
	ld	[spratr_buffer_event +7], a
; Avanza el patrón del evento
	ld	a, [spratr_buffer_event +2]
	add	4
	ld	[spratr_buffer_event +2], a
; Muestra los sprites
	ld	a, EVENT_Y
	ld	[spratr_buffer_event], a
	ld	[spratr_buffer_event +4], a
; Inicializa la duración del evento
	ld	a, EVENT_DELAY
	ld	[frames_current_event], a
; Apunta al siguiente evento
	jr	@@NEXT_EVENT

@@NEW_SPECIAL_EVENT:
	bit	7, a ; 7 = $80 = EVENT_FLAG_FINISH
	jr	nz, @@EVENT_FINISH
	bit	6, a ; 6 = $40 = EVENT_FLAG_JUMP
	jr	nz, @@EVENT_JUMP
	; bit	5, a ; 5 = $20 = EVENT_FLAG_SKID
	; jr	nz; @@EVENT_SKID

@@EVENT_SKID:
; ¿Está pulsado el cursor?
	ld	a, [stick]
	cp	3
	jr	z, @@SKID_RIGHT ; sí: derecha
	cp	7
	jr	nz, @@NEXT_EVENT ; no
; sí: izquierda
	ld	a, CAR_SPIN_L
	jr	@@SKID
@@SKID_RIGHT:
	ld	a, CAR_SPIN_R
	; jr	@@SKID ; falls through
@@SKID:
	ld	[car_status], a
	jr	@@NEXT_EVENT

@@EVENT_JUMP:
; ¿Está trompeando?
	ld	hl, car_status
	ld	a, [hl]
	cp	CAR_SPIN_L
	jr	nc, @@NEXT_EVENT ; sí: no aplica el salto
; no: cambia el coche de estado
	ld	[hl], CAR_JUMP
; determina la altura del salto en función de la velocidad
	ld	a, [speed]
	cp	SPEED_HIGH_JUMP
	ld	a, CAR_JUMP_Y_OFFSET_LOW - CAR_JUMP_Y_OFFSET
	jr	c, @@A_OK ; no es velocidad máxima
; sí: altura máxima
	xor	a
@@A_OK:
	ld	[frames_to_control], a
; La dirección efectiva será la de la carretera
	ld	a, [road_properties]
	and	TILE_MASK_DIR
	ld	[car_direction], a
	jr	@@NEXT_EVENT

@@EVENT_FINISH:
; cambia el coche de estado
	ld	a, CAR_FINISH
	ld	[car_status], a
	; jr	@@NEXT_EVENT ; falls through

; Apunta al siguiente evento
@@NEXT_EVENT:
	ld	bc, EVENT_SIZE
	add	ix, bc
	ld	[current_event_addr], ix
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Actualiza el evento que está actualmente mostrado en pantalla
; param hl: frames_current_event
UPDATE_CURRENT_EVENT:
; ¿Se ha de ocultar el evento?
	dec	[hl]
	jr	z, HIDE_CURRENT_EVENT ; sí
; no: aplica parpadeo
	neg	; a = 0..EVENT_DELAY
	add	EVENT_DELAY
	srl	a ; a /= 4 (cambia de color cada 4 frames)
	srl	a
	and	$07 ; (limitado al tamaño de EVENT_COLORS)
; busca el color a utilizar
	ld	hl, [current_event_colortable]
	add	l ; hl += a
	ld	l, a
	adc	h
	sub	l
	ld	h, a
	ld	a, [hl]
	ld	[spratr_buffer_event +7], a
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Oculta el evento que está actualmente mostrado en pantalla
HIDE_CURRENT_EVENT:
; Oculta los sprites del evento actual
	ld	a, SPAT_OB
	ld	[spratr_buffer_event], a
	ld	[spratr_buffer_event +4], a
; ¿era el pseudo evento "Go!"?
	ld	hl, [current_event_addr]
	ld	de, events
	xor	a
	sbc	hl, de
	ret	nz ; no (hl != de)
; sí: oculta los sprites de la intro
	ld	a, SPAT_END
	ld	[spratr_buffer_countdown], a
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Comprueba si se ha disparado el evento actual
; ret nz: si el disparador ha pasado de off a on (edge)
CHECK_EVENT:
; Comprueba si se dispara un nuevo evento
	ld	ix, [current_event_addr]
	ld	a, EVENT_MASK_TRIGGER
	and	[ix + EVENT_TYPE]
	ld	b, a ; b = tipo de disparador (1..5)
	djnz	@@CHECK_UL
; Comprueba un nuevo evento yendo a la izquierda
	ld	a, [car_x]
	cp	[ix + EVENT_CP]
; Hay evento si car_x < evento (x)
	jp	m, @@ON
	jr	@@OFF
@@CHECK_UL:
	djnz	@@CHECK_U
; Comprueba un nuevo evento yendo arriba a la izquierda
	ld	hl, car_y
	ld	a, [hl]
	dec	hl ; hl = car_x
	add	[hl]
	cp	[ix + EVENT_CP]
; Hay evento si car_y + car_x < evento (y + x)
	jp	m, @@ON
	jr	@@OFF
@@CHECK_U:
	djnz	@@CHECK_UR
; Comprueba un nuevo evento yendo arriba
	ld	a, [car_y]
	cp	[ix + EVENT_CP]
; Hay evento si car_y < evento (y)
	jp	m, @@ON
	jr	@@OFF
@@CHECK_UR:
	djnz	@@CHECK_R
; Comprueba un nuevo evento yendo arriba a la derecha
	ld	hl, car_y
	ld	a, [hl]
	dec	hl ; hl = car_x
	sub	[hl]
	cp	[ix + EVENT_CP]
; Hay evento si car_y - car_x < evento (y - x)
	jp	m, @@ON
	jr	@@OFF
@@CHECK_R:
; Comprueba un nuevo evento yendo a la derecha
	ld	a, [car_x]
	cp	[ix + EVENT_CP]
; Hay evento si car_x > evento (x)
	jp	m, @@OFF
	; jr	@@ON ; falls through
@@ON:
	ld	hl, current_event_trigger
	ld	a, 1
	cp	[hl] ; para el ret z/nz
	ld	[hl], a
	ret
@@OFF:
	xor	a
	ld	[current_event_trigger], a
	ret	; siempre devolverá z
; -----------------------------------------------------------------------------

;
; =============================================================================
;	Otras subrutinas del bucle principal
; =============================================================================
;

; -----------------------------------------------------------------------------
; Actualiza el marcador de tiempo
UPDATE_TIMER:
; incrementa frames_in_tenth y el tiempo si procede
	ld	hl, frames_in_tenth
	inc	[hl]
	ld	a, [frames_per_tenth]
	sub	[hl]
	ret	nz

; reinicia frames_in_tenth
	; xor	a ; innecesario por sub [hl]
	ld	[hl], a
; incrementa las décimas y las unidades de segundos
	dec	hl ; hl = time, byte 2
	ld	a, [hl]
	add	$01
	daa
	ld	[hl], a
	jr	nc, @@TIME_OK
; incrementa las decenas de segundos
	dec	hl ; hl = time, byte 1
	inc	[hl] ; (como es <8 siempre, no nos preocupa BCD)

@@TIME_OK:
; comprobaciones adicionales en cada incremento de décimas
	ld	a, [time]
	ld	hl, seconds_per_stage
	cp	[hl]
	jr	c, @@CHECK_HURRY_UP
; tiempo excedido: cambia el color del indicador a rojo
	ld	a, 6
	jr	SET_TIMER_COLOR
@@CHECK_HURRY_UP:
	dec	hl ; hl = seconds_hurry_up
	cp	[hl]
	ret	c

; segundos finales: parpadeo del marcador
	ld	a, [hurry_up]
	inc	a
	and	$07 ; (limitado al tamaño de HURRY_UP_COLORS)
	ld	[hurry_up], a
; busca el color a utilizar
	ld	hl, HURRY_UP_COLORS
	add	l ; hl += a
	ld	l, a
	adc	h
	sub	l
	ld	h, a
	ld	a, [hl]
; ------VVVV----falls through--------------------------------------------------

; -----------------------------------------------------------------------------
; Actualiza el color del marcador de tiempo
; param a: color del marcador de tiempo
SET_TIMER_COLOR:
	ld	[spratr_buffer_timer + 7], a
	ld	[spratr_buffer_timer + 15], a
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Comprueba si el coche está suficientemente cerca del centro
; y ha de avanzar el scroll
UPDATE_CAMERA:
; ¿Ha habido desplazamiento del coche o no hubo scroll en el frame anterior?
	ld	hl, scroll_status
	ld	a, SCROLL_FLAG_LAST
	cp	[hl] ; para el ret z
	res	SCROLL_BIT_LAST, [hl] ; desactiva el flag para el próximo frame
	ret	z ; no: no hay SCROLL_FLAG_CAR y sí SCROLL_FLAG_LAST
; Calcula en de el centro de la pantalla
	ld	a, [viewport_x]
	add	SCR_WIDTH / 2
	ld	e, a
	ld	a, [viewport_y]
	add	SCR_HEIGHT / 2
	ld	d, a
; Calcula en l = dx = abs(car_x - centro_x)
	ld	a, [car_x]
	sub	e
	jp	p, @@DX_OK
	cpl
@@DX_OK:
	ld	l, a
; Calcula en h = dy = abs(car_y - centro_y)
	ld	a, [car_y]
	sub	d
	jp	p, @@DY_OK
	cpl
@@DY_OK:
	ld	h, a
; Compara dx y dy
	cp	l
	jr	c, @@DX_GREATER
; dy > dx; distancia aproximada = dx + dy >> 2
	ld	a, l
	sra	a
	sra	a
	add	h
	jr	@@DO_CHECK
@@DX_GREATER:
; dx > dy; distancia aproximada = dy + dx >> 2
	; ld	a, h ; innecesario; ya está cargado h en a
	sra	a
	sra	a
	add	l
	; jr	@@DO_CHECK ; falls through
@@DO_CHECK:
; Comprueba si ha de hacer scroll
	cp	SCROLL_WHEN
	ret	nc ; no (distancia aproximada < SCROLL_WHEN)
; Marca para evitar scroll demasiado rápido
	ld	hl, scroll_status
	set	SCROLL_BIT_LAST, [hl]
; Obtiene la dirección de la cámara y aplica el scroll
	; ld	de, ... ; innecesario; ya está cargado el centro de la pantalla en de
	call	GET_TILE_VALUE
	call	GET_TILE_PROPERTIES
	jp	APPLY_SCROLL
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Actualiza las coordenadas del coche en la SPRATR
UPDATE_CAR_SPRATR:
; Localiza el spratr correspondiente a la dirección del coche
	ld	hl, SPRATR_CAR_TABLE
	ld	a, [car_heading]
	rrca	; Convierte una dirección tipo byte en una tipo DIR_*
	rrca
	rrca
	and	$1e
	call	GET_HL_A_WORD
; Vuelca el spratr
	ld	de, spratr_buffer_car
	ld	bc, NUM_SPRITES_CAR * 4 + 1
	ldir

; Calcula y : (car_y - viewport_y) *8 +car_offset_y -1 +car_offset_y_jump +car_offset_y_vibration
	ld	a, [car_y] ; car_y
	ld	hl, viewport_y ; ... - viewport_y
	or	a
	sbc	[hl]
	add	a ; ... *8
	add	a
	add	a
	ld	hl, car_offset_y ; + car_offset_y
	add	[hl]
	dec	a ; -1 (ajusta la coordenada vertical del sprite)
	ld	c, a ; preserva y sin vibración ni salto en c
	inc	hl ; + car_offset_y_jump
	add	[hl]
	inc	hl ; + car_offset_y_vibration
	add	[hl]
	ld	d, a ; preserva y en d
; Calcula x : (car_x - viewport_x) *8 + car_offset_x
	ld	a, [car_x] ; car_x
	ld	hl, viewport_x ; ... - viewport_x
	or	a
	sbc	[hl]
	add	a ; ... *8
	add	a
	add	a
	ld	hl, car_offset_x ; + car_offset_x
	add	[hl]
	ld	e, a ; preserva x en e

; suma y al spratr volcado
	ld	hl, spratr_buffer_car
	ld	b, NUM_SPRITES_CAR
@@LOOP:
; ¿y == SPAT_END?
	ld	a, [hl]
	cp	SPAT_END
	jr	z, @@PAST_SPAT ; sí
; no: y += d
	add	d
	ld	[hl], a
	inc	hl
; x += e
	ld	a, [hl]
	add	e
	ld	[hl], a
	inc	hl
; salta patrón y color
	inc	hl
	inc	hl
	djnz	@@LOOP
	jr	@@SHADOW

@@PAST_SPAT:
	ld	a, SPAT_OB
@@LOOP_2:
; y = SPAT_OB
	ld	[hl], a
; salta x, patrón y color
	inc	hl
	inc	hl
	inc	hl
	inc	hl
	djnz	@@LOOP_2
	; jr	@@SHADOW ; falls through

@@SHADOW:
; ¿está en salto?
	ld	a, [car_offset_y_jump]
	or	a
	jr	z, @@NO_SHADOW ; no: no hay sombra

; sí: y de la sombra
	ld	a, -8 ; y sin vibración ni salto - 8
	add	c
	ld	[hl], a
	inc	hl
; x de la sombra
	ld	a, -8 ; x - 8
	add	e
	ld	[hl], a
	inc	hl
; alterna entre los dos patrones de la sombra
	ld	a, $2c ^ $30
	xor	[hl]
	ld	[hl], a
	ret
	
@@NO_SHADOW:
	ld	[hl], SPAT_OB
	ret
; -----------------------------------------------------------------------------

;
; =============================================================================
;	Sonido del bucle principal
; =============================================================================
;

; -----------------------------------------------------------------------------
; Actualiza los registros del PSG.
; - Canal A: ruido del motor
; - Canales B y C: sonido del derrape
UPDATE_SOUND:
; Canal A: ruido del motor
	ld	a, [trigger]
	or	a
	ld	a, [speed] ; para la llamada a GET_ENGINE_SOUND_*
	jr	nz, @@ACCELERATE
; Sonido decelerando
	call	GET_ENGINE_SOUND_DECCELERATE
	jr	@@FREQ_A_OK
; Sonido acelerando
@@ACCELERATE:
	call	GET_ENGINE_SOUND_ACCELERATE
	; jr	@@FREQ_A_OK ; falls through
@@FREQ_A_OK:
	ld	[psg_frequency_channel_a], hl
; Canales B y C: sonido del derrape
	ld	a, [car_status]
	cp	CAR_DRIFT_L
	jr	nc, @@CHECK_DRIFT
; No hay derrape: Canales B y C anulados
	xor	a
	ld	hl, psg_volume_channel_b
	ld	[hl], a
	inc	hl ; psg_volume_channel_c
	ld	[hl], a
	ret
@@CHECK_DRIFT:
	cp	CAR_SPIN_L
	jr	nc, @@SPIN
; Sonido de derrape
; selecciona el frame de sonido correcto
	ld	hl, tmp_frame
	ld	a, [hl]
	inc	a
	and	3 ; 0..3
	ld	[hl], a
; apunta a la frecuencia del frame
	ld	hl, SOUND_DRIFT
	ld	d, 0 ; hl += a * 2
	add	a
	ld	e, a
	add	hl, de
; volcado
	ld	de, psg_frequency_channel_b
	ldi	; psg_frequency_channel_b
	ldi
; volúmenes (fijos: 12, 0)
	ld	a, 12
	ld	hl, psg_volume_channel_b
	ld	[hl], a
	xor	a
	inc	hl ; psg_volume_channel_c
	ld	[hl], a
	ret
@@SPIN:
; Sonido de trompo
; selecciona el frame de sonido correcto
	ld	hl, tmp_frame
	ld	a, [hl]
	inc	a
	and	3 ; 0..3
	ld	[hl], a
; apunta a las frecuencias y volúmenes del frame
	ld	hl, SOUND_SPIN
	ld	d, 0 ; hl += a * 6
	add	a ; a = a*2
	ld	e, a ; e = a*2
	add	a ; a = a*4
	add	e ; a = a*4 + e = e*6
	ld	e, a
	add	hl, de
; volcado
	ld	de, psg_frequency_channel_b
	ldi	; psg_frequency_channel_b
	ldi
	ldi	; psg_frequency_channel_c
	ldi
	ld	de, psg_volume_channel_b
	ldi	; psg_volume_channel_b
	ldi	; psg_volume_channel_c
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Calcula la frecuencia de sonido a utilizar reteniendo (decelerando)
; param a: velocidad para la que generar el sonido (0-96)
; ret hl: frecuencia a utilizar
GET_ENGINE_SOUND_DECCELERATE:
; Sonidos decelerando (0=2560..96=1024)
	neg	; hl = -a
	ld	h, $ff
	ld	l, a
	add	hl, hl ; ...*=16
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	bc, 2560 ; ...+=2560
	add	hl, bc
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Calcula la frecuencia de sonido a utilizar acelerando
; param a: velocidad para la que generar el sonido (0-96)
; ret hl: frecuencia a utilizar
GET_ENGINE_SOUND_ACCELERATE:
	cp	SPEED_MIN
	jr	nc, @@HIGH
; Acelerando, marcha baja (0=2560..48=1024)
	; ld	a, [speed] ; innecesario
	neg	; hl = -a
	ld	h, $ff
	ld	l, a
	add	hl, hl ; ...*=32
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	bc, 2560
	add	hl, bc
	ret

@@HIGH:
; Acelerando, marcha alta (48=1664..96=1280)
	; ld	a, [speed] ; innecesario
	neg	; hl = -a
	ld	h, $ff
	ld	l, a
	add	hl, hl ; ...*=8
	add	hl, hl
	add	hl, hl
	ld	bc, 2048
	add	hl, bc
	ret
; -----------------------------------------------------------------------------

;
; =============================================================================
;	Lectura de información del mapa
; =============================================================================
;

; -----------------------------------------------------------------------------
; Obtiene el identificador del tile que hay en unas coordendas concretas
; param de: coordenadas xy del tile
; ret a: identificador del tile
; touches bc, hl
GET_TILE_VALUE:
; Apunta hl al tile sobre el que están las coordenadas de
	ld	a, d ; d = y
	and	COORD_MASK_TILE ; .tile
	ld	h, 0
	ld	l, a
	add	hl, hl
	add	hl, hl ; (y.tile * 32) ...
	ld	bc, map
	add	hl, bc ; ... + map ...
	ld	a, e; e = x
	and	COORD_MASK_TILE ; .tile
	ld	b, 0
	ld	c, a
	rr	c
	rr	c
	rr	c
	add	hl, bc ; ... + (x.tile) ; FIXME verificar overflow
; Lee el tile
	ld	a, [hl]
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Obtiene las propiedades de un tile concreto
; param a: identificador del tile
; ret a: propiedades del tile
; touches bc, hl
GET_TILE_PROPERTIES:
; ¿Es un tile válido?
	ld	b, a ; preserva a
	and	$7f ; elimina el flag de tile reflejado
	cp	VALID_TILES
	jr	nc, @@INVALID ; no: el flag de acarreo es nc: no atravesable
; sí
	ld	a, b ; restaura a
	rlca	; el flag de tile reflejado pasará a ser el bit más bajo
; Apunta hl a la información del tile y la lee
	ld	hl, TILE_PROPERTIES
	add	l ; hl += a
	ld	l, a
	adc	h
	sub	l
	ld	h, a
	ld	a, [hl] ; a = [hl]
	ret

; No atravesable: se utiliza valor por defecto por si hay colisión con este tile
@@INVALID:
; ¿Es un tile reflejado?
	bit	7, b
	jr	nz, @@MIRROR_INVALID ; sí
; no: valor por defecto: UR
	ld	a, DIR_UR
	ret
@@MIRROR_INVALID:
; reflejado: valor por defecto UL
	ld	a, DIR_UL
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Adapta las propiedades de un tile para que sean válidas
; como indicador de la dirección y curvatura de la carretera
; param de: coordenadas xy del tile
; ret a: propiedades del tile
; touches bc, hl
GET_ROAD_PROPERTIES:
	call	GET_TILE_VALUE
	call	GET_TILE_PROPERTIES
	ld	b, a ; preservamos a (por si fuera necesario)
	and	TILE_FLAG_LEFT | TILE_FLAG_RIGHT
; si no hay giro, las propiedades valen tal cual
	ld	a, b ; restaura a para el ret z o para el and siguiente
	ret	z

; si hay giro, mira si es una dirección a corregir siempre (horizontal)
	and	TILE_MASK_DIR
	cp	DIR_L
	jr	z, @@LEFT
	cp	DIR_R
	jr	z, @@RIGHT
; otras direcciones, la dirección es válida tal cual si no hay flag modificador
	bit	TILE_BIT_HALF, b
	jr	nz, @@HALF
	bit	TILE_BIT_THIRD, b
	jr	nz, @@THIRD
; no hay flag modificador
	ld	a, b ; restaura a para el ret
	ret

@@LEFT:
; dirección izquierda, ¿está el coche en la mitad inferior del tile?
	ld	a, [car_y]
	and	7
	cp	4
	ld	a, b ; restaura a para el ret c o para el xor siguiente
	ret	c ; No (car_y.pixel < 4)
; Sí: cambia izquierda por arriba-izquierda
	xor	(DIR_L ^ DIR_UL)
	ret

@@RIGHT:
; dirección derecha, ¿está el coche en la mitad inferior del tile?
	ld	a, [car_y]
	and	7
	cp	4
	ld	a, b ; restaura a para el ret c o para el xor siguiente
	ret	c ; No (car_y.pixel < 4)
; Sí: cambia derecha por arriba-derecha
	xor	(DIR_R ^ DIR_UR)
	ret

@@HALF:
; hay flag modificador: medio tile
; ¿Está el coche en la mitad inferior del tile?
	ld	a, [car_y]
	and	7
	cp	4
	jr	@@ZERO_OR_ONE_STEP

@@THIRD:
; hay flag modificador: tile por tercios
; ¿Está el coche en el tercio superior?
	ld	a, [car_y]
	and	7
	cp	3
	jr	c, @@MINUS_ONE_STEP ; Tercio superior (car_y.pixel < 3)
; ¿Está el coche en el tercio inferior?
	cp	6
@@ZERO_OR_ONE_STEP:
	ld	a, b ; restaura a para el ret c o para el and siguiente
	ret	c

@@ONE_STEP:
; Modifica la dirección en función del giro (un paso)
	and	TILE_FLAG_RIGHT
	ld	a, b ; restaura a para el inc/dec y ret
	jr	nz, @@DEC
@@INC:
; Giro a la izquierda; incrementa la dirección
	add	2
	ret

@@MINUS_ONE_STEP:
; Modifica la dirección en función del giro (un paso, sentido contrario)
	ld	a, b ; restaura a para el and
	and	TILE_FLAG_RIGHT
	ld	a, b ; restaura a para el inc/dec y ret
	jr	nz, @@INC
@@DEC:
; Giro a la derecha; decrementa la dirección
	sub	2
	ret
; -----------------------------------------------------------------------------

;
; =============================================================================
;	Scroll
; =============================================================================
;

; -----------------------------------------------------------------------------
; Realiza el primer volcado del scroll
INIT_SCROLL:
	call	LOCATE_TOP_LEFT
	ld	c, SCR_HEIGHT / TILE_WIDTH ; filas
@@LOOP_LINE:
	ld	b, SCR_WIDTH / TILE_WIDTH ; columnas
@@LOOP_ROW:
	push	bc ; preserva el contador
	push	de ; preserva los punteros
	push	hl
	ld	a, [hl]
	call	DRAW_FULL_TILE
; Siguiente tile
	pop	hl ; restaura hl
	inc	hl ; hl++
	pop	de ; restaura de
	ld	a, TILE_WIDTH ; de += TILE_WIDTH
	add	e
	ld	e, a
	adc	d
	sub	e
	ld	d, a
	pop	bc ; restaura el contador
	djnz	@@LOOP_ROW
; ¿Hay siguiente fila?
	dec	c
	ret	z ; no hay más filas
; Siguiente fila
	ld	a, SCR_WIDTH * (TILE_WIDTH -1)
	add	e ; de += a
	ld	e, a
	adc	d
	sub	e
	ld	d, a
	ld	a, MAP_WIDTH - (SCR_WIDTH / TILE_WIDTH)
	add	l ; hl += a
	ld	l, a
	adc	h
	sub	l
	ld	h, a
	jr	@@LOOP_LINE
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Dibuja un bloque horizontal completo
; param a: índice del tile a utilizar
; param de: puntero al caracter a escribir
DRAW_FULL_TILE:
	; cp	$80 ; flag de tile reflejado
	; jp	p, @@MIRROR_FULL_TILE
	call	GET_H_LINE
	ld	b, 8 ; líneas a escribir
@@LOOP_LINE:
; Vuelca los 8 caracteres de la linea
	ld	c, 8 ; ldi decrementa bc, con esto no modifica b
	REPT 8
	ldi
	ENDR
	dec	b
	ret	z ; no hay más lineas
; Siguiente línea
	ld	a, SCR_WIDTH - TILE_WIDTH ; de += ...
	add	e
	ld	e, a
	adc	d
	sub	e
	ld	d, a
	jr	@@LOOP_LINE

; @@MIRROR_FULL_TILE:
	; and	$7F ; elimina el flag
	; call	GET_H_LINE
; ; empieza por la derecha (+7)
	; ld	bc, TILE_WIDTH - 1
	; add	hl, bc
	; ld	c, 8 ; líneas a escribir
; @@MIRROR_LOOP_LINE:
	; ld	b, 8 ; caracteres a escribir
; @@MIRROR_LOOP_CHAR:
	; ld	a, [hl]
	; dec	hl ; ...hacia la izquierda
	; cp	$80; flag de char que puede ser reflejado
	; jp	m, @@WRITE
	; xor	$1f ; refleja el char
; @@WRITE:
	; ld	[de], a
	; inc	de
	; djnz	@@MIRROR_LOOP_CHAR
	; dec	c
	; ret	z ; no hay más lineas
; ; Siguiente línea
	; ld	a, TILE_WIDTH + TILE_WIDTH ; hl += ...
	; adc	l
	; ld	l, a
	; jr	nc, @@ELSE
	; inc	h
; @@ELSE:
	; ld	a, SCR_WIDTH - TILE_WIDTH ; de += ...
	; adc	e
	; ld	e, a
	; jr	nc, @@MIRROR_LOOP_LINE
	; inc	d
	; jr	@@MIRROR_LOOP_LINE
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Calcula la dirección de desplazamiento (scroll)
; en función de la dirección de salida de un tile
; y aplica el scroll
; param a: propiedades del tile
APPLY_SCROLL:
	ld	b, a ; preservamos a (por si fuera necesario)
	and	TILE_MASK_DIR
	ld	hl, @@JUMP_TABLE
	jp	JP_TABLE_A_OK ; evitamos sra a / add a
@@JUMP_TABLE:
	.dw	@@NO_SCROLL ; 0: dirección inválida
	.dw	@@SCROLL_LEFT ; 1
	.dw	@@SCROLL_UP_LEFT ; 2
	.dw	@@SCROLL_UP ; 3
	.dw	@@SCROLL_UP_RIGHT ; 4
	.dw	@@SCROLL_RIGHT ; 5
	.dw	@@NO_SCROLL ; 6: dirección inválida
	.dw	@@NO_SCROLL ; 7: dirección inválida
	.dw	@@NO_SCROLL ; 8: no hay desplazamiento

@@NO_SCROLL:
	ret ; no hay scroll

@@SCROLL_LEFT:
; ¿Ha lllegado la cámara al centro del tile?
	call	@@IS_LOWER_HALF
	jr	nc, @@DO_SCROLL_UP_LEFT ; no (viewport_y.char >= 5)
; viewport
	dec	hl ; hl = viewport_x
	dec	[hl]
; blit_offset
	ld	de, -1
	call	BLIT_OFFSET_LD_ADD_UNDERFLOW
	ld	[blit_offset], hl
; dibuja
	call	LOCATE_TOP_LEFT
	jp	DRAW_V_LINE

@@SCROLL_UP_LEFT:
; Comprueba primero si es el caso especial UL + HALF
	bit	TILE_BIT_HALF, b
	jr	z, @@DO_SCROLL_UP_LEFT ; no
	call	@@IS_LOWER_HALF
	jr	nc, @@DO_SCROLL_UP ; sí y cámara en la mitad inferior
@@DO_SCROLL_UP_LEFT:
; viewport
	ld	hl, viewport_x
	dec	[hl]
	inc	hl ; hl = viewport_y
	dec	[hl]
; blit_offset
	ld	de, -SCR_WIDTH -1
	call	BLIT_OFFSET_LD_ADD_UNDERFLOW
	ld	[blit_offset], hl
; dibuja
	call	LOCATE_TOP_LEFT
	push	hl
	push	de ; preserva punteros
	call	DRAW_H_LINE
	pop	de
	pop	hl ; restaura punteros
	jp	DRAW_V_LINE

@@SCROLL_UP:
; Comprueba primero si hay que alinear a la derecha
	bit	TILE_BIT_CAM, b
	jr	nz, @@DO_SCROLL_UP_RIGHT ; sí
@@DO_SCROLL_UP:
; ¿Ha lllegado la cámara a la izquierda del tile?
	ld	a, [viewport_x]
	and	COORD_MASK_CHAR
	jr	nz, @@DO_SCROLL_UP_LEFT ; no (viewport_x.char != 0)
; viewport
	ld	hl, viewport_y
	dec	[hl]
; blit_offset
	ld	de, -SCR_WIDTH
	call	BLIT_OFFSET_LD_ADD_UNDERFLOW
	ld	[blit_offset], hl
; dibuja
	call	LOCATE_TOP_LEFT
	jp	DRAW_H_LINE

@@SCROLL_UP_RIGHT:
; Comprueba primero si el caso especial UL + HALF
	bit	TILE_BIT_HALF, b
	jr	z, @@DO_SCROLL_UP_RIGHT ; no
	call	@@IS_LOWER_HALF
	jr	nc, @@DO_SCROLL_UP ; sí y cámara en la mitad inferior
@@DO_SCROLL_UP_RIGHT:
; viewport
	ld	hl, viewport_x
	inc	[hl]
	inc	hl ; hl = viewport_y
	dec	[hl]
; blit_offset
	ld	de, -SCR_WIDTH +1
	call	BLIT_OFFSET_LD_ADD_UNDERFLOW
	ld	[blit_offset], hl
; dibuja
	call	LOCATE_TOP_LEFT
	call	DRAW_H_LINE
	call	LOCATE_TOP_RIGHT
	jp	DRAW_RIGHT_V_LINE

@@SCROLL_RIGHT:
; ¿Ha lllegado la cámara al centro del tile?
	call	@@IS_LOWER_HALF
	jr	nc, @@DO_SCROLL_UP_RIGHT ; No (viewport_y.char >= 5)
; viewport
	dec	hl ; hl = viewport_x
	inc	[hl]
; blit_offset
	ld	hl, [blit_offset]
	inc	hl
; overflow? (blit_offset > 768)
	ld	a, h
	cp	3
	jp	m, @@HL_OK
; corrige overflow (blit_offset -= $0300)
	add	-3
	ld	h, a

@@HL_OK:
	ld	[blit_offset], hl
; dibuja
	call	LOCATE_TOP_RIGHT
	jp	DRAW_RIGHT_V_LINE

; ret hl: constante viewport_y
; ret c/nc: cámara en la mitad superior/inferior del tile
@@IS_LOWER_HALF:
; ¿Ha lllegado la cámara al centro del tile?
	ld	hl, viewport_y
	ld	a, [hl]
	add	4 ; corrige medio tile de diferencia entre viewport y cámara
	and	COORD_MASK_CHAR
	cp	5 ; 5 en vez de 4 para alinear con el caracter más alto de la mitad inferior
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Coloca los punteros para empezar a dibujar
; en la esquina superior izquierda
; modifica: a bc
; ret hl: puntero al primer tile a utilizar
; ret de: puntero al primer caracter a escribir
LOCATE_TOP_LEFT:
; Apunta de al primer carácter a escribir
	ld	hl, [blit_offset]
	ex	de, hl
	ld	hl, namtbl_buffer
	add	hl, de
	ex	de, hl
; Apunta hl al primer tile a utilizar
	ld	a, [viewport_y]
	and	COORD_MASK_TILE
	ld	h, 0
	ld	l, a
	add	hl, hl
	add	hl, hl ; (viewport_y.tile * 32) ...
	ld	bc, map
	add	hl, bc ; ... + map ...
	ld	a, [viewport_x]
	and	COORD_MASK_TILE
	ld	b, 0
	ld	c, a
	rr	c
	rr	c
	rr	c
	add	hl, bc ; ... + (viewport_x.tile)
; No puede haber overflow
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Coloca los punteros para empezar a dibujar
; en la esquina superior derecha
; modifica: a bc
; ret hl: puntero al primer tile a utilizar
; ret de: puntero al primer caracter a escribir
LOCATE_TOP_RIGHT:
; Apunta de al primer carácter a escribir
	ld	hl, [blit_offset]
	ex	de, hl
	ld	hl, namtbl_buffer + SCR_WIDTH - 1
	add	hl, de
	push	hl ; preserva el valor calculado
; overflow?
	ld	bc, namtbl_buffer + SCR_SIZE
	xor	a
	sbc	hl, bc
	pop	de ; restaura el valor calculado
	jp	m, @@DE_OK
; corrige overflow
	dec	d
	dec	d
	dec	d ; -768
@@DE_OK:
; Apunta hl al primer tile a utilizar
	ld	a, [viewport_y]
	and	COORD_MASK_TILE
	ld	h, 0
	ld	l, a
	add	hl, hl
	add	hl, hl ; (viewport_y.tile * 32) ...
	ld	bc, map
	add	hl, bc ; ... + map ...
	ld	a, [viewport_x]
	add	SCR_WIDTH - 1 ; ... + right ...
	and	COORD_MASK_TILE
	ld	b, 0
	ld	c, a
	rr	c
	rr	c
	rr	c
	add	hl, bc ; ... + (viewport_x.tile)
	push	hl ; preserva el valor calculado
; overflow? (todo el mapa)
	ld	bc, map + MAP_SIZE
	xor	a
	sbc	hl, bc
	pop	hl ; restaura el valor calculado
	ret	m
; corrige overflow
	ld	bc, -MAP_SIZE
	add	hl, bc
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Dibuja la línea superior de la pantalla
; param hl: puntero al primer tile a utilizar (map + nnnn)
; param de: puntero al primer caracter a escribir (namtbl_buffer + nnnn)
DRAW_H_LINE:
; Primer bloque
	push	hl ; preserva map_pointer
; ¿está alineado?
	ld	a, [viewport_x]
	and	COORD_MASK_CHAR
	jr	z, @@FIRST_BLOCK_ALIGNED
; No alineado:
	ld	c, a
	ld	a, [hl]
	call	DRAW_FIRST_H_BLOCK
	jr	@@FIRST_BLOCK_END
@@FIRST_BLOCK_ALIGNED:
; Se trata como un bloque normal
	ld	a, [hl]
	call	DRAW_MID_H_BLOCK
@@FIRST_BLOCK_END:
	pop	hl ; restaura map_pointer
; Segundo bloque
	call	MAP_POINTER_RIGHT
	push	hl ; preserva map_pointer
	ld	a, [hl]
	call	DRAW_MID_H_BLOCK
	pop	hl ; restaura map_pointer
; Tercer bloque
	call	MAP_POINTER_RIGHT
	push	hl ; preserva map_pointer
	ld	a, [hl]
	call	DRAW_MID_H_BLOCK
	pop	hl ; restaura map_pointer
; Cuarto bloque
	call	MAP_POINTER_RIGHT
	push	hl ; preserva map_pointer
	ld	a, [hl]
	call	DRAW_MID_H_BLOCK
	pop	hl ; restaura map_pointer
; Hay quinto bloque si el primero no está alineado
	ld	a, [viewport_x]
	and	COORD_MASK_CHAR
	jr	z, @@CHECK_OVERFLOW
; Quinto bloque
	call	MAP_POINTER_RIGHT
	ld	a, [viewport_x]
	and	COORD_MASK_CHAR
	ld	b, a
	ld	a, [hl]
	call	DRAW_LAST_H_BLOCK
@@CHECK_OVERFLOW:
; Comprueba si al dibujar la h_line se ha excedido namtbl_buffer
	ex	de, hl
	ld	de, line_buffer
	xor	a
	sbc	hl, de
	ret	m
	ret	z
; Vuelca los caracteres usados de h_line al principio de namtbl_buffer
	ld	b, h
	ld	c, l
	ld	hl, line_buffer
	ld	de, namtbl_buffer
	ldir
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Dibuja el primer bloque horizontal (clipado por la izquierda)
; param a: índice del tile a utilizar
; param c: número de caracteres a esquivar
; param de: puntero al caracter a escribir
DRAW_FIRST_H_BLOCK:
	cp	$80 ; flag de tile reflejado
	jp	p, @@MIRROR
	push	bc ; preserva c
	call	GET_H_LINE
	pop	bc ; restaura c
; salta los caracteres indicados
	ld	b, 0
	add	hl, bc
; caracteres a escribir: 8 menos los saltados
	ld	a, 8
	sub	c
	ld	b, a
	jr	H_BLOCK_LOOP
@@MIRROR:
	push	bc ; preserva c
	and	$7F ; elimina el flag
	call	GET_H_LINE
	pop	bc ; restaura c
; salta 7 caracteres menos los indicados
	ld	a, 7
	sub	c
	ld	b, 0
	ld	c, a
	add	hl, bc
; caracteres a escribir: los que falten hasta 8
	inc	a
	ld	b, a
	jr	H_BLOCK_MIRROR_LOOP
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Dibuja un bloque horizontal completo
; param a: índice del tile a utilizar
; param de: puntero al caracter a escribir
DRAW_MID_H_BLOCK:
	cp	$80 ; flag de tile reflejado
	jp	p, @@MIRROR
	call	GET_H_LINE
; caracteres a escribir: 8 (todos)
	ld	b, 8
	jr	H_BLOCK_LOOP
@@MIRROR:
	and	$7F ; elimina el flag
	call	GET_H_LINE
; empieza por la derecha (+7)
	ld	bc, 7
	add	hl, bc
; caracteres a escribir: 8 (todos)
	ld	b, 8
	jr	H_BLOCK_MIRROR_LOOP
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Dibuja el último bloque horizontal (clipado por la derecha)
; param a: índice del tile a utilizar
; param b: número de caracteres a escribir
; param de: puntero al caracter a escribir
DRAW_LAST_H_BLOCK:
	cp	$80 ; flag de tile reflejado
	jp	p, @@MIRROR
	push	bc ; preserva b
	call	GET_H_LINE
	pop	bc ; restaura b
; caracteres a escribir: los indicados
	jr	H_BLOCK_LOOP
@@MIRROR:
	and	$7F ; elimina el flag
	push	bc ; preserva c
	call	GET_H_LINE
; empieza por la derecha (+7)
	ld	bc, 7
	add	hl, bc
	pop	bc ; restaura b
; caracteres a escribir: los indicados
	jr	H_BLOCK_MIRROR_LOOP
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Bucle de volcado de caracteres de un bloque horizontal
; param b: número de caracteres a escribir
; param de: puntero al caracter a escribir
; param hl: puntero al caracter a leer
H_BLOCK_LOOP:
	ld	a, [hl]
	inc	hl
	ld	[de], a
	inc	de
	djnz	H_BLOCK_LOOP
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Bucle de volcado de caracteres de un bloque horizontal reflejado
; param b: número de caracteres a escribir
; param de: puntero al caracter a escribir
; param hl: puntero al caracter a leer
H_BLOCK_MIRROR_LOOP:
	ld	a, [hl]
	dec	hl ; ...hacia la izquierda
	cp	$40; char a partir del cual pueden ser reflejados
	jp	c, @@WRITE
	xor	$1f ; refleja el char
@@WRITE:
	ld	[de], a
	inc	de
	djnz	H_BLOCK_MIRROR_LOOP
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Apunta a la línea superior del tile actual
; param a: índice del tile a utilizar
; ret hl: apuntando al carácter a utilizar
GET_H_LINE:
	ld	hl, TILE_DEFINITION
; Va al tile actual
	or	a
	jr	z, @@LINE ; ya está apuntando al tile correcto
	ld	b, a
	ld	c, 0 ; a * 256 ...
	srl	b
	rr	c
	srl	b
	rr	c ; ... /4
	add	hl, bc
@@LINE:
; Va a la línea superior
	ld	a, [viewport_y]
	and	COORD_MASK_CHAR
	ret	z ; ya está apuntando a la línea superior
	add	a
	add	a
	add	a ; viewport_y.char * 8
	add	l ; hl += a
	ld	l, a
	adc	h
	sub	l
	ld	h, a
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Dibuja una línea vertical de la pantalla
; param hl: puntero al primer tile a utilizar (map + nnnn)
; param de: puntero al primer caracter a escribir (line_buffer + nnnn)
DRAW_V_LINE:
; Primer bloque
	push	hl ; preserva map_pointer
; ¿está alineado?
	ld	a, [viewport_y]
	and	COORD_MASK_CHAR
	jr	z, @@FIRST_BLOCK_ALIGNED
; No alineado:
	ld	c, a
	ld	a, [hl]
	call	DRAW_FIRST_V_BLOCK
	jr	@@FIRST_BLOCK_END
@@FIRST_BLOCK_ALIGNED:
; Se trata como un bloque normal
	ld	a, [hl]
	call	DRAW_MID_V_BLOCK
@@FIRST_BLOCK_END:
	pop	hl ; restaura map_pointer
; Segundo bloque
	call	MAP_POINTER_DOWN
	push	hl ; preserva map_pointer
	ld	a, [hl]
	call	DRAW_MID_V_BLOCK
	pop	hl ; restaura map_pointer
; Tercer bloque
	call	MAP_POINTER_DOWN
	push	hl ; preserva map_pointer
	ld	a, [hl]
	call	DRAW_MID_V_BLOCK
	pop	hl ; restaura map_pointer
; Hay cuarto bloque si el primero no está alineado
	ld	a, [viewport_y]
	and	COORD_MASK_CHAR
	ret	z
; Cuarto bloque
	ld	b, a
	push	bc ; preserva b
	call	MAP_POINTER_DOWN
	pop	bc ; restaura b
	ld	a, [hl]
	call	DRAW_LAST_V_BLOCK
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Dibuja el primer bloque vertical (clipado por arriba)
; param a: índice del tile a utilizar
; param c: número de caracteres a esquivar
; param de: puntero al caracter a escribir
DRAW_FIRST_V_BLOCK:
	cp	$80 ; flag de tile reflejado
	jp	p, @@MIRROR
	push	bc ; preserva c
	call	GET_H_LINE ; Mejor que GET_V_LINE porque apunta a la primera línea a utilizar
; avanza hasta la columna correcta
	ld	a, [viewport_x]
	and	COORD_MASK_CHAR
	add	l ; hl += a
	ld	l, a
	adc	h
	sub	l
	ld	h, a
; caracteres a escribir: 8 menos los saltados
	pop	bc ; restaura c
	ld	a, 8
	sub	c
	ld	b, a
	jp	V_BLOCK_LOOP
@@MIRROR:
	push	bc ; preserva c
	and	$7F ; elimina el flag
	call	GET_H_LINE
; avanza hasta la columna correcta
	ld	a, [viewport_x]
	and	COORD_MASK_CHAR
	cpl	; a = 8 - a
	add	8
	add	l ; hl += a
	ld	l, a
	adc	h
	sub	l
	ld	h, a
; caracteres a escribir: los indicados
	pop	bc ; restaura c
	ld	a, 8
	sub	c
	ld	b, a
	jp	V_BLOCK_MIRROR_LOOP
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Dibuja un bloque vertical completo
; param a: índice del tile a utilizar
; param de: puntero al caracter a escribir
DRAW_MID_V_BLOCK:
	cp	$80 ; flag de tile reflejado
	jp	p, @@MIRROR
	call	GET_V_LINE
; avanza hasta la columna correcta
	ld	a, [viewport_x]
	and	COORD_MASK_CHAR
	add	l ; hl += a
	ld	l, a
	adc	h
	sub	l
	ld	h, a
; caracteres a escribir: 8 (todos)
	ld	b, 8
	jp	V_BLOCK_LOOP
@@MIRROR:
	and	$7F ; elimina el flag
	call	GET_V_LINE
; avanza hasta la columna correcta
	ld	a, [viewport_x]
	and	COORD_MASK_CHAR
	cpl	; a = 8 - a
	add	8
	add	l ; hl += a
	ld	l, a
	adc	h
	sub	l
	ld	h, a
; caracteres a escribir: 8 (todos)
	ld	b, 8
	jp	V_BLOCK_MIRROR_LOOP
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Dibuja el último bloque vertical (clipado por abajo)
; param a: índice del tile a utilizar
; param b: número de caracteres a escribir
; param de: puntero al caracter a escribir
DRAW_LAST_V_BLOCK:
	cp	$80 ; flag de tile reflejado
	jp	p, @@MIRROR
	push	bc ; preserva b
	call	GET_V_LINE
; avanza hasta la columna correcta
	ld	a, [viewport_x]
	and	COORD_MASK_CHAR
	add	l
	ld	l, a
	adc	h
	sub	l
	ld	h, a
; caracteres a escribir: los indicados
	pop	bc ; restaura b
	jp	V_BLOCK_LOOP
@@MIRROR:
	push	bc ; preserva b
	and	$7F ; elimina el flag
	call	GET_V_LINE
; avanza hasta la columna correcta
	ld	a, [viewport_x]
	and	COORD_MASK_CHAR
	cpl	; a = 8 - a
	add	8
	add	l ; hl += a
	ld	l, a
	adc	h
	sub	l
	ld	h, a
; caracteres a escribir: los indicados
	pop	bc ; restaura b
	jp	V_BLOCK_MIRROR_LOOP
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Bucle de volcado de caracteres de un bloque vertical
; param b: número de caracteres a escribir
; param de: puntero al caracter a escribir
; param hl: puntero al caracter a leer
V_BLOCK_LOOP:
	ld	c, 0
	push	bc
; hl
	ld	a, [hl]
	ld	bc, TILE_WIDTH
	add	hl, bc
	push	hl
; de
	ld	[de], a
	call	NAMTBL_BUFFER_DOWN
; pops y siguiente iteración
	pop	hl
	pop	bc
	djnz	V_BLOCK_LOOP
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Bucle de volcado de caracteres de un bloque vertical reflejado
; param b: número de caracteres a escribir
; param de: puntero al caracter a escribir
; param hl: puntero al caracter a leer
V_BLOCK_MIRROR_LOOP:
	ld	c, 0
	push	bc
	ld	a, [hl]
; hl += 8
	ld	bc, TILE_WIDTH
	add	hl, bc
	push	hl
; a
	cp	$40; char a partir del cual pueden ser reflejados
	jp	c, @@WRITE
	xor	$1f ; refleja el char
@@WRITE:
	ld	[de], a
	call	NAMTBL_BUFFER_DOWN
; pops y siguiente iteracion
	pop	hl
	pop	bc
	djnz	V_BLOCK_MIRROR_LOOP
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Apunta a la línea superior del tile actual
; param a: índice del tile a utilizar
; ret hl
GET_V_LINE:
	ld	hl, TILE_DEFINITION
; Va al tile actual
	or	a
	ret	z ; ya está apuntando al tile correcto
	ld	b, a
	ld	c, 0 ; a * 256 ...
	srl	b
	rr	c
	srl	b
	rr	c ; ... /4
	add	hl, bc
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Dibuja la línea vertical derecha de la pantalla
; param hl: puntero al primer tile a utilizar (map + nnnn)
; param de: puntero al primer caracter a escribir (line_buffer + nnnn)
DRAW_RIGHT_V_LINE:
; Carga una posición ficticia de viewport_x
	ld	a, [viewport_x]
	push	af ; preserva a
	add	SCR_WIDTH -1
	ld	[viewport_x], a
; Reutiliza el algortimo de la lína izquierda
	call	DRAW_V_LINE
	pop	af ; restaura a
; Restaura el valor de viewport_x
	ld	[viewport_x], a
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Actualiza blit_offset a menos (para scrolls L, UL, U, UR)
; param de: cantidad a decrementar (valor negativo)
; modifica: a
; ret hl: nuevo valor para blit_offset
BLIT_OFFSET_LD_ADD_UNDERFLOW:
	ld	hl, [blit_offset]
; actualiza blit_offset
	add	hl, de
; underflow? (blit_offset < 0)
	ld	a, h
	or	a
	ret	p
; corrige underflow (blit_offset += $0300)
	add	3
	ld	h, a
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Mueve abajo un puntero sobre el buffer de NAMTBL,
; volviendo arriba si hay overflow
; param de: valor del puntero
; modifica: a, hl, bc
; ret de: nuevo valor para el puntero
NAMTBL_BUFFER_DOWN:
; actualiza puntero sobre namtbl_buffer
	ex	de, hl ; trabaja con el registro hl
	ld	bc, SCR_WIDTH
	add	hl, bc
	push	hl ; preserva el valor calculado
; overflow?
	ld	bc, namtbl_buffer + SCR_SIZE
	xor	a
	sbc	hl, bc
	pop	de ; restaura el valor calculado
	ret	m
; corrige overflow
	dec	d
	dec	d
	dec	d ; -768
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Mueve a la derecha un puntero sobre el mapa,
; volviendo a la parte izquierda si hay overflow
; param hl: valor del puntero
; modifica: a, bc
; ret hl: nuevo valor para el puntero
MAP_POINTER_RIGHT:
	inc	hl
	push	hl ; preserva el valor calculado
; overflow? (una linea)
	ld	bc, map
	xor	a
	sbc	hl, bc
	ld	a, l
	and	MAP_WIDTH - 1
	pop	hl ; restaura el valor calculado
	ret	nz
; corrige overflow
	ld	bc, -MAP_WIDTH
	add	hl, bc
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Mueve abajo un puntero sobre el mapa,
; volviendo arriba si hay overflow
; param hl: valor del puntero
; modifica: a, bc
; ret hl: nuevo valor para el puntero
MAP_POINTER_DOWN:
	ld	bc, MAP_WIDTH
	add	hl, bc
	push	hl ; preserva el valor calculado
; overflow? (todo el mapa)
	ld	bc, map + MAP_SIZE
	xor	a
	sbc	hl, bc
	pop	hl ; restaura el valor calculado
	ret	m
; corrige overflow
	ld	bc, -MAP_SIZE
	add	hl, bc
	ret
; -----------------------------------------------------------------------------

;
; =============================================================================
;	Inicialización
; =============================================================================
;

; -----------------------------------------------------------------------------
; Vuelca a RAM las variables dependientes del framerate
; eligiendo el origen de datos correcto (50Hz o 60Hz)
; param z/nz: 60Hz/50Hz
BLIT_FRAME_RATE:
; Variables dependientes del framerate
	ld	hl, FRAME_RATE_50HZ_0
	ld	bc, FRAME_RATE_SIZE
	jr	nz, @@HL_OK
; salta la tabla de 50Hz y va a la de 60Hz
	add	hl, bc
@@HL_OK:
; vuelca los valores dependientes de la frecuencia
	ld	de, frame_rate
	ld	bc, FRAME_RATE_SIZE
	ldir
	ret
; -----------------------------------------------------------------------------

;
; =============================================================================
;	Título, attract mode, selección de rally, fin de tramo
; =============================================================================
;

; -----------------------------------------------------------------------------
; Attract mode: animación
; ret nz: se ha pulsado el disparador
; ret z: se ha dejado pasar el tiempo
ATTRACT_MODE_CUTSCENE:
; Animación "attract mode"
	ld	hl, CUTSCENE_ATTRACTMODE
	call	CLS_INIT_CUTSCENE_FIRST_FRAME
	call	ENASCR_NO_FADE
@@LOOP:
; volcado del fotograma y pequeña pausa
	call	CUTSCENE_CURRENT_FRAME
	halt
	call	LDIRVM_SPRATR
	call	LDIRVM_NAMTBL
	call	GET_TRIGGER
	ret	nz ; sale por trigger
; ¿hay más frames?
	call	CUTSCENE_HAS_NEXT
	jr	nz, @@LOOP ; sí
; no: pausa final y sale
	jp	TRIGGER_PAUSE_ONE_SECOND
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Attract mode: información del rally
; ret nz: se ha pulsado el disparador
; ret z: se ha dejado pasar el tiempo
ATTRACT_MODE_INFO:
; Pantalla del attract mode
	ld	a, [tmp_byte]
	call	CLS_PRINT_RALLY_LOGO
	call	ENASCR_FADE_IN

; Prepara el puntero de lectura del texto
	ld	hl, TXT_ATTRACT_MODE
	ld	a, [tmp_byte]
	or	a
	jr	z, @@HL_OK
; busca el texto correcto
	ld	b, a
@@HL_LOOP:
	push	bc ; preserva contador
	xor	a ; equivale a ld a, CHAR_EOF
	ld	bc, $0000
	cpir
	pop	bc ; restaura contador
	djnz	@@HL_LOOP
@@HL_OK:

; Prepara el puntero de escritura del texto
	ld	de, namtbl_buffer + (BEST_TIMES_RALLY_Y +3) * SCR_WIDTH
	call	INIT_PRINTCHAR

; Bucle de escritura de la información
@@LOOP:
	push	hl ; preserva origen
	push	de ; preserva destino
	halt
	call	LDIRVM_NAMTBL
	pop	de ; restaura destino
	pop	hl ; restaura origen
; ¿Queda texto por escribir?
	call	PRINTCHAR_HAS_NEXT
	jp	z, TRIGGER_PAUSE_FOUR_SECONDS ; no

; sí: escribe el caracter y comprueba salida por trigger
	call	PRINTCHAR_NEXT_A_OK ; (no tiene en cuenta el retardo por defecto)
	call	GET_TRIGGER
	jr	z, @@LOOP
	ret	; (devuelve el nz del TRIGGER_PAUSE)
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Vuelca las iniciales en la pantalla de entrada de iniciales
BLIT_INITIALS:
	ld	hl, initials
	ld	de, namtbl_buffer + INITIALS_X + 12 *SCR_WIDTH
	ldi	; primera inicial
	inc	de ; separación
	ldi	; segunda inicial
	inc	de ; separación
	ldi	; tercera inicial
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Obtiene la inicial que se está modificando
; ret a: valor de la inicial que se está modificando
; ret hl: puntero a la inicial que se está modificando
GET_INITIAL:
	ld	hl, initials
	ld	a, [tmp_byte]
	call	ADD_HL_A
	ld	a, [hl]
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Prepara la pantalla de título con animación (attract mode)
; ret nz: se ha pulsado el disparador
; ret z: se ha dejado pasar el tiempo
ATTRACT_MODE_TITLE_SCREEN:
; Primer paso del degradado del título
	xor	a
	call	LDIRVM_CLRTBL_TITLE
; Pantalla inicialmente vacía
	call	CLS_NAMTBL
	call	LDIRVM_NAMTBL
	call	ENASCR

; Animación del título #1: Dibujado
	ld	hl, namtbl_buffer + TITLE_X + TITLE_Y *SCR_WIDTH
	xor	a
	ld	b, NAMTBL_TITLE_WIDTH
@@LOOP_1:
	push	af ; preserva el origen
	push	bc ; preserva el tamaño restante
	push	hl ; preserva el destino
; volcado del fotograma
	ld	[hl], a
	add	NAMTBL_TITLE_WIDTH
	ld	bc, SCR_WIDTH
	add	hl, bc
	ld	[hl], a
	halt
	call	LDIRVM_NAMTBL
	call	GET_TRIGGER
; restaura el destino y lo avanza un caracter
	pop	hl
	inc	hl
; restaura el tamaño restante
	pop	bc
; ¿fin por disparador?
	jr	nz, @@QUICK
; restaura el origen y lo avanza un caracter
	pop	af
	inc	a
; ¿hay más frames?
	djnz	@@LOOP_1
; pausa intermedia
	call	TRIGGER_PAUSE_ONE_SECOND

; Animación del título #2: Recoloreado
	xor	a ; indicador de paso de degradado
@@LOOP_2:
	push	af ; preserva el paso de degradado
; volcado del paso actual del degradado
	halt
	call	LDIRVM_CLRTBL_TITLE
	; call	LDIRVM_NAMTBL
; ¿fin por disparador?
	call	GET_TRIGGER
	jr	nz, @@QUICK
	pop	af
	inc	a
; ¿fin del recoloreado?
	cp	CLRTBL_TITLE_STEPS
	jr	nz, @@LOOP_2

; pausa intermedia
	call	TRIGGER_PAUSE_ONE_SECOND
	jr	TITLE_SCREEN_FINISH

@@QUICK:
	pop	af ; restauramos el estado inicial del stack
; ------VVVV----falls through--------------------------------------------------

; -----------------------------------------------------------------------------
; Prepara la pantalla de título instantáneamente (sin animación)
; ret nz: se ha pulsado el disparador
; ret z: se ha dejado pasar el tiempo
TITLE_SCREEN:
; Paso final del degradado del título
	halt
	ld	a, CLRTBL_TITLE_STEPS
	call	LDIRVM_CLRTBL_TITLE

	ld	hl, namtbl_buffer + TITLE_X + TITLE_Y *SCR_WIDTH
	call	CLS_PRINT_TITLE
; ------VVVV----falls through--------------------------------------------------

; -----------------------------------------------------------------------------
; Completa los textos de la pantalla de título y finaliza
; ret nz: se ha pulsado el disparador
; ret z: se ha dejado pasar el tiempo
TITLE_SCREEN_FINISH:
	ld	hl, TXT_AUTHORS
	ld	de, namtbl_buffer + COPYRIGHT_Y *SCR_WIDTH
	call	PRINT_TXT
	ld	hl, TXT_PUSH_SPACE
	ld	de, namtbl_buffer + PUSH_SPACE_Y *SCR_WIDTH
	call	PRINT_TXT
	call	LDIRVM_NAMTBL
	call	ENASCR ; por si se ha llegado con la pantalla deshabilitada
	jp	TRIGGER_PAUSE_FOUR_SECONDS
; -----------------------------------------------------------------------------

;
; =============================================================================
;	Subrutinas de apoyo a título, attract mode, selección de rally
; =============================================================================
;

; -----------------------------------------------------------------------------
; Limpia la pantalla y dibuja el título del juego en la ubicación indicada
; param hl: destino
CLS_PRINT_TITLE:
	push	hl ; preserva el destino
	call	CLS_NAMTBL
	pop	hl ; restaura el destino
	xor	a
	call	@@DO_LINE
; Salta hasta el inicio de la parte inferior
	ld	bc, SCR_WIDTH -NAMTBL_TITLE_WIDTH
	add	hl, bc
@@DO_LINE:
	ld	b, NAMTBL_TITLE_WIDTH
	jr	WRITE_SEQUENTIAL_CHARS
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Limpia la pantalla,
; dibuja el logotipo de un rally en la ubicación por defecto
; param a: índice del rally a utilizar
CLS_PRINT_RALLY_LOGO:
	push	af ; preserva el índice del rally
	call	CLS_NAMTBL
	pop	af ; restaura
	ld	hl, namtbl_buffer + BEST_TIMES_RALLY_X + BEST_TIMES_RALLY_Y * SCR_WIDTH
; ------VVVV----falls through--------------------------------------------------

; -----------------------------------------------------------------------------
; Dibuja el logotipo de un rally
; param a: índice del rally a utilizar
; param hl: destino
PRINT_RALLY_LOGO:
; Convierte el índice (0..4) en el primer caracter a utilizar
	add	a ; a *= 16 (tamaño logotipo)
	add	a
	add	a
	add	a
	add	a ; a *= 2 (versiones desactivadas)
	add	CHRTBL_RALLIES_INIT
; ------VVVV----falls through--------------------------------------------------

; -----------------------------------------------------------------------------
; Dibuja el logotipo de un rally
; param a: primer caracter a utilizar
; param hl: destino
; ret a: último caracter utilizado más uno
; ret hl: última posición escrita más uno
; modifica bc
PRINT_RALLY_LOGO_A_OK:
	call	@@DO_LINE
; Salta hasta el inicio de la parte inferior
	ld	bc, SCR_WIDTH -8
	add	hl, bc
@@DO_LINE:
	ld	b, 8
	; jr	WRITE_SEQUENTIAL_CHARS ; falls through
; ------VVVV----falls through--------------------------------------------------

; -----------------------------------------------------------------------------
; Escribe una serie de valores consecutivos
; param a: primer caracter a utilizar
; param b: número de caracteres a escribir
; param hl: destino
; ret a: último caracter utilizado más uno
; ret hl: última posición escrita más uno
WRITE_SEQUENTIAL_CHARS:
	ld	[hl], a
	inc	hl
	inc	a
	djnz	WRITE_SEQUENTIAL_CHARS
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Escribe el indicador de rally y tramo
; param a: índice de nivel
; param de: destino
; ret de: siguiente destino
; touches a, bc, de, hl
PRINT_STAGE_ID:
; Texto fijo
	push	af ; ld	[tmp_byte], a
	ld	hl, TXT_SPECIAL_STAGE
	ld	bc, TXT_SPECIAL_STAGE_LENGTH
	ldir
; Número de rally
	pop	af ; ld	a, [tmp_byte]
	push	af
	sra	a
	sra	a
	add	$31 ; "1" ASCII
	ld	[de], a
	inc	de
; Guión
	ld	a, $2d ; "-" ASCII
	ld	[de], a
	inc	de
; Número de tramo
	pop	af ; ld	a, [tmp_byte]
	and	$03
	add	$31 ; "1" ASCII
	ld	[de], a
	inc	de
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Limpia la pantalla,
; dibuja el título del juego en la ubicación por defecto
; y la tabla de las mejores puntuaciones
CLS_PRINT_TITLE_HI_SCORES:
	ld	hl, namtbl_buffer + TITLE_X + HI_SCORES_TITLE_Y *SCR_WIDTH
	call	CLS_PRINT_TITLE
	ld	hl, TXT_BEST_DRIVERS
	ld	de, namtbl_buffer + (HI_SCORES_TITLE_Y +3) * SCR_WIDTH
	call	PRINT_TXT

; puntero de lectura de datos
	ld	hl, hi_scores
	push	hl ; preserva el puntero de lectura de datos
	ld	hl, TXT_HI_SCORES_TABLE ; puntero de texto constante
; puntero de escritura del texto
	ld	de, namtbl_buffer + HI_SCORES_X + HI_SCORES_Y * SCR_WIDTH
	ld	a, NUM_HIGH_SCORES
@@WRITE_LOOP:
; número, ordinal, primer separador
	ldi
	ldi
	inc	de
	inc	de
; iniciales
	ex	[sp], hl ; pasa a lectura de datos
	ldi
	ldi
	ldi
; separador
	inc	de
	inc	de
	inc	de
	inc	de
; puntos
	push	af ; preserva el contador
	xor	a
	cp	[hl]
	ld	a, $30 ; "0" ASCII
	jr	z, @@NO_HUNDREDS
	rrd
	ld	[de], a
	rld	; restaura el byte
@@NO_HUNDREDS:
	inc	de
	inc	hl
	rld
	ld	[de], a
	inc	de
	rld
	ld	[de], a
	inc	de
	rld	; restaura el byte
	inc	hl
	pop	af ; restaura el contador
; "Pts"
	ex	[sp], hl ; pasa a lectura de texto constante
	ldi
	ldi
; comprueba fin del listado
	dec	a
	jr	z, @@WRITE_OK
; salta a la siguiente línea a utilizar
	ld	bc, 2 * SCR_WIDTH - 16
	ex	de, hl
	add	hl, bc ; hl += bc (=(32 - longitud) / 2)
	ex	de, hl
	jr	@@WRITE_LOOP
@@WRITE_OK:
	pop	hl ; restaura el estado del stack
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Limpia la pantalla,
; dibuja el logotipo de un rally en la ubicación por defecto
; y la tabla de mejores tiempos
; param a: índice del rally a utilizar
CLS_PRINT_RALLY_LOGO_BEST_TIMES:
	push	af ; preserva el índice del rally
	call	CLS_PRINT_RALLY_LOGO
	pop	af ; restaura
; ------VVVV----falls through--------------------------------------------------

; -----------------------------------------------------------------------------
; Escribe la tabla de mejores tiempos de un rally
; en la ubicación por defecto
; param a: número de rally
; touches a, bc, de, hl
PRINT_BEST_TIMES:
	ld	hl, TXT_BEST_TIMES_TABLE
	push	hl ; preserva el puntero de lectura de texto constante
; puntero de lectura de datos
	call	LOCATE_BEST_TIMES
	ex	[sp], hl ; inicialmente utiliza el puntero de texto constante
; puntero de escritura del texto
	ld	de, namtbl_buffer + BEST_TIMES_X + BEST_TIMES_Y * SCR_WIDTH
	ld	a, NUM_HIGH_SCORES
@@WRITE_LOOP:
; número, ordinal, primer separador
	ldi
	ldi
	inc	de
	inc	de
; iniciales, segundo separador
	ex	[sp], hl ; pasa a lectura de datos
	ldi
	ldi
	ldi
	inc	de
	inc	de
	inc	de
; tiempo
	push	af ; preserva el número de rally
	call	PRINT_TIME
	pop	af ; restaura el número de rally
; tercer separador, puntos, "Pts"
	ex	[sp], hl ; pasa a lectura de texto constante
	inc	de
	inc	de
	inc	de
	ldi
	ldi
	ldi
	ldi
; comprueba fin del listado
	dec	a
	jr	z, @@WRITE_OK
; salta a la siguiente línea a utilizar
	ld	bc, 2 * SCR_WIDTH - 23
	ex	de, hl
	add	hl, bc ; hl += bc (=(32 - longitud) / 2)
	ex	de, hl
	jr	@@WRITE_LOOP
@@WRITE_OK:
	pop	hl ; restaura el estado del stack
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Localiza la tabla de mejores tiempos de un rally concreto
; param a: número de rally
; ret hl: puntero a la tabla de mejores tiempos
; touches a, b, de, hl
LOCATE_BEST_TIMES:
; puntero de lectura de información
	ld	hl, best_times
	or	a
	ret	z
; busca los datos correctos
	ld	b, a
	ld	de, HI_SCORES_SIZE
@@SEEK_LOOP:
	add	hl, de
	djnz	@@SEEK_LOOP
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Escribe el tiempo (minutos, segundos, décimas de segundo).
; Si el primer valor es $ff, escribe "-:--.-"
; param hl: datos origen
; param de: destino
; ret hl: siguientes datos origen
; ret de: siguiente destino
; touches a, bc, de, hl
PRINT_TIME:
; minutos
	ld	a, [hl]
	cp	$ff
	jr	nz, @@WRITE_TIME
; no hay tiempo; utilizará un texto fijo
	inc	hl ; simula la lectura de datos
	inc	hl
	push	hl ; preserva el puntero
	ld	hl, TXT_NO_TIME
	ld	bc, TXT_NO_TIME_LENGTH
	ldir
	pop	hl ; restaura el puntero correcto
	ret
@@WRITE_TIME:
	ld	a, $30 ; "0" ASCII
	rld
	ld	[de], a
	inc	de
; ":"
	ex	de, hl
	ld	[hl], $3a ; ":" ASCII
	ex	de, hl
	inc	de
; segundos
	rld
	ld	[de], a
	inc	de
	rld	; restaura el primer byte
	inc	hl ; segundo byte
	rld
	ld	[de], a
	inc	de
; "."
	ex	de, hl
	ld	[hl], $2e ; "." ASCII
	ex	de, hl
	inc	de
; décimas
	rld
	ld	[de], a
	inc	de
	rld	; restaura el segundo byte
	inc	hl
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Selecciona una opción mediante un cursor movido por los cursores.
; param [tmp_byte]: opción inicial, empezando en 0
; param b: opción máxima, empezando en 0
; param c: número de píxeles a mover el cursor
; ret [tmp_byte]: opción seleccionada, empezando en 0
GET_CURSOR_OPTION:
	push	bc ; preserva parámetros
@@PAUSE_LOOP:
	halt
	call	LDIRVM_SPRATR
; Comprueba pausa
	ld	hl, tmp_frame
	ld	a, [hl]
	or	a
	jr	z, @@OK ; no hay pausa
	dec	[hl]
	jr	@@PAUSE_LOOP
@@OK:
; Comprueba selección
	call	GET_TRIGGER
	jr	nz, @@TRIGGER
; Comprueba cambio de opción
	call	GET_STICK
	pop	bc ; restaura parámetros
	cp	5
	jr	z, @@DOWN
	cp	1
	jr	nz, GET_CURSOR_OPTION
	; jr	@@UP ; falls through
@@UP:
; ¿es la primera opción?
	ld	hl, tmp_byte
	ld	a, [hl]
	or	a
	jr	z, GET_CURSOR_OPTION ; sí
; no: sube una opción
	dec	[hl] ; cambia la opción
	ld	a, c
	neg
	jr	@@MOVE
@@DOWN:
; ¿es la última opción?
	ld	hl, tmp_byte
	ld	a, [hl]
	cp	b
	jr	z, GET_CURSOR_OPTION
; no: baja una opción
	inc	[hl] ; cambia la opción
	ld	a, c
	; jr	@@MOVE
@@MOVE:
; Mueve el sprite
	ld	hl, spratr_buffer_menu
	add	[hl]
	ld	[hl], a
; Pausa para evitar un movimiento del cursor demasiado rápido
	ld	a, FRAMES_INPUT_PAUSE
	ld	[tmp_frame], a
	jr	GET_CURSOR_OPTION
@@TRIGGER:
	pop	bc ; restaura el stack
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Hace parpadear el cursor para indicar que se ha seleccionado una opción
BLINK_CURSOR:
; Parpadeo
	ld	b, TIMES_BLINK *2
@@BLINK_LOOP:
	push	bc ; preserva el contador
; alterna el color del sprite: 15, 0, 15, 0, 15...
	ld	a, 15
	ld	hl, spratr_buffer_menu +3
	xor	[hl]
	ld	[hl], a
; Vuelca y pausa
	call	LDIRVM_SPRATR
	ld	b, FRAMES_BLINK
	call	WAIT_FRAMES

	pop	bc ; restaura el contador
	djnz	@@BLINK_LOOP
	ret
; -----------------------------------------------------------------------------

;
; =============================================================================
;	Escritura de texto y secuencias de animación
; =============================================================================
;

; -----------------------------------------------------------------------------
; Limpia una línea
; param hl: primer caracter de la línea destino
; touches: bc, de, hl
CLEAR_LINE:
	ld	d, h ; de = hl + 1
	ld	e, l
	inc	de
	ld	bc, SCR_WIDTH -1
	ld	[hl], $20 ; " " ASCII
	ldir
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Escribe múltiples literales centrados horizontalmente
; param hl: origen
; param de: primer caracter de la línea destino
; touches a, bc, de, hl
PRINT_FULL_TXT:
	push	de ; preserva el destino
	call	PRINT_TXT
	pop	de ; restaura el destino
; ¿hay más texto pendiente?
	inc	hl ; salta el CR
	ld	a, [hl]
	cp	CHAR_EOF
	ret	z ; no
; sí: salto de línea
	ex	de, hl ; destino en hl
	ld	bc, SCR_WIDTH
	add	hl, bc
	ex	de, hl ; destino en de
	jr	PRINT_FULL_TXT
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Escribe un literal centrado horizontalmente
; param hl: origen
; param de: primer caracter de la línea destino
; touches a, bc, de, hl
PRINT_TXT:
	call	LOCATE_CENTER
PRINT_TXT_DE_OK:
	ld	a, CHAR_CR
@@LOOP:
	cp	[hl]
	ret	z
	ldi
	jr	@@LOOP
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Inicializa el proceso de escritura caracter a caracter
; param hl: origen
; param de: primer caracter de la línea destino
; return de: destino centrado
INIT_PRINTCHAR:
	xor	a
	ld	[tmp_frame], a
INIT_PRINTCHAR_FRAME_OK:
	ld	[printchar_de_line], de
	; jr	LOCATE_CENTER ; (falls through)
; ------VVVV----falls through--------------------------------------------------

; -----------------------------------------------------------------------------
; Centra horizontalmente un literal
; param hl: origen
; param de: primer caracter de la línea destino
; ret de: destino
; touches: a, bc
LOCATE_CENTER:
	push	hl ; preserva origen
; busca el siguiente CHAR_CR
	ld	a, CHAR_CR
	ld	bc, SCR_WIDTH +1 ; (+1 para contar el último dec bc)
	cpir
; centra el puntero de escritura
	sra	b ; bc /= 2
	rr	c
	ex	de, hl ; de += bc (=(32 - longitud) / 2)
	add	hl, bc
	ex	de, hl
	pop	hl ; restaura origen
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Lee el siguiente caracter en la escritura caracter a caracter
; e indica si queda texto pendiente de escribir
; param hl: origen
; ret z/nz: si no/sí hay más caracteres para escribir
PRINTCHAR_HAS_NEXT:
	ld	a, [hl]
	cp	CHAR_EOF
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Procesa el siguiente caracter en la escritura caracter a caracter
; param/ret hl: origen
; param/ret de: destino
; param/ret [printchar_de_line]: primer caracter de la línea destino
PRINTCHAR_NEXT:
; ¿Ha finalizado el retardo de la escritura caracter a caracter?
	ld	a, [tmp_frame]
	or	a
	jr	z, @@NO_FRAMESKIP ; sí
; no: frameskip
	dec	a
	ld	[tmp_frame], a
	ret

@@NO_FRAMESKIP:
; Lee el caracter actual
	ld	a, [hl]
PRINTCHAR_NEXT_A_OK:
; ¿Es un caracter imprimible?
	cp	$20 ; " " ASCII
	jr	c, @@CONTROL ; no
; sí: lo vuelca
	ldi
; restaura el retardo de escritura
	ld	a, PRINTCHAR_DELAY
	ld	[tmp_frame], a
	ret

@@CONTROL:
	push	hl ; preserva origen
	ld	hl, @@JUMP_TABLE
	jp	JP_TABLE
@@JUMP_TABLE:
	.dw	@@NEXT	; CHAR_EOF equ $00	; Fin de texto
	.dw	@@NEXT	; CHAR_CR equ $01	; Fin de línea
	.dw	@@LF	; CHAR_LF equ $02	; Nueva línea
	.dw	@@CLR	; CHAR_CLR equ $03	; Borrado de línea actual
	.dw	@@CLS	; CHAR_CLS equ $04	; Borrado de todas las línes
	.dw	@@PAUSE	; CHAR_PAUSE equ $05	; Pausa en la escritura

@@LF:
; Nueva línea: avanza el puntero de línea de escritura
	ld	hl, [printchar_de_line]
	ld	bc, 2 *SCR_WIDTH
	add	hl, bc
	ex	de, hl ; primer caracter de la línea destino en de
	ld	[printchar_de_line], de
	jr	@@NEXT

@@CLR:
; Borrado de línea actual
	ld	hl, [printchar_de_line]
	push	hl ; preserva primer caracter de la línea destino
	call	CLEAR_LINE
	pop	de ; restaura primer caracter de la línea destino en de
	ld	[printchar_de_line], de
	jr	@@NEXT

@@CLS:
; Borrado de todas las líneas
	ld	hl, namtbl_buffer + CUTSCENE_TEXT_Y *SCR_WIDTH
	push	hl ; preserva primer caracter de la línea destino
	call	CLEAR_LINE
	ld	hl, namtbl_buffer + (CUTSCENE_TEXT_Y +2) *SCR_WIDTH
	call	CLEAR_LINE
	; ld	hl, namtbl_buffer + (CUTSCENE_TEXT_Y +4) *SCR_WIDTH ; descomentar si hay tres líneas
	; call	CLEAR_LINE
	pop	de ; restaura primer caracter de la línea destino en de
	ld	[printchar_de_line], de
	jr	@@NEXT

@@PAUSE:
; Pausa en la escritura
	ld	a, PRINTCHAR_PAUSE_DELAY
	ld	[tmp_frame], a
	; jr	@@NEXT ; falls through

@@NEXT:
; siguiente caracter
	pop	hl ; restaura origen
	inc	hl
	jr	LOCATE_CENTER
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Limpia la pantalla, inicializa el charset de una animación en el banco central,
; sus datos en cutscene_data, apunta al primer frame y lo vuelca al buffer de NAMTBL
; param hl: dirección de la animación a descomprimir
CLS_INIT_CUTSCENE_FIRST_FRAME:
; Descomprime los datos de animación
	ld	e, [hl] ; ld de, [hl], hl += 2
	inc	hl
	ld	d, [hl]
	inc	hl
	push	hl ; preserva hl
	ex	de, hl ; puntero (de) en hl
	ld	de, cutscene_data
	call	UNPACK_PAGE0_AWARE_DE_OK
; Descomprime y vuelca patrones
	pop	hl ; restaura hl
	ld	e, [hl] ; ld de, [hl], hl += 2
	inc	hl
	ld	d, [hl]
	inc	hl
	push	hl ; preserva hl
	ex	de, hl ; puntero (de) en hl
	ld	de, unpack_buffer
	call	UNPACK_PAGE0_AWARE_DE_OK
	call	LDIRVM_CHRTBL_BANK1
; Descomprime y vuelca colores
	pop	hl ; restaura hl
	ld	e, [hl] ; ld de, [hl], hl += 2
	inc	hl
	ld	d, [hl]
	inc	hl
	push	hl ; preserva hl
	ex	de, hl ; puntero (de) en hl
	ld	de, unpack_buffer
	call	UNPACK_PAGE0_AWARE_DE_OK
	call	LDIRVM_CLRTBL_BANK1

; Limpia la pantalla
	call	CLS_NAMTBL

; Inicializa el puntero de lectura de datos de la animación
	pop	hl ; restaura hl
	ld	[cutscene_pointer], hl
	jr	CUTSCENE_CURRENT_FRAME_OK
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Reproducción de la animación durante uno, dos y cuatro segundos
CUTSCENE_PLAY_FOUR_SECONDS:
	call	CUTSCENE_PLAY_TWO_SECONDS
CUTSCENE_PLAY_TWO_SECONDS:
	call	CUTSCENE_PLAY_ONE_SECOND
CUTSCENE_PLAY_ONE_SECOND:
	ld	hl, frame_rate
	ld	b, [hl]
	; jr	CUTSCENE_PLAY_FRAMES ; falls through
; ------VVVV----falls through--------------------------------------------------

; -----------------------------------------------------------------------------
; Reproducción de la animación durante un número determinado de frames
; param b: número de frames de duración
CUTSCENE_PLAY_FRAMES:
	push	bc ; preserva el contador de frmes
; volcado del fotograma
	call	CUTSCENE_HAS_NEXT
	call	nz, CUTSCENE_CURRENT_FRAME
	halt
	call	LDIRVM_NAMTBL
	call	LDIRVM_SPRATR
; comprueba el tiempo
	pop	bc ; restaura el contador de frames
	djnz	CUTSCENE_PLAY_FRAMES
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Reproducción de la animación hasta el final
CUTSCENE_PLAY:
	call	CUTSCENE_HAS_NEXT
	ret	z
	call	CUTSCENE_CURRENT_FRAME
	halt
	call	LDIRVM_NAMTBL
	call	LDIRVM_SPRATR
	jr	CUTSCENE_PLAY
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Reproducción de la animación durante un número determinado de frames
; y abortable pulsando el disparador
; param b: número de frames de duración que se quiere esperar
; ret nz: se ha pulsado el disparador
; ret z: se ha agotado el tiempo de reproducción
CUTSCENE_PLAY_TRIGGER_ONE_SECOND:
	ld	hl, frame_rate
	ld	b, [hl]
CUTSCENE_PLAY_TRIGGER:
	push	bc ; preserva el contador de frmes
; volcado del fotograma
	call	CUTSCENE_HAS_NEXT
	call	nz, CUTSCENE_CURRENT_FRAME
	halt
	call	LDIRVM_NAMTBL
; comprueba el disparador
	call	GET_TRIGGER
	pop	bc ; restaura el contador de frames
	ret	nz ; sí
; no
	djnz	CUTSCENE_PLAY_TRIGGER
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Indica si la animación ha acabado
; ret z: si la animación ha acabado
; ret nz: si aún quedan frames por reproducir
CUTSCENE_HAS_NEXT:
; ¿se ha agotado cumplido la duración del último frame cargado?
	ld	a, [cutscene_frames]
	or	a
	ret	nz
	
; verifica si ya acabó en el frame anterior
	ld	hl, [cutscene_pointer]
	ld	a, [hl]
	cp	CS_LOOP
	jr	z, @@LOOP ; bucle
	cp	CS_END
	ret	; ret z/nz

; bucle: retrocede el número de bytes indicado por el byte siguiente
@@LOOP:
	inc	hl
	ld	d, 0 ; hl -= [hl]
	ld	e, [hl]
	sbc	hl, de
	ld	[cutscene_pointer], hl
	or	1 ; asegura nz
	ret	; ret nz
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Ejecuta un frame de la animación
CUTSCENE_CURRENT_FRAME:
; ¿se ha agotado cumplido la duración del último frame cargado?
	ld	hl, cutscene_frames
	xor	a
	cp	[hl]
	jr	z, CUTSCENE_CURRENT_FRAME_OK ; sí
	dec	[hl]
; no: ¿hay tratamiento especial?
	inc	hl ; hl = cutscene_special
	ld	a, [hl]
	or	a
	ret	z ; no
; sí: invoca al tratamiento especial
	ld	hl, @@JUMP_TABLE
	jp	JP_TABLE
@@JUMP_TABLE:
	.dw	0
	.dw	CUTSCENE_SPECIAL_1 ; attract mode: sprite del coche
	.dw	CUTSCENE_SPECIAL_2
	.dw	CUTSCENE_SPECIAL_3
	.dw	CUTSCENE_SPECIAL_4
	.dw	CUTSCENE_SPECIAL_5 ; game over: sprite de las luces
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Vuelca el fotograma actual de la animación al buffer de NAMTBL,
; procesa los flags, establece la duración y deja avanzado el puntero
CUTSCENE_CURRENT_FRAME_OK:
; Localiza el fotograma concreto
	ld	hl, [cutscene_pointer]
	push	hl ; preserva el puntero de lectura de datos de la animación
	ld	a, [hl]
	ld	hl, cutscene_data
	or	a
	jr	z, @@HL_OK ; a = 0
	ld	bc, CUTSCENE_WIDTH * CUTSCENE_HEIGHT
@@ADD_LOOP:
	add	hl, bc
	dec	a
	jr	nz, @@ADD_LOOP
@@HL_OK:

; Vuelca el fotograma al buffer de NAMTBL
	ld	de, namtbl_buffer + (SCR_WIDTH - CUTSCENE_WIDTH) /2 + CUTSCENE_Y *SCR_WIDTH
	ld	bc, CUTSCENE_WIDTH + CUTSCENE_HEIGHT * 256
@@BLIT_LOOP:
; vuelca una línea
	push	bc ; preserva ancho y alto
	ld	b, 0 ; sólo interesa el ancho (c)
	ldir
; salta a la siguiente línea
	ld	a, SCR_WIDTH - CUTSCENE_WIDTH
	add	e ; de += a
	ld	e, a
	adc	d
	sub	e
	ld	d, a
; mientras haya lineas
	pop	bc ; restaura ancho y alto
	djnz	@@BLIT_LOOP

; Vuelca la duración del paso de la animación y el indicador de tratamiento especial
	pop	hl ; restaura el puntero de lectura de datos de la animación
	inc	hl
	ld	de, cutscene_frames
	ldi	; cutscene_frames
	ldi	; cutscene_special

; Vuelca los sprites
	; inc	hl ; ya incrementado por ldi
	ld	de, spratr_buffer
@@SPRITE_LOOP:
; ¿se ha llegado al SPAT_END?
	ld	a, [hl]
	cp	SPAT_END
	jr	z, @@SPRITES_OK ; sí
; no: vuelca un sprite
	ldi	; y
	ldi	; x
	ldi	; pattern
	ldi	; color
	jr	@@SPRITE_LOOP

@@SPRITES_OK:
	ldi	; vuelca el SPAT_END

; Deja preparado el puntero para el siguiente fotograma
	; inc	hl ; ya incrementado por ldi
	ld	[cutscene_pointer], hl
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Animaciones especiales del attract mode: movimiento del sprite del coche

CUTSCENE_SPECIAL_1:
; Uno de cada 2 frames
	ld	a, [cutscene_frames]
	and	1
	ret	nz
; x--
	ld	hl, spratr_buffer +1
	call	CUTSCENE_SPECIAL_DEC

; Uno de cada 32 frames
	ld	a, [cutscene_frames] ; innecesario
	and	31
	ret	nz
; y++
	ld	hl, spratr_buffer
	jr	CUTSCENE_SPECIAL_INC
	
CUTSCENE_SPECIAL_2:
; Uno de cada 4 frames
	ld	a, [cutscene_frames]
	and	3
	ret	nz
; y++
	ld	hl, spratr_buffer
	jr	CUTSCENE_SPECIAL_INC
	
CUTSCENE_SPECIAL_3:
; Uno de cada 2 frames
	ld	a, [cutscene_frames]
	and	1
	ret	nz
; x++
	ld	hl, spratr_buffer +1
	call	CUTSCENE_SPECIAL_INC

; Uno de cada 32 frames
	ld	a, [cutscene_frames]
	and	31
	ret	nz
; y++
	ld	hl, spratr_buffer
	jr	CUTSCENE_SPECIAL_INC
	
CUTSCENE_SPECIAL_4:
; x--
	ld	hl, spratr_buffer +5
	call	CUTSCENE_SPECIAL_DEC

; Uno de cada 16 frames
	ld	a, [cutscene_frames] ; innecesario
	and	15
	ret	nz
; y++
	ld	hl, spratr_buffer +4
	jr	CUTSCENE_SPECIAL_INC
; -----------------------------------------------------------------------------
	
; -----------------------------------------------------------------------------
; Subrutinas auxiliares de las animaciones especiales del attract mode
CUTSCENE_SPECIAL_DEC:
	ld	b, 3 ; 3 sprites
@@LOOP:
	dec	[hl]
	inc	hl
	inc	hl
	inc	hl
	inc	hl
	djnz	@@LOOP
	ret

CUTSCENE_SPECIAL_INC:
	ld	b, 3 ; 3 sprites
@@LOOP:
	inc	[hl]
	inc	hl
	inc	hl
	inc	hl
	inc	hl
	djnz	@@LOOP
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Animación especial de game over: movimiento del sprite de las luces
CUTSCENE_SPECIAL_5:
; Uno de cada cuatro frames
	ld	a, [cutscene_frames]
	and	3
	ret	nz
; y--, x++
	ld	hl, spratr_buffer +4
	dec	[hl]
	inc	hl
	dec	[hl]
; Cambia el sprite...
	ld	a, [cutscene_frames]
	cp	96
	jr	z, @@INC_PATTERN ; ...cuando queden 32 frames
	cp	40
	ret	nz
; ...cuando queden 16 frames
@@INC_PATTERN:
	inc	hl
	ld	a, 4
	add	[hl]
	ld	[hl], a
	ret
; -----------------------------------------------------------------------------

;
; =============================================================================
;	Subrutinas de utilidad genéricas
; =============================================================================
;

; -----------------------------------------------------------------------------
; Suma hl + a o hl + 2*a
; param hl: sumando
; param a: sumando
ADD_HL_A_A:
	add	a ; a *= 2
ADD_HL_A:
	add	l ; hl += a
	ld	l, a
	adc	h
	sub	l
	ld	h, a
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Lee un word de una tabla
; param hl: dirección de la tabla a utilizar
; param a: índice (0 based) de la tabla
GET_HL_A_A_WORD:
	add	a ; a *= 2
GET_HL_A_WORD:
	add	l ; hl += a
	ld	l, a
	adc	h
	sub	l
	ld	h, a
	ld	a, [hl] ; hl = [hl]
	inc	hl
	ld	h, [hl]
	ld	l, a
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Utiliza una jump table
; param hl: dirección de la jump table a utilizar
; param a: índice (0 based) de la jump table
JP_TABLE:
	add	a ; a *= 2
JP_TABLE_A_OK:
	add	l ; hl += a
	ld	l, a
	adc	h
	sub	l
	ld	h, a
	ld	a, [hl] ; hl = [hl]
	inc	hl
	ld	h, [hl]
	ld	l, a
	jp	[hl]
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Pausa de uno, dos y cuatro segundos
; touches b, hl
WAIT_FOUR_SECONDS:
IFDEF DEBUG_QUICKPLAY
	jr	WAIT_ONE_SECOND
ELSE
	call	WAIT_TWO_SECONDS
ENDIF
WAIT_TWO_SECONDS:
IFDEF DEBUG_QUICKPLAY
	jr	WAIT_ONE_SECOND
ELSE
	call	WAIT_ONE_SECOND
ENDIF
WAIT_ONE_SECOND:
	ld	hl, frame_rate
	ld	b, [hl]
	; jr	WAIT_FRAMES ; falls through
; ------VVVV----falls through--------------------------------------------------

; -----------------------------------------------------------------------------
; Pausa de un número determinado de frames
; param b: número de frames de duración de la pausa
; touches b, hl
WAIT_FRAMES:
	halt
	djnz	WAIT_FRAMES
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Pausa de un segundo abortable pulsando el disparador
; (ver TRIGGER_PAUSE)
TRIGGER_PAUSE_ONE_SECOND:
	ld	a, [frame_rate]
	jr	TRIGGER_PAUSE_A
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Pausa de cuatro segundos abortable pulsando el disparador
; (ver TRIGGER_PAUSE)
TRIGGER_PAUSE_FOUR_SECONDS:
	ld	a, [frame_rate]
IFDEF DEBUG_QUICKPLAY
ELSE
	add	a
	add	a
ENDIF
	; jr	TRIGGER_PAUSE_A ; falls through
; ------VVVV----falls through--------------------------------------------------

; -----------------------------------------------------------------------------
; Pausa abortable pulsando el disparador
; param b: número de frames de duración de la pausa
; touches a, bc, de, hl
; ret nz: se ha pulsado el disparador
; ret z: se ha agotado la pausa
TRIGGER_PAUSE_A:
	ld	b, a
TRIGGER_PAUSE:
	push	bc
	halt
	call	GET_TRIGGER
	pop	bc
	ret	nz ; trigger
	djnz	TRIGGER_PAUSE
	ret	; z = no trigger
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Lee el valor del disparador del teclado
; o del joystick en puerto 1
; ret a: valor actual leído de GTTRIG (level)
; ret [trigger]: valor actual leído de GTTRIG (level)
; ret nz: si el disparador ha pasado de off a on (edge)
GET_TRIGGER:
	xor	a
	call	GTTRIG ; teclado
	or	a
	jr	nz, @@ON
	inc	a
	call	GTTRIG ; joystick
	or	a ; para el ret z/nz
	jr	nz, @@ON
; off
	ld	[trigger], a
	ret	; siempre devolverá z
@@ON:
	ld	hl, trigger
	cp	[hl] ; para el ret z/nz
	ld	[hl], a
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Lee el valor de los cursores o del joystick en puerto 1,
; simplificándolo a 0, 3 (derecha) o 7 (izquierda)
; ret [stick]: valor simplificado leído de GET_STICK
GET_LR_STRICK:
	call	GET_STICK
	cp	2
	jr	c, @@NO ; 0-1
	cp	5
	jr	c, @@RIGHT ; 2-4
	jr	nz, @@LEFT ; 6-7
	; jr	z, @@NO ; 5 ; falls through
@@NO:
	xor	a
	ld	[stick], a
	ret
@@LEFT:
	ld	a, 7
	ld	[stick], a
	ret
@@RIGHT:
	ld	a, 3
	ld	[stick], a
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Lee el valor de los cursores o del joystick en puerto 1
; ret a: valor leído de GTSTCK
GET_STICK:
	xor	a
	call	GTSTCK ; teclado
	or	a
	ret	nz
	inc	a
	jp	GTSTCK ; joystick
; -----------------------------------------------------------------------------

;
; =============================================================================
;	Buffers VRAM (namtbl, spratr), acceso a VRAM mediante BIOS
; =============================================================================
;

; -----------------------------------------------------------------------------
; Vaciado del buffer de pantalla con el carácter espacio
CLS_NAMTBL:
	ld      hl, namtbl_buffer
	ld      de, namtbl_buffer + 1
	ld      bc, SCR_SIZE - 1
	ld      [hl], $20 ; " " ASCII
	ldir
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Vuelca el buffer de NAMTBL utilizando la BIOS
LDIRVM_NAMTBL:
	ld	hl, namtbl_buffer
	ld	de, NAMTBL
	ld	bc, SCR_SIZE
	jp	LDIRVM
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Vuleca el buffer de SPRATR utilizando la BIOS
LDIRVM_SPRATR:
	ld	hl, spratr_buffer
	ld	de, SPRATR
	ld	bc, SPRATR_BUFFER_LENGTH
	jp	LDIRVM
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Vacía NAMTBL, deshabilita sprites y desactiva la pantalla
DISSCR_NO_FADE:
	halt	; (sincronización antes de desactivar la pantalla)
	call	DISSCR
; Vacía NAMTBL
	call	CLS
; Deshabilita sprites
	ld	hl, SPRATR
	ld	a, SPAT_END
	jp	WRTVRM
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Fundido de salida (cortinilla horizontal)
; Vacía NAMTBL, deshabilita sprites y desactiva la pantalla
DISSCR_FADE_OUT:
; Deshabilita sprites
	ld	hl, SPRATR
	ld	a, SPAT_END
	call	WRTVRM

IFDEF DEBUG_QUICKPLAY
	jp	DISSCR
ENDIF

; Fundido
	ld	hl, NAMTBL
	ld	b, SCR_WIDTH
@@COL:
	push	bc ; preserva contador de columnas
	push	hl ; preserva puntero
	ld	de, SCR_WIDTH
	ld	b, SCR_HEIGHT
	ld	a, $20 ; " " ASCII
@@H_CHAR:
	call	WRTVRM
	add	hl, de
	djnz	@@H_CHAR
	halt
	pop	hl ; restaura puntero
	inc	hl
	pop	bc ; restaura contador de columnas
	djnz	@@COL

; Desactiva la pantalla
	jp	DISSCR
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Vuelca los buffer de NAMTBL y SPRATR y activa la pantalla
ENASCR_NO_FADE:
	halt	; (sincronización antes del volcado por si la pantalla estaba activada)
	call	LDIRVM_NAMTBL
	call	LDIRVM_SPRATR
	halt	; (sincronización antes de activar la pantalla)
	jp	ENASCR
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Fundido de entrada (cortinilla horizontal)
; Vuelca los buffer de NAMTBL y SPRATR y activa la pantalla
ENASCR_FADE_IN:
IFDEF DEBUG_QUICKPLAY
	jr	ENASCR_NO_FADE
ENDIF
; Inicialmente vacía, tanto NAMTBL como sprites
	ld	hl, NAMTBL
	ld	bc, SCR_SIZE
	ld	a, $20 ; " " ASCII
	call	FILVRM
	ld	hl, SPRATR
	ld	a, SPAT_END
	call	WRTVRM

; Activa la pantalla
	halt	; (sincronización antes de activar la pantalla)
	call	ENASCR
; ------VVVV----falls through--------------------------------------------------

; -----------------------------------------------------------------------------
; Fundido de entrada/salida (cortinilla horizontal),
; de la imagen actual al contenido de NAMTBL
LDIRVM_NAMTBL_FADE_INOUT:
; Deshabilita sprites
	ld	hl, SPRATR
	ld	a, SPAT_END
	call	WRTVRM

IFDEF DEBUG_QUICKPLAY
	jp	LDIRVM_NAMTBL
ENDIF

; Fundido
	ld	hl, NAMTBL
	ld	de, namtbl_buffer
	ld	c, SCR_WIDTH
@@COL:
	push	hl ; preserva puntero hl
	push	de ; preserva puntero de
	ld	b, SCR_HEIGHT
@@CHAR:
	push	bc ; preserva contadores
; escribe un caracter
	ld	a, [de]
	call	WRTVRM
; baja una posición
	ld	bc, SCR_WIDTH
	add	hl, bc
	ex	de, hl
	add	hl, bc
	ex	de, hl
	pop	bc ; restaura contadores
	djnz	@@CHAR
	push	bc ; preserva contadores
	halt
; se mueve a la derecha una posición
	pop	bc ; restaura contadores
	pop	de ; restaura puntero de
	inc	de
	pop	hl ; restaura puntero hl
	inc	hl
	dec	c
	jr	nz, @@COL
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Volcado del degradado del título
; param a: paso del degradado, entre 0 y CLRTBL_TITLE_STEPS
LDIRVM_CLRTBL_TITLE:
; primera línea de caracteres
	ld	hl, CLRTBL_TITLE
	call	ADD_HL_A
	push	hl ; preserva el origen
	ld	de, CLRTBL
	ld	b, NAMTBL_TITLE_WIDTH
	call	LDIRVM_BLOCKS
; segunda línea de caracteres
	pop	hl ; restaura el origen
	ld	bc, 8
	add	hl, bc
	ld	de, CLRTBL + NAMTBL_TITLE_WIDTH *8
	ld	b, NAMTBL_TITLE_WIDTH
	; jp	LDIRVM_BLOCKS ; falls_through
; ------VVVV----falls through--------------------------------------------------

; -----------------------------------------------------------------------------
; Volcado con repetición de un mismo bloque a VRAM
; (rutina original: COPY_BLOCK de Eduardo A. Robsy Petrus)
; param hl: dirección RAM del bloque (normalmente CLRTBL)
; param de: dirección VRAM destino
; param b: número de bloques a copiar
LDIRVM_BLOCKS:
	push	bc ; preserva el contador
	push	hl ; preserva el origen
	push	de ; preserva el destino
; Vuelca un bloque
	ld	bc, 8
	call	LDIRVM
	pop	hl ; restaura el destino (en hl)
	ld	bc, 8 ; hl += 8
	add	hl, bc
	ex	de, hl ; destino actualizado en de
	pop	hl ; restaura el origen
	pop	bc ; restaura el contador
	djnz	LDIRVM_BLOCKS
	ret
; -----------------------------------------------------------------------------

;
; =============================================================================
;	Descompresión de gráficos a VRAM
; =============================================================================
;

; -----------------------------------------------------------------------------
; Inicializa el charset y los sprites de las pantallas de menú
; (nombre, selección de rally, tablas de records, etc.)
INIT_MAIN_CHARSET_SPRTBL:
; Carga los sprites
	ld	hl, SPRTBL_DEFAULT_PACKED
	call	UNPACK_PAGE0_AWARE
	ld	hl, unpack_buffer
	ld	de, SPRTBL
	ld	bc, SPRTBL_DEFAULT_SIZE
	call	LDIRVM

; Carga el charset principal: título, fuente y rallies
	call	PREPARE_CHRTBL_TITLE_RALLIES_FONT
	call	LDIRVM_CHRTBL
	call	PREPARE_CLRTBL_RALLIES_FONT
	jr	LDIRVM_CLRTBL
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Descomprime los patrones del título, de la fuente de letra y de los rallies
PREPARE_CHRTBL_TITLE_RALLIES_FONT:
	ld	hl, CHRTBL_TITLE_PACKED
	ld	de, unpack_buffer
	call	UNPACK
; ------VVVV----falls through--------------------------------------------------

; -----------------------------------------------------------------------------
; Descomprime los patrones de la fuente de letra y de los rallies
PREPARE_CHRTBL_RALLIES_FONT:
	ld	hl, CHRTBL_RALLIES_PACKED
	ld	de, unpack_buffer + CHRTBL_RALLIES_INIT *8
	call	UNPACK
; ------VVVV----falls through--------------------------------------------------

; -----------------------------------------------------------------------------
; Descomprime los patrones de la fuente de letra
PREPARE_CHRTBL_FONT:
	ld	hl, CHRTBL_FONT_PACKED
	ld	de, unpack_buffer + CHRTBL_FONT_INIT *8
	jp	UNPACK
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Prepara los colores de la fuente de letra y descomprime los de los rallies
PREPARE_CLRTBL_RALLIES_FONT:
	ld	hl, CLRTBL_RALLIES_PACKED
	ld	de, unpack_buffer + CHRTBL_RALLIES_INIT *8
	call	UNPACK
; ------VVVV----falls through--------------------------------------------------

; -----------------------------------------------------------------------------
; Prepara los colores de la fuente de letra
PREPARE_CLRTBL_FONT:
	ld	a, FONT_COLOR
	ld	hl, unpack_buffer + CHRTBL_FONT_INIT *8
	ld	de, unpack_buffer + CHRTBL_FONT_INIT *8 +1
	ld	bc, (CHRTBL_RALLIES_INIT - CHRTBL_FONT_INIT) *8 -1
	ld	[hl], a
	ldir
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
UNPACK_LDIRVM_CHRTBL:
	ld	de, unpack_buffer
	call	UNPACK
; ------VVVV----falls through--------------------------------------------------

; -----------------------------------------------------------------------------
LDIRVM_CHRTBL:
	ld	de, CHRTBL
	call	LDIRVM_CXRTBL_BANK
	ld	de, CHRTBL + CHRTBL_SIZE + CHRTBL_SIZE
	call	LDIRVM_CXRTBL_BANK
; ------VVVV----falls through--------------------------------------------------

; -----------------------------------------------------------------------------
LDIRVM_CHRTBL_BANK1:
	ld	de, CHRTBL + CHRTBL_SIZE
	jr	LDIRVM_CXRTBL_BANK
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
UNPACK_LDIRVM_CLRTBL:
	ld	de, unpack_buffer
	call	UNPACK
; ------VVVV----falls through--------------------------------------------------

; -----------------------------------------------------------------------------
LDIRVM_CLRTBL:
	ld	de, CLRTBL
	call	LDIRVM_CXRTBL_BANK
	ld	de, CLRTBL + CHRTBL_SIZE + CHRTBL_SIZE
	call	LDIRVM_CXRTBL_BANK
; ------VVVV----falls through--------------------------------------------------

; -----------------------------------------------------------------------------
LDIRVM_CLRTBL_BANK1:
	ld	de, CLRTBL + CHRTBL_SIZE
	; jr	LDIRVM_CXRTBL_BANK
; ------VVVV----falls through--------------------------------------------------

; -----------------------------------------------------------------------------
; Vuelca un banco completo de patrones o colores utilizando la BIOS
; param de: dirección VRAM destino
LDIRVM_CXRTBL_BANK:
	ld	hl, unpack_buffer
	ld	bc, CHRTBL_SIZE
	jp	LDIRVM
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Restaura los rallies y la fuente de letra en el banco 1 (central)
; normalmente tras haber mostrado una animación
RESTORE_RALLIES_FONT_BANK1:
; patrones
	call	PREPARE_CHRTBL_RALLIES_FONT
	ld	de, CHRTBL + CHRTBL_SIZE + CHRTBL_FONT_INIT *8
	call	@@BLIT
; colores
	call	PREPARE_CLRTBL_RALLIES_FONT
	ld	de, CLRTBL + CHRTBL_SIZE + CHRTBL_FONT_INIT *8
@@BLIT:
	ld	hl, unpack_buffer + CHRTBL_FONT_INIT *8
	ld	bc, CHRTBL_SIZE - CHRTBL_FONT_INIT *8
	jp	LDIRVM
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Restaura la fuente de letra en el banco 1 (central)
; normalmente tras haber mostrado una animación
RESTORE_FONT_BANK1:
; patrones
	call	PREPARE_CHRTBL_FONT
	ld	de, CHRTBL + CHRTBL_SIZE + CHRTBL_FONT_INIT *8
	call	@@BLIT
; colores
	call	PREPARE_CLRTBL_FONT
	ld	de, CLRTBL + CHRTBL_SIZE + CHRTBL_FONT_INIT *8
@@BLIT:
	ld	hl, unpack_buffer + CHRTBL_FONT_INIT *8
	ld	bc, (CHRTBL_RALLIES_INIT - CHRTBL_FONT_INIT) *8
	jp	LDIRVM
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Sustituye los sprites para la salida por los sprites para el final
INIT_INGAME_SPRTBL_END:
	ld	hl, SPRTBL_OTHERS_END_PACKED
	call	UNPACK_PAGE0_AWARE
	ld	hl, unpack_buffer
	ld	de, SPRTBL + (NUM_SPRITES_CAR + NUM_SPRITES_SHADOW + NUM_SPRITES_TIMER + NUM_SPRITES_EVENT) *32
	ld	bc, SPRTBL_OTHERS_END_SIZE
	jp	LDIRVM
; -----------------------------------------------------------------------------

;
; =============================================================================
;	Acceso a VRAM sin BIOS
; =============================================================================
;

; -----------------------------------------------------------------------------
; Prepara los valores de las variables auxiliares para el volcado de sprites
PREPARE_BLIT_SPRTBL:
; Localiza y almacena el sprtbl correspondiente a la dirección del coche
	ld	a, [car_heading]
	rrca	; Convierte una dirección tipo byte en una tipo DIR_*
	rrca
	rrca
	and	$1e
PREPARE_BLIT_SPRTBL_A_OK:
; Localiza y almacena el sprtbl correspondiente a la dirección a
	ld	hl, SPRTBL_CAR_TABLE
	call	GET_HL_A_WORD
	ld	[blit_sprite_src], hl
	ld	hl, SPR_CAR_SIZE_TABLE
	call	GET_HL_A_WORD
	ld	[blit_sprite_size], hl

; Localiza los sprtbl del contador de tiempo
; Decenas
	ld	a, [time]
	and	$0f
	ld	d, a ; de = a * 32
	ld	e, 0
	srl	d
	rr	e
	srl	d
	rr	e
	srl	d
	rr	e
	ld	hl, SPRTBL_TIMER
	add	hl, de
	ld	[blit_sprite_timer_src], hl
; Unidades
	ld	a, [time +1]
	and	$f0
	ld	d, 0 ; de = (a >> 4) * 32
	ld	e, a
	sla	e
	rl	d
	ld	hl, SPRTBL_TIMER
	add	hl, de
	ld	[blit_sprite_timer_src +2], hl
; Décimas
	ld	a, [time +1]
	and	$0f
	ld	d, a ; de = a * 32
	ld	e, 0
	srl	d
	rr	e
	srl	d
	rr	e
	srl	d
	rr	e
	ld	hl, SPRTBL_TIMER + 32 *10
	add	hl, de
	ld	[blit_sprite_timer_src +4], hl

	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Vuelca los sprites a la VRAM de forma rápida
; (no puede usarse fuera de v-blank)
; El volcado se divide en fragmento:
; - SPRATR
; - Animación correcta del coche en la SPRTBL
; - Números del marcador de tiempo en la SPRTBL
; (basado en FLDIRVM de SapphiRe,
; del post "La rutina de transferencia refinitiva"
; @ Karoshi MSX Community)
; touches a, bc, de, hl
BLIT_SPRITES:
; Obtiene el puerto de VDP para escritura
	ld	a, [VDP_DW]	; a = puerto #0 de escritura del VDP
	ld	c, a		; c = puerto #0 de escritura del VDP

; Vuelca spratr_buffer a SPRATR
	ld	hl, spratr_buffer
	ld	de, ((SPRATR & $3fff) | $4000)
	ld	b, (4 * (16 + 1)) & $ff ; (primeros 16 sprites)
	call	@@BLIT
	outi	; (para el decimoséptimo sprite)
	outi
	outi
	outi
	outi	; (para el byte adicional que contendrá SPAT_END)

; Vuelca la animación correcta de SPRTBL_CAR a SPRTBL
	ld	hl, [blit_sprite_src]
	ld	de, ((SPRTBL & $3fff) | $4000)
	ld	b, ((NUM_SPRITES_CAR * 2) * (16 + 1)) & $ff
	call	@@BLIT

; Vuelca los números del tiempo de SPRTBL_TIMER a SPRTBL
; Decenas (primer sprite)
	ld	hl, [blit_sprite_timer_src]
	ld	de, (((SPRTBL + (NUM_SPRITES_CAR * 32)) & $3fff) | $4000)
	call	@@BLIT_HALF_SPRITE
; Decenas (segundo sprite)
	ld	de, (((SPRTBL + (NUM_SPRITES_CAR * 32) + 32) & $3fff) | $4000)
	call	@@BLIT_HALF_SPRITE
; Unidades (primer sprite)
	ld	hl, [blit_sprite_timer_src +2]
	ld	de, (((SPRTBL + (NUM_SPRITES_CAR * 32) + 16) & $3fff) | $4000)
	call	@@BLIT_HALF_SPRITE
; Unidades (segundo sprite)
	ld	de, (((SPRTBL + (NUM_SPRITES_CAR * 32) + 48) & $3fff) | $4000)
	call	@@BLIT_HALF_SPRITE
; Décimas (primer sprite)
	ld	hl, [blit_sprite_timer_src +4]
	ld	de, (((SPRTBL + (NUM_SPRITES_CAR * 32) + 64) & $3fff) | $4000)
	call	@@BLIT_HALF_SPRITE
; Décimas (segundo sprite)
	ld	de, (((SPRTBL + (NUM_SPRITES_CAR * 32) + 96) & $3fff) | $4000)
	; call	@@BLIT_HALF_SPRITE ; falls through
@@BLIT_HALF_SPRITE:
	ld	b, (16 + 1) & $ff
@@BLIT:
	inc	c	; c = puerto #1 de escritura del VDP
	out	[c], e 	; Escribimos en el VDP el byte bajo de la direccion de destino
	; set	6, d	; Activamos el sexto bit del byte alto (no seria necesario si ya lo dejamos activado al inicializar DE)
	; res	7, d	; Desactivamos el séptimo bit del byte alto (no seria necesario si ya lo dejamos desactivado al inicializar DE)
	out	[c], d	; Escribimos en el VDP el byte alto de la direccion de destino
	dec	c	; c = puerto #0 de escritura del VDP
@@LOOP:
	REPT 16
	outi
	ENDR
	djnz	@@LOOP
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Vuelca el buffer a la VRAM de forma rápida y aplicando offset
; El volcado se divide en tres fragmentos:
; - Líneas completas en la parte superior de la pantalla
; - Caracteres sueltos en la línea que separa las dos partes
; - Líneas completas en la parte inferior de la pantalla
; Se calcula el tamaño de cada fragmento de forma previa
; y se almacena en la pila para acelerar el volcado propiamente dicho
BLIT_NAMTBL_WITH_OFFSET:
; hl = offset a aplicar
	ld	hl, [blit_offset]
; Preserva en a el byte bajo del offset... (1)
	ld	a, l
; Calcula las líneas completas de la parte inferior
	add	hl, hl ; hl << 3 ergo h = hl / 32
	add	hl, hl
	add	hl, hl
	push	hl ; preserva h (líneas completas parte inferior)
; (1) ...y calcula los caracteres sueltos de la parte inferior
	and	$1f
	jr	z, @@NO_CHARS
; Hay caracteres sueltos
	push	af ; preserva a (caracteres sueltos parte inferior o derecha)
	neg
	add	SCR_WIDTH ; a = 32 -a
	push	af ; preserva a (caracteres sueltos parte superior o izquierda)
; Calcula las líneas completas de la parte superior
	ld	a, h
	neg
	add	SCR_HEIGHT
	dec	a ; a = 24 -a -1 (por la línea que separa)
	push	af ; preserva a (filas completas parte superior)
	jr	@@READY
@@NO_CHARS:
; No hay caracteres sueltos
	push	af ; preserva un 0 (no hay caracteres sueltos)
; Calcula las líneas completas de la parte superior
	ld	a, h
	neg
	add	24 ; a = 24 -a
	push	af ; preserva a (filas completas parte superior)
@@READY:
; hl = primer caracter a volcar (buffer + offset)
	ld	de, [blit_offset]
	ld	hl, namtbl_buffer
	add	hl, de
; de = NAMTBL ...pre-preparado para lo que viene a continuación
	ld	de, ((NAMTBL & $3F00) | $4000)
; Prepara el VDP para escritura
; (basado en FLDIRVM de SapphiRe, del post "La rutina de transferencia refinitiva" @ Karoshi MSX Community)
	ld	a, [VDP_DW]	; a = puerto #0 de escritura del VDP
	ld	c, a		; c = puerto #0 de escritura del VDP
	inc	c		; c = puerto #1 de escritura del VDP
	out	[c], e 	; Escribimos en el VDP el byte bajo de la direccion de destino
	; set	6, d	; Activamos el sexto bit del byte alto (no seria necesario si ya lo dejamos activado al inicializar DE)
	; res	7, d	; Desactivamos el séptimo bit del byte alto (no seria necesario si ya lo dejamos desactivado al inicializar DE)
	out	[c], d	; Escribimos en el VDP el byte alto de la direccion de destino
	dec	c	; c = puerto #0 de escritura del VDP
; Filas completas de la parte superior
	pop	af
	or	a
	jp	z, @@CHARS ; no hay filas completas
@@UPPER_ROW:
; Fila completa de la parte superior
	REPT 31
	outi	; #1..#31
	nop	; 4t
	nop	; +4t = 8t >= 8t
	ENDR
	outi	; #32
	dec	a ; 4t
	jp	nz, @@UPPER_ROW ; +10t = 14t >= 8t
@@CHARS:
; Caracteres sueltos de la parte superior (izquierda)
	pop	af
	or	a
	jp	z, @@SKIP_TO_LOWER_ROWS ; no hay caracteres sueltos
@@LEFT_CHAR:
	outi
	dec	a ; 4t
	jp	nz, @@LEFT_CHAR ; +10t = 14t >= 8t
; Se ha acabado el buffer; va al inicio para volcar la parte inferior
	ld	hl, namtbl_buffer
; Caracteres sueltos de la parte inferior (derecha)
	pop	af
@@RIGHT_CHAR:
	outi
	dec	a ; 4t
	jp	nz, @@RIGHT_CHAR ; +10t = 14t >= 8t
	jp	@@LOWER_ROWS
@@SKIP_TO_LOWER_ROWS:
; Se ha acabado el buffer; va al inicio para volcar la parte inferior
	ld	hl, namtbl_buffer
@@LOWER_ROWS:
; Filas completas de la parte inferior
	pop	af
	or	a
	ret	z ; no hay filas completas
@@LOWER_ROW:
	REPT 31
	outi	; #1..#31
	nop	; 4t
	nop	; +4t = 8t >= 8t
	ENDR
	outi	; #32
	dec	a ; 4t
	jp	nz, @@LOWER_ROW ; +10t = 14t >= 8t
	ret
; -----------------------------------------------------------------------------

IFDEF DEBUG_BDRCLR
; -----------------------------------------------------------------------------
; Modifica instantáneamente el color del borde
; param b: color a utilizar
SUB_DEBUG_BDRCLR:
	push	bc
	ld	c, $07
	call	WRTVDP
	pop	bc
	ret
; -----------------------------------------------------------------------------
ENDIF

;
; =============================================================================
;	Buffers PSG, acceso a PSG mediante BIOS, replayer PT3 mediante hook
; =============================================================================
;

; -----------------------------------------------------------------------------
; Inicializa el PSG y el buffer que se utilizará durante el juego
GICINI_BUFFER:
; Inicializa el PSG mediante la BIOS
	call	GICINI
; Inicializa el buffer que se utilizará durante el juego
	xor	a
	ld	b, psg_envelope_shape - psg_buffer + 1
	ld	hl, psg_buffer
@@LOOP:
	call	RDPSG
	ld	[hl], a
	inc	a
	inc	hl
	djnz	@@LOOP
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Asigna un valor al mezclador en el buffer PSG,
; manteniendo inalterados los dos bits más altos
; param a: valor para el mezclador, con los dos bits más altos a 0
; touches a, hl
SET_PSG_MIXER:
	ld	hl, psg_mixer
	xor	[hl] ; a = 2b [buffer], 6b [a xor hl]
	and	$3f  ; a = 00           6b [a xor hl]
	xor	[hl] ; a = 2b [buffer], 6b [a xor hl xor hl = a]
	ld	[hl], a
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Vuelca a los registros del buffer al PSG
WRTPSG_BUFFER:
	xor	a
	ld	b, psg_envelope_frequency - psg_buffer + 1
	ld	hl, psg_buffer
@@LOOP:
	ld	e, [hl]
	call	WRTPSG
	inc	a
	inc	hl
	djnz	@@LOOP
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Descomprime una canción, inicializa el reproductor
; y lo instala en la interrupción.
; param hl: puntero a la canción comprimida
INIT_REPLAYER:
; Descomprime la música
	ld	de, music
	call	UNPACK_PAGE0_AWARE_DE_OK
; Prepara los valores iniciales del las variables el replayer
	ld	a, 6
	ld	[replayer_frameskip], a
; Con las interrupciones deshabilitadas...
	halt	; sincronización
	di
; ...instala el reproductor de PT3 en la interrupción
	ld	hl, @@HOOK
	ld	de, HTIMI
	ld	bc, HOOK_SIZE
	ldir
; ...inicializa la reproducción
	ld	hl, music -100
	call	PT3_INIT
	ld	hl, PT3_SETUP
	set	0, [hl] ; desactiva loop
; Habilita las interrupciones y finaliza
	ei
	halt	; asegura que se limpie el bit de interrupción del VDP
	halt	; TODO duda: ¿innecesarios? ¿innecesario uno?
	ret

; Hook a instalar en H.TIMI
@@HOOK:
	jp	@@INTERRUPT
	ret	; padding a 5 bytes (tamaño de un hook)
	ret

; Subrutina que se invocará en cada interrupción
@@INTERRUPT:
; Ejecuta un frame del reproductor musical
	call	REPLAYER_INTERRUPT
; Se ejecuta el hook previo
	jp	old_htimi_hook
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Detiene manualmente el reproductor y lo desinstala de la interrupción.
REPLAYER_DONE:
; Silencia el reproductor
	halt	; sincronización
	call	PT3_MUTE
; Con las interrupciones deshabilitadas, recupera el hook previo
	di
	call	RESTORE_OLD_HTIMI_HOOK
	ei
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Subrutina del reproductor musical.
REPLAYER_INTERRUPT:
; En función de los 50Hz/60Hz...
	ld	a, [frame_rate]
	cp	60
	jr	nz, @@NO_FRAMESKIP ; 50Hz
; 60Hz: comprueba si toca frameskip
	ld	hl, replayer_frameskip
	dec	[hl]
	jr	nz, @@NO_FRAMESKIP ; no
; sí: no reproduce música y restaura el valor de frameskip
	ld	a, 6
	ld	[hl], a
	ret

@@NO_FRAMESKIP:
; frame normal: reproduce música
	; di	; innecesario (estamos en la interrupción)
	call	PT3_ROUT
	call	PT3_PLAY
	; ei	; innecesario (estamos en la interrupción)
; comprueba si se ha llegado al final de la canción
	ld	hl, PT3_SETUP
	bit	0, [hl]
	ret	z ; no (está en modo bucle)
	bit	7, [hl]
	ret	z ; no (no ha terminado)
; sí: detiene automáticamente el reproductor
; ------VVVV----falls through--------------------------------------------------

; -----------------------------------------------------------------------------
; Desinstala el reproductor recuperando el hook previo.
; Invocar siempre con las interrupciones deshabilitadas
RESTORE_OLD_HTIMI_HOOK:
	ld	hl, old_htimi_hook
	ld	de, HTIMI
	ld	bc, HOOK_SIZE
	ldir
	ret
; -----------------------------------------------------------------------------

	.printtext	" ... main code"
	.printhex	$

; EOF
