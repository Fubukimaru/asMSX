		; -----------------------------------------------------
		; --- RUTINAS PARA COLOCAR LAS PAGINAS DEL CARTUCHO ---
		; --- MODO 48K                                      ---
		; -----------------------------------------------------
		; --- SIEMPRE DEBEN IR EN LA PAGINA 1 DEL CARTUCHO! ---
		; -----------------------------------------------------

		; --- RUTINAS PRINCIPALES DEL MODULO ---
		; SETPAGES48K:	BIOS-ROM-YY-ZZ	 -> ROM-ROM-ROM-ZZ (SITUA PAGINAS 2 Y 0, EN ESTE ORDEN)
		;               ADEMAS GUARDA LOS SLOTS DEL JUEGO Y LA BIOS POR SI HAY QUE INTERCAMBIAR
		; SETGAMEPAGE0:	XX-ROM-YY-ZZ     -> ROM-ROM-YY-ZZ (NO TOCA LA PAGINA 2)
		; RESTOREBIOS:  XX-ROM-YY-ZZ     -> BIOS-ROM-YY-ZZ (VUELVE A SITUAR LA BIOS)
		; SETPAGE0:	POSICIONA SLOT EN LA PAGINA 0

		; --- VARIABLES EN RAM NECESARIAS ---
		; SLOTBIOS:	BYTE PARA ALMACENAR EL SLOT DE LA BIOS
		; SLOTGAME:	BYTE PARA ALMACENAR EL SLOT DEL JUEGO

		; INCLUDE	"SETPAGES32K.ASM"

SETPAGES48K:	; --- Posiciona las paginas de un cartucho de 48K ---
		call	SETPAGES32K			; Colocamos la pagina 2 del cartucho
		; --- Guardamos el slot de la BIOS por si tenemos que restaurarla ---
		ld	a,[$FCC1]			; Valor del slot de la BIOS
		ld	[SLOTBIOS],a			; Grabamos el slot de la BIOS para recuperarlo si hace falta
		; --- Guardamos el slot del juego por si hay que restaurarlo ---
		call	RSLREG				; Leemos el contenido del registro de seleccion de slots
		rrca					; Rotamos a la derecha...
		rrca					; ...dos veces
		call	GETSLOT				; Obtenemos el slot de la pagina 1 ($4000-$7FFF) y volvemos
		ld	[SLOTGAME],a			; Grabamos el slot del juego para recuperarlo si hace falta
SETGAMEPAGE0:	; --- RUTINA QUE POSICIONA LA PAGINA 0 DEL JUEGO ---
		; ---     ANTES HAY QUE LLAMAR A SETPAGES48K     ---
		ld	a,[SLOTGAME]			; Leemos el slot del juego
		jp	SETPAGE0			; Situamos la pagina 0 del juego y volvemos
RESTOREBIOS:	; --- RUTINA QUE VUELVE A SITUAR LA BIOS ---
		; --- ANTES HAY QUE LLAMAR A SETPAGES48K ---
		ld	a,[SLOTBIOS]			; Leemos el slot de la BIOS
SETPAGE0:	; --- RUTINA QUE POSICIONA SLOT EN LA PAGINA 0 ---
		; --- AUTOR: Ramones                           ---
		; --- ENTRADA: a = slot con formato FxxxSSPP   ---
		di					; Desactivamos las interrupciones
		ld	b,a				; Guardamos el slot
		in	a,[$0A8]			; Leemos el registro principal de slots
		and	$FC				; Nos quedamos con los valores de las tres paginas superiores
		ld	d,a				; D = Valor del slot primario
		ld	a,b				; Recuperamos el slot
		and	$03				; Nos fijamos en el slot primario
		or	d				; Colocamos los bits de las paginas superiores
		ld	d,a				; Guardamos en D el valor final para el slot primario
		; Comprobamos si esta expandido
		ld	a,b				; Recuperamos el slot
		bit	7,a				; Miramos el bit de expansion
		jr	z,@@SETPRIMARY			; ...y saltamos si no esta expandido
		; Si llegamos aqui el slot esta expandido
		and	03h				; Nos quedamos con el slot primario
		rrca					; Rotamos ciclicamente a la derecha una...
		rrca					; ...y dos veces
		ld	c,a				; Guardamos el valor en c
		ld	a,d				; Recuperamos el valor final para el slot primario
		and	$3F				; Nos quedamos con las paginas 0, 1 y 2
		or	c				; Colocamos los bits para la pagina 3
		ld	c,a				; C:=valor del slot primario incluso en pagina 3
		ld	a,b				; Recuperamos otra vez el slot
		and	$0C				; Nos quedamos con el valor del subslot
		rrca					; Rotamos ciclicamente a la derecha una...
		rrca					; ...y dos veces
		ld	b,a				; B:= Slot expandido en pagina 3
		ld	a,c				; valor del slot primario incluyendo pagina 3
		out	[$A8],a				; Slots : Primario, xx, xx, Primario
		ld	a,[$FFFF]			; Leemos registro de seleccion de subslots
		cpl					; Complementamos (recordemos que siempre hay que complementarlo)
		and	$FC				; Nos quedamos con las paginas superiores
		or	b				; Colocamos el valor del slot expandido en pagina 0
		ld	[$FFFF],a			; Seleccionamos el slot expandido
@@SETPRIMARY:	; --- Colocamos el slot primario ---
		ld	a,d				; Valor final del slot primario
		out	[$A8],a				; Slots: Seleccionado, xx, xx, Ram
		ret					; Volvemos
