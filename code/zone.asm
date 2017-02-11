; -----------------------------------------------------------------------------------------------
;	
;	 ¦¦¦ ¦¦¦ ¦  ¦ ¦¦¦
;	   ¦ ¦ ¦ ¦¦ ¦ ¦
;	  ¦  ¦ ¦ ¦ ¦¦ ¦¦¦ 
;	 ¦   ¦ ¦ ¦  ¦ ¦
;	 ¦¦¦ ¦¦¦ ¦  ¦ ¦¦¦
;
; 	 I'm - OpenSource 
;       ZONE - versión 2048 Bytes 
; Jos'b 2008 - José Javier Franco Benítez	
;
; Objetivo del juego - ZONE
;
;	El juego esta basado en un juego electrónico que hace algunos años anunciaban en TV,
;	y de cuyo nombre no  puedo acordarme. El  juego consiste en  resolver una serie  de 
;	puzzles, consiguiendo eliminar todas las casillas que estén iluminadas. Para  poder
;	conocer el mecanismo del juego, simplemente hay que jugar.
;
; Controles
;
;	- Cursores para mover el puntero por la pantalla
;	- Barra espaciadora para ejercer movimiento
;	- ESC para volver a pantalla inmediatamente anterior o salida al BASIC
; 
; Ensamblador utilizado
;
;	AsMSX 0.12g
;
; Lista de todas las funciones incluidas por orden alfabético
;
; 	- ARROW        	> Imprime el puntero en pantalla
; 	- ARROW_OFF	> Hace desaparecer el puntero
;	- BIT2BYTE     	> Transforma bits, 0's y 1's, a bytes, 0's y 128's
;	- CLEAR		> CLS para Screen 2
;	- LOCATE       	> Pasa coordenadas físicas X e Y a dirección VRAM en tabla de nombres
;	- MOVE_ARROW	> Gestiona las variables [x] e [Y] de posición del puntero
; 	- PUT_BLOCK    	> Coloca bloque de de 2x2 caracteres en la dirección indicada por LOCATE
;	- PUT_SPRITE   	> Coloca un sprite en pantalla con argumentos similares al BASIC
;	- PUZZLE	> Rutina principal del juego que gestiona las actualizaciones del PUZZLE
;	- READ_STICK   	> Lee estado del "STICK" del teclado o "JOYSTICK" del puerto 1
;	- READ_TRIGGER 	> Lee estado de la barra SPACE o DISPARADOR mando en puerto 1
;	- STAGE_PRINT  	> Imprime pantalla juego
;	- STATE_PUZZLE	> Comprueba estado puzzle (devuelve A=0 si ha finalizado)
;	- SOUND		> Emite sonidos por PSG
;	- TITLE		> Imprime pantalla de presentación del juego
; 	- WAIT_TRIGGER	> Espera a que se haya pulsado disparador
;
; Notas del autor al código fuente
;
;	Es evidente que el código fuente puede ser mejorado, incluso teniendo en cuenta mis
;	propias limitaciones como programador en ensamblador. Sin  embargo el espíritu  del 
;	que he pretendido dotar a este código es que refleje de forma simple la posibilidad
;	de crear un programa de manera que pueda ser entendido con facilidad por cualquiera
;	que este en sus comienzos en el mundo del Z80.
;
; 	El grueso de instrucciones que se han utilizado son básicamente las siguientes:
;	- CALL, CP, DJNZ, JP, JR, LD, POP, PUSH y RET
;
;	Y como instrucciones puntuales, estas otras:
;	- ADD, AND, BIT, DEC, INC, SBC, SLA, SRL y XOR
;
;	Por supuesto, aquel  que considere que el  código  puede ser  fácilmente  mejorado
;	manteniendo el espíritu del mismo, debería tener la obligación de comunicármelo. 
;
; Posibles fallos detectados en el ensamblador AsMSX 0.12g durante el desarrollo de este juego
;
;	- No reconoce la etiqueta DSPFNK (00CFh) de llamada a la BIOS para activar teclas función
;	- ADD IX, HL - No se envía mensaje de error
;	- Colocando la directiva "db" entre directivas "ds" la toma como otra "ds"¿?
;	- Error al colocar como dato Hex. "DBh" ¿lo interpreta como directiva la "db"?
;
; Agradecimientos
;
;	- A todo el mundo, conocidos y desconocidos.
;
; -----------------------------------------------------------------------------------------------

; -----------------------------------------------------------------------------------------------
; Prepara ensamblador
; -----------------------------------------------------------------------------------------------
	
	.BIOS				; Activa tabla de nombres oficiales para la BIOS
	.BASIC				; Fichero compatible con Basic, formato BIN
	.ORG C000h			; Dirección ensamblado

	FORCLR equ F3E9h		; Asigna etiqueta a dirección memoria
	BAKCLR equ F3EAh		; Asigna etiqueta a dirección memoria
	BDRCLR equ F3EBh		; Asigna etiqueta a dirección memoria
 
					; Para "Screen 2"
	CHPATT equ 0000h		; Tabla patrones char (0 Dec - Definiciones Char)
	CHNAME equ 1800h		; Tabla de nombres char (6144 Dec - Posiciones)
	CHCLOR equ 2000h		; Tabla de colores char (8192 Dec - Colores char)

	SPATTB equ 1B00h		; Tabla de atributos de sprites (6912 Dec - Atb. Sprites)
	SPPATT equ 3800h		; Tabla de patrones de sprites (14336 Dec - Def. Sprites)

; -----------------------------------------------------------------------------------------------
; Establece modo pantalla, color por defecto y otras configuraciones de pantalla
; -----------------------------------------------------------------------------------------------

	ld a,2				; Carga registro A con valor 2	
	ld [FORCLR],a			; Almacena en F3E9 valor 2 - Color tinta
	ld a,0				; Carga registro A con valor 0
	ld [BAKCLR],a			; Almacena en F3EA valor 0 - Color de fondo
	ld [BDRCLR],a			; Almacena en F3E9 valor 0 - Color de bordes
	call CHGCLR			; Llama BIOS para hacer COLOR 2,0,0
	
	call INIGRP			; Activa SCREEN 2 e inicializa todas las tablas
	ld c,1				; Registro 1 VDP
	ld b,11000010b			; Prepara información para activar SCREEN 2,2
	call WRTVDP			; Introduce información en VDP a través de la BIOS

