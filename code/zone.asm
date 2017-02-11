; -----------------------------------------------------------------------------------------------
;
;	 ��� ��� �  � ���
;	   � � � �� � �
;	  �  � � � �� ���
;	 �   � � �  � �
;	 ��� ��� �  � ���
;
; 	 I'm - OpenSource
;       ZONE - versi�n 2048 Bytes
; Jos'b 2008 - Jos� Javier Franco Ben�tez
;
; Objetivo del juego - ZONE
;
;	El juego esta basado en un juego electr�nico que hace algunos a�os anunciaban en TV,
;	y de cuyo nombre no  puedo acordarme. El  juego consiste en  resolver una serie  de
;	puzzles, consiguiendo eliminar todas las casillas que est�n iluminadas. Para  poder
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
; Lista de todas las funciones incluidas por orden alfab�tico
;
; 	- ARROW        	> Imprime el puntero en pantalla
; 	- ARROW_OFF	> Hace desaparecer el puntero
;	- BIT2BYTE     	> Transforma bits, 0's y 1's, a bytes, 0's y 128's
;	- CLEAR		> CLS para Screen 2
;	- LOCATE       	> Pasa coordenadas f�sicas X e Y a direcci�n VRAM en tabla de nombres
;	- MOVE_ARROW	> Gestiona las variables [x] e [Y] de posici�n del puntero
; 	- PUT_BLOCK    	> Coloca bloque de de 2x2 caracteres en la direcci�n indicada por LOCATE
;	- PUT_SPRITE   	> Coloca un sprite en pantalla con argumentos similares al BASIC
;	- PUZZLE	> Rutina principal del juego que gestiona las actualizaciones del PUZZLE
;	- READ_STICK   	> Lee estado del "STICK" del teclado o "JOYSTICK" del puerto 1
;	- READ_TRIGGER 	> Lee estado de la barra SPACE o DISPARADOR mando en puerto 1
;	- STAGE_PRINT  	> Imprime pantalla juego
;	- STATE_PUZZLE	> Comprueba estado puzzle (devuelve A=0 si ha finalizado)
;	- SOUND		> Emite sonidos por PSG
;	- TITLE		> Imprime pantalla de presentaci�n del juego
; 	- WAIT_TRIGGER	> Espera a que se haya pulsado disparador
;
; Notas del autor al c�digo fuente
;
;	Es evidente que el c�digo fuente puede ser mejorado, incluso teniendo en cuenta mis
;	propias limitaciones como programador en ensamblador. Sin  embargo el esp�ritu  del
;	que he pretendido dotar a este c�digo es que refleje de forma simple la posibilidad
;	de crear un programa de manera que pueda ser entendido con facilidad por cualquiera
;	que este en sus comienzos en el mundo del Z80.
;
; 	El grueso de instrucciones que se han utilizado son b�sicamente las siguientes:
;	- CALL, CP, DJNZ, JP, JR, LD, POP, PUSH y RET
;
;	Y como instrucciones puntuales, estas otras:
;	- ADD, AND, BIT, DEC, INC, SBC, SLA, SRL y XOR
;
;	Por supuesto, aquel  que considere que el  c�digo  puede ser  f�cilmente  mejorado
;	manteniendo el esp�ritu del mismo, deber�a tener la obligaci�n de comunic�rmelo.
;
; Posibles fallos detectados en el ensamblador AsMSX 0.12g durante el desarrollo de este juego
;
;	- No reconoce la etiqueta DSPFNK (00CFh) de llamada a la BIOS para activar teclas funci�n
;	- ADD IX, HL - No se env�a mensaje de error
;	- Colocando la directiva "db" entre directivas "ds" la toma como otra "ds"�?
;	- Error al colocar como dato Hex. "DBh" �lo interpreta como directiva la "db"?
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
	.ORG 0xC000			; Direcci�n ensamblado

	FORCLR equ 0xF3E9		; Asigna etiqueta a direcci�n memoria
	BAKCLR equ 0xF3EA		; Asigna etiqueta a direcci�n memoria
	BDRCLR equ 0xF3EB		; Asigna etiqueta a direcci�n memoria

					; Para "Screen 2"
	CHPATT equ 0x0000		; Tabla patrones char (0 Dec - Definiciones Char)
	CHNAME equ 0x1800		; Tabla de nombres char (6144 Dec - Posiciones)
	CHCLOR equ 0x2000		; Tabla de colores char (8192 Dec - Colores char)

	SPATTB equ 0x1B00		; Tabla de atributos de sprites (6912 Dec - Atb. Sprites)
	SPPATT equ 0x3800		; Tabla de patrones de sprites (14336 Dec - Def. Sprites)

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
	ld b,11000010b			; Prepara informaci�n para activar SCREEN 2,2
	call WRTVDP			; Introduce informaci�n en VDP a trav�s de la BIOS

