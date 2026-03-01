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

				LDR R0, =var1
				LDR R1, =var2
				LDR R2, =array1
				LDR R3, =array2

                BX      LR              ; Return from main
                ENDP

var1			DCB 0xB5
var2			DCB 0x47
array1			DCB 0x15, 0x1A, 0x15, 0x2C
array2			DCD 0x230D, 0x203F, 0x02D0, 0x00A2
var3			SPACE 100
                    

                ALIGN
                END