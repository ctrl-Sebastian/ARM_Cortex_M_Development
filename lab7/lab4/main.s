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
                
				movw r0, #0x0000
				movt r0, #0x2000
				
				mov r1, #5
				mov r2, #2
				
				b	calculate_area
				
calculate_area	
				mul r3, r1, r2
				str r3, [r0]
				
                
                
                                
                BX      LR              ; Return from main
                ENDP

                ALIGN
                END