; -----------------------------------------------------------------------------------------------
; Define set gr�fico y de caracteres (sustituir por la funci�n definitiva)
; -----------------------------------------------------------------------------------------------

	call 41h			; Desactiva pantalla

	ld hl,GRAF			; Direcci�n RAM origen (set gr�fico)
	ld de,4096			; Direcci�n VRAM destino (solo en el tercer banco)
	ld bc,104			; Total de valores a copiar
	call LDIRVM			; Llamada a BIOS para realizar el paso de RAM=>VRAM

	ld hl,BLOCK			; Direcci�n RAM origen (set gr�fico)
	ld de,91*8			; Direcci�n VRAM destino (primer banco)
	ld bc,64			; Total de valores a copiar
	call LDIRVM			; Llamada a BIOS para realizar el paso de RAM=>VRAM

	ld hl,BLOCK			; Direcci�n RAM origen (set gr�fico)
	ld de,91*8+2048			; Direcci�n VRAM destino (segundo banco)
	ld bc,64			; Total de valores a copiar
	call LDIRVM			; Llamada a BIOS para realizar el paso de RAM=>VRAM

	ld hl,BLOCK			; Direcci�n RAM origen (set gr�fico)
	ld de,91*8+4096			; Direcci�n VRAM destino (tercer banco)
	ld bc,64			; Total de valores a copiar
	call LDIRVM			; Llamada a BIOS para realizar el paso de RAM=>VRAM

					; COLOR
	ld hl,COLOR			; Direcci�n RAM origen (set gr�fico)
	ld de,CHCLOR+4096		; Direcci�n VRAM destino (solo en el tercer banco)
	ld bc,104			; Total de valores a copiar
	call LDIRVM			; Llamada a BIOS para realizar el paso de RAM=>VRAM

	ld hl,CBLOCK			; Direcci�n RAM origen (set gr�fico)
	ld de,CHCLOR+91*8		; Direcci�n VRAM destino (primer banco)
	ld bc,64			; Total de valores a copiar
	call LDIRVM			; Llamada a BIOS para realizar el paso de RAM=>VRAM

	ld hl,CBLOCK			; Direcci�n RAM origen (set gr�fico)
	ld de,CHCLOR+91*8+2048		; Direcci�n VRAM destino (segundo banco)
	ld bc,64			; Total de valores a copiar
	call LDIRVM			; Llamada a BIOS para realizar el paso de RAM=>VRAM

	ld hl,CBLOCK			; Direcci�n RAM origen (set gr�fico)
	ld de,CHCLOR+91*8+4096		; Direcci�n VRAM destino (tercer banco)
	ld bc,64			; Total de valores a copiar
	call LDIRVM			; Llamada a BIOS para realizar el paso de RAM=>VRAM

; -----------------------------------------------------------------------------------------------
; Define SPRITE para puntero flecha
; -----------------------------------------------------------------------------------------------
	ld hl,SPT			; Direeci�n RAM origen (SPRITE)
	ld de, SPPATT 			; Direcci�n VRAM destino (tabla de patrones de Sprites)
	ld bc,64			; Total de valores a copiar 64 valores (2 Sprites)
	call LDIRVM			; Llamada a BIOS para realizar el paso de RAM=>VRAM

; -----------------------------------------------------------------------------------------------
; Presentaci�n
; -----------------------------------------------------------------------------------------------
@@CREDITS:
	call TITLE			; Imprime pantalla de presentaci�n del juego
	call 44h			; Activa pantalla

	call WAIT_TRIGGER		; Espera a que pulse disparador o ESC
	cp 27				; Comprueba que se ha pulsado ESC
	jp z, @@EXIT_TO_BASIC		; Si es as� retorna al BASIC

; -----------------------------------------------------------------------------------------------
; Bucle principal del juego
; -----------------------------------------------------------------------------------------------

	ld a,1				; Prepara para descomprimir informaci�n
	ld hl,GO			; Apunta a pantalla de aviso "empieza juego"
	call STAGE_PRINT		; Lanza pantalla intermedia

	call WAIT_TRIGGER		; Vuelve a esperar a que se pulse disparador o ESC
	cp 27				; Comprueba que se ha pulsado ESC
	jp z, @@CREDITS			; Si es as� retorna a la pantalla de cr�ditos

	ld hl,ST01			; Apunta a pantalla inicial de juego

	ld a,10				; N�mero de pantallas para jugar
	ld [CONTADOR],a			; Almacena en memoria
@@MAIN:					; BUCLE PRINCIPAL DE JUEGO
	ld a,1				; Indica que queremos imprimir pantalla codificada en bit
	call STAGE_PRINT		; Imprime pantalla de juego
	push hl				; Reserva puntero a pantalla

@@GAME:					; Bucle principal para cada puzzle
	ld a,7				; Prepara para leer valor de ESC a trav�s de SNSMAT
	call SNSMAT			; Lee estado ESC
	bit 2,a				; Comprueba que la tecla ESC ha sido pulsada
	jp z, @@RESTART 		; Si es as� reinicia el puzzle

	call ARROW			; Llama a la rutina que imprime el puntero en [X] e [Y]
	call MOVE_ARROW			; Llama a la rutina que gestiona la posici�n del puntero
	call READ_TRIGGER		; Lee si se ha pulsado SPACE o DISPARADOR Joystick
	cp 0xFF	  			; Comprueba si realmente ha sido pulsado disparador
	call z, PUZZLE			; Si ha sido as� actualiza puzzle
	call STATE_PUZZLE		; Comprueba "continuamente" estado puzzle (A=0 Fin)
	cp 0				; Comprueba que no hay bloques activos (IF A=0 THEN END)

	jp nz, @@GAME			; Continua en juego si la comparaci�n anterior es falsa

	call ARROW_OFF			; Env�a fuera de la pantalla el puntero

	ld a,[CONTADOR]			; Recupera posici�n del contador de pantallas
	dec a				; Decrementa su valor
	jp z, @@END			; Si ya no hay m�s pantallas a "congratulations"
	ld [CONTADOR],a			; De lo contrario actualiza contador y siguiente puzzle

	ld a,1				; Prepara para descomprimir informaci�n
	ld hl,NEXT			; Apunta a pantalla de aviso "siguiente pantalla"
	call STAGE_PRINT		; Lanza pantalla intermedia

	pop hl				; Recupera puntero a pantalla
	ld de,24 			; Incrementa en 24 bytes la direcci�n de HL
	add hl,de
					; Ojo que PUSH y POP deben estar equilibrados
	call WAIT_TRIGGER		; Esperar pulsaci�n disparador para continuar otro puzzle
	cp 27				; Comprueba que se ha pulsado ESC
	jp z,@@CREDITS			; Si es as� retorna a la pantalla de CREDITOS

	jp @@MAIN			; Al BUCLE PRINCIPAL DE JUEGO

