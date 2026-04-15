				AREA	myData, DATA, READWRITE
GPIO_B_BASE		EQU		0x48000400
RCC_BASE		EQU		0x40021000
	
GPIO_MODER		equ		0x00
GPIO_IDR		equ		0x10
GPIO_ODR		equ		0x14
	
RCC_AHB2ENR		equ		0x4C
	
				AREA	readData, DATA, READONLY
;						   0	 1	   2	 3	   4	 5	   6	 7	   8	 9
seg_patterns    DCB     0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F
				ALIGN
digit_select    DCW     0x0D00      ; Hundreds (CA2)
                DCW     0x0B00      ; Tens     (CA3)
                DCW     0x0700      ; Ones     (CA4)
				ALIGN
array			dcd		0x00, 0x01, 0x02
;array			dcd		0x05, 0x06, 0x07, 0x08, 0x0f, 0x11
size			equ		10
				
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
				ldr		r0, =array
reset_loop		mov		r1, #0
display_loop		
				cmp		r1, #size
				bgt		reset_loop
				
				; get the number from the array into R1

				ldr		r2, [r0, r1, lsl #1]	; r2 holds the current number

				bl		calc_digits				; process r2, r3 & r4
				
												; pushing the values to display
				str     r4, [sp, #0]     		; +0 = Hundreds (r4 = 0)
                str     r3, [sp, #4]     		; +4 = Tens     (r4 = 1)
                str     r2, [sp, #8]     		; +8 = Ones     (r4 = 2)	
				
				ldr		r5, =GPIO_B_BASE
				ldr		r6, =seg_patterns
				ldr		r7, =digit_select
				
				bl		display_number			;
				bl		delay_1sec				; turn on
				bl		display_blank			;
				;bl		delay_1sec				; turn off
				
				add		r1, r1, #1
				b		display_loop


				endp

display_blank	proc
	
				push 	{r4-r7}
				
				ldr		r4, =0x00000F00
				str		r4, [r5, #GPIO_ODR]
				
				pop		{r4-r7}
				bx		lr
	
				endp

display_number	proc
				mov		r4, #0
				
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
				push	{lr}
				bl		delay_2ms
				pop		{lr}				
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
mux_finish		add		sp, sp, #12				; clean the 3 digits from the current number stored in stack

				bx		lr						
				
				endp

; calc digits return by registers
calc_digits		proc
				
calc_100s		cmp		r2, #100
				blt		calc_10s
				sub		r2, r2, #100
				add		r4, r4, #1				; r4 storing hundreds
				b		calc_100s
				
calc_10s		cmp		r4, #10
				blt		done
				sub		r2, r2, #10
				add		r3, r3, #1				; r3 storing tens
				b		calc_10s
done			bx		lr					
				endp

				
;	----------------------------------
;				delay func
;	----------------------------------

delay_2ms	    proc
                push    {r4, r5}
				
                mov     r4, #10
outer_2ms      	mov     r5, #500 

inner_2ms      	subs    r5, r5, #1
                bne     inner_2ms
                subs    r4, r4, #1
                bne     outer_2ms
				
                pop     {r4, r5}
				bx		lr
                endp

;	1 second delay func
					
delay_1sec		proc
                push    {r4, r5}
				
                mov     r4, #1000
outer_1sec      mov     r5, #500 

inner_1sec      subs    r5, r5, #1
                bne     inner_1sec
                subs    r4, r4, #1
                bne     outer_1sec
				
                pop     {r4, r5}
                bx      lr
                endp

				ALIGN
				END