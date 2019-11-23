;
;	Authors: Equípo 1
;   Date: 19/11/19
;
.include "m8535def.inc"
.def row=r16
.def col=r17
.def aux=r18
.def cont=r19
.def offset=r20
.def times=r21

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
	inc times
	cpi times, 50
	brsh move
    ldi row, $00
    out porta, row
	add ZL, offset
    lpm row, z+
    reti
move: ;move the figure one val at a time 
	inc offset
	cpi offset, 17
	brsh again
	clr times
    ldi row, $00
    out porta, row
	add ZL, offset
    lpm row, z+
    reti
again: ; Restart from first figure
	clr times
	clr offset
    ldi row, $00
    out porta, row
	add ZL, offset
    lpm row, z+
    reti
return:
	reti
mat:
	.db $18, $24, $42, $81, $81, $42, $24, $18, $18, $3C, $66, $C3, $C3,  $66, $3C, $18, $18, $3C, $7E, $E7, $E7, $7E , $3C, $18
	;cols      0,   1,   2,   3,   4,   5,   6,   7   