; -----------------------------------------------------------------------------------------------
; Final del juego. Se ha conseguido superar con �xito todos los puzzles
; -----------------------------------------------------------------------------------------------
@@END:
	pop hl				; Equilibra la pila

	ld a,1				; Prepara para descomprimir informaci�n
	ld hl,WELL			; Apunta a pantalla de aviso "empieza juego"
	call STAGE_PRINT		; Lanza pantalla intermedia

	call WAIT_TRIGGER		; Espera a que pulse disparador o ESC
	jp @@CREDITS			; Retorna a la pantalla de CREDITOS

; -----------------------------------------------------------------------------------------------
; Actualiza la PILA para reiniciar el puzzle
; -----------------------------------------------------------------------------------------------
@@RESTART:
					; Con este peque�o algoritmo se puede reiniciar el puzzle
					; y adem�s dar la posibilidad de retornar a la pantalla
					; de cr�ditos.

	call ARROW_OFF			; Env�a fuera de la pantalla el puntero

	ld a,1				; Prepara para descomprimir informaci�n
	ld hl,INTE			; Apunta a pantalla de aviso "?"
	call STAGE_PRINT		; Lanza pantalla intermedia

					; Importante es recuperar estado de la pila para evitar
					; el desbordamiento y dejar registro Hl tal cual
	pop hl				; Recupera puntero a pantalla, y no actualiza HL
					; Esto se hace entre las dos llamadas CALL para evitar
					; que se retorne a la pantalla de cr�ditos con la pila
					; tocada, y para evitar que HL cambie


	call WAIT_TRIGGER		; Esperar pulsaci�n disparador para continuar otro puzzle
	cp 27				; Comprueba que se ha pulsado ESC
	jp z,@@CREDITS			; Si es as� retorna a la pantalla de CREDITOS

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
	call 00CFh			; KEY ON a trav�s de su referencia
	call INITXT			; Activa SCREEN 0
	ret				; Devuelve control al BASIC

; -----------------------------------------------------------------------------------------------
; ARROW
;
;	Descripci�n:
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
	ld d,1				; N� sprite
	ld e,14				; Color
	call PUT_SPRITE			; Imprime sprite Borde del puntero

	ld a,1				; Plano
	ld d,0				; N� sprite
	ld e,15				; Color
	call PUT_SPRITE			; Imprime sprite cuerpo del puntero

	dec b				; Reduce los valores de [X] en un par de unidades
	dec b				; para producir el efecto de sombra en el puntero
	inc c				; Aumenta los valores de [Y] en un par de unidades
	inc c				; para producir el efecto de sombra en el puntero

	ld a,2				; plano
	ld d,0				; N� sprite
	ld e,1				; Color
	call PUT_SPRITE			; imprime sprite de color negro para hacer efecto sombra

	pop de				; Recupera valor para DE
	pop bc				; Recupera valor para Bc
	pop af				; Recupera valor para AF

	ret				; Retorna al punto de llamada

; -----------------------------------------------------------------------------------------------
; ARROW_OFF
;
;	Descripci�n:
;		- Hace puntero transparente, y env�a a X=0 e Y=0
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
	ld d,1				; N� sprite
	call PUT_SPRITE			; Imprime sprite Borde	del puntero

	ld a,1				; Plano
	ld d,0				; N� sprite
	call PUT_SPRITE			; Imprime sprite Cuerpo del puntero

	ld a,2				; plano
	ld d,0				; N� sprite
	call PUT_SPRITE			; sombra

	pop de				; Recupera valor para DE
	pop bc				; Recupera valor para Bc
	pop af				; Recupera valor para AF

	ret				; Retorno al punto de llamada

; -----------------------------------------------------------------------------------------------
; BIT2BYTE
;
;	Descripci�n:
;		- Descomprime informaci�n en Bits a Bytes
;
;	Entrada:
;		- HL = Direcci�n memoria que contiene los Bits
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
					; de memoria, durante la transformaci�n de Bit a Byte

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
;	Descripci�n:
;		- Pasa coordenadas f�sicas X,Y a formato direcci�n VRAM en tabla de nombres
;
;	Entrada:
;		- E = Coordenada en X
;		- D = Coordenada en Y
;
;	Salida:
;		- HL = Direcci�n VRAM
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
	cp 0				; Comprueba que se solicita una l�nea distinta de la 1�
	call nz, @@SUMA32		; Si es as�, suma +32 posiciones VRAM por cada valor D

	ld d,0				; Borra parte alta del registro DE
	add hl, de			; Suma el valor X a la direcci�n VRAM contenida en HL

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

	ret				; Continua con la funci�n LOCATE

; -----------------------------------------------------------------------------------------------
; MOVE_ARROW
;
;	Descripci�n:
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
	cp 0				; 1� Comprueba si "NADA" se ha pulsado
	jp z, @@END_MOVE		; Si es as� devuelve el control a la rutina llamante

	cp 1				; Comprueba si se ha pulsado ARRIBA
	jr nz, @@CHK2			; Si no es as� realiza siguiente comprobaci�n
	dec c				; Decrementa C, que es igual que Y=Y-1
@@CHK2:
	cp 2				; Comprueba si se ha pulsado ARRIBA-DERECHA
	jr nz, @@CHK3			; Si no as� es realiza siguiente comprobaci�n
	dec c				; Decrementa C, que es igual que Y=Y-1
	inc b				; Incrementa B, que es igual que X=X+1
@@CHK3:
	cp 3				; Comprueba si se ha pulsado DERECHA
	jr nz, @@CHK4			; Si no es as� realiza siguiente comprobaci�n
	inc b				; Incrementa B, que es igual que X=X+1