; -----------------------------------------------------------------------------------------------
; Define set gráfico y de caracteres (sustituir por la función definitiva)
; -----------------------------------------------------------------------------------------------

	call 41h			; Desactiva pantalla

	ld hl,GRAF			; Dirección RAM origen (set gráfico) 
	ld de,4096			; Dirección VRAM destino (solo en el tercer banco)
	ld bc,104			; Total de valores a copiar
	call LDIRVM			; Llamada a BIOS para realizar el paso de RAM=>VRAM

	ld hl,BLOCK			; Dirección RAM origen (set gráfico) 
	ld de,91*8			; Dirección VRAM destino (primer banco)
	ld bc,64			; Total de valores a copiar
	call LDIRVM			; Llamada a BIOS para realizar el paso de RAM=>VRAM

	ld hl,BLOCK			; Dirección RAM origen (set gráfico) 
	ld de,91*8+2048			; Dirección VRAM destino (segundo banco)
	ld bc,64			; Total de valores a copiar
	call LDIRVM			; Llamada a BIOS para realizar el paso de RAM=>VRAM

	ld hl,BLOCK			; Dirección RAM origen (set gráfico) 
	ld de,91*8+4096			; Dirección VRAM destino (tercer banco)
	ld bc,64			; Total de valores a copiar
	call LDIRVM			; Llamada a BIOS para realizar el paso de RAM=>VRAM

					; COLOR
	ld hl,COLOR			; Dirección RAM origen (set gráfico) 
	ld de,CHCLOR+4096		; Dirección VRAM destino (solo en el tercer banco)
	ld bc,104			; Total de valores a copiar
	call LDIRVM			; Llamada a BIOS para realizar el paso de RAM=>VRAM

	ld hl,CBLOCK			; Dirección RAM origen (set gráfico) 
	ld de,CHCLOR+91*8		; Dirección VRAM destino (primer banco)
	ld bc,64			; Total de valores a copiar
	call LDIRVM			; Llamada a BIOS para realizar el paso de RAM=>VRAM

	ld hl,CBLOCK			; Dirección RAM origen (set gráfico) 
	ld de,CHCLOR+91*8+2048		; Dirección VRAM destino (segundo banco)
	ld bc,64			; Total de valores a copiar
	call LDIRVM			; Llamada a BIOS para realizar el paso de RAM=>VRAM

	ld hl,CBLOCK			; Dirección RAM origen (set gráfico) 
	ld de,CHCLOR+91*8+4096		; Dirección VRAM destino (tercer banco)
	ld bc,64			; Total de valores a copiar
	call LDIRVM			; Llamada a BIOS para realizar el paso de RAM=>VRAM

; ----------------------------------------------------------------------------------------------- 
; Define SPRITE para puntero flecha
; -----------------------------------------------------------------------------------------------
	ld hl,SPT			; Direeción RAM origen (SPRITE) 
	ld de, SPPATT 			; Dirección VRAM destino (tabla de patrones de Sprites)
	ld bc,64			; Total de valores a copiar 64 valores (2 Sprites)
	call LDIRVM			; Llamada a BIOS para realizar el paso de RAM=>VRAM

; -----------------------------------------------------------------------------------------------
; Presentación
; -----------------------------------------------------------------------------------------------
@@CREDITS:	
	call TITLE			; Imprime pantalla de presentación del juego
	call 44h			; Activa pantalla

	call WAIT_TRIGGER		; Espera a que pulse disparador o ESC
	cp 27				; Comprueba que se ha pulsado ESC
	jp z, @@EXIT_TO_BASIC		; Si es así retorna al BASIC

; -----------------------------------------------------------------------------------------------
; Bucle principal del juego
; -----------------------------------------------------------------------------------------------

	ld a,1				; Prepara para descomprimir información
	ld hl,GO			; Apunta a pantalla de aviso "empieza juego"
	call STAGE_PRINT		; Lanza pantalla intermedia
	
	call WAIT_TRIGGER		; Vuelve a esperar a que se pulse disparador o ESC
	cp 27				; Comprueba que se ha pulsado ESC
	jp z, @@CREDITS			; Si es así retorna a la pantalla de créditos	

	ld hl,ST01			; Apunta a pantalla inicial de juego

	ld a,10				; Número de pantallas para jugar
	ld [CONTADOR],a			; Almacena en memoria
@@MAIN:					; BUCLE PRINCIPAL DE JUEGO
	ld a,1				; Indica que queremos imprimir pantalla codificada en bit
	call STAGE_PRINT		; Imprime pantalla de juego
	push hl				; Reserva puntero a pantalla

@@GAME:					; Bucle principal para cada puzzle
	ld a,7				; Prepara para leer valor de ESC a través de SNSMAT
	call SNSMAT			; Lee estado ESC
	bit 2,a				; Comprueba que la tecla ESC ha sido pulsada
	jp z, @@RESTART 		; Si es así reinicia el puzzle

	call ARROW			; Llama a la rutina que imprime el puntero en [X] e [Y]
	call MOVE_ARROW			; Llama a la rutina que gestiona la posición del puntero
	call READ_TRIGGER		; Lee si se ha pulsado SPACE o DISPARADOR Joystick
	cp FFh	  			; Comprueba si realmente ha sido pulsado disparador
	call z, PUZZLE			; Si ha sido así actualiza puzzle
	call STATE_PUZZLE		; Comprueba "continuamente" estado puzzle (A=0 Fin)		
	cp 0				; Comprueba que no hay bloques activos (IF A=0 THEN END)

	jp nz, @@GAME			; Continua en juego si la comparación anterior es falsa

	call ARROW_OFF			; Envía fuera de la pantalla el puntero

	ld a,[CONTADOR]			; Recupera posición del contador de pantallas
	dec a				; Decrementa su valor
	jp z, @@END			; Si ya no hay más pantallas a "congratulations"
	ld [CONTADOR],a			; De lo contrario actualiza contador y siguiente puzzle

	ld a,1				; Prepara para descomprimir información
	ld hl,NEXT			; Apunta a pantalla de aviso "siguiente pantalla"
	call STAGE_PRINT		; Lanza pantalla intermedia

	pop hl				; Recupera puntero a pantalla
	ld de,24 			; Incrementa en 24 bytes la dirección de HL
	add hl,de				
					; Ojo que PUSH y POP deben estar equilibrados
	call WAIT_TRIGGER		; Esperar pulsación disparador para continuar otro puzzle
	cp 27				; Comprueba que se ha pulsado ESC
	jp z,@@CREDITS			; Si es así retorna a la pantalla de CREDITOS

	jp @@MAIN			; Al BUCLE PRINCIPAL DE JUEGO

; -----------------------------------------------------------------------------------------------
; Final del juego. Se ha conseguido superar con éxito todos los puzzles
; -----------------------------------------------------------------------------------------------
@@END:	
	pop hl				; Equilibra la pila 

	ld a,1				; Prepara para descomprimir información
	ld hl,WELL			; Apunta a pantalla de aviso "empieza juego"
	call STAGE_PRINT		; Lanza pantalla intermedia

	call WAIT_TRIGGER		; Espera a que pulse disparador o ESC
	jp @@CREDITS			; Retorna a la pantalla de CREDITOS

; -----------------------------------------------------------------------------------------------
; Actualiza la PILA para reiniciar el puzzle
; -----------------------------------------------------------------------------------------------
@@RESTART:
					; Con este pequeño algoritmo se puede reiniciar el puzzle
					; y además dar la posibilidad de retornar a la pantalla
					; de créditos.

	call ARROW_OFF			; Envía fuera de la pantalla el puntero

	ld a,1				; Prepara para descomprimir información
	ld hl,INTE			; Apunta a pantalla de aviso "?"
	call STAGE_PRINT		; Lanza pantalla intermedia

					; Importante es recuperar estado de la pila para evitar
					; el desbordamiento y dejar registro Hl tal cual
	pop hl				; Recupera puntero a pantalla, y no actualiza HL
					; Esto se hace entre las dos llamadas CALL para evitar
					; que se retorne a la pantalla de créditos con la pila
					; tocada, y para evitar que HL cambie 


	call WAIT_TRIGGER		; Esperar pulsación disparador para continuar otro puzzle
	cp 27				; Comprueba que se ha pulsado ESC
	jp z,@@CREDITS			; Si es así retorna a la pantalla de CREDITOS

	jp @@MAIN			; Salta al principio
	
