;
; practica1.asm
;
; Created: 9/3/2019 9:06:05 AM
; Author : EliteBook
;
.include "m8535def.inc"


ser R16 

out DDRA, R16

out DDRC, R16

out PORTB, R16

out PORTD, R16


main: 
	
	in R16, PINB
	
	in R17, PIND
	
	add R16, R17
	
	out PORTA, R16
	
	in R16, SREG
	
	out PORTC, R16
	
	rjmp main
