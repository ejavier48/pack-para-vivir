;
; practica2.asm
;
; Created: 9/2/2019 10:13:12 PM
; Au
;
.include "m8535def.inc"
.def hex = R16
.def ascii = R17
.def aux = R18

ser hex
ser ascii

out DDRA, hex
out PORTB, hex

out DDRC, ascii
out PORTD, ascii

ascii2hex:
	in ascii, PIND
	ldi aux, $30
	add ascii, aux
	cpi ascii, $3A
	brsh letrahex
showhex:
	out PORTC, ascii
	rjmp hex2ascii
letrahex:
	ldi aux, $7
	add ascii, aux
	rjmp showhex
hex2ascii:
	in hex, PINB
	subi hex, $30
	cpi hex, $11
	brsh letraascii
showascii:
	out PORTA, hex
	rjmp ascii2hex
letraascii:
	subi hex, $7
	rjmp showascii