; -----------------------------------------------------------------------------------------------
; Salida al BASIC
; -----------------------------------------------------------------------------------------------
@@EXIT_TO_BASIC:						
	ld a,15				; Carga registro A con valor 15	
	ld [FORCLR],a			; Almacena en F3E9 valor 15 - Color tinta
	ld a,4				; Carga registro A con valor 4
	ld [BAKCLR],a			; Almacena en F3EA valor 4 - Color de fondo
	ld [BDRCLR],a			; Almacena en F3E9 valor 4 - Color de bordes
	call CHGCLR			; Llama BIOS para hacer COLOR 15,4,4
	call 00CFh			; KEY ON a través de su referencia
	call INITXT			; Activa SCREEN 0
	ret				; Devuelve control al BASIC

; -----------------------------------------------------------------------------------------------
; ARROW
;
;	Descripción:
;		- Imprime el puntero en pantalla con borde y sombra
;
;	Entrada:
;		- Ninguna, toma los valores de las posiciones de memoria [X] e [Y]
;	
;	Salida:
;		- En pantalla
;
; 	Estado:
;		- Ok
; -----------------------------------------------------------------------------------------------
ARROW:
	push af				; Reserva valor de AF
	push bc				; Reserva valor de BC
	push de				; Reserva valor de DE

	ld a,[X]			; Lee valores de X 
	ld b,a				; Asigna a registro B para usarlo en llamada PUT_SPRITE
	ld a,[Y]			; Lee valores de Y
	ld c,a				; Asigna a registro C para usarlo en llamada PUT_SPRITE
			
	ld a,0				; plano
	ld d,1				; Nº sprite
	ld e,14				; Color
	call PUT_SPRITE			; Imprime sprite Borde del puntero

	ld a,1				; Plano
	ld d,0				; Nº sprite
	ld e,15				; Color
	call PUT_SPRITE			; Imprime sprite cuerpo del puntero

	dec b				; Reduce los valores de [X] en un par de unidades
	dec b				; para producir el efecto de sombra en el puntero
	inc c				; Aumenta los valores de [Y] en un par de unidades
	inc c				; para producir el efecto de sombra en el puntero

	ld a,2				; plano
	ld d,0				; Nº sprite
	ld e,1				; Color
	call PUT_SPRITE			; imprime sprite de color negro para hacer efecto sombra

	pop de				; Recupera valor para DE
	pop bc				; Recupera valor para Bc
	pop af				; Recupera valor para AF

	ret				; Retorna al punto de llamada

; -----------------------------------------------------------------------------------------------
; ARROW_OFF
;
;	Descripción:
;		- Hace puntero transparente, y envía a X=0 e Y=0
;
;	Entrada:
;		- Ninguna
;	
;	Salida:
;		- En pantalla
;
; 	Estado:
;		- Ok
; -----------------------------------------------------------------------------------------------
ARROW_OFF:

	push af				; Reserva valor de AF
	push bc				; Reserva valor de BC
	push de				; Reserva valor de DE

	ld e,0				; Color = Transparente
	ld b,0				; X=0
	ld c,0				; Y=0

	ld a,0				; plano
	ld d,1				; Nº sprite
	call PUT_SPRITE			; Imprime sprite Borde	del puntero

	ld a,1				; Plano
	ld d,0				; Nº sprite
	call PUT_SPRITE			; Imprime sprite Cuerpo del puntero

	ld a,2				; plano
	ld d,0				; Nº sprite
	call PUT_SPRITE			; sombra

	pop de				; Recupera valor para DE
	pop bc				; Recupera valor para Bc
	pop af				; Recupera valor para AF

	ret				; Retorno al punto de llamada

; ----------------------------------------------------------------------------------------------- 
; BIT2BYTE
;
;	Descripción:
;		- Descomprime información en Bits a Bytes
;
;	Entrada:
;		- HL = Dirección memoria que contiene los Bits
;	
;	Salida:
;		- En el BUFFER
;
;	Estado:
;	 	- Ok
; -----------------------------------------------------------------------------------------------
BIT2BYTE:
	push af				; Reserva AF	
	push bc				; reserva BC
	push hl				; Reserva HL
	push ix				; Reserva IX

	ld ix, BUFFER			; Puntero a BUFFER

	ld b,24				; Lee los 24 Bytes codificados (de 1 a 24)
@@BUC_EXT:
	push bc				; Reserva BC para bucle exterior

	ld d,[hl]			; Carga Byte Codificado en D para dejar intacta la celda
					; de memoria, durante la transformación de Bit a Byte

	ld b,8				; Lee los 8 bits de cada Byte (uno a uno)
@@BUC_INT:
	ld a,d				; Carga A con el Byte codificado	
	and 10000000b			; A=128 si bit 7 de [HL] es 1 de lo contrario A=0
	ld [ix],a			; Almacena valor del bit en el Byte apuntado por IX
	sla d				; Desplaza Byte a izquierda para analizar siguiente Bit
	inc ix				; Siguiente Byte de BUFFER 
	djnz @@BUC_INT			; Repite bucle interior 8 veces (8 bits)

	inc hl				; Siguiente Byte codificado
	pop bc				; Recupera BC para continuar con el bucle exterior
	djnz @@BUC_EXT			; Decrementa B y Termina el bucle si B=0

	pop ix				; Reserva IX
	pop hl				; Reserva HL
	pop bc				; Reserva BC
	pop af				; Reserva AF

	ret				; Devuelve control al punto de llamada

; ----------------------------------------------------------------------------------------------- 
; LOCATE
;
;	Descripción:
;		- Pasa coordenadas físicas X,Y a formato dirección VRAM en tabla de nombres
;
;	Entrada:	
;		- E = Coordenada en X 
;		- D = Coordenada en Y
;	
;	Salida:
;		- HL = Dirección VRAM
;
; 	Estado:
;		- OK
; -----------------------------------------------------------------------------------------------
LOCATE:
	push af				; Asegura valor AF
	push bc				; Asegura valor BC
	push de				; Asegura valor DE

	ld hl, CHNAME			; Apunta a tabla de nombres
	
	ld a,d				; A=D
	cp 0				; Comprueba que se solicita una línea distinta de la 1ª
	call nz, @@SUMA32		; Si es así, suma +32 posiciones VRAM por cada valor D

	ld d,0				; Borra parte alta del registro DE
	add hl, de			; Suma el valor X a la dirección VRAM contenida en HL
	
	pop de				; Restaura valor DE
	pop bc				; Restaura valor BC
	pop af				; Restaura valor AF
	ret				; Retorna al punto de llamada

