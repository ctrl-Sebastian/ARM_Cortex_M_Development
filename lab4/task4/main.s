;ARM assembly code shell

        PRESERVE8
        THUMB

; Vector Table
        AREA    RESET, DATA, READONLY
        EXPORT  __Vectors

__Vectors
        DCD     0x20018000          ; Top of Stack (96KB RAM)
        DCD     Reset_Handler       ; Reset Handler

        AREA    |.text|, CODE, READONLY

; Reset Handler
Reset_Handler   PROC
                EXPORT  Reset_Handler
                BL      main            
                B       .
                ENDP


main            PROC
                EXPORT  main
                
				ldr r0, =0xFFFFFFFF		; lower half of A
				ldr r1, =0x00000000		; upper half of A
				
				ldr r2, =0x00000002		; lower half of B
				ldr r3, =0x00000002		; upper half of B
				
				; i am going to store the final value between r8, r9, r10 and r11
				; and use r4 and r5 as temporal registers
				
				mov r8, #0
				mov r9, #0
				mov r10, #0
				mov r11, #0
				mov r12, #0		; to catch carry
				
				; (A_lo * B_lo)
				umull r8, r9, r0, r2
				
				; (A_lo * B_hi)
				umull r4, r5, r0, r3
				adds r9, r9, r4
				adcs r10, r10, r5
				adc r11, r11, r12		; catch any final overflow into the highest word
				
				; (A_hi * B_lo)
				umull r4, r5, r1, r2
				adds r9, r9, r4
				adcs r10, r10, r5
				adc r11, r11, r12
				
				; (A_hi * B_hi)
				umull r4, r5, r1, r3
				adds r10, r10, r4
				adc r11, r11, r5
				
				mov r4, #0
				mov r5, #0
				
				ldr r4, =0x20000000
				str r8, [r4]
				str r9, [r4, #4]
				str r10, [r4, #8]
				str r11, [r4, #12]
				
				
				
				
				
                BX      LR              ; Return from main
                ENDP

                ALIGN
                END