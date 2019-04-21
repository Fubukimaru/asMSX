; -----------------------------------------------------------------------------
; World Rally
; (c) 2014 theNestruo (Néstor Sancho Bejarano)
; email:   theNestruo@gmail.com
; twitter: @NestorSancho
; -----------------------------------------------------------------------------
; MSX cartridge / 48kB ROM / 16kB RAM
; -----------------------------------------------------------------------------
; Sintaxis / ensamblador:
; - asMSX (v0.16 WIP, Eduardo A. Robsy Petrus)
; Bibliotecas, código incluido:
; - Pletter (v0.5c1, XL2S Entertainment, adaptación asMSX por José Vila Cuadrillero)
; - PT3 Player (Dioniso, versión ROM por MSX-KUN, adaptación asMSX por SapphiRe)
; - SETPAGES32K, SETPAGES48K (Konamiman / SapphiRe)
; Código adaptado:
; - FLDIRVM (SapphiRe, "La rutina de transferencia refinitiva" @ Karoshi MSX Community)
; - COPY_BLOCK (Eduardo A. Robsy Petrus)
; -----------------------------------------------------------------------------

; Compilación condicional (demos, código de depuración...)
	; DEMO_VERSION		equ 1 ; Versión demo: limita la partida a un único rally
	TIME_OVER_GAME_OVER	equ 1 ; Time Over implica Game Over sin posibilidad de Continue

	; DEBUG_BDRCLR		equ 1 ; Color de borde indicando operaciones
	; DEBUG_QUICKPLAY	equ 1 ; Salta al ingame lo más rápido posible
	; DEBUG_WIPSTAGE	equ 1 ; Utiliza el mapa W.I.P. como 1-1
	; DEBUG_CHEATS		equ 1 ; Otros fragmentos de código específicos
	; DEBUG_RALLYOVERDEMO	equ 1 ; Salta al fin de un rally
	; DEBUG_GAMEOVERDEMO	equ 1 ; Salta al game over
	; DEBUG_ENDDEMO		equ 1 ; Salta al ending

;
; =============================================================================
; 	Constantes simbólicas
; =============================================================================
;

; Puntos de entrada a la BIOS
	.bios

; Direcciones ROM (Constantes de la BIOS)
IFDEF VDP_DR ; (asMSX modificado ya define estas constantes con .bios)
ELSE
	VDP_DR	equ $0006 ; Base port address for VDP data read
	VDP_DW	equ $0007 ; Base port address for VDP data write
	MSXID1	equ $002b ; Frecuency, date format, charset
	MSXID3	equ $002d ; MSX version number
ENDIF