@@CHK4:
	cp 4				; Comprueba si se ha pulsado DERECHA-ABAJO
	jr nz, @@CHK5			; Si no es as� realiza siguiente comprobaci�n
	inc c				; Incrementa C, que es igual que Y=Y+1
	inc b				; Incrementa B, que es igual que X=X+1
@@CHK5:
	cp 5				; Comprueba si se ha pulsado ABAJO
	jr nz, @@CHK6			; Si no es as� realiza siguiente comprobaci�n
	inc c				; Incrementa C, que es igual que Y=Y+1
@@CHK6:
	cp 6				; Comprueba si se ha pulsado IZQUIERDA-ABAJO
	jr nz, @@CHK7			; Si no es as� realiza siguiente comprobaci�n
	inc c				; Incrementa C, que es igual que Y=Y+1
	dec b				; Decrementa B, que es igual que X=X-1
@@CHK7:
	cp 7				; Comprueba si se ha pulsado IZQUIERDA
	jr nz, @@CHK8			; Si no es as� realiza siguiente comprobaci�n
	dec b 				; Decrementa B, que es igual que X=X-1
@@CHK8:
	cp 8				; Comprueba si se ha pulsado IZQUIERDA-ARRIBA
	jr nz, @@CHK_END		; Si no es as� realiza siguiente comprobaci�n
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
	ld a,b				; Comprueba posici�n X
	cp 0				; � Est� en el l�mite izquierdo ?
	jr nz, @@CL2			; Si no es as� comprueba siguiente l�mite
	ld b,1				; de lo contrario pone el registro en su estado anterior
@@CL2:
	cp 255				; � Est� en el l�mite derecho ?
	jr nz, @@CL3			; Si no es as� comprueba siguiente l�mite
	ld b,254			; de lo contrario pone el registro en su estado anterior
@@CL3:
	ld a,c				; Comprueba posici�n Y
	cp 0				; � Est� en el l�mite superior ?
	jr nz, @@CL4			; Si no es as� comprueba siguiente l�mite
	ld c,1				; de lo contrario pone el registro en su estado anterior
@@CL4:
	cp 191				; � Est� en el l�mite inferior ?
	ret nz				; Si no es as� retorna al punto de llamada
	ld c, 190			; de lo contrario pone el registro en su estado anterior

	ret				; Finaliza comprobaciones y retorna al punto llamante

; -----------------------------------------------------------------------------------------------
; PUT_BLOCK
;
;	Descripci�n:
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

					; El primer car�cter a imprimir se ha pasado por reg. A
	call WRTVRM			; Imprime car�cter contenido en A
	inc a				; Cambia a el siguiente car�cter a imprimir
	push hl				; Guarda direcci�n VRAM para usarlo despu�s
	inc hl				; Incrementa en +1 la direcci�n VRAM
	call WRTVRM			; Imprime car�cter A+1
	pop hl				; Recupera direcci�n VRAM
	ld de,32			; Cambia de l�nea incrementando en +32 la direcc. VRAM
	add hl,de			; Hace la suma HL=HL+32
	inc a				; Prepara siguiente car�cter a imprimir
	call WRTVRM			; Imprime A+2
	inc a				; Prepara el �ltimo car�cter a imprimir
	inc hl				; Aumenta la direcci�n VRAM en +1
	call WRTVRM			; Imprime caracter A+3

	pop de				; Restaura registro DE
	pop hl				; Restaura registro HL
	pop bc				; Restaura registro BC
	pop af				; Restaura registro AF

	ret				; Finaliza la rutina

; -----------------------------------------------------------------------------------------------
; PUT_SPRITE
;
;	Descripci�n:
;		- Imprime un sprite (16x16) en pantalla
;
;	Entrada:
;		- A = Plano
;		- B = Coordenada en X del sprite
;		- C = Coordenada en Y del Sprite
;		- D = N�mero de sprite a imprimir
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
	add a,c				; Al contenido de A se le a�aden 3 veces m�s de A, que es
	add a,c				; lo mismo que A=A+A+A+A, con esto se calcula el OFFSET
	add a,c				; del plano dentro de la tabla de atributos de sprites

	ld b,0				; B=0
	ld c,a				; C=A equivale a LD BC,A

	ld ix,SPATTB			; Apunta a la tabla de atributos de sprites
	add ix,bc			; Desplaza posici�n VRAM hasta el plano elegido en A
	push ix				; Empuja IX para pasar valor a HL, es igual a LD IX,BC
	pop hl				; HL contiene la posici�n VRAM en la tabla de atributos

	xor a				; A=0
	add a,d				; Al contenido de A se le a�aden 4 veces m�s de D, que es
	add a,d				; lo mismo que A=4*D. Con esto se consigue acceder al
	add a,d				; sprite numero D definido en tabla de patrones sprites
	add a,d				; Para el caso de sprites de 8x8 sobrar�an estas l�neas
	ld d,a				; Se actualiza el valor correcto para D en sprites de 16

	pop bc				; Recupera valores de posici�n X e Y del sprite

	ld a,c				; Posiciona sprite en Y
	call WRTVRM			; VPOKE HL,C
	inc hl				; Siguiente posici�n de la tabla de atributos
	ld a,b				; Posiciona sprite en X
	call WRTVRM			; VPOKE HL,B
	inc hl				; Siguiente posici�n de la tabla de atributos
	ld a,d				; N�mero de sprite a imprimir
	call WRTVRM			; VPOKE HL,D
	inc hl				; Siguiente posici�n de la tabla de atributos
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
;	Descripci�n:
;		- Gestiona el estado del puzzle cada vez que se pulsa el disparador
;
;	Entrada:
;		- Ninguna, toma los valores de las posiciones de memoria [X] e [Y]
;
;	Salida:
;		- En pantalla y en el BUFFER d�nde se encuentra la informaci�n del puzzle
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
					; no se suelte. Esa es la funci�n de este bucle inicial.
