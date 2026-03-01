;ARM assembly code shell

        PRESERVE8
        THUMB

; Vector Table
        AREA    RESET, DATA, READONLY
        ;EXPORT  __Vectors

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
				LDR R0, =0x00000001 ; load into register 0
				LDR R1, =0x7FFFFFFF ; load into register 1
				ADDS R2, R0, R1		; operation 1
				
				LDR R3, =0xFFFFFFFF
				LDR R4, =0x00000005
				ADDS R5, R3, R4
				
				LDR R6, =0xDEADBEEF
				LDR R7, =0xDEADBEEF
				SUBS R8, R6, R7
				
				LDR R9, =0xFFFFFFFF
				LDR R10, =0x00000001
				SUBS R11, R9, R10
				
                BX      LR              ; Return from main
                ENDP

                ALIGN
                END