@@SUMA32:
	push de				; Reserva DE para usarlo registro en el bucle
	ld b,d				; Posiciona bloque en Y
	ld de,32			; sumando +32
@@BUC:	
	add hl,de			; Posiciona HL incrementando en +32
	djnz @@BUC			; Realiza bucle hasta que ha finalizado de colocar Y
	pop de				; Recupera DE para usar el valor X

	ret				; Continua con la función LOCATE

; ----------------------------------------------------------------------------------------------- 
; MOVE_ARROW
;
;	Descripción:
;		- Gestiona el control del puntero (ARROW)
;
;	Entrada:
;		- Ninguna, toma los valores de las posiciones de memoria [X] e [Y]
;	
;	Salida:
;		- Salva los valores actualizados en [X] e [Y]
;
; 	Estado:
;		- Ok
; -----------------------------------------------------------------------------------------------
MOVE_ARROW:

	push af				; Asegura valor de AF
	push bc				; Asegura valor de BC

	ld a,[X]			; Lee valor [X]
	ld b,a				; Asigna a registro B
	ld a,[Y]			; Lee valor [Y]
	ld c,a				; Asigna a registro C

	call READ_STICK			; Lee estado de mando de juego "STICK" o "JOYSTICK"
	cp 0				; 1º Comprueba si "NADA" se ha pulsado
	jp z, @@END_MOVE		; Si es así devuelve el control a la rutina llamante

	cp 1				; Comprueba si se ha pulsado ARRIBA
	jr nz, @@CHK2			; Si no es así realiza siguiente comprobación
	dec c				; Decrementa C, que es igual que Y=Y-1		
@@CHK2:
	cp 2				; Comprueba si se ha pulsado ARRIBA-DERECHA
	jr nz, @@CHK3			; Si no así es realiza siguiente comprobación
	dec c				; Decrementa C, que es igual que Y=Y-1		
	inc b				; Incrementa B, que es igual que X=X+1		
@@CHK3:
	cp 3				; Comprueba si se ha pulsado DERECHA
	jr nz, @@CHK4			; Si no es así realiza siguiente comprobación
	inc b				; Incrementa B, que es igual que X=X+1		
@@CHK4:
	cp 4				; Comprueba si se ha pulsado DERECHA-ABAJO
	jr nz, @@CHK5			; Si no es así realiza siguiente comprobación
	inc c				; Incrementa C, que es igual que Y=Y+1
	inc b				; Incrementa B, que es igual que X=X+1
@@CHK5:
	cp 5				; Comprueba si se ha pulsado ABAJO
	jr nz, @@CHK6			; Si no es así realiza siguiente comprobación
	inc c				; Incrementa C, que es igual que Y=Y+1
@@CHK6:
	cp 6				; Comprueba si se ha pulsado IZQUIERDA-ABAJO
	jr nz, @@CHK7			; Si no es así realiza siguiente comprobación
	inc c				; Incrementa C, que es igual que Y=Y+1
	dec b				; Decrementa B, que es igual que X=X-1
@@CHK7:
	cp 7				; Comprueba si se ha pulsado IZQUIERDA
	jr nz, @@CHK8			; Si no es así realiza siguiente comprobación
	dec b 				; Decrementa B, que es igual que X=X-1
@@CHK8:
	cp 8				; Comprueba si se ha pulsado IZQUIERDA-ARRIBA
	jr nz, @@CHK_END		; Si no es así realiza siguiente comprobación
	dec c				; Decrementa c, que es igual que Y=Y-1
	dec b				; Decrementa B, que es igual que X=X-1
@@CHK_END:
	
	call @@LIMITS			; Llama a la rutina 'interna' que limita al puntero

	ld a,b				; A=B
	ld [X],a			; Actualiza valor de [X]
	ld a,c				; A=C
	ld [Y],a			; Actualiza valor de [Y]

@@END_MOVE:
	pop bc				; Recupera valor de BC
	pop af				; Recupera valor de AF

	ret				; Vuelve al punto de llamada

@@LIMITS:				; Evita que el puntero se salga de limites de pantalla	
	ld a,b				; Comprueba posición X
	cp 0				; ¿ Está en el límite izquierdo ?
	jr nz, @@CL2			; Si no es así comprueba siguiente límite
	ld b,1				; de lo contrario pone el registro en su estado anterior
@@CL2:
	cp 255				; ¿ Está en el límite derecho ?
	jr nz, @@CL3			; Si no es así comprueba siguiente límite
	ld b,254			; de lo contrario pone el registro en su estado anterior
@@CL3:
	ld a,c				; Comprueba posición Y
	cp 0				; ¿ Está en el límite superior ?
	jr nz, @@CL4			; Si no es así comprueba siguiente límite
	ld c,1				; de lo contrario pone el registro en su estado anterior
@@CL4:
	cp 191				; ¿ Está en el límite inferior ?
	ret nz				; Si no es así retorna al punto de llamada
	ld c, 190			; de lo contrario pone el registro en su estado anterior

	ret				; Finaliza comprobaciones y retorna al punto llamante

; ----------------------------------------------------------------------------------------------- 
; PUT_BLOCK
;
;	Descripción:
;		- Imprime pantalla un bloque macizo o hueco
;
;	Entrada:
;		- A = tipo de bloque ( hueco=95, macizo=91)
;		- E = Coordenada en X 
;		- D = Coordenada en Y
;	
;	Salida:
;		- En pantalla
;
; 	Estado:
;		- OK 
; -----------------------------------------------------------------------------------------------
PUT_BLOCK:
	push af				; Reserva registro AF
	push bc				; Reserva registro BC
	push hl				; Reserva registro HL
	push de				; Reserva registro DE
	
	call LOCATE			; Posiciona punto VRAM donde imprimir el bloque

					; El primer carácter a imprimir se ha pasado por reg. A
	call WRTVRM			; Imprime carácter contenido en A
	inc a				; Cambia a el siguiente carácter a imprimir 
	push hl				; Guarda dirección VRAM para usarlo después
	inc hl				; Incrementa en +1 la dirección VRAM 
	call WRTVRM			; Imprime carácter A+1
	pop hl				; Recupera dirección VRAM
	ld de,32			; Cambia de línea incrementando en +32 la direcc. VRAM
	add hl,de			; Hace la suma HL=HL+32
	inc a				; Prepara siguiente carácter a imprimir
	call WRTVRM			; Imprime A+2
	inc a				; Prepara el último carácter a imprimir 
	inc hl				; Aumenta la dirección VRAM en +1
	call WRTVRM			; Imprime caracter A+3

	pop de				; Restaura registro DE
	pop hl				; Restaura registro HL
	pop bc				; Restaura registro BC
	pop af				; Restaura registro AF

	ret				; Finaliza la rutina