@@OFF:
	call READ_TRIGGER		; Lee estado de la barra SPACE o DISPARADOR MANDO 1
	cp 00h				; Comprueba que se ha soltado alguno de los dos
	jr nz, @@OFF 			; Si no es as� espera a que se deje de pulsar TRIGGER

	ld a,[X]			; Lee coordenada X de posici�n del puntero
	ld e,a				; y le asigna valor al registro D
	ld a,[Y]			; Lee coordenada Y de posici�n del puntero
	ld d,a				; y le asigna valor al registro E

					; Localiza en qu� bloque est� el puntero

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

					; Busca posici�n RAM en BUFFER correspondiente al bloque
					; Este trozo de c�digo es igual al de la funci�n LOCATE
					; Solo cambia destino memoria y tama�o matriz

	ld hl, BUFFER			; Apunta a BUFFER donde se encuentra info pantalla
					; El tama�o de la pantalla es de 16x12 bloques

	ld a,d				; A=D
	cp 0				; Comprueba que se solicita una l�nea distinta de la 1�
	call nz, @@SUMA16		; Si es as�, suma +16 posiciones BUFFER por cada valor D

	ld d,0				; Borra parte alta del registro DE
	add hl, de			; Suma el valor X a la direcci�n BUFFER contenida en HL
					; HL contiene posici�n RAM d�nde se encuentra el puntero

					; A continuaci�n se modifican los bloques necesarios

					; BLOQUE SUPERIOR
	ld de,16			; Prepara para posicionar direcci�n HL en bloque superior
	sbc hl,de			; Coloca HL en bloque superior
	ld a,[YB]			; A=Coordenada YB
	cp 0				; Comp. que coordenada [YB-1] no supera limite superior
	jr z, @@BLOCK_LEFT		; Si supera l�mite pasa del bloque e imprime siguiente
	call @@INVERT			; De lo contrario invierte valor bloque

@@BLOCK_LEFT:				; BLOQUE IZQUIERDO
	ld de,15			; Prepara para posicionar direcc. Hl en bloque izquierdo
	add hl,de			; Coloca HL en bloque izquierdo
	ld a,[XB]			; A=Coordenada XB
	cp 0				; Comp. que coordenada [XB-1] no supera l�mite izquierdo
	jr z, @@BLOCK_ARROW		; Si supera l�mite pasa del bloque e imprime siguiente
	call @@INVERT			; De lo contrario invierte valor bloque

@@BLOCK_ARROW:				; BLOQUE DEL PUNTERO
	inc hl				; Este bloque siempre est� en pantalla
	call @@INVERT			; Llama a rutina para invertir valor

					; BLOQUE DERECHO
	inc hl				; Posiciona HL en el bloque derecho
	ld a,[XB]			; A=Coordenada XB
	cp 15				; Comp. que coordenada [XB+1] no supera l�mite Derecho
	jr z, @@BLOCK_DOWN		; Si supera l�mite pasa del bloque e imprime siguiente
	call @@INVERT			; De lo contrario invierte valor bloque

@@BLOCK_DOWN:				; BLOQUE INFERIOR
	ld de,15			; Prepara para posicionar HL en bloque inferior
	add hl,de			; Coloca HL en bloque inferior
	ld a, [YB]			; A=Coordenada YB
	cp 11				; Comp. que coordenada [YB+1] no supera l�mite inferior
	jr z, @@PUZZLE_END		; Si supera l�mite pasa del bloque y finaliza rutina
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
	ld a,[hl]			; De lo contrario lee el valor de esa posici�n
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
;	Descripci�n:
;		- Lee el estado del "STICK" del teclado O "JOYSTICK" en puerto 1
;
;	Entrada:
;		- Ninguna.
;
;	Salida:
;		- A= de 0 a 7, igual que la funci�n "A= STICK(0) OR STICK(1)" del BASIC
;
; 	Estado:
;		- Ok
; -----------------------------------------------------------------------------------------------
READ_STICK:

	ld a,0				; Prepara para leer STICK del teclado
	call GTSTCK			; Lee valor del STICK
	cp 0				; Comprueba si se ha pulsado alg�n cursor del teclado
	ret nz				; Si es as� retorna y devuelve en A el valor asignado
	ld a,1				; De lo contrario prepara para leer JOYSTICK en puerto 1
	call GTSTCK			; Lee valor del JOYSTICK

	ret				; Devuelve valor A<>0 si se ha pulsado algo, o A=0

; -----------------------------------------------------------------------------------------------
; READ_TRIGGER
;
;	Descripci�n:
;		- Lee estado del disparador "SPACE" o "TRIGGER 1"
;
;	Entrada:
;		- Ninguna
;
;	Salida:
;		- A = 0 o -1(FFh) seg�n este el disparador "sin pulsar" o "pulsado"
;
; 	Estado:
;		- Ok
; -----------------------------------------------------------------------------------------------
READ_TRIGGER:

	ld a,0				; Prepara para leer SPACE
	call GTTRIG			; Lee estado de la barra SPACE
	cp 0xFF				; Comprueba que ha sido pulsada
	ret z				; Si es as� retorna y devuelve en A=FFh
	ld a,1				; Prepara para leer TRIGGER en puerto 1
	call GTTRIG			; Lee estado TRIGGER

	ret				; Retorna con valor en A=0 o A=FFh

