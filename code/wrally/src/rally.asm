; -----------------------------------------------------------------------------
; World Rally
; (c) 2014 theNestruo (N�stor Sancho Bejarano)
; email:   theNestruo@gmail.com
; twitter: @NestorSancho
; -----------------------------------------------------------------------------
; MSX cartridge / 48kB ROM / 16kB RAM
; -----------------------------------------------------------------------------
; Sintaxis / ensamblador:
; - asMSX (v0.16 WIP, Eduardo A. Robsy Petrus)
; Bibliotecas, c�digo incluido:
; - Pletter (v0.5c1, XL2S Entertainment, adaptaci�n asMSX por Jos� Vila Cuadrillero)
; - PT3 Player (Dioniso, versi�n ROM por MSX-KUN, adaptaci�n asMSX por SapphiRe)
; - SETPAGES32K, SETPAGES48K (Konamiman / SapphiRe)
; C�digo adaptado:
; - FLDIRVM (SapphiRe, "La rutina de transferencia refinitiva" @ Karoshi MSX Community)
; - COPY_BLOCK (Eduardo A. Robsy Petrus)
; -----------------------------------------------------------------------------

; Compilaci�n condicional (demos, c�digo de depuraci�n...)
	; DEMO_VERSION		equ 1 ; Versi�n demo: limita la partida a un �nico rally
	TIME_OVER_GAME_OVER	equ 1 ; Time Over implica Game Over sin posibilidad de Continue

	; DEBUG_BDRCLR		equ 1 ; Color de borde indicando operaciones
	; DEBUG_QUICKPLAY	equ 1 ; Salta al ingame lo m�s r�pido posible
	; DEBUG_WIPSTAGE	equ 1 ; Utiliza el mapa W.I.P. como 1-1
	; DEBUG_CHEATS		equ 1 ; Otros fragmentos de c�digo espec�ficos
	; DEBUG_RALLYOVERDEMO	equ 1 ; Salta al fin de un rally
	; DEBUG_GAMEOVERDEMO	equ 1 ; Salta al game over
	; DEBUG_ENDDEMO		equ 1 ; Salta al ending

;
; =============================================================================
; 	Constantes simb�licas
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
	SPAT_EC		equ $80 ; Early clock bit (desplazado 32 p�xeles hacia la izquierda)

; Valores generales
	NUM_RALLIES	equ 5 ; N�mero de rallies
	NUM_HIGH_SCORES	equ 5 ; N�mero de entradas en el high score

	RALLY_BIT_FINISHED	equ 0 ; Cada bit en un nibble para permitir contarlos sumando
	RALLY_BIT_LOCKED	equ 4 ;
	RALLY_FLAG_FINISHED	equ $01 << RALLY_BIT_FINISHED
	RALLY_FLAG_LOCKED	equ $01 << RALLY_BIT_LOCKED
	WHEN_TO_UNLOCK		equ 1 ; N�mero de rallies que hay que vencer para desbloquear los dem�s

	STAGE_MASK_RALLY	equ $fc ; Parte que indica el rally en current_stage
	STAGE_MASK_STAGE	equ $03 ; Parte que indica el tramo en current_stage