; ----------------------------------------------------------------------------------------------- 
; PUT_SPRITE
;
;	Descripción:
;		- Imprime un sprite (16x16) en pantalla
;
;	Entrada:
;		- A = Plano
;		- B = Coordenada en X del sprite
;		- C = Coordenada en Y del Sprite
;		- D = Número de sprite a imprimir
;		- E = Color del sprite
;	
;	Salida:
;		- En pantalla
;
; 	Estado:
;		- Ok
; -----------------------------------------------------------------------------------------------
PUT_SPRITE:
	push af				; Reserva AF
	push bc				; Reserva BC
	push de				; Reserva DE
	push hl				; Reserva HL
	push ix				; Reserva IX

	push bc				; Reserva registro BC para poder usarlo en otras cosas

	ld c,a				; C=A					
	add a,c				; Al contenido de A se le añaden 3 veces más de A, que es
	add a,c				; lo mismo que A=A+A+A+A, con esto se calcula el OFFSET
	add a,c				; del plano dentro de la tabla de atributos de sprites

	ld b,0				; B=0
	ld c,a				; C=A equivale a LD BC,A

	ld ix,SPATTB			; Apunta a la tabla de atributos de sprites
	add ix,bc			; Desplaza posición VRAM hasta el plano elegido en A
	push ix				; Empuja IX para pasar valor a HL, es igual a LD IX,BC
	pop hl				; HL contiene la posición VRAM en la tabla de atributos

	xor a				; A=0
	add a,d				; Al contenido de A se le añaden 4 veces más de D, que es
	add a,d				; lo mismo que A=4*D. Con esto se consigue acceder al  
	add a,d				; sprite numero D definido en tabla de patrones sprites
	add a,d				; Para el caso de sprites de 8x8 sobrarían estas líneas
	ld d,a				; Se actualiza el valor correcto para D en sprites de 16

	pop bc				; Recupera valores de posición X e Y del sprite

	ld a,c				; Posiciona sprite en Y
	call WRTVRM			; VPOKE HL,C
	inc hl				; Siguiente posición de la tabla de atributos
	ld a,b				; Posiciona sprite en X
	call WRTVRM			; VPOKE HL,B
	inc hl				; Siguiente posición de la tabla de atributos
	ld a,d				; Número de sprite a imprimir
	call WRTVRM			; VPOKE HL,D
	inc hl				; Siguiente posición de la tabla de atributos
	ld a,e				; Color del sprite		
	call WRTVRM			; VPOKE HL,E

	pop ix				; Restaura valor para IX
	pop hl				; Restaura valor para HL
	pop de				; Restaura valor para DE
	pop bc				; Restaura valor para BC
	pop af				; Restaura valor para AF
	
	ret				; Al punto de llamada

; -----------------------------------------------------------------------------------------------
; PUZZLE
;
;	Descripción:
;		- Gestiona el estado del puzzle cada vez que se pulsa el disparador
;
;	Entrada:
;		- Ninguna, toma los valores de las posiciones de memoria [X] e [Y]
;	
;	Salida:
;		- En pantalla y en el BUFFER dónde se encuentra la información del puzzle
;
; 	Estado:
;		- Ok
; -----------------------------------------------------------------------------------------------
PUZZLE:
	push af				; Reserva AF
	push bc				; Reserva BC
	push de				; Reserva DE
	push hl				; Reserva HL

					; A esta rutina se ha entrado cuando se ha pulsado
					; el disparador, pero no se activa hasta que el TRIGGER 
					; no se suelte. Esa es la función de este bucle inicial.
@@OFF:					
	call READ_TRIGGER		; Lee estado de la barra SPACE o DISPARADOR MANDO 1
	cp 00h				; Comprueba que se ha soltado alguno de los dos
	jr nz, @@OFF 			; Si no es así espera a que se deje de pulsar TRIGGER

	ld a,[X]			; Lee coordenada X de posición del puntero
	ld e,a				; y le asigna valor al registro D
	ld a,[Y]			; Lee coordenada Y de posición del puntero
	ld d,a				; y le asigna valor al registro E

					; Localiza en qué bloque está el puntero

					; D=D/16 Coordenada [X]
	srl e				; Divide por 2
	srl e				; Divide por 2 (total divide por 4)
	srl e				; Divide por 2 (total divide por 8)
	srl e				; Divide por 2 (total divide por 16)
	
					; E=E/16 Coordenada [Y]
	srl d				; Divide por 2
	srl d				; Divide por 2 (total divide por 4)
	srl d				; Divide por 2 (total divide por 8)
	srl d				; Divide por 2 (total divide por 16)

	ld a,e				; Almacena nueva coordenada X referida a bloques
	ld [XB],a			; Introduce en memoria coordenada XB
	ld a,d				; Almacena nueva coordenada Y referida a bloques
	ld [YB],a			; Introduce en memoria coordenada YB

					; Busca posición RAM en BUFFER correspondiente al bloque
					; Este trozo de código es igual al de la función LOCATE
					; Solo cambia destino memoria y tamaño matriz
					 
	ld hl, BUFFER			; Apunta a BUFFER donde se encuentra info pantalla
					; El tamaño de la pantalla es de 16x12 bloques
	
	ld a,d				; A=D
	cp 0				; Comprueba que se solicita una línea distinta de la 1ª
	call nz, @@SUMA16		; Si es así, suma +16 posiciones BUFFER por cada valor D

	ld d,0				; Borra parte alta del registro DE
	add hl, de			; Suma el valor X a la dirección BUFFER contenida en HL
					; HL contiene posición RAM dónde se encuentra el puntero			
					
					; A continuación se modifican los bloques necesarios

					; BLOQUE SUPERIOR
	ld de,16			; Prepara para posicionar dirección HL en bloque superior
	sbc hl,de			; Coloca HL en bloque superior
	ld a,[YB]			; A=Coordenada YB
	cp 0				; Comp. que coordenada [YB-1] no supera limite superior
	jr z, @@BLOCK_LEFT		; Si supera límite pasa del bloque e imprime siguiente
	call @@INVERT			; De lo contrario invierte valor bloque

@@BLOCK_LEFT:				; BLOQUE IZQUIERDO
	ld de,15			; Prepara para posicionar direcc. Hl en bloque izquierdo
	add hl,de			; Coloca HL en bloque izquierdo	
	ld a,[XB]			; A=Coordenada XB
	cp 0				; Comp. que coordenada [XB-1] no supera límite izquierdo
	jr z, @@BLOCK_ARROW		; Si supera límite pasa del bloque e imprime siguiente
	call @@INVERT			; De lo contrario invierte valor bloque

@@BLOCK_ARROW:				; BLOQUE DEL PUNTERO				
	inc hl				; Este bloque siempre está en pantalla
	call @@INVERT			; Llama a rutina para invertir valor

					; BLOQUE DERECHO
	inc hl				; Posiciona HL en el bloque derecho
	ld a,[XB]			; A=Coordenada XB
	cp 15				; Comp. que coordenada [XB+1] no supera límite Derecho
	jr z, @@BLOCK_DOWN		; Si supera límite pasa del bloque e imprime siguiente
	call @@INVERT			; De lo contrario invierte valor bloque

@@BLOCK_DOWN:				; BLOQUE INFERIOR
	ld de,15			; Prepara para posicionar HL en bloque inferior
	add hl,de			; Coloca HL en bloque inferior
	ld a, [YB]			; A=Coordenada YB
	cp 11				; Comp. que coordenada [YB+1] no supera límite inferior
	jr z, @@PUZZLE_END		; Si supera límite pasa del bloque y finaliza rutina
	call @@INVERT			; De lo contrario invierte valor bloque