; -----------------------------------------------------------------------------------------------
; STAGE_PRINT
;
;	Descripci�n:
;		- Imprime pantalla de juego codificada en bits
;
;	Entrada:
;		- A  = 1, Indica si hay que descomprimir informaci�n "pantalla inicial" en BUFFER
;		- HL = Direcci�n memoria que contiene la "pantalla inicial" de juego, solo tiene
;		       utilidad cuando se quiere descomprimir la pantalla inicial de cada puzzle
;
;	Salida:
;		- En pantalla
;
; 	Estado:
;		- Ok (se mantiene @@AUX_1 Y @@AUX_2 por legibilidad del c�digo)
; -----------------------------------------------------------------------------------------------
STAGE_PRINT:
	push af				; Reserva valor AF
	push bc				; Reserva valor BC
	push hl				; Reserva valor HL
	push de				; Reserva valor DE

	cp 1				; Comprueba que se quiere descomprimir pantalla
	call z, BIT2BYTE		; Descomprime la informaci�n codificada en bit en BUFFER

	ld ix,BUFFER			; Almacena en IX la direcci�n de memoria del BUFFER
	ld e,0				; Prepara para imprimir en coordenada X
	ld d,0				; Prepara para imprimir en coordenada Y

	ld b,192			; N�mero de ciclos a realizar por el bucle
@@BUC:
	ld a,[ix]			; A = Contenido del BUFFER
	cp 0				; Compara con el valor cero
	push af				; Almacena estado del registro de banderas FLAG
	call nz, @@AUX_1		; Si la comparaci�n anterior es <>0 imprime bloque macizo
	pop af				; Rescata el estado del registro de banderas FLAG
	call z,  @@AUX_2		; Si la comparaci�n anterior es =0 imprime bloque hueco

	inc e				; Avanza para imprimir el siguiente bloque
	inc e				; en dos unidades por ser titles de 2x2 caracteres
	ld a,e				; Hace A=E para comprobar si ha llegado a final de fila
	cp 32				; Testea para ver si ha llegado al final de la l�nea
	call Z,  @@AUX_3		; Cambia l�nea en caso de que el test anterior sea verdad

	inc ix				; Incrementa la posici�n del BUFFER
	djnz @@BUC			; Final del bucle

	pop de				; Restaura valor DE
	pop hl				; Restaura valor HL
	pop bc				; Restaura valor BC
	pop af				; Restaura valor AF
	ret				; Finaliza la funci�n y retorna al punto de llamada

@@AUX_1:
	ld a,91				; Prepara para imprimir bloque macizo
	call PUT_BLOCK			; Llama a rutina para imprimir bloque
	ret				; Devuelve control a funci�n principal

@@AUX_2:
	ld a, 95			; Prepara para imprimir bloque hueco
	call PUT_BLOCK			; Llama a rutina para imprimir bloque
	ret				; Devuelve control a funci�n principal

@@AUX_3:
	inc d				; Avanza una l�nea de bloques
	inc d				; por lo que avanza en Y dos posiciones
	ld e,0				; Coloca coordenada X al principio de la l�nea
	ret				; Retorna al punto de llamada

; -----------------------------------------------------------------------------------------------
; STATE_PUZZLE
;
;	Descripci�n:
;		- Cuenta cuantos bloques quedan para terminar el puzzle
;
;	Entrada:
;		- Ninguna
;
;	Salida:
;		- A= N�mero de bloques que quedan para terminar, si A=0 puzzle realizado
;
; 	Estado:
;		- Ok
; -----------------------------------------------------------------------------------------------
STATE_PUZZLE:
	push bc				; Reserva BC
	push hl				; Reserva HL

	ld a, 0				; Inicializa el contador "A" a cero
	ld hl,BUFFER			; Apunta al BUFFER
	ld b,192			; N�mero total de bloques
@@BUC:
	ld c,[HL]			; Carga valor (0=Sin bloque, 128=Con bloque)
	srl c				; Lleva valor del "7�" bit a bit "6�" = dividir por 2
	srl c				; Lleva valor del "6�" bit a bit "5�" = dividir por 4
	srl c				; Lleva valor del "5�" bit a bit "4�" = dividir por 8
	srl c				; Lleva valor del "4�" bit a bit "3�" = dividir por 16
	srl c				; Lleva valor del "3�" bit a bit "2�" = dividir por 32
	srl c				; Lleva valor del "2�" bit a bit "1�" = dividir por 64
	srl c				; Lleva valor del "1�" bit a bit "0�" = dividir por 128
	add a, c			; A=A+C, siendo C=0 o C=1
	inc hl				; Aumenta posici�n BUFFER
	djnz @@BUC			; Repite operaci�n para todas las posiciones del BUFFER

	pop hl				; Recupera valor HL
	pop bc				; Recupera valor BC

	ret				; Al punto de llamada y A contiene bloques a�n activos

; -----------------------------------------------------------------------------------------------
; SOUND
;
;	Descripci�n:
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
	ld b,[ix]			; Cantidad de datos a enviar, y n�mero de bucles
@@BUCLE:
	ld a,[ix+1] 			; Registro PSG
	ld e,[ix+2]			; Dato
	call WRTPSG			; Env�a informaci�n al PSG a trav�s de la BIOS
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
;	Descripci�n:
;		- Imprime pantalla de presentaci�n del juego
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

	ld hl,INFO			; Direcci�n RAM origen (set grafico)
	ld de,CHNAME+704		; Direcci�n VRAM destino (solo en el tercer banco)
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
;	Descripci�n:
;		- Espera a que se haya pulsado disparador
;
;	Entrada:
;		- Ninguna
;
;	Salida:
;		- A = 27 (Si se ha pulsado ESC) de lo contrario env�a A=0
;
; 	Estado:
;		- Ok
; -----------------------------------------------------------------------------------------------
WAIT_TRIGGER:

@@BUC1:
	ld a,7				; Prepara para leer valor de ESC a trav�s de SNSMAT
	call SNSMAT			; Lee estado ESC
	bit 2,a	 		   	; Comprueba que la tecla ESC ha sido pulsada
	jp z, @@ESC			; Si es as� devuelve valor A=?????1??
	call READ_TRIGGER		; Lee estado de la barra SPACE o DISPARADOR MANDO 1
	cp 0xFF				; Comprueba que se ha pulsado alguno de los dos
	jr nz, @@BUC1			; Si no es as� retorna al bucle de presentaci�n

