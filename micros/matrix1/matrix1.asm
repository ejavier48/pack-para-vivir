.include "m8535def.inc"
.def row=r16
.def col=r17
.def aux=r18
.def cont=r19

rjmp main
.org $009
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
    ldi col, $80
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
    lsr col
    lpm row, z+
    reti
 restart:
    clr aux
    ldi col, $80
    ldi ZL, low(mat<<1)
    ldi ZH, high(mat<<1)
    ldi row, $00
    out porta, row
    lpm row, z+
    reti
return:
	reti
mat:
    .db $00, $7E, $42, $5A, $4A, $7A, $02, $FE