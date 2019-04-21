; -----------------------------------------------------------------------------
; World Rally
; (c) 2014 theNestruo (Néstor Sancho Bejarano)
; -----------------------------------------------------------------------------
; Datos y recursos (páginas 1 y 2)
; -----------------------------------------------------------------------------

;
; =============================================================================
;	Literales, datos y recursos
; =============================================================================
;

; -----------------------------------------------------------------------------
; Valores de inicialización, valores constantes, literales y textos
; -----------------------------------------------------------------------------

; Datos dependientes de la frecuencia de refresco
FRAME_RATE_50HZ_0:
; frame_rate / frames_per_tenth / seconds_hurry_up / seconds_per_stage / seconds_time_over
	.db	50, $05, $05, $06, $08
@@BEST_TIMES:
; best_times
	.db	"MCR", $24, $00 ; 2:40.0 ; 35º Rallye Sanremo - Rallye d'Italia
	.db	"SAI", $24, $50 ; 2:45.0
	.db	"KKK", $25, $00 ; 2:50.0
	.db	"AUR", $25, $50 ; 2:55.0
	.db	"MAK", $30, $00 ; 3:00.0
	.db	"SAI", $24, $00 ; 2:40.0 ; 61ème Rallye Automobile de Monte-Carlo
	.db	"KKK", $24, $50 ; 2:45.0
	.db	"AUR", $25, $00 ; 2:50.0
	.db	"MCR", $25, $50 ; 2:55.0
	.db	"MAK", $30, $00 ; 3:00.0
	.db	"AUR", $24, $00 ; 2:40.0 ; 37ème Tour de Corse - Rallye de France
	.db	"SAI", $24, $50 ; 2:45.0
	.db	"KKK", $25, $00 ; 2:50.0
	.db	"MCR", $25, $50 ; 2:55.0
	.db	"MAK", $30, $00 ; 3:00.0
	.db	"KKK", $24, $00 ; 2:40.0 ; 43th 1000 Lakes Rally
	.db	"SAI", $24, $50 ; 2:45.0
	.db	"AUR", $25, $00 ; 2:50.0
	.db	"MCR", $25, $50 ; 2:55.0
	.db	"MAK", $30, $00 ; 3:00.0
	.db	"SAI", $24, $00 ; 2:40.0 ; 29º Rallye Catalunya-Costa Brava
	.db	"KKK", $24, $50 ; 2:45.0
	.db	"AUR", $25, $00 ; 2:50.0
	.db	"MCR", $25, $50 ; 2:55.0
	.db	"MAK", $30, $00 ; 3:00.0
	FRAME_RATE_SIZE equ $ - FRAME_RATE_50HZ_0

FRAME_RATE_60HZ_0:
; frame_rate / frames_per_tenth / seconds_hurry_up / seconds_per_stage / seconds_time_over
	.db	60, $06, $04, $05, $07
; best_times
	.db	"MCR", $21, $40 ; 2:14.0 ; 35º Rallye Sanremo - Rallye d'Italia
	.db	"SAI", $21, $80 ; 2:18.0
	.db	"KKK", $22, $20 ; 2:22.0
	.db	"AUR", $22, $60 ; 2:26.0
	.db	"MAK", $23, $00 ; 2:30.0
	.db	"SAI", $21, $40 ; 2:10.0 ; 61ème Rallye Automobile de Monte-Carlo
	.db	"KKK", $21, $80 ; 2:18.0
	.db	"AUR", $22, $20 ; 2:22.0
	.db	"MCR", $22, $60 ; 2:26.0
	.db	"MAK", $23, $00 ; 2:30.0
	.db	"AUR", $21, $40 ; 2:14.0 ; 37ème Tour de Corse - Rallye de France
	.db	"SAI", $21, $80 ; 2:18.0
	.db	"KKK", $22, $20 ; 2:22.0
	.db	"MCR", $22, $60 ; 2:26.0
	.db	"MAK", $23, $00 ; 2:30.0
	.db	"KKK", $21, $40 ; 2:14.0 ; 43th 1000 Lakes Rally
	.db	"SAI", $21, $80 ; 2:18.0
	.db	"AUR", $22, $20 ; 2:22.0
	.db	"MCR", $22, $60 ; 2:26.0
	.db	"MAK", $23, $00 ; 2:30.0
	.db	"SAI", $21, $40 ; 2:14.0 ; 29º Rallye Catalunya-Costa Brava
	.db	"KKK", $21, $80 ; 2:18.0
	.db	"AUR", $22, $20 ; 2:22.0
	.db	"MCR", $22, $60 ; 2:26.0
	.db	"MAK", $23, $00 ; 2:30.0

HI_SCORES_0:
	.db	"SAI", $00, $85
	HI_SCORE_ENTRY_SIZE equ $ - HI_SCORES_0
	.db	"KKK", $00, $74
	.db	"AUR", $00, $66
	.db	"MCR", $00, $60
	.db	"MAK", $00, $40
	HI_SCORES_SIZE equ $ - HI_SCORES_0

GLOBALS_0:
	.db	"1UP"
	INITIALS_SIZE equ $ - GLOBALS_0
	INITIALS_X equ (SCR_WIDTH - INITIALS_SIZE *2 +1) /2 ; *2-1 para añadir espacios intermedios
	.db	CREDITS_0 ; credits
IFDEF DEMO_VERSION
	.db	RALLY_FLAG_LOCKED, $00, $00, RALLY_FLAG_LOCKED, $00 ; rally_status
ELSE
	.db	$00, $00, $00, $00, RALLY_FLAG_LOCKED ; rally_status
ENDIF
	.db	$00, $00 ; championship_score
IFDEF DEBUG_QUICKPLAY
	.db	0 ; last_rally_position que muestra STAGE_INTRO_SPECIAL
ELSE
	.db	5 ; last_rally_position que muestra STAGE_INTRO
ENDIF
	GLOBALS_SIZE equ $ - GLOBALS_0

CLRTBL_TITLE:
	.db	$50, $50, $50, $50, $50, $50, $50, $50 ; valores iniciales
	.db	$50, $50, $50, $50, $50, $50, $50, $50
	.db	$40, $50, $50, $40, $50, $40, $10, $f0 ; degradado
	.db	$30, $20, $30, $20, $20, $30, $20, $20
	CLRTBL_TITLE_STEPS equ $ - CLRTBL_TITLE -16