; Valores del t�tulo / attract mode / men�s / etc.
	CHRTBL_FONT_INIT	equ $20 ; Caracter en el que empieza la fuente de letra
	CHRTBL_RALLIES_INIT	equ $60 ; Caracter en el que empiezan los logos de los rallies
	CHRTBL_INITIALS_INIT	equ $70 ; Primer caracter con la bandera en la que se imprimir�n las iniciales

	FONT_COLOR	equ $f0 ; Color de la fuente de letra

	NAMTBL_TITLE_WIDTH	equ 16 ; Ancho del logotipo en caracteres

	CUTSCENE_WIDTH	equ 16 ; Tama�o y posici�n, en caracteres, de la animaci�n
	CUTSCENE_HEIGHT	equ 8
	CUTSCENE_Y	equ 8
	CUTSCENE_TEXT_Y	equ 17

	CS_LOOP	equ $fe ; Indicador de bucle de animaci�n
	CS_END	equ $ff ; Indicador de fin de animaci�n

	CHAR_EOF	equ $00 ; Fin de texto
	CHAR_CR		equ $01 ; Fin de l�nea
	CHAR_LF		equ $02 ; Nueva l�nea
	CHAR_CLR	equ $03 ; Borrado de l�nea actual
	CHAR_CLS	equ $04 ; Borrado de todas las l�nes
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
	DIR_NO	equ 16 ; direcci�n inv�lida (tile no atravesables)

	HEADING_MASK_DIR	equ $f0 ; M�scara para indicar la direcci�n
	HEADING_FLAG_HALF	equ $10 ; M�scara/flag para indicar direcci�n no octogonal
	HEADING_MASK_SUB	equ $0f ; M�scara para indicar la intenci�n de giro
	HEADING_SUB_ZERO	equ $08 ; Valor neutral de la intenci�n de giro

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

	VALID_TILES	equ $48 ; N�mero de tiles v�lidos (no decorativos): $00..$47

	TILE_WIDTH	equ 8
	TILE_SIZE	equ TILE_WIDTH * TILE_WIDTH

	COORD_MASK_TILE	equ $f8 ; Parte que indica el tile en una coordenada
	COORD_MASK_CHAR	equ $07 ; Parte que indica el caracter en una coordenada

	TILE_BIT_CAM	equ 0 ; En los tiles direcci�n arriba, indica que la c�mara se alinea a la derecha
	TILE_BIT_LEFT	equ 4 ; El tile es una curva a la izquierda
	TILE_BIT_RIGHT	equ 5 ; El tile es una curva a la derecha
	TILE_BIT_HALF	equ 6 ; Modifica la direcci�n efectiva (+2) de la mitad inferior del tile
	TILE_BIT_THIRD	equ 7 ; Modifica la direcci�n efectiva (+2, +4) de los tercios inferiores del tile
	TILE_FLAG_CAM	equ $01 << TILE_BIT_CAM
	TILE_FLAG_LEFT	equ $01 << TILE_BIT_LEFT
	TILE_FLAG_RIGHT	equ $01 << TILE_BIT_RIGHT
	TILE_FLAG_HALF	equ $01 << TILE_BIT_HALF
	TILE_FLAG_THIRD	equ $01 << TILE_BIT_THIRD

	TILE_MASK_DIR	equ $0e ; Indica la direcci�n del tile

	EVENT_TYPE	equ 0 ; Offset del tipo de disparador
	EVENT_CP	equ 1 ; Offset del valor para la comparaci�n
	EVENT_PATTERN	equ 2 ; Offset del patr�n visual
	EVENT_COLOR	equ 3 ; Offset del color
	EVENT_SIZE	equ 4 ; Tama�o de cada evento

	MAX_EVENTS	equ 32 ; N�mero m�ximo de eventos en un tramo

	EVENT_MASK_SPECIAL	equ $e0 ; Indica que es un evento de tipo especial
	EVENT_FLAG_FINISH	equ $80 ; Evento especial llegada a meta
	EVENT_FLAG_JUMP		equ $40 ; Evento especial salto
	EVENT_FLAG_SKID		equ $20 ; Evento especial mancha de aceite/agua/hielo
	EVENT_MASK_TRIGGER	equ $07 ; Indica el disparador del evento (1=L, 2=UL, 3=U, 4=UR, 5=R)

; Valores de scroll
	SCROLL_BIT_CAR	equ 0 ; Sincroniza la comprobaci�n de scroll con los frames en los que se ha movido el coche
	SCROLL_BIT_LAST	equ 1 ; Evita que se produzca scroll dos frames consecutivos
	SCROLL_FLAG_CAR		equ $01 << SCROLL_BIT_CAR
	SCROLL_FLAG_LAST	equ $01 << SCROLL_BIT_LAST

; Valores de sprites
	NUM_SPRITES_MENU	equ 1 ; cuadradito / cursor

	NUM_SPRITES_CAR		equ 6 ; m�ximo de SPR_CAR_SIZE_TABLE
	NUM_SPRITES_SHADOW	equ 1
	NUM_SPRITES_TIMER	equ 4
	NUM_SPRITES_EVENT	equ 2
	NUM_SPRITES_COUNTDOWN	equ 4 ; sprites adicionales para la cuenta atr�s (4 por "Go!")
	NUM_SPRITES_INTRO	equ 8 ; sprites que sustituyen al temporizador, eventos y adicionales durante las intros
	; NUM_SPRITES		equ NUM_SPRITES_CAR + NUM_SPRITES_SHADOW + NUM_SPRITES_TIMER + NUM_SPRITES_EVENT + NUM_SPRITES_COUNTDOWN +1

; Parametrizaci�n general
	CREDITS_0	equ 3 ; N�mero de cr�ditos iniciales

; Parametrizaci�n del t�tulo / attract mode / men�s / etc.
	PRINTCHAR_DELAY		equ 3 ; Ralentiza la escritura caracter a caracter
	PRINTCHAR_PAUSE_DELAY	equ 150 ; Pausa la escritura caracter a caracter
IFDEF DEBUG_QUICKPLAY
	TIMES_BLINK		equ 1 ; N�mero de repeticiones del parpadeo
	FRAMES_BLINK		equ 1 ; Frames de duraci�n del parpadeo
ELSE
	TIMES_BLINK		equ 10 ; N�mero de repeticiones del parpadeo
	FRAMES_BLINK		equ 3 ; Frames de duraci�n del parpadeo
ENDIF
	FRAMES_INPUT_PAUSE	equ 6 ; Pausa tras el cambio de opci�n

IFDEF DEMO_VERSION
	CREDITS_Y	equ 4
ELSE
	CREDITS_Y	equ 6
