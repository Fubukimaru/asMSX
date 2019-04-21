		; -----------------------------------------------------
		; --- RUTINAS PARA COLOCAR LAS PAGINAS DEL CARTUCHO ---
		; -----------------------------------------------------
		; --- SIEMPRE DEBEN IR EN LA PAGINA 1 DEL CARTUCHO! ---
		; -----------------------------------------------------

		; --- RUTINAS PRINCIPALES DEL MODULO ---
		; GETSLOT:	OBTIENE EL VALOR DEL SLOT QUE LE INDIQUEMOS
		; SETPAGES32K:	BIOS-ROM-YY-ZZ	 -> BIOS-ROM-ROM-ZZ (SITUA PAGINA 2)

		; --- VARIABLES EN RAM NECESARIAS ---
		; NINGUNA

GETSLOT:	; --- Rutina que construye el valor del SLOT para llamar a ENASLT ---
		; --- Entrada: a = SLOT                                           ---
		; --- Salida: a = valor para ENASLT                               ---
		; --- AUTOR: Konamiman                                            ---
		and	$03				; Proteccion, nos aseguramos de que el valor esta en 0-3
		ld	c,a				; c = slot de la pagina
		ld	b,0				; bc = slot de la pagina
		ld	hl,$FCC1			; Tabla de slots expandidos
		add	hl,bc				; hl -> variable que indica si este slot esta expandido
		ld	a,[hl]				; Tomamos el valor
		and	$80				; Si el bit mas alto es cero...
		jr	z,@@EXIT			; ...nos vamos a @@EXIT
		; --- El slot esta expandido ---
		or	c				; Slot basico en el lugar adecuado
		ld	c,a				; Guardamos el valor en c
		inc	hl				; Incrementamos hl una...
		inc	hl				; ...dos...
		inc	hl				; ...tres...
		inc	hl				; ...cuatro veces
		ld	a,[hl]				; a = valor del registro de subslot del slot donde estamos
		and	$0C				; Nos quedamos con el valor donde esta nuestro cartucho
@@EXIT:		or	c				; Slot extendido/basico en su lugar
		ret					; Volvemos

SETPAGES32K:	; --- Posiciona las paginas de un megarom o un 32K ---
		ld	a,$C9				; Codigo de RET
		ld	[@@NOPRET],a			; Modificamos la siguiente instruccion si estamos en RAM
@@NOPRET:	nop					; No hacemos nada si no estamos en RAM
		; --- Si llegamos aqui no estamos en RAM, hay que posicionar la pagina ---
		call	RSLREG				; Leemos el contenido del registro de seleccion de slots
		rrca					; Rotamos a la derecha...
		rrca					; ...dos veces
		call	GETSLOT				; Obtenemos el slot de la pagina 1 ($4000-$BFFF)
		ld	h,$80				; Seleccionamos pagina 2 ($8000-$BFFF)
		jp	ENASLT				; Posicionamos la pagina 2 y volvemos