SPRATR_NAME_ENTRY_0:
	.db	92 -1, INITIALS_X *8 -4, $04, 4 ; cuadradito
	.db	SPAT_END
	SPRATR_NAME_ENTRY_0_LENGTH equ $ - SPRATR_NAME_ENTRY_0

SPRATR_RALLY_SELECT_0:
	.db	RALLY_OPTIONS_Y *8 +3, RALLY_OPTIONS_X *8 -32, $00, 15 ; cursor
	.db	SPAT_END
	SPRATR_RALLY_SELECT_0_LENGTH equ $ - SPRATR_RALLY_SELECT_0

INGAME_DATA_0:
	.db	0 ; scroll_status
	.dw	$0000 ; blit_offset
	.db	0, -SCR_HEIGHT ; viewport_x, viewport_y (izquierda, abajo del todo)

	.db	CAR_STOPPED ; car_status
	.db	CAR_X_0, CAR_Y_0 ; car_x, car_y
	.db	0, 0 ; car_offset_x, car_offset_y
	.db	0 ; car_offset_y_jump
	.db	0 ; car_offset_y_vibration
	.db	DIR_UR * $10 + HEADING_SUB_ZERO ; car_heading
	.db	DIR_UR ; car_direction
	.db	0 ; speed
	.db	MOVE_WHEN ; dist_to_move
	.db	0 ; frames_to_control

	.db	$00 ; time_seconds
	.db	$00 ; time_tenths
	.db	0 ; frames_in_tenth
	.db	0 ; hurry_up

	.dw	events ; current_event_addr
	.db	0 ; current_event_trigger
	.dw	$0000 ; current_event_colortable
	.db	EVENT_DELAY ; frames_current_event (para que se elimine el "Go!")

	INGAME_DATA_0_LENGTH equ $ - INGAME_DATA_0

SPECIAL_INTRO_DATA_0:
; tiempo (en fotogramas) antes de empezar a volar los pájaros)
	.db	53, 40, 49

SPRATR_INTRO_SPECIAL_0:
; pájaros
	.db	INTRO_BIRD_SPAT_Y_0,    INTRO_BIRD_SPAT_X_0,     $6c, 15
	.db	INTRO_BIRD_SPAT_Y_0 +8, INTRO_BIRD_SPAT_X_0 +12, $6c, 15
	.db	INTRO_BIRD_SPAT_Y_0 +4, INTRO_BIRD_SPAT_X_0 +20, $6c, 15
	.db	SPAT_END
	SPRATR_INTRO_SPECIAL_0_LENGTH equ $ - SPRATR_INTRO_SPECIAL_0

SPRATR_INTRO_READY:
; sombra
	.db	SPAT_OB, 0, $2c, 1
; temporizador
	.db	SPAT_OB, 116, $18, 1 ; segundos
	.db	SPAT_OB, 116, $1c, 2
	.db	SPAT_OB, 132, $20, 1 ; décimas
	.db	SPAT_OB, 132, $24, 2
; eventos
	.db	SPAT_OB, 120, $7c, 1 ; El patrón se incrementará al utilizarlo
	.db	SPAT_OB, 120, $28, 0
; sprites adicionales
	.db	COUNTDOWN_Y, 112, $34, 1 ; "Ready?"
	.db	COUNTDOWN_Y, 112, $38, 2
	.db	COUNTDOWN_Y, 128, $3c, 1
	.db	COUNTDOWN_Y, 128, $40, 2
	.db	SPAT_END
	SPRATR_INTRO_READY_LENGTH equ $ - SPRATR_INTRO_READY

SPRATR_INTRO_3_2_1:
; sprites adicionales
	.db	COUNTDOWN_Y, 120, $44, 1 ; "Tres"
	.db	COUNTDOWN_Y, 120, $48, 9
	.db	SPAT_END
	SPRATR_INTRO_3_2_1_LENGTH equ $ - SPRATR_INTRO_3_2_1

SPRATR_INTRO_GO:
; sprites adicionales
	.db	COUNTDOWN_Y, 112, $5c, 1 ; "Go!"
	.db	COUNTDOWN_Y, 112, $60, 2
	.db	COUNTDOWN_Y, 128, $64, 1
	.db	COUNTDOWN_Y, 128, $68, 2
	.db	SPAT_END
	SPRATR_INTRO_GO_LENGTH equ $ - SPRATR_INTRO_GO

SPRATR_FINISH:
; eventos
	.db	EVENT_Y, 112, $34, 1 ; "Finish!"
	.db	EVENT_Y, 112, $38, 2
	.db	EVENT_Y, 128, $3c, 1
	.db	EVENT_Y, 128, $40, 2
	.db	SPAT_END
	SPRATR_FINISH_LENGTH equ $ - SPRATR_FINISH

SPRATR_TIME_OVER:
	.db	TIMER_Y, 112, $44, 1 ; "Time"
	.db	TIMER_Y, 112, $48, 6
	.db	TIMER_Y, 128, $4c, 1
	.db	TIMER_Y, 128, $50, 6
	.db	TIMER_Y +16, 112, $54, 1 ; "Over"
	.db	TIMER_Y +16, 112, $58, 6
	.db	TIMER_Y +16, 128, $5c, 1
	.db	TIMER_Y +16, 128, $60, 6
	.db	SPAT_END
	SPRATR_TIME_OVER_LENGTH equ $ - SPRATR_TIME_OVER

TXT_16KB_RAM_REQUIRED:
	.db	"16KB RAM REQUIRED"
	TXT_16KB_RAM_REQUIRED_LENGTH equ $ - TXT_16KB_RAM_REQUIRED

TXT_CREDITS:
	.db	"WORLD  RALLY", CHAR_CR
	.db	"@THENESTRUO 2014", CHAR_CR, CHAR_CR, CHAR_CR
IFDEF DEMO_VERSION
	.db	"* PRIVATE BETA", CHAR_CR, CHAR_CR, CHAR_CR
