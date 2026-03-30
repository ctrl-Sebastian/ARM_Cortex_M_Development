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
RCC_AHB2ENR		EQU		0x4002104C	; peripheral clock enable register

; GPIOA
GPIOA_BASE		EQU		0x48000000	; base address for GPIOA
GPIO_MODER		EQU		0x00		; offset: mode register (input/output/etc)
GPIO_ODR		EQU		0x14		; offset: output data register

; Clock enable bits
GPIOAEN			EQU		(1<<0)		; bit 0 of RCC_AHB2ENR enables GPIOA clock


        AREA    |.text|, CODE, READONLY

; Reset Handler
Reset_Handler   PROC
                EXPORT  Reset_Handler
                BL      main            
                B       .
                ENDP


main            PROC
                EXPORT  main
                ; Enable GPIOA clock
				; Must be done before any GPIO register access
				LDR		R4, =RCC_AHB2ENR	; R4 = address of clock enable register
				LDR		R1, [R4]			; read current value (don't clobber other bits)
				ORR		R1, R1, #GPIOAEN	; set bit 0 to enable GPIOA clock
				STR		R1, [R4]			; write back


				; Configure PA0-PA7 as outputs
				; MODER uses 2 bits per pin: 00=input, 01=output, 10=AF, 11=analog
				; For 8 output pins: 01 01 01 01 01 01 01 01 = 0x5555
				LDR		R4, =GPIOA_BASE				; R4 = base address, reused for all GPIOA regs
				LDR		R5, [R4, #GPIO_MODER]		; read current MODER
				LDR		R6, =0x0000FFFF				; mask: target bits 15:0 (pins PA0-PA7)
				BIC		R5, R5, R6					; clear those bits
				LDR		R6, =0x00005555				; 01 pattern = output mode for PA0-PA7
				ORR		R5, R5, R6					; apply
				STR		R5, [R4, #GPIO_MODER]		; write back to MODER
				
				; Temporary test - put this right after MODER setup
				LDR R0, =GPIOA_BASE
				LDR R1, =0x000000FF     ; all 8 LEDs on
				STR R1, [R0, #GPIO_ODR]


				ldr		r1, =1
				ldr		r2,	=2
				
				add		r3, r1, r2
				
				strb		r3, [r0, #GPIO_ODR]
				; delay
				
                                
                BX      LR              ; Return from main
                ENDP


                ALIGN
                END