@@PUZZLE_END:
	ld a,0				; Indica que se imprima pantalla directamente de BUFFER
	call STAGE_PRINT		; Actualiza pantalla

	call SOUND			; Emite sonido

	pop hl				; Recupera HL
	pop de				; Recupera DE
	pop bc				; Recupera BC
	pop af				; Recupera AF

	ret				; Al punto de llamada

@@INVERT:				; HL debe contener el OFFSET en el BUFFER
	ld a,[hl]			; De lo contrario lee el valor de esa posición
	xor 10000000b			; Invierte su contenido	
	ld [hl],a			; Y lo vuelve a almacenar en el mismo lugar RAM
	ret				; Al punto de llamada

@@SUMA16:
	push de				; Reserva DE para usarlo registro en el bucle
	ld b,d				; Posiciona bloque en Y
	ld de,16			; sumando +16
@@BUC:	
	add hl,de			; Posiciona HL incrementando en +16
	djnz @@BUC			; Realiza bucle hasta que ha finalizado de colocar Y
	pop de				; Recupera DE para usar el valor X

	ret				; Al punto de llamada

; ----------------------------------------------------------------------------------------------- 
; READ_STICK
;
;	Descripción:
;		- Lee el estado del "STICK" del teclado O "JOYSTICK" en puerto 1
;
;	Entrada:
;		- Ninguna.
;	
;	Salida:
;		- A= de 0 a 7, igual que la función "A= STICK(0) OR STICK(1)" del BASIC
;
; 	Estado:
;		- Ok
; -----------------------------------------------------------------------------------------------
READ_STICK:

	ld a,0				; Prepara para leer STICK del teclado
	call GTSTCK			; Lee valor del STICK 
	cp 0				; Comprueba si se ha pulsado algún cursor del teclado
	ret nz				; Si es así retorna y devuelve en A el valor asignado
	ld a,1				; De lo contrario prepara para leer JOYSTICK en puerto 1
	call GTSTCK			; Lee valor del JOYSTICK 

	ret				; Devuelve valor A<>0 si se ha pulsado algo, o A=0	

; ----------------------------------------------------------------------------------------------- 
; READ_TRIGGER
;
;	Descripción:
;		- Lee estado del disparador "SPACE" o "TRIGGER 1"
;
;	Entrada:	
;		- Ninguna
;	
;	Salida:
;		- A = 0 o -1(FFh) según este el disparador "sin pulsar" o "pulsado"
;
; 	Estado:
;		- Ok
; -----------------------------------------------------------------------------------------------
READ_TRIGGER:

	ld a,0				; Prepara para leer SPACE
	call GTTRIG			; Lee estado de la barra SPACE
	cp FFh				; Comprueba que ha sido pulsada
	ret z				; Si es así retorna y devuelve en A=FFh
	ld a,1				; Prepara para leer TRIGGER en puerto 1
	call GTTRIG			; Lee estado TRIGGER

	ret				; Retorna con valor en A=0 o A=FFh

; ----------------------------------------------------------------------------------------------- 
; STAGE_PRINT 
;
;	Descripción:
;		- Imprime pantalla de juego codificada en bits
;
;	Entrada:
;		- A  = 1, Indica si hay que descomprimir información "pantalla inicial" en BUFFER
;		- HL = Dirección memoria que contiene la "pantalla inicial" de juego, solo tiene
;		       utilidad cuando se quiere descomprimir la pantalla inicial de cada puzzle
;	
;	Salida:
;		- En pantalla
;
; 	Estado:
;		- Ok (se mantiene @@AUX_1 Y @@AUX_2 por legibilidad del código)
; -----------------------------------------------------------------------------------------------
STAGE_PRINT:	
	push af				; Reserva valor AF
	push bc				; Reserva valor BC
	push hl				; Reserva valor HL
	push de				; Reserva valor DE
	
	cp 1				; Comprueba que se quiere descomprimir pantalla
	call z, BIT2BYTE		; Descomprime la información codificada en bit en BUFFER

	ld ix,BUFFER			; Almacena en IX la dirección de memoria del BUFFER
	ld e,0				; Prepara para imprimir en coordenada X
	ld d,0				; Prepara para imprimir en coordenada Y
	
	ld b,192			; Número de ciclos a realizar por el bucle
@@BUC:	
	ld a,[ix]			; A = Contenido del BUFFER 
	cp 0				; Compara con el valor cero	
	push af				; Almacena estado del registro de banderas FLAG
	call nz, @@AUX_1		; Si la comparación anterior es <>0 imprime bloque macizo
	pop af				; Rescata el estado del registro de banderas FLAG
	call z,  @@AUX_2		; Si la comparación anterior es =0 imprime bloque hueco

	inc e				; Avanza para imprimir el siguiente bloque
	inc e				; en dos unidades por ser titles de 2x2 caracteres
	ld a,e				; Hace A=E para comprobar si ha llegado a final de fila
	cp 32				; Testea para ver si ha llegado al final de la línea
	call Z,  @@AUX_3		; Cambia línea en caso de que el test anterior sea verdad

	inc ix				; Incrementa la posición del BUFFER
	djnz @@BUC			; Final del bucle

	pop de				; Restaura valor DE
	pop hl				; Restaura valor HL
	pop bc				; Restaura valor BC
	pop af				; Restaura valor AF
	ret				; Finaliza la función y retorna al punto de llamada

@@AUX_1:
	ld a,91				; Prepara para imprimir bloque macizo
	call PUT_BLOCK			; Llama a rutina para imprimir bloque
	ret				; Devuelve control a función principal

@@AUX_2:
	ld a, 95			; Prepara para imprimir bloque hueco
	call PUT_BLOCK			; Llama a rutina para imprimir bloque
	ret				; Devuelve control a función principal

@@AUX_3:	
	inc d				; Avanza una línea de bloques
	inc d				; por lo que avanza en Y dos posiciones
	ld e,0				; Coloca coordenada X al principio de la línea
	ret				; Retorna al punto de llamada

; -----------------------------------------------------------------------------------------------
; STATE_PUZZLE
;
;	Descripción:
;		- Cuenta cuantos bloques quedan para terminar el puzzle
;
;	Entrada:
;		- Ninguna
;	
;	Salida:
;		- A= Número de bloques que quedan para terminar, si A=0 puzzle realizado
;
; 	Estado:
;		- Ok
; -----------------------------------------------------------------------------------------------
STATE_PUZZLE:
	push bc				; Reserva BC
	push hl				; Reserva HL	

	ld a, 0				; Inicializa el contador "A" a cero
	ld hl,BUFFER			; Apunta al BUFFER
	ld b,192			; Número total de bloques