ENDIF
	.db	"CODE:", CHAR_CR
	.db	"N$STOR SANCHO", CHAR_CR, CHAR_CR
	.db	"GRAPHICS:", CHAR_CR
	.db	"TONI G#LVEZ", CHAR_CR
	.db	"N$STOR SANCHO", CHAR_CR, CHAR_CR
	.db	"MUSIC:", CHAR_CR
	.db	"WONDER (STRAVAGANZA)", CHAR_CR, CHAR_EOF

TXT_AUTHORS:
	.db	"@ NESTRUO-G#LVEZ-WONDER 2014", CHAR_CR

TXT_PUSH_SPACE:
	.db	"PUSH SPACE KEY", CHAR_CR

TXT_BEST_DRIVERS:
	.db	"BEST DRIVERS", CHAR_CR

TXT_GAME_START:
	.db	"GAME START", CHAR_CR

TXT_NAME_ENTRY:
	.db	"ENTER YOUR NAME", CHAR_CR

TXT_RALLY_SELECT:
	.db	"CHOOSE A RALLY", CHAR_CR

TXT_SPECIAL_STAGE:
	.db	"SPECIAL STAGE "
	TXT_SPECIAL_STAGE_LENGTH equ $ - TXT_SPECIAL_STAGE
	TXT_SPECIAL_STAGE_X equ (SCR_WIDTH - (TXT_SPECIAL_STAGE_LENGTH +3)) /2

TXT_TIME_LIMIT:
	.db	"TIME LIMIT "
	TXT_TIME_LIMIT_OFFSET equ $ - TXT_TIME_LIMIT
TXT_TIME_LIMIT_EXCEEDED:
	.db	"00 SECONDS"
	TXT_TIME_LIMIT_LENGTH equ $ - TXT_TIME_LIMIT
	TXT_TIME_LIMIT_X equ (SCR_WIDTH - TXT_TIME_LIMIT_LENGTH) /2
	.db	" LIMIT EXCEEDED"
	TXT_TIME_LIMIT_EXCEEDED_LENGTH equ $ - TXT_TIME_LIMIT_EXCEEDED
	TXT_TIME_LIMIT_EXCEEDED_X equ (SCR_WIDTH - TXT_TIME_LIMIT_EXCEEDED_LENGTH) /2

TXT_STAGE_STANDINGS:
	.db	"YOUR TIME", CHAR_CR

TXT_TOTAL_TIME:
	.db	"RALLY", CHAR_CR

TXT_EXTENDED_PLAY:
	.db	"EXTENDED PLAY", CHAR_CR

TXT_CONTINUE:
	.db	"CONTINUE? "
	TXT_CONTINUE_OFFSET equ $ - TXT_CONTINUE
	.db	"9"
	TXT_CONTINUE_LENGTH equ $ - TXT_CONTINUE
	TXT_CONTINUE_X equ (SCR_WIDTH - TXT_CONTINUE_LENGTH) /2

TXT_RALLY_STANDINGS:
	.db	"FINAL STANDINGS", CHAR_CR

TXT_GAME_OVER:
IFDEF DEMO_VERSION
	.db	"DEMO OVER", CHAR_CR
ELSE
	.db	"GAME OVER", CHAR_CR
ENDIF

TXT_BEST_TIMES_TABLE:
	.db	"1", $3b, "20", $5e, $5f
	.db	"2", $3c, "15", $5e, $5f
	.db	"3", $3d, "12", $5e, $5f
	.db	"4", $3e, "10", $5e, $5f
	.db	"5", $3e, " 8", $5e, $5f

TXT_HI_SCORES_TABLE:
	.db	"1", $3b, $5e, $5f
	.db	"2", $3c, $5e, $5f
	.db	"3", $3d, $5e, $5f
	.db	"4", $3e, $5e, $5f
	.db	"5", $3e, $5e, $5f

TXT_NO_TIME:
	.db	"-:--.-"
	TXT_NO_TIME_LENGTH equ $ - TXT_NO_TIME

TXT_ATTRACT_MODE:
; 35º Rallye Sanremo - Rallye d'Italia
	.db	"35", 91, " RALLYE SANREMO", CHAR_CR, CHAR_LF
	.db	"RALLYE D'ITALIA", CHAR_CR, CHAR_LF, CHAR_LF
	.db	"MONTAINOUS ROADS OVERLOOKING", CHAR_CR, CHAR_LF
	.db	"THE PICTURESQUE SEASIDE TOWN", CHAR_CR, CHAR_LF
	.db	"FEATURE FAST FLOWING SECTIONS,", CHAR_CR, CHAR_LF
	.db	"BUT ALSO CHANGES OF RHYTHM", CHAR_CR, CHAR_LF
	.db	"AND BLIND CORNERS.", CHAR_CR, CHAR_EOF
; 61ème Rallye Automobile de Monte-Carlo
	.db	"61", 92, 93, " RALLYE AUTOMOBILE", CHAR_CR, CHAR_LF
	.db	"DE MONTE-CARLO", CHAR_CR, CHAR_LF, CHAR_LF
	.db	"DIFFICULT AND DEMANDING RALLY", CHAR_CR, CHAR_LF
	.db	"ALONG THE FRENCH RIVIERA", CHAR_CR, CHAR_LF
	.db	"FEATURING ", 34, "COL DE TURINI", 34, ",", CHAR_CR, CHAR_LF
	.db	"ONE OF THE MOST FAMOUS", CHAR_CR, CHAR_LF
	.db	"SPECIAL STAGES IN THE WORLD.", CHAR_CR, CHAR_EOF
; 37ème Tour de Corse - Rallye de France
	.db	"37", 92, 93, " TOUR DE CORSE", CHAR_CR, CHAR_LF
	.db	"RALLYE DE FRANCE", CHAR_CR, CHAR_LF, CHAR_LF
	.db	"RALLY HELD ON ASPHALT ROADS,", CHAR_CR, CHAR_LF
	.db	"KNOWN AS THE", CHAR_CR, CHAR_LF
	.db	34, "TEN THOUSANDS TURNS RALLY", 34, CHAR_CR, CHAR_LF
	.db	"BECAUSE OF THE TWISTY ", CHAR_CR, CHAR_LF
	.db	"MOUNTAIN ROADS.", CHAR_CR, CHAR_EOF
