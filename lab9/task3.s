; ============================================================
; 7-Segment + LED Binary Counter - STM32L476RG
; ============================================================
; 7-seg shows 0-9 on digit 1 (leftmost)
; LEDs show binary representation of same number on PA0-PA7
; Increments every ~1 second
; ============================================================

	AREA mydata, DATA, READONLY

; Segment patterns for 0-9, active HIGH common cathode
; Bit order: dp g f e d c b a
seg_patterns	DCB		0x3F	; 0 = a,b,c,d,e,f
				DCB		0x06	; 1 = b,c
				DCB		0x5B	; 2 = a,b,d,e,g
				DCB		0x4F	; 3 = a,b,c,d,g
				DCB		0x66	; 4 = b,c,f,g
				DCB		0x6D	; 5 = a,c,d,f,g
				DCB		0x7D	; 6 = a,c,d,e,f,g
				DCB		0x07	; 7 = a,b,c
				DCB		0x7F	; 8 = a,b,c,d,e,f,g
				DCB		0x6F	; 9 = a,b,c,d,f,g

; Active LOW digit select - only using digit 1 (CA1)
; CA1=PB8 LOW, rest HIGH
digit_select	DCW		0x0E00

; Register definitions
RCC_AHB2ENR		EQU		0x4002104C
GPIOAEN			EQU		(1<<0)
GPIOBEN			EQU		(1<<1)

GPIOA_BASE		EQU		0x48000000
GPIOB_BASE		EQU		0x48000400
GPIO_MODER		EQU		0x00
GPIO_ODR		EQU		0x14

; 
; adjust to 80000000 if running at 80MHz
ONE_SECOND		EQU		1000		;
MUX_DELAY		EQU		2000

	AREA mycode, CODE, READONLY
	EXPORT __main
	ENTRY

__main

; --- Enable GPIOA and GPIOB clocks ---
	LDR		R0, =RCC_AHB2ENR
	LDR		R1, [R0]
	ORR		R1, R1, #GPIOAEN
	ORR		R1, R1, #GPIOBEN
	STR		R1, [R0]

; --- Configure PA0-PA7 as outputs (LEDs) ---
	LDR		R0, =GPIOA_BASE
	LDR		R1, [R0, #GPIO_MODER]
	LDR		R2, =0x0000FFFF	
	BIC		R1, R1, R2
	LDR		R2, =0x00005555
	ORR		R1, R1, R2
	STR		R1, [R0, #GPIO_MODER]

; --- Configure PB0-PB11 as outputs (7-seg) ---
	LDR		R0, =GPIOB_BASE
	LDR		R1, [R0, #GPIO_MODER]
	LDR		R2, =0x00FFFFFF
	BIC		R1, R1, R2
	LDR		R2, =0x00555555
	ORR		R1, R1, R2
	STR		R1, [R0, #GPIO_MODER]

; --- Cache base addresses ---
	LDR		R4, =GPIOA_BASE
	LDR		R5, =GPIOB_BASE

; --- Load array addresses ---
	LDR		R6, =seg_patterns
	LDR		R7, =digit_select

; --- R8 = current count (0-9) ---
	MOV		R8, #0

; --- R9 = 1 second tick counter ---
	LDR		R9, =ONE_SECOND

; ============================================================
; Main loop - multiplex 7-seg while counting
; ============================================================
main_loop

; --- Update LEDs with binary value of current count ---
	LDR		R1, [R4, #GPIO_ODR]
	BIC		R1, R1, #0xFF
	ORR		R1, R1, R8			; R8 = count, maps directly to PA0-PA7
	STR		R1, [R4, #GPIO_ODR]

; --- Load segment pattern for current count ---
	LDRB	R10, [R6, R8]

; --- Load digit select (always digit 1) ---
	LDRH	R11, [R7]

; --- Combine and write to 7-seg ODR ---
	ORR		R10, R10, R11
	LDR		R1, =0x00000FFF
	LDR		R2, [R5, #GPIO_ODR]
	BIC		R2, R2, R1
	ORR		R2, R2, R10
	STR		R2, [R5, #GPIO_ODR]

; --- MUX delay (keep digit lit) ---
	LDR		R3, =MUX_DELAY
mux_delay_loop
	SUBS	R3, R3, #1
	BNE		mux_delay_loop

; --- Blank 7-seg ---
	LDR		R1, =0x00000FFF
	LDR		R2, [R5, #GPIO_ODR]
	BIC		R2, R2, R1
	STR		R2, [R5, #GPIO_ODR]

; --- Decrement 1 second counter ---
	SUBS	R9, R9, #1
	BNE		main_loop			; not 1 second yet, keep multiplexing

; --- 1 second elapsed - advance count ---
	LDR		R9, =ONE_SECOND		; reset tick counter
	ADD		R8, R8, #1			; increment count
	CMP		R8, #10
	MOVGE	R8, #0				; wrap back to 0 after 9

	B		main_loop

deadloop
	B		deadloop

	END