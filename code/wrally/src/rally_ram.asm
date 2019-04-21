; -----------------------------------------------------------------------------
; World Rally
; (c) 2014 theNestruo (Néstor Sancho Bejarano)
; -----------------------------------------------------------------------------
; RAM (página 3)
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Variables globales
; -----------------------------------------------------------------------------

; ; Número de versión de MSX cuya paleta está en uso (inicialmente, copia de MSXID3)
; msx_version_palette:
	; .byte
; Hertzios de refresco de la pantalla (50Hz/60Hz)
frame_rate:
	.byte
; Variables de conveniencia dependientes de los hertzios
frames_per_tenth:
	.byte	; BCD
seconds_hurry_up:
	.byte	; BCD; por comodidad, decenas de segundo en el nibble bajo
seconds_per_stage:
	.byte	; BCD; por comodidad, decenas de segundo en el nibble bajo
seconds_time_over:
	.byte	; BCD; por comodidad, decenas de segundo en el nibble bajo
; Tablas de mejores tiempos (valores iniciales dependientes de los hertzios)
best_times:
	.ds	HI_SCORES_SIZE * NUM_RALLIES

; Tabla de mejores puntuaciones finales
hi_scores:
	.ds	HI_SCORES_SIZE

globals:
; Iniciales del jugador
initials:
	.ds	INITIALS_SIZE
; Créditos de los que se dispone
credits:
	.byte
; Estado de los rallies
rally_status:
	.ds	NUM_RALLIES
; Puntuación total acumulada de la partida (BCD)
championship_score:
	.byte
	.byte
; Posición final en el último rally (0-index)
last_rally_position:
	.byte

; Número de nivel actual: $0c rally, $03 tramo
current_stage:
	.byte

; Tiempo de cada tramo del rally actual (BCD)
current_rally_stage_times:
	REPT 3
	.byte	; minutos, primer dígito de segundos
	.byte	; segundo dígito de segundos, décimas de segundo
	ENDR
	CURRENT_RALLY_STAGE_TIMES_LENGTH equ $ - current_rally_stage_times

; Tiempo total acumulado en el rally actual (BCD)
current_rally_total_time:
	.byte	; minutos, primer dígito de segundos
	.byte	; segundo dígito de segundos, décimas de segundo

; Copia del tiempo total acumulado para restaurarlo si se continúa (BCD)
current_rally_total_time_backup:
	.byte
	.byte

; -----------------------------------------------------------------------------
; Variables del bucle principal del juego
; -----------------------------------------------------------------------------

; Mapa del tramo actual y eventos
map:
	.ds	MAP_SIZE ; 32*32 = 1K
events:
	.ds	MAX_EVENTS * EVENT_SIZE

; Variables de las animaciones de inicio de tramo
intro_car_xy:
intro_car_x:
	.byte
intro_car_y:
	.byte
intro_car2_xy:
	.word
intro_car_speed:
	.byte
intro_car_dist_to_move:
	.byte

ingame_data:

; Flags de control (scroll)
scroll_status:
	.byte
; Offset del blitting (scroll)
blit_offset:
	.word
; Coordenadas del viewport sobre el mapa (scroll)
viewport_xy:
viewport_x:
	.byte
viewport_y:
	.byte

; Estado del coche
car_status:
	.byte
; Coordenadas del tile que ocupa la parte superior izquierda del coche
car_xy:
car_x:
	.byte
car_y:
	.byte
; Desplazamiento del coche respecto al tile
car_offset_xy:
car_offset_x:
	.byte
car_offset_y:
	.byte
car_offset_y_jump:
	.byte
car_offset_y_vibration:
	.byte
; Nibble alto: dirección hacia la que apunta el coche (frame visualizado, 16 posibles valores)
; Nibble bajo: actúa como acumulador de giro
car_heading:
	.byte
; Dirección en la que se mueve el coche (DIR_*, 8 posibles valores)
car_direction:
	.byte
; Velocidad del coche o del scroll
speed:
	.byte
; Distancia (acmulación de velocidad) que falta hasta mover el coche
dist_to_move:
	.byte
; Frames que faltan para recuperar el control del coche tras una colisión o un salto
frames_to_control:
	.byte

; Tiempo transcurrido (en segundos y décimas de segundo) (BCD)
time:
	.byte ; decenas de segundos
	.byte ; segundos y décimas de segundo
frames_in_tenth:
	.byte

; Indica parpadeo de color del indicador de tiempo
hurry_up:
	.byte

; Puntero al siguiente evento a buscar
current_event_addr:
	.word
; Permite detectar los eventos por edge y no por level
current_event_trigger:
	.byte