; 43th 1000 Lakes Rally
	.db	"43", 62, " 1000 LAKES RALLY", CHAR_CR, CHAR_LF, CHAR_LF
	.db	"THIS RALLY HAS BEEN KNOWN", CHAR_CR, CHAR_LF
	.db	"TO BE VERY DIFFICULT", CHAR_CR, CHAR_LF
	.db	"FOR NON-NORDIC DRIVERS.", CHAR_CR, CHAR_LF
	.db	"IT'S ONE OF THE MOST POPULAR", CHAR_CR, CHAR_LF
	.db	"AND PRESTIGIOUS RALLIES", CHAR_CR, CHAR_LF
	.db	"IN THE CHAMPIONSHIP.", CHAR_CR, CHAR_EOF
; 29º Rallye Catalunya-Costa Brava
	.db	"29", 91, " RALLYE", CHAR_CR, CHAR_LF
	.db	"CATALUNYA-COSTA BRAVA", CHAR_CR, CHAR_LF, CHAR_LF
	.db	"RALLY COMPETITION HELD ON", CHAR_CR, CHAR_LF
	.db	"THE WIDE, SMOOTH AND SWEEPING", CHAR_CR, CHAR_LF
	.db	"ASPHALT ROADS AROUND THE REGION", CHAR_CR, CHAR_LF
	.db	"OF COSTA BRAVA IN CATALONIA.", CHAR_CR, CHAR_EOF

TXT_ENDING:
	.db	"CONGRATULATIONS!", CHAR_CR, CHAR_PAUSE, CHAR_PAUSE, CHAR_CLS
	.db	"CODE & MAIN GFX:", CHAR_CR, CHAR_LF
	.db	"N$STOR SANCHO", CHAR_CR, CHAR_PAUSE, CHAR_PAUSE, CHAR_CLS
	.db	"CAR SPRITE & ADDITIONAL GFX:", CHAR_CR, CHAR_LF
	.db	"TONI G#LVEZ", CHAR_CR, CHAR_PAUSE, CHAR_PAUSE, CHAR_CLS
	.db	"MUSIC:", CHAR_CR, CHAR_LF
	.db	"WONDER (STRAVAGANZA)", CHAR_CR, CHAR_PAUSE, CHAR_PAUSE, CHAR_CLS
	.db	"SPECIAL THANKS:", CHAR_CR, CHAR_LF
	.db	"JOS$ VILA CUADRILLERO", CHAR_CR, CHAR_PAUSE, CHAR_CLR
	.db	"EDUARDO A. ROBSY PETRUS", CHAR_CR, CHAR_PAUSE, CHAR_CLR
	.db	"SAPPHIRE", CHAR_CR, CHAR_PAUSE, CHAR_CLR
	.db	"JON CORT#ZAR", CHAR_CR, CHAR_PAUSE, CHAR_CLS
	.db	"GREETINGS:", CHAR_CR, CHAR_LF
	.db	"KONAMITO", CHAR_CR, CHAR_PAUSE, CHAR_CLR
	.db	"KOTAI", CHAR_CR, CHAR_PAUSE, CHAR_CLR
	.db	"MANUEL PAZOS", CHAR_CR, CHAR_PAUSE, CHAR_CLR
	.db	"KAROSHI MSX COMMUNITY", CHAR_CR, CHAR_PAUSE, CHAR_CLR
	.db	"AAMSX", CHAR_CR, CHAR_PAUSE, CHAR_CLR
	.db	"MSX.ORG", CHAR_CR, CHAR_PAUSE, CHAR_CLS
	.db	"THANKS FOR PLAYING", CHAR_CR, CHAR_PAUSE, CHAR_PAUSE, CHAR_CLS
	.db	"WORLD RALLY", CHAR_CR, CHAR_PAUSE, CHAR_LF
	.db	"@THENESTRUO 2014", CHAR_CR, CHAR_PAUSE, CHAR_PAUSE, CHAR_EOF

	.printtext	" ... data, constants, texts"
	.printhex	$

; -----------------------------------------------------------------------------
; Datos del bucle principal
; -----------------------------------------------------------------------------

; Definición gráfica de los tiles (sólo normales)
TILE_DEFINITION:
	.incbin	"data/tileset.tmx.bin"

; Información de los tiles (normal, reflejado)
TILE_PROPERTIES:
; 00..07
	.db	DIR_UR,	DIR_UL ; diag básica (x4)
	.db	DIR_UR,	DIR_UL
	.db	DIR_UR,	DIR_UL
	.db	DIR_UR,	DIR_UL
	.db	DIR_R,	DIR_L ; horiz #1
	.db	DIR_R,	DIR_L ; horiz, salto
	.db	DIR_R +TILE_FLAG_RIGHT,	DIR_L +TILE_FLAG_LEFT ; curva diag-horiz (x2)
	.db	DIR_R +TILE_FLAG_RIGHT,	DIR_L +TILE_FLAG_LEFT
; 08..0F
	.db	DIR_UR,	DIR_UL ; diag ribera (x4)
	.db	DIR_UR,	DIR_UL
	.db	DIR_UR,	DIR_UL
	.db	DIR_UR,	DIR_UL
	.db	DIR_R,	DIR_L ; horiz #2
	.db	DIR_U +TILE_FLAG_CAM,				DIR_U ; vert
	.db	DIR_UR +TILE_FLAG_RIGHT +TILE_FLAG_HALF,	DIR_UL +TILE_FLAG_LEFT +TILE_FLAG_HALF ; curva vert-diag (x2)
	.db	DIR_UR +TILE_FLAG_RIGHT +TILE_FLAG_HALF,	DIR_UL +TILE_FLAG_LEFT +TILE_FLAG_HALF
; 10..17
	.db	DIR_UR,	DIR_UL ; diag rocas (x4)
	.db	DIR_UR,	DIR_UL
	.db	DIR_UR,	DIR_UL
	.db	DIR_UR,	DIR_UL
	.db	DIR_U +TILE_FLAG_CAM,			DIR_U ; vert rocas #1
	.db	DIR_U +TILE_FLAG_CAM,			DIR_U ; vert rocas #2
	.db	DIR_U +TILE_FLAG_RIGHT +TILE_FLAG_CAM,	DIR_U +TILE_FLAG_LEFT ; curva diag-vert (x2)
	.db	DIR_U +TILE_FLAG_RIGHT +TILE_FLAG_HALF,	DIR_U +TILE_FLAG_LEFT +TILE_FLAG_HALF +TILE_FLAG_CAM
