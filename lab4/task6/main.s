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
                
				; 5 * 6
				mov r0, #5
				mov r1, #6
				
				mul r2, r0, r1
				
				; 0xFF * 0x3
				mov r0, #0xFF
				mov r1, #0x3
				
				mul r2, r0, r1
				
				; 0b01101100 * 0b00001010
				mov r0, #2_01101100
				mov r1, #2_00001010
				
				mul r2, r0, r1
				
				; 255* 255
				mov r0, #255
				mov r1, #255
				
				mul r2, r0, r1
				
				
                                
                BX      LR              ; Return from main
                ENDP

                ALIGN
                END