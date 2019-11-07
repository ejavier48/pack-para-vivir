.include "m8535def.inc"
.def row=r16
.def col=r17
.def aux=r18

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
    ldi row, 3
    out tccr0, row
    ldi row, 1
    out timsk, row
    ldi ZL, (mat<<1)
    ldi ZH, (mat<<1)
    lpm row, z+
    ldi col, $7F
    ldi aux, $00
    sec
    sei
loop:
    out porta, row
    out portc, col
    rjmp loop
change:
    inc aux
    cpi aux, 8
    brsh restart
    sec
    ldi row, $00
    out porta, row
    ror col
    lpm row, z+
    reti
 restart:
    clr aux
    ldi col, $7F
    ldi ZL, (mat<<1)
    ldi ZH, (mat<<1)
	sec
    ldi row, $00
    out porta, row
    ror col
    lpm row, z+
    reti
mat:
    .db $FF, $81, $BD, $A5, $B5, $85, $FD, $01
