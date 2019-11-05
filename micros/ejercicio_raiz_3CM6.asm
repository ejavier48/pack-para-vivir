;
;  Sanchez Gama Erick Javier
;  Ortega Ramirez Angel David
;  Grupo 3CM6
;

.include "m8535def.inc"

.def dato=R16
.def aux=R17
.def cont=R18
.def unid=R19
.def dece=R20

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
    ldi R30, $2F
	clr ZH
main:
    ldi aux, low(RAMEND)
	out spl, aux
	ldi aux, high(RAMEND)
	out sph, aux
    ser dato
    out DDRA, dato ; output
    out DDRC, dato
    out PORTB, dato ; input
readNum:
    in dato, PINB
    rjmp binary
binary:
    ldi ZL, low(A<<1)
    ldi ZH, high(A<<1)
    ldi conta, 0
loop:
    lpm aux, z+
    cp dato, aux
    brsh deco
    inc conta
    rjmp loop
deco:
    ldi dece, 10
    cp dece, conta
    brsh decenas
    ldi dece, 0
    rjmp show
decenas:
    ldi dece, 1
    subi conta, 10
    rjmp show
show:
    ldi ZL, 21
    add ZL, conta
    ld unid, ZL
    out PORTC, unid
    ldi ZL, 21
    add ZL, dece
    ld unid, ZL
    out PORTA, unid
    rjmp readNum
A:
    db 1, 4, 9, 16, 25, 36, 49, 64, 81, 100, 121, 144, 169, 196, 225


