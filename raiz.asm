;
;  Sanchez Gama Erick Javier
;  Ortega Ramirez Angel David
;  Grupo 3CM6
;

.include "m8535def.inc"

.def dato=R16
.def aux=R17
.def conta=R18
.def uni=R19
.def dece=R20

main:
    ldi aux, low(RAMEND)
	out spl, aux
	ldi aux, high(RAMEND)
	out sph, aux
    ser dato
    out DDRA, dato; output
    out DDRC, dato
    out PORTB, dato; input
readNum:
    in aux, PINB
    rjmp binary
binary:
    clr dece
    clr uni
	cpi aux, 1
	brlo print0
    cpi aux, 3
    brlo print1
    cpi aux, 8
    brlo print2
    cpi aux, 15
    brlo print3
    cpi aux, 24
    brlo print4
    cpi aux, 35
    brlo print5    
    cpi aux, 48
    brlo print6
    cpi aux, 63
    brlo print7
    cpi aux, 80
    brlo print8
    cpi aux, 99
    brlo print9
    cpi aux, 120
    brlo printA
    cpi aux, 143
    brlo printB 
    cpi aux, 168
    brlo printC
    cpi aux, 195
    brlo printD 
    cpi aux, 224
    brlo printE
    rjmp printF
print0:
    ldi dece, $3F
    ldi uni, $3F 
    rjmp show
print1:
    ldi dece, $3F
    ldi uni, $06 
    rjmp show
print2:
    ldi dece, $3F
    ldi uni, $5B
    rjmp show
print3:
    ldi dece, $3F 
    ldi uni, $4F
    rjmp show
print4:
    ldi dece, $3F 
    ldi uni, $66
    rjmp show
print5:
    ldi dece, $3F 
    ldi uni, $6D
    rjmp show
print6:
    ldi dece, $3F 
    ldi uni, $7D
    rjmp show
print7:
    ldi dece, $3F
    ldi uni, $27
    rjmp show
print8:
    ldi dece, $3F
    ldi uni, $7F
    rjmp show
print9:
    ldi dece, $3F
    ldi uni, $2F
    rjmp show
printA:
    ldi dece, $06
    ldi uni, $3F
    rjmp show
printB:
    ldi dece, $06
    ldi uni, $06 
    rjmp show
printC:
    ldi dece, $06
    ldi uni, $5B
    rjmp show
printD:
    ldi dece, $06 
    ldi uni, $4F
    rjmp show
printE:
    ldi dece, $06 
    ldi uni, $66
    rjmp show
printF:
    ldi dece, $06 
    ldi uni, $6D
    rjmp show
show:
	com uni
    out PORTC, uni
	com dece 
    out PORTA, dece
    rjmp readNum