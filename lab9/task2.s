				AREA	myData, DATA, READONLY
GPIOA_BASE		EQU		0x48000000
RCC_BASE		EQU		0x40021000
	
GPIO_MODER		EQU		0x00
GPIO_OTYPER		EQU		0x04	
GPIO_OSPEEDR	EQU		0x08
GPIO_PUPDR		EQU		0x0C
GPIO_IDR		EQU		0x10
GPIO_ODR		EQU		0x14
	
RCC_AHB2ENR		EQU		0x4C
	
				AREA	main, CODE, READONLY
				EXPORT __main
				ENTRY
		
PIN				EQU		5
GPIO_BASE		EQU		GPIOA_BASE

Enable_Clock	PROC
	
				ldr 	r2, =RCC_BASE
				ldr 	r1, [r2, #RCC_AHB2ENR]
				orr 	r1, r1, #1
				str 	r1, [r2, #RCC_AHB2ENR]
				
				bx		lr
				ENDP

__main			PROC
				bl		Enable_Clock
				
				ldr 	r3, =GPIO_BASE
				;	set pins as output
				ldr		r1, [r3, #GPIO_MODER]
				ldr		r4, =0x0000FFFF
				bic		r1, r1, r4
				ldr		r4, =0x00005555
				orr		r1, r1, r4
				str		r1, [r3, #GPIO_MODER]
				
				; test
				
				ldr		r0, =GPIO_BASE
				ldr		r1, =0x000000FF
				str		r1, [r0, #GPIO_ODR]
				
main_loop		
				;	turn off
				LDR R0, =GPIOA_BASE
				LDR R1, =0x00000000     ; all 8 LEDs off
				STR R1, [R0, #GPIO_ODR]
				
				
				bl		delay
				
				;	turn on
				LDR R0, =GPIOA_BASE
				LDR R1, =0x0000FFFF     ; all 8 LEDs on
				STR R1, [R0, #GPIO_ODR]
				
				bl		delay
				
				b		main_loop
				
	
stop			b 	stop
				ENDP

delay			proc
				push	{r4, r5}
				
				mov		r4, #1000
outer_loop		mov 	r5, #500
inner_loop		subs	r5, r5, #1
				bne		inner_loop
				subs	r4, r4, #1
				bne		outer_loop
				
				pop		{r4, r5}
				bx		lr
				endp

				END