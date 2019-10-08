.include "m8535def.inc"
.def aux=r16
.def cont=r17

rjmp main
.org $009
rjmp sube

main:
	ldi aux, low(RAMEND)
	out spl, aux
	ldi aux, high(RAMEND)
	out sph, aux
	ser aux
	out ddrc, aux
	ldi aux, 5
	out tccr0, aux
	ldi aux, 1
	out timsk, aux
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
	clr cont
loop:
	ldi ZL, 21
	add ZL, cont
	ld aux, Z
	out PORTC, aux
	rjmp loop
sube:
	inc cont
	cpi cont, 10
	breq a_dece
	reti
a_dece:
	clr cont
	reti