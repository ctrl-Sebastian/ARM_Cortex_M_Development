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
                
                ; Operation 1
                LDR     R0, =2_00001010
                LDR     R1, =2_00011101
                ADDS    R2, R0, R1

                ; Operation 2
                LDR     R0, =0xFFFFFFFF     
                LDR     R1, =1
                ADDS    R2, R0, R1
				
				; Operation 3
                LDR     R0, =2_11101011
                LDR     R1, =2_00011111
                ADDS    R2, R0, R1

                ; Operation 4
                LDR     R0, =0xFFFFFF92
                LDR     R1, =0xFFFFFFA6
                ADDS    R2, R0, R1

                ; Operation 5
                LDR     R0, =2_01100100
                LDR     R1, =2_00010111
                SUBS    R2, R0, R1
				
				; Operation 6
                LDR     R0, =2_00011001
                LDR     R1, =2_00011010
                SUBS    R2, R0, R1
				
				; Operation 7
                LDR     R0, =2_10001100
                LDR     R1, =2_11000100
                SUBS    R2, R0, R1
				
				; Operation 8
                LDR     R0, =2_01101110
                LDR     R1, =2_10100110
                SUBS    R2, R0, R1
                
                
                                
                BX      LR              ; Return from main
                ENDP

                ALIGN
                END