@@BUC2:
	call READ_TRIGGER		; Lee estado de la barra SPACE o DISPARADOR MANDO 1
	cp 00h				; Comprueba que se ha soltado alguno de los dos
	jr nz, @@BUC2 			; Si no es as� espera a que se deje de pulsar TRIGGER
	xor a				; Evita enviar cualquier valor si se ha pulsado TRIGGER
	ret				; Al punto de llamada

@@ESC:
	ld a, 27			; Env�a A=27 para indicar que se ha pulsado ESC
	ret				; Al punto de llamada

; -----------------------------------------------------------------------------------------------
; Informaci�n fija en RAM
; -----------------------------------------------------------------------------------------------

	; Definici�n de los gr�ficos desde el car�cter 0 hasta el 10
GRAF:	db 0x7C,0xFE,0x8E,0x8E,0x8E,0xCE,0x7C,0x00,0x04,0x06,0x06,0x06,0x06,0x06,0x04,0x00
        db 0x7C,0xFE,0x06,0x7C,0xC0,0xFE,0x7C,0x00,0x7C,0x8E,0xCE,0xFE,0x8E,0xCE,0x7C,0x00
        db 0xE3,0xE6,0x0C,0x18,0x30,0x67,0xC7,0x00,0x3C,0x42,0x99,0x85,0x85,0x99,0x42,0x3C
        db 0x0E,0x0E,0x0E,0x0E,0xCE,0xFE,0xFE,0x00,0x00,0x00,0xFB,0x9A,0x9B,0x98,0xFB,0x00
        db 0x36,0x16,0xD7,0x06,0xC6,0x46,0xC7,0x00,0x00,0x00,0xE0,0x60,0x60,0x60,0xE0,0x00
        db 0x7C,0xC6,0xC6,0xFE,0xC6,0xC6,0x44,0x00,0x7C,0xFE,0xC0,0x7C,0x06,0xFE,0x7C,0x00
        db 0x44,0xEE,0xFE,0xD6,0xC6,0xC6,0x44,0x00

COLOR:	db 0xB1,0xE1,0xE1,0xF1,0xE1,0xE1,0xB1,0xB1,0xB1,0xE1,0xE1,0xF1,0xE1,0xE1,0xB1,0xB1
        db 0xB1,0xE1,0xE1,0xF1,0xE1,0xE1,0xB1,0xB1,0xB1,0xE1,0xE1,0xF1,0xE1,0xE1,0xB1,0xB1
        db 0xC1,0x21,0x31,0x31,0x31,0x21,0xC1,0xC1,0x61,0x81,0x81,0x91,0x91,0x81,0x81,0x61
        db 0x41,0x51,0x51,0x71,0x51,0x51,0x41,0x41,0x41,0x51,0x51,0x71,0x51,0x51,0x41,0x41
        db 0x41,0x51,0x51,0x71,0x51,0x51,0x41,0x41,0x41,0x51,0x51,0x71,0x51,0x51,0x41,0x41
        db 0xC1,0x21,0x21,0x31,0x21,0x21,0xC1,0xC1,0xC1,0x21,0x21,0x31,0x21,0x21,0xC1,0xC1
        db 0xC1,0x21,0x21,0x31,0x21,0x21,0xC1,0xC1

	; Definici�n del tipo de bloque relleno
BLOCK:	db 0x7F,0x80,0x9F,0xBF,0xBF,0xBF,0xBF,0xBF,0xFC,0x02,0xF2,0xFA,0xFA,0xFA,0xFA,0xFA
	db 0xBF,0xBF,0xBF,0xBF,0x9F,0x80,0x7F,0x00,0xFA,0xFA,0xFA,0xFA,0xF2,0x02,0xFC,0x00
	; Definici�n del tipo de bloque hueco
 	db 0x7F,0x80,0x9F,0xBF,0xBF,0xBF,0xBF,0xBF,0xFC,0x02,0xF2,0xFA,0xFA,0xFA,0xFA,0xFA
	db 0xBF,0xBF,0xBF,0xBF,0x9F,0x80,0x7F,0x00,0xFA,0xFA,0xFA,0xFA,0xF2,0x02,0xFC,0x00

	; Color bloque relleno
CBLOCK:	db 0x20,0x20,0x30,0x30,0x20,0x20,0x20,0x20,0x20,0x20,0x30,0x30,0x20,0x20,0x20,0x20
	db 0x20,0x20,0x30,0x30,0x20,0x20,0x20,0x20,0x20,0x20,0x30,0x30,0x20,0x20,0x20,0x20
	; Color bloque hueco
	db 0x14,0x14,0x14,0x14,0x14,0x14,0x14,0x14,0x14,0x14,0x14,0x14,0x14,0x14,0x14,0x14
	db 0x14,0x14,0x14,0x14,0x14,0x14,0x14,0x14,0x14,0x14,0x14,0x14,0x14,0x14,0x14,0x14

	; Definici�n de SPRITES de 16x16 - Cuerpo del puntero y sombra
SPT:	db 0x80,0xC0,0xE0,0xF0,0xF8,0xFC,0xFE,0xFF,0xFF,0xFF,0xFF,0xFF,0xFE,0xF8,0xE2,0x87
	db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x80,0xC0,0xE0,0x80,0x00,0x00,0x00,0x00

	; Definici�n de SPRITES de 16x16 - Borde del puntero
	db 0x80,0xC0,0xE0,0xB0,0x98,0x8C,0x86,0x83,0x81,0x80,0x80,0x83,0x8E,0xB8,0xE0,0x80
	db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x80,0xC0,0xE0,0x80,0x00,0x00,0x00,0x00

	; Pantallas codificadas en bits 16X12 titles
