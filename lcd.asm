.include "m8535def.inc"
.equ	LCD_RS	= 1
.equ	LCD_RW	= 2
.equ	LCD_E	= 3

.def	temp	= r16
.def	argument= r17		;argument for calling subroutines
.def	return	= r18		;return value from subroutines

.org 0
rjmp reset

reset:
	ldi	temp, low(RAMEND)
	out	SPL, temp
	ldi	temp, high(RAMEND)
	out	SPH, temp
	
	rcall	LCD_init
	
	rcall	LCD_wait
	ldi	argument, 'N'	;write 'A' to the LCD char data RAM
	rcall	LCD_putchar
	ldi	argument, 'I'	;write 'A' to the LCD char data RAM
	rcall	LCD_putchar
	ldi	argument, 'N'	;write 'A' to the LCD char data RAM
	rcall	LCD_putchar
	ldi	argument, 'J'	;write 'A' to the LCD char data RAM
	rcall	LCD_putchar
	ldi	argument, 'A'	;write 'A' to the LCD char data RAM
	rcall	LCD_putchar
	ldi	argument, 'R'	;write 'A' to the LCD char data RAM
	rcall	LCD_putchar
	ldi	argument, 'E'	;write 'A' to the LCD char data RAM
	rcall	LCD_putchar
	ldi	argument, 'F'	;write 'A' to the LCD char data RAM
	rcall	LCD_putchar
	ldi	argument, ':'	;write 'A' to the LCD char data RAM
	rcall	LCD_putchar
	ldi	argument, ')'	;write 'A' to the LCD char data RAM
	rcall	LCD_putchar
	
	rcall	LCD_wait
loop:	rjmp loop

lcd_command8:	;used for init (we need some 8-bit commands to switch to 4-bit mode!)
	in	temp, DDRD		;we need to set the high nibble of DDRD while leaving
					;the other bits untouched. Using temp for that.
	sbr	temp, 0b11110000	;set high nibble in temp
	out	DDRD, temp		;write value to DDRD again
	in	temp, PortD		;then get the port value
	cbr	temp, 0b11110000	;and clear the data bits
	cbr	argument, 0b00001111	;then clear the low nibble of the argument
					;so that no control line bits are overwritten
	or	temp, argument		;then set the data bits (from the argument) in the
					;Port value
	out	PortD, temp		;and write the port value.
	sbi	PortD, LCD_E		;now strobe E
	nop
	nop
	nop
	cbi	PortD, LCD_E
	in	temp, DDRD		;get DDRD to make the data lines input again
	cbr	temp, 0b11110000	;clear data line direction bits
	out	DDRD, temp		;and write to DDRD
ret

