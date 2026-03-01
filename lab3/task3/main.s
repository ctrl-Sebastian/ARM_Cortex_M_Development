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
                
                LDR R0, =0x20000020
				LDR R1, =10
				LDR R2, =20
				LDR R3, =30
				LDR R4, =40
				LDR R5, =50

                STRB R1, [R0], #1
                STRB R2, [R0], #1
                STRB R3, [R0], #1
                STRB R4, [R0], #1
                STRB R5, [R0], #1
                                
                BX      LR              ; Return from main
                ENDP

                ALIGN
                END