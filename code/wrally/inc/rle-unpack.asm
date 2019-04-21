; Depack procedures for RLEpack

DEPACK_RAM:
; Decompress data packed with RLEpack de RAM a RAM
; Parameters: 	HL=compressed data address
;		DE=destination address
@@LOOP:
        ld      a,[hl]
        inc     hl
        cp      0C0h
        jr      c,@@SINGLE
        and     3Fh
        inc     a
        ld      b,a
        ld      a,[hl]
        inc     hl
@@DUMP:
        ld      [de],a
        inc     de
        djnz    @@DUMP
        jr      @@LOOP
@@SINGLE:
        ld      c,a
        or      [hl]
        ld      a,c
        ret     z
        ld      b,1
        jr      @@DUMP


DEPACK_VRAM:
; Decompressed data packed with RLEpack from RAM to VRAM
; Parameters: 	HL=compressed data address 
;		DE=VRAM destination address
; Note: 	Execute just after the v-blank interruption
        ex      de,hl
        call    SETWRT
        ex      de,hl
@@LOOP:
        ld      a,[hl]
        inc     hl
        cp      0C0h
        jr      c,@@SINGLE
        and     3Fh
        inc     a
        ld      b,a
        ld      a,[hl]
        inc     hl
@@DUMP:
        out     [98h],a
        djnz    @@DUMP
        jr      @@LOOP
@@SINGLE:
        ld      c,a
        or      [hl]
        ld      a,c
        ret     z
        ld      b,1
        jr      @@DUMP