lcd_putchar:
	push	argument		;save the argmuent (it's destroyed in between)
	in	temp, DDRD		;get data direction bits
	sbr	temp, 0b11110000	;set the data lines to output
	out	DDRD, temp		;write value to DDRD
	in	temp, PortD		;then get the data from PortD
	cbr	temp, 0b11111110	;clear ALL LCD lines (data and control!)
	cbr	argument, 0b00001111	;we have to write the high nibble of our argument first
					;so mask off the low nibble
	or	temp, argument		;now set the argument bits in the Port value
	out	PortD, temp		;and write the port value
	sbi	PortD, LCD_RS		;now take RS high for LCD char data register access
	sbi	PortD, LCD_E		;strobe Enable
	nop
	nop
	nop
	cbi	PortD, LCD_E
	pop	argument		;restore the argument, we need the low nibble now...
	cbr	temp, 0b11110000	;clear the data bits of our port value
	swap	argument		;we want to write the LOW nibble of the argument to
					;the LCD data lines, which are the HIGH port nibble!
	cbr	argument, 0b00001111	;clear unused bits in argument
	or	temp, argument		;and set the required argument bits in the port value
	out	PortD, temp		;write data to port
	sbi	PortD, LCD_RS		;again, set RS
	sbi	PortD, LCD_E		;strobe Enable
	nop
	nop
	nop
	cbi	PortD, LCD_E
	cbi	PortD, LCD_RS
	in	temp, DDRD
	cbr	temp, 0b11110000	;data lines are input again
	out	DDRD, temp
ret

lcd_command:	;same as LCD_putchar, but with RS low!
	push	argument
	in	temp, DDRD
	sbr	temp, 0b11110000
	out	DDRD, temp
	in	temp, PortD
	cbr	temp, 0b11111110
	cbr	argument, 0b00001111
	or	temp, argument

	out	PortD, temp
	sbi	PortD, LCD_E
	nop
	nop
	nop
	cbi	PortD, LCD_E
	pop	argument
	cbr	temp, 0b11110000
	swap	argument
	cbr	argument, 0b00001111
	or	temp, argument
	out	PortD, temp
	sbi	PortD, LCD_E
	nop
	nop
	nop
	cbi	PortD, LCD_E
	in	temp, DDRD
	cbr	temp, 0b11110000
	out	DDRD, temp
ret

LCD_getchar:
	in	temp, DDRD		;make sure the data lines are inputs
	andi	temp, 0b00001111	;so clear their DDR bits
	out	DDRD, temp
	sbi	PortD, LCD_RS		;we want to access the char data register, so RS high
	sbi	PortD, LCD_RW		;we also want to read from the LCD -> RW high
	sbi	PortD, LCD_E		;while E is high
	nop
	in	temp, PinD		;we need to fetch the HIGH nibble
	andi	temp, 0b11110000	;mask off the control line data
	mov	return, temp		;and copy the HIGH nibble to return
	cbi	PortD, LCD_E		;now take E low again
	nop				;wait a bit before strobing E again
	nop	
	sbi	PortD, LCD_E		;same as above, now we're reading the low nibble
	nop
	in	temp, PinD		;get the data
	andi	temp, 0b11110000	;and again mask off the control line bits
	swap	temp			;temp HIGH nibble contains data LOW nibble! so swap
	or	return, temp		;and combine with previously read high nibble
	cbi	PortD, LCD_E		;take all control lines low again
	cbi	PortD, LCD_RS
	cbi	PortD, LCD_RW
ret					;the character read from the LCD is now in return

LCD_getaddr:	;works just like LCD_getchar, but with RS low, return.7 is the busy flag
	in	temp, DDRD
	andi	temp, 0b00001111
	out	DDRD, temp
	cbi	PortD, LCD_RS
	sbi	PortD, LCD_RW
	sbi	PortD, LCD_E
	nop
	in	temp, PinD
	andi	temp, 0b11110000
	mov	return, temp
	cbi	PortD, LCD_E
	nop
	nop
	sbi	PortD, LCD_E
	nop
	in	temp, PinD
	andi	temp, 0b11110000
	swap	temp
	or	return, temp
	cbi	PortD, LCD_E
	cbi	PortD, LCD_RW
ret

LCD_wait:				;read address and busy flag until busy flag cleared
	rcall	LCD_getaddr
	andi	return, 0x80
	brne	LCD_wait
	ret


LCD_delay:
	clr	r2
	LCD_delay_outer:
	clr	r3
		LCD_delay_inner:
		dec	r3
		brne	LCD_delay_inner
	dec	r2
	brne	LCD_delay_outer
ret

LCD_init:
	
	ldi	temp, 0b00001110	;control lines are output, rest is input
	out	DDRD, temp
	
	rcall	LCD_delay		;first, we'll tell the LCD that we want to use it
	ldi	argument, 0x20		;in 4-bit mode.
	rcall	LCD_command8		;LCD is still in 8-BIT MODE while writing this command!!!

	rcall	LCD_wait
	ldi	argument, 0x28		;NOW: 2 lines, 5*7 font, 4-BIT MODE!
	rcall	LCD_command		;
	
	rcall	LCD_wait
	ldi	argument, 0x0F		;now proceed as usual: Display on, cursor on, blinking
	rcall	LCD_command
	
	rcall	LCD_wait
	ldi	argument, 0x01		;clear display, cursor -> home
	rcall	LCD_command
	
	rcall	LCD_wait
	ldi	argument, 0x06		;auto-inc cursor
	rcall	LCD_command
ret