;
; practica6.asm
;
; Created: 9/24/2019 8:57:40 AM
; Author : EliteBook
;

.include "m8535def.inc"
.def aux=R16
.def unidades=R17
.def decenas=R18
reset:
	rjmp main
	rjmp aumen
	rjmp decre
main:
	ldi aux, low(RAMEND)
	out spl, aux
	ldi aux, high(RAMEND)
	out sph, aux
	ser aux
	out DDRC, aux
	out DDRA, aux
	out PORTD, aux
	ldi aux, $0B
	out MCUCR, aux
	ldi aux, $C0
	out GICR, aux
	clr unidades
	clr decenas
	sei
load:
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
loop:
	ldi ZL, 21
	add ZL, unidades
	ld aux, Z
	out PORTC, aux
	ldi ZL, 21
	add ZL, decenas
	ld aux, Z
	out PORTA, aux
	rjmp loop
aumen:
	inc unidades
	cpi unidades, 10
	breq a_dece
	reti
decre:
	dec unidades
	cpi unidades, $FF
	breq d_dece
	reti
a_dece:
	clr unidades
	inc decenas
	cpi decenas, 10
	breq restart
	reti
d_dece:
	ldi unidades, 9
	dec decenas
	cpi decenas, $FF
	breq maxi
	reti
restart:
	clr unidades
	clr decenas
	reti
maxi:
	ldi decenas, 9
	reti