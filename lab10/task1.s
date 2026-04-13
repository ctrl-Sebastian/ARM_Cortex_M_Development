				AREA	myData, DATA, READWRITE
GPIO_B_BASE		EQU		0x48000400
GPIO_C_BASE		EQU		0x48000800
RCC_BASE		EQU		0x40021000
	
GPIO_MODER		equ		0x00
GPIO_PUPDR		equ		0x0C
GPIO_IDR		equ		0x10
GPIO_ODR		equ		0x14
	
RCC_AHB2ENR		equ		0x4C
				
				AREA	myCode, CODE, READONLY
					
;						   0	 1	   2	 3	   4	 5	   6	 7	   8	 9
seg_patterns    DCB     0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F
				ALIGN
digit_select    DCW     0x0D00      ; Hundreds (CA2)
                DCW     0x0B00      ; Tens     (CA3)
                DCW     0x0700      ; Ones     (CA4)
				
				EXPORT	main
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
				;		configuring port c 8 pins as inputs
				ldr		r0, =GPIO_C_BASE
				ldr		r1, [r0, #GPIO_MODER]
				ldr		r2, =0x0000FFFF				; clearing first 8 bits (00 = inputs)
				bic		r1, r1, r2
				str		r1, [r0, #GPIO_MODER]
				
				;		turn on internal pull up resistors for dip switch
				ldr		r1, [r0, #GPIO_PUPDR]
				ldr		r2, =0x0000FFFF				; repeating for clarity
				bic		r1, r1, r2					; clearing lower word
				ldr		r2, =0x00005555				
				orr		r1, r1, r2					; set lower 8 pins as 01
				str		r1, [r0, #GPIO_PUPDR]
				
				bx		lr
				endp


main			proc

				bl		enable_clock
				bl		setup_gpio
				
display			ldr		r0, =GPIO_C_BASE
				ldr		r1, [r0, #GPIO_IDR]
				and		r1, r1, #0xFF			; use only first 8 bits (8 switches)
												
												; exclusive or to turn the 0's to 1's
				eor		r1, r1, #0xFF			; bits are 0's when SW is selected
				
				mov		r2, #0					; counter for hundreds for display
				mov		r3, #0					; counter for tenths for display
												; at the end, r1 will hold the units
				
calc_100s		cmp		r1, #100
				blt		calc_10s
				sub		r1, r1, #100
				add		r2, r2, #1
				b		calc_100s
				
calc_10s		cmp		r1, #10
				blt		done_calc
				sub		r1, r1, #10
				add		r3, r3, #1
				b		calc_10s

				push	{r1, r3, r2}			; pushing the values to display
												; to the stack in order:
												;	R1         R2        R3
												; units -> hundreds -> tenths 
												; +0		+4		   +8
done_calc
				mov		r4, #0
				ldr		r5, =GPIO_B_BASE
				ldr		r6, =seg_patterns
				ldr		r7, =digit_select
				
				
mux_loop		cmp		r4, #2
				bgt		mux_finish	

				ldr		r8, [sp, r4, lsl #2]	; get digit
				ldrb	r9, [r6, r8]			; load segment pattern in position 
												; of digit to display
												
				ldrh	r10, [r7, r4, lsl #1]	; load the digit select half word
				
				; combination of segment pattern and digit selection
				orr		r9, r9, r10
				ldr		r11, =0x00000FFF
				ldr		r12, [r5, #GPIO_ODR]
				bic		r12, r12, r11
				orr		r12, r12, r9
				str		r12, [r5, #GPIO_ODR]
				
				bl		delay
				
				; turn off display
				ldr		r11, =0x00000FFF
				ldr		r12, [r5, #GPIO_ODR]
				bic		r12, r12, r11
				ldr     r11, =0x00000F00         ; turn off digits		 1000      0000 0000
                orr     r12, r12, r11            ;						4digits    8 segments
				str		r12, [r5, #GPIO_ODR]
				
				add		r4, r4, #1
				b		mux_loop
				
				
												; restore stack
mux_finish		add		sp, sp, #12				; i stored 3 registers
				b		display					; 3 * 4 = 12

				endp
					
;	----------------------------------
;				delay func
;	----------------------------------

delay           proc
                push    {r4, r5}
				
                mov     r4, #10
outer_loop      mov     r5, #500 

inner_loop      subs    r5, r5, #1
                bne     inner_loop
                subs    r4, r4, #1
                bne     outer_loop
				
                pop     {r4, r5}
                bx      lr
                endp

				ALIGN
				END