@@BUC:
	ld c,[HL]			; Carga valor (0=Sin bloque, 128=Con bloque)
	srl c				; Lleva valor del "7º" bit a bit "6º" = dividir por 2
	srl c				; Lleva valor del "6º" bit a bit "5º" = dividir por 4
	srl c				; Lleva valor del "5º" bit a bit "4º" = dividir por 8
	srl c				; Lleva valor del "4º" bit a bit "3º" = dividir por 16
	srl c				; Lleva valor del "3º" bit a bit "2º" = dividir por 32
	srl c				; Lleva valor del "2º" bit a bit "1º" = dividir por 64
	srl c				; Lleva valor del "1º" bit a bit "0º" = dividir por 128
	add a, c			; A=A+C, siendo C=0 o C=1
	inc hl				; Aumenta posición BUFFER
	djnz @@BUC			; Repite operación para todas las posiciones del BUFFER

	pop hl				; Recupera valor HL
	pop bc				; Recupera valor BC

	ret				; Al punto de llamada y A contiene bloques aún activos

; ----------------------------------------------------------------------------------------------- 
; SOUND
;
;	Descripción:
;		- Efectos de sonido
;
;	Entrada:
;		- Ninguna
;	
;	Salida:
;		- PSG
;
; 	Estado:
;		- Ok
; -----------------------------------------------------------------------------------------------
SOUND:

	push af				; Reserva Registro AF
	push bc				; Reserva Registro BC
	push de				; Reserva Registro DE
	push ix				; Reserva Registro IX

	ld ix,SND			; Apunta a sonido
	ld b,[ix]			; Cantidad de datos a enviar, y número de bucles
@@BUCLE:
	ld a,[ix+1] 			; Registro PSG
	ld e,[ix+2]			; Dato 
	call WRTPSG			; Envía información al PSG a través de la BIOS
	inc ix				; Incrementa para leer siguiente dato
	inc ix				; en dos unidades ya que se leen de dos en dos
	djnz @@BUCLE			; Siguiente dato

	pop ix				; Recupera registro IX
	pop de				; Recupera registro DE
	pop bc				; Recupera registro BC
	pop af				; Recupera registro AF

	ret				; Al punto de Llamada

; ----------------------------------------------------------------------------------------------- 
; TITLE
;
;	Descripción:
;		- Imprime pantalla de presentación del juego
;
;	Entrada:
;		- Toma todos los datos necesarios de memoria
;	
;	Salida:
;		- En pantalla
;
;	Estado:
;		- Ok
; -----------------------------------------------------------------------------------------------
TITLE:
	push af				; Asegura valor AF
	push bc				; Asegura valor BC
	push de				; Asegura valor DE
	push hl				; Asegura valor HL

	ld a,1				; Indica que queremos imprimir pantalla codificada en bit
	ld hl,ST00			; Apunta a pantalla inicial de juego
	call STAGE_PRINT		; Imprime pantalla

	ld hl,INFO			; Dirección RAM origen (set grafico) 
	ld de,CHNAME+704		; Dirección VRAM destino (solo en el tercer banco)
	ld bc,64			; Total de valores a copiar
	call LDIRVM			; Llamada a BIOS para realizar el paso de RAM=>VRAM

	pop hl				; Recupera valor HL
	pop de				; Recupera valor DE
	pop bc				; Recupera valor BC
	pop af				; Recupera valor AF

	ret				; Al punto de llamada

; -----------------------------------------------------------------------------------------------
; WAIT_TRIGGER
;
;	Descripción:
;		- Espera a que se haya pulsado disparador
;
;	Entrada:
;		- Ninguna
;	
;	Salida:
;		- A = 27 (Si se ha pulsado ESC) de lo contrario envía A=0
;
; 	Estado:
;		- Ok
; -----------------------------------------------------------------------------------------------
WAIT_TRIGGER:

@@BUC1:
	ld a,7				; Prepara para leer valor de ESC a través de SNSMAT
	call SNSMAT			; Lee estado ESC
	bit 2,a	 		   	; Comprueba que la tecla ESC ha sido pulsada
	jp z, @@ESC			; Si es así devuelve valor A=?????1??
	call READ_TRIGGER		; Lee estado de la barra SPACE o DISPARADOR MANDO 1
	cp FFh				; Comprueba que se ha pulsado alguno de los dos
	jr nz, @@BUC1			; Si no es así retorna al bucle de presentación

@@BUC2:
	call READ_TRIGGER		; Lee estado de la barra SPACE o DISPARADOR MANDO 1
	cp 00h				; Comprueba que se ha soltado alguno de los dos
	jr nz, @@BUC2 			; Si no es así espera a que se deje de pulsar TRIGGER
	xor a				; Evita enviar cualquier valor si se ha pulsado TRIGGER
	ret				; Al punto de llamada

@@ESC:
	ld a, 27			; Envía A=27 para indicar que se ha pulsado ESC
	ret				; Al punto de llamada

; ----------------------------------------------------------------------------------------------- 
; Información fija en RAM 
; -----------------------------------------------------------------------------------------------

	; Definición de los gráficos desde el carácter 0 hasta el 10
GRAF:	db 7Ch,FEh,8Eh,8Eh,8Eh,CEh,7Ch,00h,04h,06h,06h,06h,06h,06h,04h,00h
        db 7Ch,FEh,06h,7Ch,C0h,FEh,7Ch,00h,7Ch,8Eh,CEh,FEh,8Eh,CEh,7Ch,00h
        db E3h,E6h,0Ch,18h,30h,67h,C7h,00h,3Ch,42h,99h,85h,85h,99h,42h,3Ch
        db 0Eh,0Eh,0Eh,0Eh,CEh,FEh,FEh,00h,00h,00h,FBh,9Ah,9Bh,98h,FBh,00h
        db 36h,16h,D7h,06h,C6h,46h,C7h,00h,00h,00h,E0h,60h,60h,60h,E0h,00h
        db 7Ch,C6h,C6h,FEh,C6h,C6h,44h,00h,7Ch,FEh,C0h,7Ch,06h,FEh,7Ch,00h
        db 44h,EEh,FEh,D6h,C6h,C6h,44h,00h

COLOR:	db B1h,E1h,E1h,F1h,E1h,E1h,B1h,B1h,B1h,E1h,E1h,F1h,E1h,E1h,B1h,B1h
        db B1h,E1h,E1h,F1h,E1h,E1h,B1h,B1h,B1h,E1h,E1h,F1h,E1h,E1h,B1h,B1h
        db C1h,21h,31h,31h,31h,21h,C1h,C1h,61h,81h,81h,91h,91h,81h,81h,61h
        db 41h,51h,51h,71h,51h,51h,41h,41h,41h,51h,51h,71h,51h,51h,41h,41h
        db 41h,51h,51h,71h,51h,51h,41h,41h,41h,51h,51h,71h,51h,51h,41h,41h
        db C1h,21h,21h,31h,21h,21h,C1h,C1h,C1h,21h,21h,31h,21h,21h,C1h,C1h
        db C1h,21h,21h,31h,21h,21h,C1h,C1h

	; Definición del tipo de bloque relleno 
