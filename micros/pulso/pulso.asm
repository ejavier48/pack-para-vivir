.include "m8535def.inc"
.def aux = r16
.macro pulso
    sbi porta, 0
    ldi aux, @0
    loop1:
        rcall delay
        dec aux
        brne loop1
        cbi porta, 0
        ldi aux, @1
    loop2:
        rcall delay
        dec aux
        brne loop2
        rjmp otro
.endmacro
main:
    ldi aux, low(ramend)
    out spl, aux
    ldi aux, high(ramend)
    out sph, aux
    ser aux
    out ddra, aux
    out portd, aux
otro:
    sbis pind, 5
    rjmp cero
    sbis pind, 6
    rjmp uno
    sbis pind, 7
    rjmp dos
    rjmp otro
cero:
    pulso 2, 38
uno:
    pulso 3, 37
dos:
    pulso 4, 36
delay:
    ldi  r18, 166
L1: 
    dec  r18
    brne L1
    ret
