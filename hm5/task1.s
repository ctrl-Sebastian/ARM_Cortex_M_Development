				AREA	myData, DATA, READWRITE
GPIO_B_BASE		EQU		0x48000400
RCC_BASE		EQU		0x40021000
	
GPIO_MODER		equ		0x00
GPIO_IDR		equ		0x10
GPIO_ODR		equ		0x14
	
RCC_AHB2ENR		equ		0x4C
	
				AREA	readData, DATA, READONLY
				ALIGN
digit_select    DCW		0x0E00		; Thousands
				DCW     0x0D00      ; Hundreds (CA2)
                DCW     0x0B00      ; Tens     (CA3)
                DCW     0x0700      ; Ones     (CA4)
				ALIGN
						; E				C			E		blank
word_ECE		dcb		0x79,  		0x39,       0x79,		0x00
						; 2				5			1		0
word_2510		dcb		0x5B,		0x6D, 		0x06,		0x3F

				
				AREA	myCode, CODE, READONLY
				EXPORT	__main
				ENTRY

enable_clock	proc
	
				ldr		r2, =RCC_BASE
				ldr		r1, [r2, #RCC_AHB2ENR]
				orr		r1, r1, #0x06				;0110	(bit 1 & bit 2)
				str		r1, [r2, #RCC_AHB2ENR]
				bx		lr

				endp

setup_gpio		proc
	
				;		configuring port b 12 pins as output
				ldr		r0, =GPIO_B_BASE
				ldr		r1, [r0, #GPIO_MODER]
				ldr		r2, =0x00FFFFFF
				bic		r1, r1, r2
				ldr		r2, =0x00555555
				orr		r1, r1, r2
				str		r1, [r0, #GPIO_MODER]
				
				bx		lr
				endp

__main			proc

				bl		enable_clock
				bl		setup_gpio

loop			
				ldr 	r9, =100
mux_1sec_ece	
				ldr		r0, =word_ECE
				bl		display_word
				subs	r9, r9, #1
				bne		mux_1sec_ece
				
				bl		display_blank
				bl		delay_1sec
				
				ldr 	r9, =100
				
mux_1sec_2510	
				ldr		r0, =word_2510
				bl		display_word
				subs	r9, r9, #1
				bne		mux_1sec_2510
				
				bl		display_blank
				bl		delay_1sec
				
				b		loop

				endp

display_blank	proc
				ldr     r0, =GPIO_B_BASE
                ldr     r1, =0x00000FFF
                ldr     r2, [r0, #GPIO_ODR]
                bic     r2, r2, r1
                ldr     r1, =0x00000F00
                orr     r2, r2, r1
                str     r2, [r0, #GPIO_ODR]
                bx      lr
				endp

display_word	proc
				push    {r4-r8, lr}
				mov		r4, r0					; copying digit pointer to r4				; r5 = loop index

				ldr     r6, =GPIO_B_BASE
                ldr     r7, =digit_select
				
				
				mov		r5, #0					; 0 through 3 loop					
mux_loop		cmp		r5, #3
				bgt		mux_finish	

				ldrb	r1, [r4, r5]			; load segment pattern in position 
												; of digit to display
												
				ldrh	r2, [r7, r5, lsl #1]	; load the digit select half word
				
				; combination of segment pattern and digit selection
				orr		r1, r1, r2
				ldr		r3, =0x00000FFF
				ldr		r0, [r6, #GPIO_ODR]
				bic		r0, r0, r3
				orr		r0, r0, r1
				str		r0, [r6, #GPIO_ODR]
				
				bl		delay_2ms	
				
				; turn off display
				ldr		r3, =0x00000FFF
				ldr		r0, [r6, #GPIO_ODR]
				bic		r0, r0, r3
				ldr     r3, =0x00000F00         ; turn off digits    1000      0000 0000
                orr     r0, r0, r3            ;						4digits    8 segments
				str		r0, [r6, #GPIO_ODR]
				
				
				add		r5, r5, #1
				b		mux_loop	
						
mux_finish		pop 	{r4-r8, pc}			
				endp

;		delays

delay_2ms       PROC
                push    {r4, r5}
                mov     r4, #10
outer_2ms       mov     r5, #400 
inner_2ms       subs    r5, r5, #1
                bne     inner_2ms
                subs    r4, r4, #1
                bne     outer_2ms
                pop     {r4, r5}
                bx      lr
                ENDP
                    
delay_1sec      PROC
                push    {r4, r5}
                mov     r4, #500
outer_1sec      mov     r5, #2500 
inner_1sec      subs    r5, r5, #1
                bne     inner_1sec
                subs    r4, r4, #1
                bne     outer_1sec
                pop     {r4, r5}
                bx      lr
                ENDP

                ALIGN
                END