BLOCK:	db 7Fh,80h,9Fh,BFh,BFh,BFh,BFh,BFh,FCh,02h,F2h,FAh,FAh,FAh,FAh,FAh
	db BFh,BFh,BFh,BFh,9Fh,80h,7Fh,00h,FAh,FAh,FAh,FAh,F2h,02h,FCh,00h
	; Definición del tipo de bloque hueco
 	db 7Fh,80h,9Fh,BFh,BFh,BFh,BFh,BFh,FCh,02h,F2h,FAh,FAh,FAh,FAh,FAh
	db BFh,BFh,BFh,BFh,9Fh,80h,7Fh,00h,FAh,FAh,FAh,FAh,F2h,02h,FCh,00h

	; Color bloque relleno	
CBLOCK:	db 20h,20h,30h,30h,20h,20h,20h,20h,20h,20h,30h,30h,20h,20h,20h,20h
	db 20h,20h,30h,30h,20h,20h,20h,20h,20h,20h,30h,30h,20h,20h,20h,20h
	; Color bloque hueco
	db 14h,14h,14h,14h,14h,14h,14h,14h,14h,14h,14h,14h,14h,14h,14h,14h
	db 14h,14h,14h,14h,14h,14h,14h,14h,14h,14h,14h,14h,14h,14h,14h,14h

	; Definición de SPRITES de 16x16 - Cuerpo del puntero y sombra
SPT:	db 80h,C0h,E0h,F0h,F8h,FCh,FEh,FFh,FFh,FFh,FFh,FFh,FEh,F8h,E2h,87h
	db 00h,00h,00h,00h,00h,00h,00h,00h,80h,C0h,E0h,80h,00h,00h,00h,00h

	; Definición de SPRITES de 16x16 - Borde del puntero
	db 80h,C0h,E0h,B0h,98h,8Ch,86h,83h,81h,80h,80h,83h,8Eh,B8h,E0h,80h
	db 00h,00h,00h,00h,00h,00h,00h,00h,80h,C0h,E0h,80h,00h,00h,00h,00h

	; Pantallas codificadas en bits 16X12 titles
GO:	db 00h,00h,00h,00h,00h,00h,1Eh,08h,10h,E8h,16h,A8h	; GO!
	db 12h,A0h,1Eh,E8h,00h,00h,00h,00h,00h,00h,00h,00h

NEXT:	db 00h,00h,00h,00h,00h,00h,97h,57h,D4h,52h,B6h,22h	; NEXT
	db 94h,52h,97h,52h,00h,00h,00h,00h,00h,00h,00h,00h

INTE:	db 00h,00h,03h,C0h,07h,E0h,06h,60h,00h,60h,00h,C0h	; ?
	db 01h,80h,01h,80h,00h,00h,01h,80h,01h,80h,00h,00h

WELL:	db 00h,00h,00h,00h,00h,00h,8Bh,D2h,8Ah,12h,ABh,12h	; WELL
	db DAh,12h,8Bh,$DB,00h,00h,00h,00h,00h,00h,00h,00h		

ST00:	db 00h,00h,00h,00h,00h,00h,EEh,97h,2Ah,D4h,4Ah,B7h	; Stage 0 - Presentación
	db 8Ah,94h,EEh,97h,00h,00h,00h,00h,00h,00h,00h,00h

ST01: 	db 00h,00h,10h,00h,10h,00h,6Ch,00h,10h,00h,10h,00h	; Stage 1 - 4 Movimientos
	db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h	; Muy Fácil - Star

ST02:	db 00h,00h,00h,00h,00h,00h,22h,00h,6Bh,00h,00h,00h	; Stage 2 - 6 Movimientos
	db 00h,00h,08h,00h,00h,00h,00h,00h,00h,00h,00h,00h	; Muy Fácil - Umbrella

ST03:	db 00h,00h,00h,00h,01h,80h,00h,00h,02h,40h,08h,10h	; Stage 3 - 12 Movimientos
	db 08h,10h,02h,40h,00h,00h,01h,80h,00h,00h,00h,00h	; Fácil-Medio - Circle

ST04:	db 00h,00h,02h,40h,02h,40h,04h,20h,1Ah,58h,00h,00h	; Stage 4 - 24 Movimientos
	db 00h,00h,1Ah,58h,04h,20h,02h,40h,02h,40h,00h,00h	; Medio - Cross

ST05:	db 19h,80h,29h,40h,86h,10h,10h,84h,00h,21h,10h,08h	; Stage 5 - 44 Movimientos
	db 84h,00h,21h,08h,08h,61h,02h,94h,02h,94h,04h,62h	; Medio - Double Wave

ST06: 	db 00h,04h,00h,00h,00h,00h,00h,04h,00h,09h,00h,24h	; Stage 6 - 18 Movimientos 
	db 00h,24h,00h,09h,00h,04h,00h,00h,00h,00h,00h,04h	; Medio - Tissue

ST07:	db 00h,00h,00h,00h,00h,A0h,01h,1Ch,01h,22h,01h,00h	; Stage 7 - 22 Movimientos
	db 02h,8Ah,00h,04h,02h,24h,01h,C4h,00h,28h,00h,00h	; Medio - Rose

ST08:	db 00h,08h,03h,00h,07h,00h,07h,12h,00h,55h,00h,82h	; Stage 8 - 36 Movimientos
	db 00h,00h,01h,93h,00h,00h,00h,82h,00h,54h,04h,11h	; Dificil - Quarter to Twelve	

ST09:	db 55h,55h,D1h,55h,6Fh,55h,40h,00h,00h,00h,42h,40h	; Stage 9 - ??
	db 44h,20h,80h,00h,90h,20h,01h,C0h,06h,00h,98h,00h	; Extra - Not enough

ST0A:	db 00h,00h,00h,00h,06h,20h,08h,40h,04h,28h,00h,10h	; Stage A - ??
	db 00h,00h,00h,40h,10h,40h,04h,40h,05h,10h,04h,00h	; Extra - Terror

	; Información pantalla
INFO:	db 20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h
	db 20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h
	db 20h,01h,00h,00h,04h,20h,0Ah,0Bh,0Ch,20h,20h,20h,20h,20h,20h,20h
	db 20h,20h,20h,20h,20h,06h,07h,08h,09h,05h,20h,02h,00h,00h,03h,20h

					; Formato "Registro_PSG, Información"
SND:	db 6				; Cantidad de información que hay que enviar al PSG
	db 0,172			; Ajuste fino canal A				
	db 1,7				; Ajuste grueso canal A			
	db 8,16				; Volumen canal A máximo con activación curva Envolvente
	db 11,16			; f(Hz)=3.5*10^6/(R11*256+R12)	Valor de R11
	db 12,16			; 				Valor de R12
	db 13,0				; Forma de ONDA elegida (0,4,8,10,11,12,13,14)

; ----------------------------------------------------------------------------------------------- 
; Información variable y buffer en RAM
; -----------------------------------------------------------------------------------------------
BUFFER:		ds 192				; BUFFER, para almacenar pantallas en BYTES
XB:		ds 1				; Bloque horizontal donde está el puntero 
YB:		ds 1				; Bloque vertical donde está el puntero
X: 		db 120				; Coordenada X del puntero "ARROW"
Y:		db 88				; Coordenada Y del puntero "ARROW"
CONTADOR:	db 1				; Reserva memoria para contador principal
