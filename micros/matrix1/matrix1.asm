;
;	Authors: Equípo 1
;   Date: 19/11/19
;
.include "m8535def.inc"
.def row=r16
.def col=r17
.def aux=r18
.def cont=r19

rjmp main
.org $9
rjmp change

main:
    ldi row, low(RAMEND)
    out spl, row
    ldi row, high(RAMEND)
    out sph, row
    ser row
    out ddra, row
    out ddrc, row
    ldi row, 2
    out tccr0, row
    ldi row, 1
    out timsk, row
    ldi ZL, low(mat<<1)
    ldi ZH, high(mat<<1)
    lpm row, z+
    ldi col, $01
    ldi aux, $00
	ldi cont, $00
    sei
loop:
    out porta, row
    out portc, col
    rjmp loop
change:
	inc cont
	cpi cont, 2
	brlo return
	clr cont
    inc aux
    cpi aux, 8
    brsh restart
    ldi row, $00
    out porta, row
    lsl col
    lpm row, z+
    reti
 restart:
    clr aux
    ldi col, $01
    ldi ZL, low(mat<<1)
    ldi ZH, high(mat<<1)
    ldi row, $00
    out porta, row
    lpm row, z+
    reti
return:
	reti
mat:
	.db $FF, $7E, $3C, $18, $3C, $7E, $FF, $00
;cols      0,   1,   2,   3,   4,   5,   6,   7