; Puntero a la tabla de colores para el parpadeo
current_event_colortable:
	.word
; Fotogramas pendientes para eliminar el evento actual
frames_current_event:
	.byte

; Propiedad del tile sobre el que se encuentra el coche
road_properties:
	.byte

; -----------------------------------------------------------------------------
; Buffers VRAM
; -----------------------------------------------------------------------------

; Buffer de NAMTBL en RAM
namtbl_buffer:
	.ds	SCR_SIZE ; 32*24 = 768b
; Para evitar controlar el overflow Las rutinas de draw_h_line,
; se ubica una línea extra a continuación de namtbl_buffer
line_buffer:
	.ds	SCR_WIDTH ; ...+32 = 800b

; Buffer de SPRATR en RAM
spratr_buffer:
spratr_buffer_menu:
	.ds	NUM_SPRITES_MENU *4
	.byte	; (para albergar un SPAT_END)

	.org	spratr_buffer ; (comparte RAM)
spratr_buffer_car:
	.ds	NUM_SPRITES_CAR *4
	spratr_buffer_intro	equ spratr_buffer_car + SPR_CAR_SIZE_0 *4 ; (comparte RAM)
spratr_buffer_shadow:
	.ds	NUM_SPRITES_SHADOW *4
spratr_buffer_timer:
	.ds	NUM_SPRITES_TIMER *4
spratr_buffer_event:
	.ds	NUM_SPRITES_EVENT *4
spratr_buffer_countdown:
	.ds	NUM_SPRITES_COUNTDOWN *4
	.byte	; (para albergar un SPAT_END)
	SPRATR_BUFFER_LENGTH equ $ - spratr_buffer

; Auxiliares para BLIT_SPRITES
blit_sprite_src:
	.word
blit_sprite_size:
	.word
blit_sprite_timer_src:
	.word	; decenas de segundos
	.word	; unidades de segundos
	.word	; décimas

; -----------------------------------------------------------------------------
; Buffer PSG
; -----------------------------------------------------------------------------

psg_buffer:
psg_frequency_channel_a:
	.word ; 0, 1
psg_frequency_channel_b:
	.word ; 2, 3
psg_frequency_channel_c:
	.word ; 4, 5
psg_noise_period:
	.byte ; 6
psg_mixer:
	.byte ; 7
psg_volume_channel_a:
	.byte ; 8
psg_volume_channel_b:
	.byte ; 9
psg_volume_channel_c:
	.byte ; 10
psg_envelope_frequency:
	.word ; 11, 12
psg_envelope_shape:
	.byte ; 13

; -----------------------------------------------------------------------------
; Buffer de descompresión (general, y también textos, cutscenes)
; -----------------------------------------------------------------------------

; shared_ram_begin: ; (comparte RAM)

; Buffer general para descompresión
unpack_buffer:
IF CHRTBL_SIZE > SPRTBL_EVENTS_SIZE
	.ds	CHRTBL_SIZE ; CHRTBL / CLRTBL = 256*8B = 2K
ELSE
	.ds	SPRTBL_EVENTS_SIZE
ENDIF

; shared_ram_end:
	; .org	shared_ram_begin ; (comparte RAM)

; Datos descomprimidos de la música
music:
	.ds	3400 ; valor aproximado (real: max(sfx\*.pt3) - 100: 3302b)

; Datos descomprimidos de una secuencia de animación
cutscene_data:
	.ds	1700 ; valor aproximado (real: max(gfx\charset_cutscene_?.pcx.nam): 1280b)

; IF shared_ram_end > $
	; .org	shared_ram_end
; ENDIF

; -----------------------------------------------------------------------------
; Otras variables
; -----------------------------------------------------------------------------

; Rutina de interrupción previamente existente en el hook H.TIMI
old_htimi_hook:
	.ds	HOOK_SIZE

; Variables temporales (parpadeos, frame de sonido, etc.)
tmp_frame:
	.byte
tmp_byte:
	.byte

; Escritura linea a linea: puntero al primer caracter de la línea destino
printchar_de_line:
	.word

; Animaciones: puntero a la información del fotograma actual
cutscene_pointer:
	.word
; Animaciones: indicador de frames pendientes del fotograma actual
cutscene_frames:
	.byte
; Animaciones: indicador de procesado especial de frames
cutscene_special:
	.byte

; Sincronización de la música en equipos a 60Hz
replayer_frameskip:
	.byte

; Almacenan el resultado de GET_LR_STRICK y GET_TRIGGER respectivamente
stick:
	.byte
trigger:
	.byte

	.printtext	" ... vars"
	.printhex	$

; EOF