; 18..1f
	.db	DIR_UR,	DIR_UL ; diag árboles (x3)
	.db	DIR_UR,	DIR_UL
	.db	DIR_UR,	DIR_UL
	.db	DIR_UR,	DIR_UL ; diag, obstáculo tronco (x2)
	.db	DIR_UR,	DIR_UL
	.db	DIR_U +TILE_FLAG_CAM,		DIR_U ; vert árboles
	.db	DIR_UL +TILE_FLAG_RIGHT,	DIR_UR +TILE_FLAG_LEFT ; curva horiz-diag (x2)
	.db	DIR_L +TILE_FLAG_RIGHT,		DIR_R +TILE_FLAG_LEFT
; 20..27
	.db	DIR_UR,	DIR_UL ; diag básica, salto (x3)
	.db	DIR_UR,	DIR_UL
	.db	DIR_UR,	DIR_UL
	.db	DIR_UR,	DIR_UL ; diag árboles, salto
	.db	DIR_UR,	DIR_UL ; diag rocas, salto
	.db	DIR_U +TILE_FLAG_RIGHT +TILE_FLAG_THIRD +TILE_FLAG_CAM,	DIR_U +TILE_FLAG_LEFT +TILE_FLAG_THIRD ; curva cerrada (x3)
	.db	DIR_U +TILE_FLAG_RIGHT +TILE_FLAG_THIRD,		DIR_U +TILE_FLAG_LEFT +TILE_FLAG_THIRD +TILE_FLAG_CAM
	.db	DIR_U +TILE_FLAG_RIGHT +TILE_FLAG_THIRD,		DIR_U +TILE_FLAG_LEFT +TILE_FLAG_THIRD +TILE_FLAG_CAM
; 28..2f
	.db	DIR_UR,	DIR_UL ; diag árboles, salto vías (x3)
	.db	DIR_UR,	DIR_UL
	.db	DIR_UR,	DIR_UL
	.db	DIR_U +TILE_FLAG_CAM,	DIR_U ; vert árboles, salto vías
	.db	DIR_UR,	DIR_UL ; fin puente (x4)
	.db	DIR_UR,	DIR_UL
	.db	DIR_UR,	DIR_UL
	.db	DIR_UR,	DIR_UL
; 30..37
	.db	DIR_UR,	DIR_UL ; diag, multitud izquierda
	.db	DIR_UR,	DIR_UL ; llegada (x2)
	.db	DIR_UR,	DIR_UL
	.db	DIR_UR,	DIR_UL ; inicio puente (x2)
	.db	DIR_UR,	DIR_UL
	.db	DIR_UR,	DIR_UL ; diag puente (x3)
	.db	DIR_UR,	DIR_UL
	.db	DIR_UR,	DIR_UL
; 38..3f
	.db	DIR_UR,	DIR_UL ; salida (x2)
	.db	DIR_UR,	DIR_UL
	.db	DIR_UR,	DIR_UL ; diag, multitud derecha
	.db	DIR_UR,	DIR_UL ; diag, obstáculo coche
	.db	DIR_UR,	DIR_UL ; inicio/fin ribera (x4)
	.db	DIR_UR,	DIR_UL
	.db	DIR_UR,	DIR_UL
	.db	DIR_UR,	DIR_UL
; 40..47
	.db	DIR_R +TILE_FLAG_RIGHT,				DIR_L +TILE_FLAG_LEFT ; curva vert-diag rocas
	.db	DIR_UR +TILE_FLAG_RIGHT +TILE_FLAG_HALF,	DIR_UL +TILE_FLAG_LEFT +TILE_FLAG_HALF ; curva vert-diag ribera
	.db	DIR_U +TILE_FLAG_RIGHT +TILE_FLAG_HALF,	DIR_U +TILE_FLAG_LEFT +TILE_FLAG_HALF +TILE_FLAG_CAM ; curva diag-vert árboles
	.db	DIR_UR,	DIR_UL ; FIXME EMPTY
	.db	DIR_U +TILE_FLAG_RIGHT +TILE_FLAG_CAM,	DIR_U +TILE_FLAG_LEFT ; curva diag-vert, charco (x2)
	.db	DIR_U +TILE_FLAG_RIGHT +TILE_FLAG_HALF,	DIR_U +TILE_FLAG_LEFT +TILE_FLAG_HALF +TILE_FLAG_CAM
	.db	DIR_UR,	DIR_UL ; diag pared rocas (x2)
	.db	DIR_UR,	DIR_UL

; Atravesabilidad de los tiles (sólo normales)
TILE_WALKABILITY:
; 00..07
	.db	$00, $00, $00, $00, $00, $01, $03, $07 ; diag básica (x4)
	.db	$0f, $1f, $3f, $7f, $ff, $ff, $ff, $ff
	.db	$ff, $ff, $ff, $fe, $fc, $f8, $f0, $e0
	.db	$c0, $80, $00, $00, $00, $00, $00, $00
	.db	$00, $ff, $ff, $ff, $ff, $ff, $ff, $00 ; horiz
	.db	$00, $ff, $ff, $ff, $ff, $ff, $ff, $00 ; horiz, salto
	.db	$00, $07, $1f, $3f, $ff, $ff, $ff, $ff ; curva diag-horiz (x2)
	.db	$00, $ff, $ff, $ff, $ff, $ff, $ff, $f0
; 08..0F
	.db	$00, $00, $00, $00, $00, $01, $03, $07 ; diag ribera (x4)
	.db	$0f, $1f, $3f, $7f, $ff, $ff, $ff, $ff
	.db	$ff, $ff, $ff, $ff, $fe, $fc, $f8, $f0
	.db	$e0, $c0, $80, $00, $00, $00, $00, $00
	.db	$00, $ff, $ff, $ff, $ff, $ff, $00, $00 ; horiz ???
	.db	$3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f ; vert
	.db	$0f, $1f, $1f, $3f, $3f, $3f, $3f, $3f ; curva vert-diag (x2)
	.db	$ff, $ff, $ff, $fe, $fe, $fc, $fc, $fc
