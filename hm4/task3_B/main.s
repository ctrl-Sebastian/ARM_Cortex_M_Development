;ARM assembly code shell

        PRESERVE8
        THUMB

; Vector Table
        AREA    RESET, DATA, READONLY
        EXPORT  __Vectors

__Vectors
        DCD     0x20018000          ; Top of Stack (96KB RAM)
        DCD     Reset_Handler       ; Reset Handler
			
			
		AREA 	mydata, DATA, READONLY
; RCC
RCC_AHB2ENR		equ		0x4002104C	; peripheral clock enable register
GPIOBEN         equ     (1<<1)
GPIOB_BASE      equ     0x48000400
GPIO_MODER      equ     0x00
GPIO_ODR        equ     0x14


MUX_DELAY       equ     2000    ; Delay to keep each digit lit
HALF_SECOND     equ     250     ; Number of full 4-digit passes to equal ~0.5s


beef_patterns   dcb     0x7C, 0x79, 0x79, 0x71  ; b, E, E, F
cafe_patterns   dcb     0x39, 0x77, 0x71, 0x79  ; C, A, F, E
off_patterns    dcb     0x00, 0x00, 0x00, 0x00  ; All OFF

; --- Digit Selectors (Active LOW) ---
digit_select    dcw     0x0E00      ; CA1 (PB8=0)
                dcw     0x0D00      ; CA2 (PB9=0)
                dcw     0x0B00      ; CA3 (PB10=0)
                dcw     0x0700      ; CA4 (PB11=0)

        AREA    |.text|, CODE, READONLY

; Reset Handler
Reset_Handler   PROC
                EXPORT  Reset_Handler
                BL      main            
                b       .
                ENDP


main            PROC
                EXPORT  main

				ldr     r4, =RCC_AHB2ENR
				ldr     r1, [r4]
				orr     r1, r1, #GPIOBEN
				str     r1, [r4]

				ldr     r4, =GPIOB_BASE
				ldr     r5, [r4, #GPIO_MODER]
				ldr     r6, =0x00FFFFFF
				bic     r5, r5, r6
				ldr     r6, =0x00555555
				orr     r5, r5, r6
				str     r5, [r4, #GPIO_MODER]
			   

				ldr     r0, =GPIOB_BASE     
				ldr     r12, =digit_select  
				
				mov     r4, #0              ; r4 = Current State (0=BEEF, 1=OFF, 2=CAFE, 3=OFF)
				ldr     r5, =HALF_SECOND    ; r5 = Tick counter for 0.5s delay
		
state_check
				cmp     r4, #0
				ldreq   r6, =beef_patterns  ; r6 holds the active word pointer
				
				cmp     r4, #1
				ldreq   r6, =off_patterns
				
				cmp     r4, #2
				ldreq   r6, =cafe_patterns
				
				cmp     r4, #3
				ldreq   r6, =off_patterns
	   
mux_start
				mov     r7, #0              ; r7 = Digit index (0 to 3)
		
digit_loop
				cmp     r7, #4
				bge     tick_check          ; If all 4 digits are drawn, check the timer

				ldrb    r8, [r6, r7]

				lsl     r9, r7, #1          ; increase index i
				ldrh    r9, [r12, r9]

				orr     r10, r8, r9

				ldr     r1, =0x00000FFF
				ldr     r2, [r0, #GPIO_ODR]
				bic     r2, r2, r1
				orr     r2, r2, r10
				str     r2, [r0, #GPIO_ODR]

				ldr     r11, =MUX_DELAY		; keep digit lit
				
mux_delay_loop
				subs    r11, r11, #1
				bne     mux_delay_loop

				ldr     r1, =0x00000FFF
				ldr     r2, [r0, #GPIO_ODR]
				bic     r2, r2, r1
				str     r2, [r0, #GPIO_ODR]

				add     r7, r7, #1
				b       digit_loop
				
tick_check
				subs    r5, r5, #1
				bne     mux_start         

				ldr     r5, =HALF_SECOND 
				add     r4, r4, #1          ; move to next state
				cmp     r4, #4
				movge   r4, #0              ; Wrap back to State 0 after State 3

				b       state_check         ; Loop forever
		
deadloop		b		deadloop
		
                BX      LR              ; Return from main
                ENDP
                ALIGN
                END