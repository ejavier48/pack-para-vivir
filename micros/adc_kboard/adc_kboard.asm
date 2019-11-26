.include "m8535def.inc"

rjmp load
.org $0E
rjmp conv

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
	ldi r16, low(ramend)
	out spl, r16
	ldi r16, high(ramend)
	out sph, r16
	ser r16
	out ddrd, r16
	out ddrb, r16
	ldi r16, $ED
	out adcsra, r16
	sei
loop:
    ldi ZL, 21
    add ZL, r17
    ld r16, z
    out PORTC, r16
	rjmp loop
conv:
	in r16, adch
	ldi r17, 0
decre:
	cpi r16, 26
	brlt end
	inc r17
	subi r16, 25
	rjmp decre
end:
	ldi r16, $ED
	out adcsra, r16
	reti