; 10..17
	.db	$00, $00, $00, $00, $00, $01, $03, $07 ; diag rocas (x4)
	.db	$0f, $1f, $3f, $7f, $ff, $ff, $ff, $ff
	.db	$ff, $ff, $ff, $ff, $fe, $fc, $f8, $f0
	.db	$e0, $c0, $80, $00, $00, $00, $00, $00
	.db	$1f, $1f, $1f, $0f, $1f, $1f, $1f, $1f ; vert rocas #1
	.db	$3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f ; vert rocas #2
	.db	$3f, $3f, $3f, $1f, $1f, $0f, $0f, $07 ; curva diag-vert (x2)
	.db	$fc, $fe, $fe, $ff, $ff, $ff, $ff, $ff
; 18..1f
	.db	$00, $00, $00, $00, $00, $01, $03, $07 ; diag árboles (x3)
	.db	$0f, $1f, $1f, $3f, $ff, $ff, $ff, $ff
	.db	$ff, $ff, $ff, $f0, $f0, $f0, $f0, $e0
	.db	$0f, $1f, $03, $07, $07, $07, $ff, $ff ; diag, obstáculo tronco (x2)
	.db	$ff, $ff, $ff, $80, $00, $00, $00, $e0
	.db	$1f, $1f, $1f, $1f, $3f, $3f, $3f, $3f ; vert árboles
	.db	$ff, $ff, $ff, $7f, $3f, $1f, $07, $00 ; curva horiz-diag (x2)
	.db	$f8, $ff, $ff, $ff, $ff, $ff, $ff, $00
; 20..27
	.db	$00, $00, $00, $00, $00, $01, $07, $07 ; diag básica, salto (x3)
	.db	$0f, $1f, $3f, $7f, $ff, $ff, $ff, $ff
	.db	$ff, $ff, $ff, $ff, $fe, $f8, $f0, $e0
	.db	$00, $00, $00, $00, $00, $01, $07, $07 ; diag árboles, salto
	.db	$00, $00, $00, $00, $00, $01, $07, $07 ; diag rocas, salto
	.db	$0f, $0f, $0f, $0f, $0f, $0f, $0f, $07 ; curva cerrada (x3)
	.db	$ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	.db	$c0, $80, $80, $00, $80, $80, $c0, $e0
; 28..2f
	.db	$00, $00, $00, $00, $00, $00, $03, $07 ; diag árboles, salto (x3)
	.db	$0f, $1f, $3f, $3f, $7f, $ff, $ff, $ff
	.db	$ff, $ff, $ff, $fe, $fe, $fc, $f8, $f0
	.db	$3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f ; vert árboles, salto
	.db	$00, $00, $00, $00, $00, $00, $00, $01 ; fin puente (x4)
	.db	$0f, $0f, $1f, $3f, $3f, $7f, $ff, $ff
	.db	$ff, $ff, $fc, $f8, $c0, $80, $00, $00
	.db	$c0, $80, $00, $00, $00, $00, $00, $00
; 30..37
	.db	$00, $00, $00, $00, $00, $01, $03, $07 ; diag, multitud izquierda
	.db	$0f, $1f, $3f, $7f, $ff, $ff, $ff, $ff ; llegada (x2)
	.db	$ff, $ff, $ff, $fe, $fc, $f8, $f0, $e0
	.db	$03, $0f, $1f, $7f, $ff, $ff, $ff, $ff ; inicio puente (x2)
	.db	$ff, $ff, $fe, $fe, $fc, $f8, $f0, $e0
	.db	$00, $00, $00, $00, $00, $00, $00, $01 ; diag puente (x3)
	.db	$03, $07, $0f, $1f, $3f, $7f, $ff, $ff
	.db	$fe, $fc, $f8, $f0, $e0, $c0, $80, $00
; 38..3f
	.db	$07, $03, $07, $07, $0f, $1f, $3f, $7f ; salida (x2)
	.db	$f0, $e0, $e0, $e0, $c0, $80, $00, $00
	.db	$c0, $80, $00, $00, $00, $00, $00, $00 ; diag, multitud derecha
	.db	$f0, $e0, $e0, $e0, $e0, $e0, $c0, $e0 ; diag, obstáculo coche
	.db	$00, $00, $00, $00, $00, $01, $03, $07 ; inicio/fin ribera (x4)
	.db	$00, $00, $00, $00, $00, $01, $03, $07
	.db	$80, $80, $00, $00, $00, $00, $00, $00
	.db	$c0, $80, $00, $00, $00, $00, $00, $00
; 40..47
	.db	$00, $07, $1f, $3f, $ff, $ff, $ff, $ff ; curva diag-horiz rocas
	.db	$0f, $1f, $1f, $3f, $3f, $3f, $3f, $3f ; curva vert-diag ribera
	.db	$f8, $f8, $f8, $fc, $fe, $ff, $ff, $ff ; curva diag-vert
	.db	$ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff ; FIXME EMPTY
	.db	$3f, $3f, $3f, $1f, $1f, $0f, $0f, $07 ; curva diag-vert, charco (x2)
	.db	$fc, $fe, $fe, $ff, $ff, $ff, $ff, $ff
	.db	$e0, $c0, $80, $00, $00, $00, $00, $00 ; diag pared rocas (x2)
	.db	$e0, $c0, $80, $00, $00, $00, $00, $00

; Número de sprites del coche
SPR_CAR_SIZE_TABLE:
	.db	6,	4,	4,	4
	.db	5,	4,	4,	4
	.db	5,	4,	4,	4
	.db	6,	4,	4,	4
	SPR_CAR_SIZE_0	equ 5 ; tamaño en sprites de la animación inicial

; Patrones de los sprites del coche
SPRTBL_CAR_TABLE:
	.dw	@@SPRITE_0_0,	@@SPRITE_32_0,	@@SPRITE_64_0,	@@SPRITE_96_0
	.dw	@@SPRITE_0_32,	@@SPRITE_32_32,	@@SPRITE_64_32,	@@SPRITE_96_32
	.dw	@@SPRITE_0_64,	@@SPRITE_32_64,	@@SPRITE_64_64,	@@SPRITE_96_64
	.dw	@@SPRITE_0_96,	@@SPRITE_32_96,	@@SPRITE_64_96,	@@SPRITE_96_96
	.include	"spr/spr_car.pcx.spr.asm"