; Direcciones RAM (variables de sistema)
IFDEF CLIKSW ; (asMSX modificado ya define estas constantes con .bios)
ELSE
	CLIKSW	equ $f3db ; Keyboard click sound
	RG1SAV	equ $f3e0 ; Content of VDP(1) register (R#1)
	FORCLR	equ $f3e9 ; Foreground colour
	BAKCLR	equ $f3ea ; Background colour
	BDRCLR	equ $f3eb ; Border colour
	NEWKEY	equ $fbe5 ; Current state of the keyboard matrix ($fbe5-$fbef)
	HIMEM 	equ $fc4a ; High free RAM address available (init stack with)
ENDIF

; Direcciones RAM (hooks)
	HKEYI	equ $fd9a ; Interrupt handler
	HTIMI	equ $fd9f ; Interrupt handler
	HOOK_SIZE	equ HTIMI - HKEYI

; Direcciones VRAM
	CHRTBL	equ $0000 ; Pattern table
	NAMTBL	equ $1800 ; Name table
	CLRTBL	equ $2000 ; Color table
	SPRATR	equ $1B00 ; Sprite attributes table
	SPRTBL	equ $3800 ; Sprite pattern table

; Valores del sistema
	SCR_WIDTH	equ 32
	SCR_HEIGHT	equ 24
	SCR_SIZE	equ SCR_HEIGHT * SCR_WIDTH
	CHRTBL_SIZE	equ 256 * 8
	SPAT_END	equ $d0 ; Sprite que indica el final del SPRATR
	SPAT_OB		equ $d1 ; Sprite out of bounds (oculto)
	SPAT_EC		equ $80 ; Early clock bit (desplazado 32 píxeles hacia la izquierda)

; Valores generales
	NUM_RALLIES	equ 5 ; Número de rallies
	NUM_HIGH_SCORES	equ 5 ; Número de entradas en el high score

	RALLY_BIT_FINISHED	equ 0 ; Cada bit en un nibble para permitir contarlos sumando
	RALLY_BIT_LOCKED	equ 4 ;
	RALLY_FLAG_FINISHED	equ $01 << RALLY_BIT_FINISHED
	RALLY_FLAG_LOCKED	equ $01 << RALLY_BIT_LOCKED
	WHEN_TO_UNLOCK		equ 1 ; Número de rallies que hay que vencer para desbloquear los demás

	STAGE_MASK_RALLY	equ $fc ; Parte que indica el rally en current_stage
	STAGE_MASK_STAGE	equ $03 ; Parte que indica el tramo en current_stage

; Valores del título / attract mode / menús / etc.
	CHRTBL_FONT_INIT	equ $20 ; Caracter en el que empieza la fuente de letra
	CHRTBL_RALLIES_INIT	equ $60 ; Caracter en el que empiezan los logos de los rallies
	CHRTBL_INITIALS_INIT	equ $70 ; Primer caracter con la bandera en la que se imprimirán las iniciales

	FONT_COLOR	equ $f0 ; Color de la fuente de letra

	NAMTBL_TITLE_WIDTH	equ 16 ; Ancho del logotipo en caracteres

	CUTSCENE_WIDTH	equ 16 ; Tamaño y posición, en caracteres, de la animación
	CUTSCENE_HEIGHT	equ 8
	CUTSCENE_Y	equ 8
	CUTSCENE_TEXT_Y	equ 17

	CS_LOOP	equ $fe ; Indicador de bucle de animación
	CS_END	equ $ff ; Indicador de fin de animación

	CHAR_EOF	equ $00 ; Fin de texto
	CHAR_CR		equ $01 ; Fin de línea
	CHAR_LF		equ $02 ; Nueva línea
	CHAR_CLR	equ $03 ; Borrado de línea actual
	CHAR_CLS	equ $04 ; Borrado de todas las línes
	CHAR_PAUSE	equ $05	; Pausa en la escritura

; Valores que gestionan el funcionamiento interno del juego
	DIR_DL	equ 0 ; abajo izquierda
	DIR_L	equ 2 ; izquierda
	DIR_UL	equ 4 ; arriba izquierda
	DIR_U	equ 6 ; arriba
	DIR_UR	equ 8 ; arriba derecha
	DIR_R	equ 10 ; derecha
	DIR_DR	equ 12 ; abajo derecha
	DIR_D	equ 14 ; abajo
	DIR_NO	equ 16 ; dirección inválida (tile no atravesables)

	HEADING_MASK_DIR	equ $f0 ; Máscara para indicar la dirección
	HEADING_FLAG_HALF	equ $10 ; Máscara/flag para indicar dirección no octogonal
	HEADING_MASK_SUB	equ $0f ; Máscara para indicar la intención de giro
	HEADING_SUB_ZERO	equ $08 ; Valor neutral de la intención de giro

	CAR_STOPPED	equ 0
	CAR_NORMAL	equ 2
	CAR_JUMP	equ 4 ; Saltando
	CAR_DRIFT_L	equ 6 ; Sobreviraje
	CAR_DRIFT_R	equ 8 ; Sobreviraje
	CAR_DRIFT_END_L	equ 10 ; Finalizando el sobreviraje
	CAR_DRIFT_END_R	equ 12 ; Finalizando el sobreviraje
	CAR_SLIDE_L	equ 14 ; Deslizando (col. lateral)
	CAR_SLIDE_R	equ 16 ; Deslizando (col. lateral)
	CAR_SPIN_L	equ 18 ; Trompeando (col. diagonal)
	CAR_SPIN_R	equ 20 ; Trompeando (col. diagonal)
	CAR_FINISH	equ 22 ; Cruzada la meta
	; CAR_CRASH	equ 24

	COLL_FLAG_FL	equ $01
	COLL_FLAG_FR	equ $02
	COLL_FLAG_RL	equ $04
	COLL_FLAG_RR	equ $08

; Valores de mapa / tiles / eventos
	MAP_WIDTH	equ 32
	MAP_SIZE	equ MAP_WIDTH * MAP_WIDTH

	VALID_TILES	equ $48 ; Número de tiles válidos (no decorativos): $00..$47

	TILE_WIDTH	equ 8
	TILE_SIZE	equ TILE_WIDTH * TILE_WIDTH

	COORD_MASK_TILE	equ $f8 ; Parte que indica el tile en una coordenada
	COORD_MASK_CHAR	equ $07 ; Parte que indica el caracter en una coordenada

	TILE_BIT_CAM	equ 0 ; En los tiles dirección arriba, indica que la cámara se alinea a la derecha
	TILE_BIT_LEFT	equ 4 ; El tile es una curva a la izquierda
	TILE_BIT_RIGHT	equ 5 ; El tile es una curva a la derecha
	TILE_BIT_HALF	equ 6 ; Modifica la dirección efectiva (+2) de la mitad inferior del tile
	TILE_BIT_THIRD	equ 7 ; Modifica la dirección efectiva (+2, +4) de los tercios inferiores del tile
	TILE_FLAG_CAM	equ $01 << TILE_BIT_CAM
	TILE_FLAG_LEFT	equ $01 << TILE_BIT_LEFT
	TILE_FLAG_RIGHT	equ $01 << TILE_BIT_RIGHT
	TILE_FLAG_HALF	equ $01 << TILE_BIT_HALF
	TILE_FLAG_THIRD	equ $01 << TILE_BIT_THIRD

	TILE_MASK_DIR	equ $0e ; Indica la dirección del tile

	EVENT_TYPE	equ 0 ; Offset del tipo de disparador
	EVENT_CP	equ 1 ; Offset del valor para la comparación
	EVENT_PATTERN	equ 2 ; Offset del patrón visual
	EVENT_COLOR	equ 3 ; Offset del color
	EVENT_SIZE	equ 4 ; Tamaño de cada evento

	MAX_EVENTS	equ 32 ; Número máximo de eventos en un tramo

	EVENT_MASK_SPECIAL	equ $e0 ; Indica que es un evento de tipo especial
	EVENT_FLAG_FINISH	equ $80 ; Evento especial llegada a meta
	EVENT_FLAG_JUMP		equ $40 ; Evento especial salto
	EVENT_FLAG_SKID		equ $20 ; Evento especial mancha de aceite/agua/hielo
	EVENT_MASK_TRIGGER	equ $07 ; Indica el disparador del evento (1=L, 2=UL, 3=U, 4=UR, 5=R)

; Valores de scroll
	SCROLL_BIT_CAR	equ 0 ; Sincroniza la comprobación de scroll con los frames en los que se ha movido el coche
	SCROLL_BIT_LAST	equ 1 ; Evita que se produzca scroll dos frames consecutivos
	SCROLL_FLAG_CAR		equ $01 << SCROLL_BIT_CAR
	SCROLL_FLAG_LAST	equ $01 << SCROLL_BIT_LAST

; Valores de sprites
	NUM_SPRITES_MENU	equ 1 ; cuadradito / cursor

	NUM_SPRITES_CAR		equ 6 ; máximo de SPR_CAR_SIZE_TABLE
	NUM_SPRITES_SHADOW	equ 1
	NUM_SPRITES_TIMER	equ 4
	NUM_SPRITES_EVENT	equ 2
	NUM_SPRITES_COUNTDOWN	equ 4 ; sprites adicionales para la cuenta atrás (4 por "Go!")
	NUM_SPRITES_INTRO	equ 8 ; sprites que sustituyen al temporizador, eventos y adicionales durante las intros
	; NUM_SPRITES		equ NUM_SPRITES_CAR + NUM_SPRITES_SHADOW + NUM_SPRITES_TIMER + NUM_SPRITES_EVENT + NUM_SPRITES_COUNTDOWN +1

; Parametrización general
	CREDITS_0	equ 3 ; Número de créditos iniciales

; Parametrización del título / attract mode / menús / etc.
	PRINTCHAR_DELAY		equ 3 ; Ralentiza la escritura caracter a caracter
	PRINTCHAR_PAUSE_DELAY	equ 150 ; Pausa la escritura caracter a caracter
IFDEF DEBUG_QUICKPLAY
	TIMES_BLINK		equ 1 ; Número de repeticiones del parpadeo
	FRAMES_BLINK		equ 1 ; Frames de duración del parpadeo
ELSE
	TIMES_BLINK		equ 10 ; Número de repeticiones del parpadeo
	FRAMES_BLINK		equ 3 ; Frames de duración del parpadeo
ENDIF
	FRAMES_INPUT_PAUSE	equ 6 ; Pausa tras el cambio de opción

IFDEF DEMO_VERSION
	CREDITS_Y	equ 4
ELSE
	CREDITS_Y	equ 6
ENDIF

	TITLE_X		equ (SCR_WIDTH - NAMTBL_TITLE_WIDTH) /2 ; Coordenadas del título
	TITLE_Y		equ 6
	COPYRIGHT_Y	equ 9 ; Coordenadas del copyright
	PUSH_SPACE_Y	equ 17 ; Coordenadas de "PUSH SPACE KEY"

	OPTIONS_X	equ 9 ; Coordenadas de la primera opción en el menú de opciones
	OPTIONS_Y	equ 8

	RALLY_OPTIONS_X	equ 14 ; Coordenadas del primer logo en la selección de rally
	RALLY_OPTIONS_Y equ 6

	BEST_TIMES_RALLY_X	equ 12 ; Coordenadas del logo en la pantalla de mejores tiempos
	BEST_TIMES_RALLY_Y	equ 2

	STAGE_TIMES_X	equ 3 ; Coordenadas de la tabla de tiempos de un tramo
	STAGE_TIMES_Y	equ 8

	BEST_TIMES_X	equ 5 ; Coordenadas de la tabla de mejores tiempos de un rally
	BEST_TIMES_Y	equ 10

	HI_SCORES_TITLE_Y	equ 2 ; Coordenadas del título en la pantalla de records

	HI_SCORES_X	equ 8 ; Coordenadas de la tabla de records
	HI_SCORES_Y	equ 10

; Parametrización ingame / intro
	TIMER_Y		equ 12 -1 ; Coordenada Y en la que se muestra el temporizador
	EVENT_Y		equ 36 -1 ; Coordenada Y en la que se muestran los iconos de los eventos
	COUNTDOWN_Y	equ 64 -1 ; Coordenada Y en la que se muestra la secuencia "Ready? 3 2 1 Go!"

	EVENT_DELAY	equ 8 *4 *2 ; Frames que dura en pantalla el icono de un evento (dos ciclos de parpadeo)

	ENGINE_VOLUME equ 12

	CAR_COLOR	equ 15 ; Color del coche del jugador
	OPPONENT_COLOR	equ 5 ; Colores de los coches de la intro
	OPPONENT2_COLOR	equ 6

	CAR_X_0	equ 9 ; Coordenadas (de mapa) iniciales del coche
	CAR_Y_0 equ -6
	INTRO_CAR_SPAT_X_0	equ CAR_X_0 *8 ; Coordenadas (sprite) iniciales de salida / del coche de la intro
	INTRO_CAR_SPAT_Y_0	equ CAR_Y_0 *8 +192 -1
	CAR_SPAT_X_0		equ INTRO_CAR_SPAT_X_0 -64; Coordenadas (sprite) iniciales del coche (oculto, pre-intro)
	CAR_SPAT_Y_0		equ INTRO_CAR_SPAT_Y_0 +64
	INTRO_BIRD_SPAT_X_0	equ 144 ; Coordenadas (sprite) de los pájaros de la intro
	INTRO_BIRD_SPAT_Y_0	equ 48 -1

	INTRO_MAX_SPEED	equ 4 << 4 ; 4 píxeles por frame

; Parametrización del control del coche
	SPEED_MIN	equ 48 ; Velocidad mínima
	SPEED_MAX	equ 96 ; Velocidad máxima (¡atención! revisar los cáculos de UPDATE_SOUND si cambia)
	SPEED_DRIFT	equ 64 ; Velocidad máxima al sobrevirar
	SPEED_SPIN	equ 16 ; Velocidad máxima al trompear
	MOVE_WHEN	equ 192 ; Momento en el que se mueve el coche (múltiplo de SPEED_MAX por suavidad)
	DECEL_SPINING	equ 2 ; Deceleración al trompear
	DECEL_FINISHING	equ 3 ; Deceleración una vez cruzada la meta
	SPEED_HIGH_JUMP	equ 80 ; Velocidad a partir de la cual el salto es alto

	SCROLL_WHEN	equ 9 ; 10 ; Distancia del coche al centro en la que se hace scroll

	DRIFT_MARGIN	equ 2 ; Diferencia de dirección que se acepta al derrapar
	FAST_TURN_DRIFT	equ 3 ; Velocidad angular al sobrevirar
	FAST_TURN_SPIN	equ 4 ; Velocidad angular al trompear

	CONTROL_SLIDE_DELAY	equ 12 ; Frames hasta recuperar el control
	CONTROL_DRIFT_DELAY	equ 16 ; Frames finales del derrape

;
; =============================================================================
;	ROM, 48kB
; =============================================================================
;

	; .rom	; (incompatible con ROMs de 48kB)
	.size	48

;
; =============================================================================
;	Almacén de datos comprimidos (página 0)
; =============================================================================
;

	.page	0
; (página 0 sin cabecera ROM)
	.dw	$0000

	.printtext	"------------------------------$0000-ROM-"
	.printhex	$

; -----------------------------------------------------------------------------
	.include	"src/rally_rom_page0.asm"
; -----------------------------------------------------------------------------

page0_end:

;
; =============================================================================
;	Código (páginas 1 y 2)
; =============================================================================
;

	.page	1
rom_start:
; Cabecera de la ROM manual (directiva .rom incompatible con ROMs de 48kB)
	.db	"AB"		; ID ("AB")
	.dw	INIT		; INIT
	nop			; (random nops make asmsx happy)
	nop
	nop
	.org	rom_start + $10	; STATEMENT, DEVICE, TEXT, Reserved

	.printtext	"-----Cartridge header---------$4000-ROM-"
	.printhex	$

; -----------------------------------------------------------------------------
; SETPAGES32K, SETPAGES48K (Konamiman / SapphiRe)
	.include	"inc/SETPAGES32K.ASM"
	.include	"inc/SETPAGES48K.ASM"
	
; Pletter (v0.5c1, XL2S Entertainment, adaptación asMSX por José Vila Cuadrillero)
	.include	"inc/pletter05c-unpackRam-asmsx.asm"
	UNPACK equ unpack ; punto de entrada al descompresor

; PT3 Player (Dioniso, versión ROM por MSX-KUN, adaptación asMSX por SapphiRe)
	.include	"inc/PT3-ROM.ASM"
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Descomprime datos, teniendo en cuenta que puedan estar en la página 0
; (en cuyo caso deshabilitará las interrupciones durante la descompresión)
; param hl: origen de los datos (ROM)
; param de: destino de los datos (RAM)
UNPACK_PAGE0_AWARE:
	ld	de, unpack_buffer
UNPACK_PAGE0_AWARE_DE_OK:
; ¿hl >= $4000?
	ld	a, $40 ; $4000
	cp	h
	jp	c, UNPACK ; sí: descomprime de forma normal

; no: descomprime desde la página 0
	; di	; innecesario; SETGAMEPAGE0 deshabilita las interrupciones
	push	hl ; preserva origen
	push	de ; preserva destino
; entra en la página 0
	call	SETGAMEPAGE0
	pop	de ; restaura destino
	pop	hl ; restaura origen
	call	UNPACK
	; jp	EXIT_UNPACK_PAGE0 ; falls through
; ------VVVV----falls through--------------------------------------------------

; -----------------------------------------------------------------------------
; Sale de la página 0, habilitando las interrupciones de nuevo
EXIT_UNPACK_PAGE0:
	call	RESTOREBIOS
	ei
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Descomprime el mapa y los eventos del tramo actual desde la página 0
UNPACK_MAP:
	; di	; innecesario; SETGAMEPAGE0 deshabilita las interrupciones
	call	SETGAMEPAGE0
	call	UNPACK_MAP_PAGE0
	jr	EXIT_UNPACK_PAGE0
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Descomprime la tabla de patrones ingame desde la página 0,
; con las modificaciones al vuelo para poner las iniciales en la pancarta
UNPACK_CHRTBL_INGAME:
	; di	; innecesario; SETGAMEPAGE0 deshabilita las interrupciones
	call	SETGAMEPAGE0
	call	UNPACK_CHRTBL_INGAME_PAGE0
	jr	EXIT_UNPACK_PAGE0
; -----------------------------------------------------------------------------

	.printtext	" ... libraries"
	.printhex	$

; -----------------------------------------------------------------------------
	.include	"src/rally_rom_code.asm"
	.include	"src/rally_rom_data.asm"
; -----------------------------------------------------------------------------

rom_end:

;
; =============================================================================
;	RAM: página 3
; =============================================================================
;

	.page	3
ram_start:

	.printtext	"------------------------------$c000-RAM-"
	.printhex	$

; -----------------------------------------------------------------------------
	.include	"src/rally_ram.asm"
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Variables de las bibliotecas incluidas
	.include	"inc/PT3-RAM.ASM"

	.printtext	" ... libraries' vars"
	.printhex	$

; Variables de SETPAGES: slot de la bios y del juego
; (asegura que estén disponibles incluso con 8kB de RAM)
IF $ < $e000
	.org $e000
ENDIF
SLOTBIOS:
	.byte
SLOTGAME:
	.byte
; -----------------------------------------------------------------------------

	; .printtext	"-----Core DiskRom System------$f1c9-RAM-"
	; .printtext	"-----DiskROM System vars------$f341-RAM-"
	.printtext	"-----MSX System vars----------$f380-RAM-"

	.printtext	"ROM bytes free:"
	.printdec	rom_start - page0_end
	.printdec	ram_start - rom_end
; EOF