GO:	db 0x00,0x00,0x00,0x00,0x00,0x00,0x1E,0x08,0x10,0xE8,0x16,0xA8	; GO!
	db 0x12,0xA0,0x1E,0xE8,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00

NEXT:	db 0x00,0x00,0x00,0x00,0x00,0x00,0x97,0x57,0xD4,0x52,0xB6,0x22	; NEXT
	db 0x94,0x52,0x97,0x52,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00

INTE:	db 0x00,0x00,0x03,0xC0,0x07,0xE0,0x06,0x60,0x00,0x60,0x00,0xC0	; ?
	db 0x01,0x80,0x01,0x80,0x00,0x00,0x01,0x80,0x01,0x80,0x00,0x00

WELL:	db 0x00,0x00,0x00,0x00,0x00,0x00,0x8B,0xD2,0x8A,0x12,0xAB,0x12	; WELL
	db 0xDA,0x12,0x8B,0xDB,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00

ST00:	db 0x00,0x00,0x00,0x00,0x00,0x00,0xEE,0x97,0x2A,0xD4,0x4A,0xB7	; Stage 0 - Presentaci�n
	db 0x8A,0x94,0xEE,0x97,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00

ST01: 	db 0x00,0x00,0x10,0x00,0x10,0x00,0x6C,0x00,0x10,0x00,0x10,0x00	; Stage 1 - 4 Movimientos
	db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00	; Muy F�cil - Star

ST02:	db 0x00,0x00,0x00,0x00,0x00,0x00,0x22,0x00,0x6B,0x00,0x00,0x00	; Stage 2 - 6 Movimientos
	db 0x00,0x00,0x08,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00	; Muy F�cil - Umbrella

ST03:	db 0x00,0x00,0x00,0x00,0x01,0x80,0x00,0x00,0x02,0x40,0x08,0x10	; Stage 3 - 12 Movimientos
	db 0x08,0x10,0x02,0x40,0x00,0x00,0x01,0x80,0x00,0x00,0x00,0x00	; F�cil-Medio - Circle

ST04:	db 0x00,0x00,0x02,0x40,0x02,0x40,0x04,0x20,0x1A,0x58,0x00,0x00	; Stage 4 - 24 Movimientos
	db 0x00,0x00,0x1A,0x58,0x04,0x20,0x02,0x40,0x02,0x40,0x00,0x00	; Medio - Cross

ST05:	db 0x19,0x80,0x29,0x40,0x86,0x10,0x10,0x84,0x00,0x21,0x10,0x08	; Stage 5 - 44 Movimientos
	db 0x84,0x00,0x21,0x08,0x08,0x61,0x02,0x94,0x02,0x94,0x04,0x62	; Medio - Double Wave

ST06: 	db 0x00,0x04,0x00,0x00,0x00,0x00,0x00,0x04,0x00,0x09,0x00,0x24	; Stage 6 - 18 Movimientos
	db 0x00,0x24,0x00,0x09,0x00,0x04,0x00,0x00,0x00,0x00,0x00,0x04	; Medio - Tissue

ST07:	db 0x00,0x00,0x00,0x00,0x00,0xA0,0x01,0x1C,0x01,0x22,0x01,0x00	; Stage 7 - 22 Movimientos
	db 0x02,0x8A,0x00,0x04,0x02,0x24,0x01,0xC4,0x00,0x28,0x00,0x00	; Medio - Rose

ST08:	db 0x00,0x08,0x03,0x00,0x07,0x00,0x07,0x12,0x00,0x55,0x00,0x82	; Stage 8 - 36 Movimientos
	db 0x00,0x00,0x01,0x93,0x00,0x00,0x00,0x82,0x00,0x54,0x04,0x11	; Dificil - Quarter to Twelve

ST09:	db 0x55,0x55,0xD1,0x55,0x6F,0x55,0x40,0x00,0x00,0x00,0x42,0x40	; Stage 9 - ??
	db 0x44,0x20,0x80,0x00,0x90,0x20,0x01,0xC0,0x06,0x00,0x98,0x00	; Extra - Not enough

ST0A:	db 0x00,0x00,0x00,0x00,0x06,0x20,0x08,0x40,0x04,0x28,0x00,0x10	; Stage A - ??
	db 0x00,0x00,0x00,0x40,0x10,0x40,0x04,0x40,0x05,0x10,0x04,0x00	; Extra - Terror

	; Informaci�n pantalla
INFO:	db 0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	db 0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	db 0x20,0x01,0x00,0x00,0x04,0x20,0x0A,0x0B,0x0C,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	db 0x20,0x20,0x20,0x20,0x20,0x06,0x07,0x08,0x09,0x05,0x20,0x02,0x00,0x00,0x03,0x20

					; Formato "Registro_PSG, Informaci�n"
SND:	db 6				; Cantidad de informaci�n que hay que enviar al PSG
	db 0,172			; Ajuste fino canal A
	db 1,7				; Ajuste grueso canal A
	db 8,16				; Volumen canal A m�ximo con activaci�n curva Envolvente
	db 11,16			; f(Hz)=3.5*10^6/(R11*256+R12)	Valor de R11
	db 12,16			; 				Valor de R12
	db 13,0				; Forma de ONDA elegida (0,4,8,10,11,12,13,14)

; -----------------------------------------------------------------------------------------------
; Informaci�n variable y buffer en RAM
; -----------------------------------------------------------------------------------------------
BUFFER:		ds 192				; BUFFER, para almacenar pantallas en BYTES
XB:		ds 1				; Bloque horizontal donde est� el puntero
YB:		ds 1				; Bloque vertical donde est� el puntero
X: 		db 120				; Coordenada X del puntero "ARROW"
Y:		db 88				; Coordenada Y del puntero "ARROW"
CONTADOR:	db 1				; Reserva memoria para contador principal