; Atributos de los sprites del coche
SPRATR_CAR_TABLE:
	.dw	@@SPRITE_0_0,	@@SPRITE_32_0,	@@SPRITE_64_0,	@@SPRITE_96_0
	.dw	@@SPRITE_0_32,	@@SPRITE_32_32,	@@SPRITE_64_32,	@@SPRITE_96_32
	.dw	@@SPRITE_0_64,	@@SPRITE_32_64,	@@SPRITE_64_64,	@@SPRITE_96_64
	.dw	@@SPRITE_0_96,	@@SPRITE_32_96,	@@SPRITE_64_96,	@@SPRITE_96_96
	.include	"spr/spr_car.pcx.spat.asm"

; Tabla de offsets (en píxeles) en los que comprobar la colisión
CHECK_COLLISION_OFFSETS:
	;	del. izq.	del. der.	tra. izq.	tra. der.	direccion
	.db	 -8,  11,	-14,   6,	 13,  -4,	  7, -10	; 0 DL
	.db	-13,   8,	-16,   2,	 15,   0,	 12,  -6	; 1
	.db	-15,   6,	-15,  -1,	 15,   6,	 15,  -1	; 2 L
	.db	-16,   0,	-12,  -6,	 14,   8,	 15,   3	; 3
	.db	-14,  -4,	 -7,  -9,	  7,  11,	 14,   6	; 4 UL
	.db	-10,  -6,	 -2,  -9,	  2,  12,	 10,   9	; 5
	.db	 -6,  -9,	  5,  -9,	 -6,  12,	  5,  12	; 6 U
	.db	  1,  -9,	  9,  -6,	-11,   9,	 -3,  12	; 7
	.db	  6,  -9,	 13,  -4,	-15,   6,	 -8,  11	; 8 UR
	.db	 11,  -6,	 15,   0,	-16,   3,	-15,   8	; 9
	.db	 14,  -1,	 14,   6,	-16,  -1,	-16,   6	; 10 R
	.db	 15,   2,	 12,   8,	-13,  -6,	-16,   0	; 11
	.db	 13,   6,	  7,  11,	 -8, -10,	-14,  -4	; 12 DR
	.db	 10,   9,	  2,  12,	 -2, -10,	-11,  -6	; 13
	.db	  5,  12,	 -6,  12,	  5,  -9,	 -6,  -9	; 14 D
	.db	 -3,  12,	-11,   9,	 10,  -6,	  1, -10	; 15

CAR_JUMP_Y_OFFSET:
	.db	-3, -6, -9, -12,  -14, -16, -18, -20,  -21, -22, -23, -24
	.db	-24, -24, -24, -24,  -24, -24, -24, -24,  -24, -24, -24, -24
	.db	-23, -22, -21, -20, -19, -18,  -16, -14, -12, -10, -8, -6, -4, -2, 0, 1, 0
CAR_JUMP_Y_OFFSET_LOW:
	.db	-2, -4, -6, -8,  -9, -10, -11, -12
	.db	-12, -12, -12, -12,  -12, -12, -12, -12
	.db	-11, -10, -9, -8, -7,  -5, -3, -1, 1, 0
	CAR_JUMP_Y_OFFSET_LENGTH equ $ - CAR_JUMP_Y_OFFSET

; Patrones de los sprites del temporizador
SPRTBL_TIMER:
	.incbin "spr/spr_numbers.pcx.spr"

; Secuencias de colores
EVENT_COLORS:
	.db	15,  9,  8,  6,  6,  6,  6,  8 ; obstáculo (estrechamiento)
	.db	15,  7,  5,  4,  4,  4,  4,  5 ; muy fácil
	.db	15,  3,  2, 12, 12, 12, 12,  3 ; fácil
	.db	15, 11, 10, 10, 15, 11, 10, 10 ; medio
	.db	15,  8,  6,  6, 15,  8,  6,  6 ; difícil
HURRY_UP_COLORS:
	.db	15, 11, 15, 11,  9,  9,  9, 11

	.printtext	" ... ingame data (tiles, gfx, ...)"
	.printhex	$

; -----------------------------------------------------------------------------
; Gráficos comprimidos y animaciones
; -----------------------------------------------------------------------------

; Charsets y sprites de las pantallas de título, attract mode, etc.
CHRTBL_TITLE_PACKED:
	.incbin	"gfx/charset_bw_title.pcx.chr.plet5"
CHRTBL_FONT_PACKED:
	.incbin	"gfx/charset_bw_font.pcx.chr.plet5"
CHRTBL_RALLIES_PACKED:
	.incbin	"gfx/charset_color_rallies.pcx.chr.plet5"
CLRTBL_RALLIES_PACKED:
	.incbin	"gfx/charset_color_rallies.pcx.clr.plet5"
SPRTBL_DEFAULT_PACKED:
	.incbin	"spr/spr_default.pcx.spr.plet5"
	SPRTBL_DEFAULT_SIZE equ 27 *32 ; Tamaño sin compresión

; Animación del attract mode
CUTSCENE_ATTRACTMODE:
	.dw	@@DATA_PACKED
	.dw	@@CHRTBL_PACKED
	.dw	@@CLRTBL_PACKED
; Secuencia de la animación
	;	frame	durac.	special	sprites
	.db	0,	68,	1,	88 -1, 140, $0c, 1 ; coche	; 140 - (68 / 2) = 106
	.db				88 -1, 140, $10, 14
	.db				88 -1, 140, $14, 15
	.db				SPAT_END
	.db	0,	8,	2,	92 -1, 104, $18, 1 ; coche
	.db				92 -1, 104, $1c, 14
	.db				92 -1, 104, $20, 15
	.db				SPAT_END
	.db	0,	50,	3,	93 -1, 104, $24, 1 ; coche	; 104 + (50 / 2) = 129
	.db				93 -1, 104, $28, 14
	.db				93 -1, 104, $2c, 15
	.db				SPAT_END
	.db	0,	12,	2,	95 -1, 130, $30, 1 ; coche
	.db				95 -1, 130, $34, 14
	.db				95 -1, 130, $38, 15
	.db				SPAT_END
	.db	0,	34,	4,	104 -1, 48, $08, 1 ; ocultador
	.db				98 -1, 130, $3c, 1 ; coche	; 130 - 34 = 96
	.db				98 -1, 130, $40, 14
	.db				98 -1, 130, $44, 15
	.db				SPAT_END
	.db	0,	48,	4,	104 -1, 48, $08, 1 ; ocultador
	.db				101 -1, 96, $48, 1 ; coche
	.db				101 -1, 96, $4c, 14
	.db				101 -1, 96, $50, 15
	.db				SPAT_END
	.db	0,	30,	0,	SPAT_END
	.db	1,	1,	0,	SPAT_END
	.db	2,	2,	0,	SPAT_END
	.db	3,	4,	0,	SPAT_END
	.db	4,	60,	0,	SPAT_END
	.db	CS_END
