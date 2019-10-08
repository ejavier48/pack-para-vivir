;
; practica4.asm
;
; Created: 9/9/2019 10:30:39 PM
; Author : EliteBook
;

.include "m8535def.inc"
.def dato=R16
.def aux=R17

ser dato
out DDRA, dato

cargar:
	ldi R21, $3F
	ldi R22, $06
	ldi R23, $5B
	ldi R24, $4F
	ldi R25, $66
	ldi R26, $6D
	ldi R27, $7D
	ldi R28, $27
	ldi R29, $7F
	clr ZH
	ldi dato, $00
main:
	ldi ZL, 21
	add ZL, dato
	ld  aux, Z 
	out PORTA, aux
	rjmp delay500ms
increment:	
    inc dato
	cpi dato, $0A
	brne main
	ldi dato, $00
	rjmp main
delay500ms:
	ldi  r18, 3
    ldi  r19, 138
    ldi  r20, 86
loop: 
	dec  r20
    brne loop
    dec  r19
    brne loop
    dec  r18
    brne loop
    rjmp increment