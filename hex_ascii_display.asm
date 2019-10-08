;
; practica3.asm
;
; Created: 9/9/2019 10:07:35 AM
; Author : EliteBook
;

.include "m8535def.inc"
.def dato = R16

ser dato
out DDRA, dato
out PORTB, dato

cargar:
	ldi ZL, $60
	lds ZL, $3F
	inc ZL
	lds ZL, $06
	inc ZL
	lds ZL, $5B
	inc ZL
	lds ZL, $4F
	inc ZL
	lds ZL, $66
	inc ZL
	lds ZL, $6D
	inc ZL
	lds ZL, $7D
	inc ZL
	lds ZL, $27
	inc ZL
	lds ZL, $7F
	inc ZL
	lds ZL, $6F
	inc ZL
	lds ZL, $77
	inc ZL
	lds ZL, $7C
	inc ZL
	lds ZL, $39
	inc ZL
	lds ZL, $5E
	inc ZL
	lds ZL, $79
	inc ZL
	lds ZL, $71
	clr ZH
main:
	in dato, PINB
	subi dato, $30
	cpi dato, $11
	brsh letra
show_display:
	ldi ZL, $60
	add ZL, dato
	ld dato, Z
	out PORTA, dato
	rjmp main
letra:
	subi dato, $07
	rjmp show_display