; Frames de la animación
@@DATA_PACKED:
	.incbin	"gfx/charset_cutscene_attractmode.pcx.nam.plet5"
@@CHRTBL_PACKED:
	.incbin "gfx/charset_cutscene_attractmode.pcx.chr.plet5"
@@CLRTBL_PACKED:
	.incbin "gfx/charset_cutscene_attractmode.pcx.clr.plet5"

; Animación "Final standings"
CUTSCENE_RALLYOVER:
	.dw	CUTSCENE_SHARED_NAMTBL_PACKED
	.dw	CUTSCENE_SHARED_CHRTBL_PACKED
	.dw	CUTSCENE_SHARED_CLRTBL_PACKED
; Secuencia por defecto de la animación
CUTSCENE_RALLYOVER_SEQ_DEFAULT:
	;	frame	durac.	special	sprites
	.db	9,	200,	0,	SPAT_END
	.db	CS_END
; Secuencias alternativas de las animaciones
CUTSCENE_RALLYOVER_SEQ_TABLE:
	.dw	@@FIRST
	.dw	@@SECOND
	.dw	@@THIRD
	.dw	CUTSCENE_RALLYOVER_SEQ_DEFAULT
	.dw	CUTSCENE_RALLYOVER_SEQ_DEFAULT
	;	frame	durat.	special	sprites
@@FIRST:
	.db	5,	6,	0,	112 -1, 112, $08, 7
	.db				SPAT_END
	.db	6,	6,	0,	112 -1, 112, $08, 7
	.db				SPAT_END
	.db	CS_LOOP, $ - @@FIRST
@@SECOND:
	.db	7,	200,	0,	112 -1, 112, $08, 7
	.db				SPAT_END
	.db	CS_END
@@THIRD:
	.db	8,	200,	0,	112 -1, 96, $08, 7
	.db				SPAT_END
	.db	CS_END
@@OTHER:

; Animación "Continue?"
CUTSCENE_CONTINUE:
	.dw	CUTSCENE_SHARED_NAMTBL_PACKED
	.dw	CUTSCENE_SHARED_CHRTBL_PACKED
	.dw	CUTSCENE_SHARED_CLRTBL_PACKED
; Secuencias de las animaciones
	;	frame	durat.	special	sprites
CUTSCENE_CONTINUE_SEQ_CONTINUE:
	.db	0,	30,	0,	SPAT_END ; 0 "Continue?"
	.db	1,	5,	0,	SPAT_END ; 1
	.db	0,	6,	0,	SPAT_END ; 2
	.db	1,	7,	0,	SPAT_END ; 3
	.db	CS_LOOP, $ - CUTSCENE_CONTINUE_SEQ_CONTINUE
CUTSCENE_CONTINUE_SEQ_YES:
	.db	2,	8,	0,	SPAT_END ; 0 "Continue"
	.db	3,	8,	0,	SPAT_END ; 1
	.db	CS_LOOP, $ - CUTSCENE_CONTINUE_SEQ_YES
CUTSCENE_CONTINUE_SEQ_NO:
	.db	4,	1,	0,	SPAT_END ; 0 "No continue"
	.db	CS_END

; Animación "Game over"
CUTSCENE_GAMEOVER:
	.dw	CUTSCENE_SHARED_NAMTBL_PACKED
	.dw	CUTSCENE_SHARED_CHRTBL_PACKED
	.dw	CUTSCENE_SHARED_CLRTBL_PACKED
; Secuencia de la animación
	;	frame	durat.	special	sprites
	.db	10,	30,	0,	SPAT_END
	.db	10,	128,	5,	128 -1, 176, $08, 1 ; ocultador
	.db				128 -1, 176, $58, 6 ; luces rojas
	.db				SPAT_END
	.db	10,	200,	0,	SPAT_END
	.db	CS_END

; Frames de las animaciones "Final standings", "Continue?" y "Game over"
CUTSCENE_SHARED_NAMTBL_PACKED:
	.incbin	"gfx/charset_cutscene_shared.pcx.nam.plet5"
CUTSCENE_SHARED_CHRTBL_PACKED:
	.incbin "gfx/charset_cutscene_shared.pcx.chr.plet5"
CUTSCENE_SHARED_CLRTBL_PACKED:
	.incbin "gfx/charset_cutscene_shared.pcx.clr.plet5"

; Animación del ending
CUTSCENE_ENDING:
	.dw	@@DATA_PACKED
	.dw	@@CHRTBL_PACKED
	.dw	@@CLRTBL_PACKED
; Secuencia de la animación
	;	frame	durat.	special	sprites
	.db	0,	200,	0,	SPAT_END
	.db	CS_END
; Frames de la animación
@@DATA_PACKED:
	.incbin	"gfx/charset_cutscene_ending.pcx.nam.plet5"
@@CHRTBL_PACKED:
	.incbin "gfx/charset_cutscene_ending.pcx.chr.plet5"
@@CLRTBL_PACKED:
	.incbin "gfx/charset_cutscene_ending.pcx.clr.plet5"

	.printtext	" ... packed data (gfx, cutscenes)"
	.printhex	$

; -----------------------------------------------------------------------------
; Recursos de música y sonido
; -----------------------------------------------------------------------------

SOUND_DRIFT:
	.dw	$0060
	.dw	$006f
	.dw	$0067
	.dw	$0062

SOUND_SPIN:
	.dw	$009a, $0092
	.db	12, 12
	.dw	$00a5, $00a1
	.db	11, 11
	.dw	$0092, $009a
	.db	10, 10
	.dw	$0092, $009a
	.db	7, 9

	.printtext	" ... sfx"
	.printhex	$

; EOF