ENDIF

	TITLE_X		equ (SCR_WIDTH - NAMTBL_TITLE_WIDTH) /2 ; Coordenadas del t�tulo
	TITLE_Y		equ 6
	COPYRIGHT_Y	equ 9 ; Coordenadas del copyright
	PUSH_SPACE_Y	equ 17 ; Coordenadas de "PUSH SPACE KEY"

	OPTIONS_X	equ 9 ; Coordenadas de la primera opci�n en el men� de opciones
	OPTIONS_Y	equ 8

	RALLY_OPTIONS_X	equ 14 ; Coordenadas del primer logo en la selecci�n de rally
	RALLY_OPTIONS_Y equ 6

	BEST_TIMES_RALLY_X	equ 12 ; Coordenadas del logo en la pantalla de mejores tiempos
	BEST_TIMES_RALLY_Y	equ 2

	STAGE_TIMES_X	equ 3 ; Coordenadas de la tabla de tiempos de un tramo
	STAGE_TIMES_Y	equ 8

	BEST_TIMES_X	equ 5 ; Coordenadas de la tabla de mejores tiempos de un rally
	BEST_TIMES_Y	equ 10

	HI_SCORES_TITLE_Y	equ 2 ; Coordenadas del t�tulo en la pantalla de records

	HI_SCORES_X	equ 8 ; Coordenadas de la tabla de records
	HI_SCORES_Y	equ 10

; Parametrizaci�n ingame / intro
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
	INTRO_BIRD_SPAT_X_0	equ 144 ; Coordenadas (sprite) de los p�jaros de la intro
	INTRO_BIRD_SPAT_Y_0	equ 48 -1

	INTRO_MAX_SPEED	equ 4 << 4 ; 4 p�xeles por frame

; Parametrizaci�n del control del coche
	SPEED_MIN	equ 48 ; Velocidad m�nima
	SPEED_MAX	equ 96 ; Velocidad m�xima (�atenci�n! revisar los c�culos de UPDATE_SOUND si cambia)
	SPEED_DRIFT	equ 64 ; Velocidad m�xima al sobrevirar
	SPEED_SPIN	equ 16 ; Velocidad m�xima al trompear
	MOVE_WHEN	equ 192 ; Momento en el que se mueve el coche (m�ltiplo de SPEED_MAX por suavidad)
	DECEL_SPINING	equ 2 ; Deceleraci�n al trompear
	DECEL_FINISHING	equ 3 ; Deceleraci�n una vez cruzada la meta
	SPEED_HIGH_JUMP	equ 80 ; Velocidad a partir de la cual el salto es alto

	SCROLL_WHEN	equ 9 ; 10 ; Distancia del coche al centro en la que se hace scroll

	DRIFT_MARGIN	equ 2 ; Diferencia de direcci�n que se acepta al derrapar
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
;	Almac�n de datos comprimidos (p�gina 0)
; =============================================================================
;

	.page	0
; (p�gina 0 sin cabecera ROM)
	.dw	$0000

	.printtext	"------------------------------$0000-ROM-"
	.printhex	$

; -----------------------------------------------------------------------------
	.include	"src/rally_rom_page0.asm"
; -----------------------------------------------------------------------------

page0_end:

;
; =============================================================================
;	C�digo (p�ginas 1 y 2)
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
	
; Pletter (v0.5c1, XL2S Entertainment, adaptaci�n asMSX por Jos� Vila Cuadrillero)
	.include	"inc/pletter05c-unpackRam-asmsx.asm"
	UNPACK equ unpack ; punto de entrada al descompresor

; PT3 Player (Dioniso, versi�n ROM por MSX-KUN, adaptaci�n asMSX por SapphiRe)
	.include	"inc/PT3-ROM.ASM"
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Descomprime datos, teniendo en cuenta que puedan estar en la p�gina 0
; (en cuyo caso deshabilitar� las interrupciones durante la descompresi�n)
; param hl: origen de los datos (ROM)
; param de: destino de los datos (RAM)
UNPACK_PAGE0_AWARE:
	ld	de, unpack_buffer
UNPACK_PAGE0_AWARE_DE_OK:
; �hl >= $4000?
	ld	a, $40 ; $4000
	cp	h
	jp	c, UNPACK ; s�: descomprime de forma normal

; no: descomprime desde la p�gina 0
	; di	; innecesario; SETGAMEPAGE0 deshabilita las interrupciones
	push	hl ; preserva origen
	push	de ; preserva destino
; entra en la p�gina 0
	call	SETGAMEPAGE0
	pop	de ; restaura destino
	pop	hl ; restaura origen
	call	UNPACK
	; jp	EXIT_UNPACK_PAGE0 ; falls through
; ------VVVV----falls through--------------------------------------------------

; -----------------------------------------------------------------------------
; Sale de la p�gina 0, habilitando las interrupciones de nuevo
EXIT_UNPACK_PAGE0:
	call	RESTOREBIOS
	ei
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Descomprime el mapa y los eventos del tramo actual desde la p�gina 0
UNPACK_MAP:
	; di	; innecesario; SETGAMEPAGE0 deshabilita las interrupciones
	call	SETGAMEPAGE0
	call	UNPACK_MAP_PAGE0
	jr	EXIT_UNPACK_PAGE0
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Descomprime la tabla de patrones ingame desde la p�gina 0,
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
;	RAM: p�gina 3
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
; (asegura que est�n disponibles incluso con 8kB de RAM)
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
