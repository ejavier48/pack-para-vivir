	.include "m8535def.inc"
	.def aux = r16
	.def col = r17
	.def aux2 = r18
	.def aux3 = r19

	rjmp main
	.org $08
	rjmp scroll
	rjmp barre
main: 
	ldi aux,low(RAMEND)
	out spl,aux
	ldi aux,high(RAMEND)
	out sph,aux
	ser aux
	out DDRA,aux
	out DDRC,aux
	ldi aux,$40
	mov r0,aux
	ldi aux,$76
	mov r1,aux
	ldi aux,$5c
	mov r2,aux
	ldi aux,$30
	mov r3,aux
	ldi aux,$5f
	mov r4,aux
	ldi aux,$40
	mov r5,aux
	ldi aux,1
	out TCCR0,aux
	ldi aux,2
	out TCCR1B,aux
	ldi aux,5
	out TIMSK,aux
	sei
	clr zh
	ldi zl,5
	ldi col,$40
uno: 
	out PORTC,col
	ld aux,z
	out PORTA,aux
	rjmp uno
barre: 
	ldi aux2,192
	out TCNT0,aux2
	out PORTA,zh
	lsr col
	brcs dos
	dec zl
	reti
dos: 
	ldi col,$40
	ldi zl,5
	reti
scroll: 
	mov aux3,r5
	mov r5,r4
	mov r4,r3
	mov r3,r2
	mov r2,r1
	mov r1,r0
	mov r0,aux3 
	reti
