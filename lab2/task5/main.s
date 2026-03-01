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
                
                MOV R0, #0x0F		; R0 <- 0x0F
				ADDS R0, R0, #0x27	; R0 <- R0 + 0x27
				ADDS R0, R0, #0x45	; R0 <- R0 + 0x45
				
				ADDS R0, R0, #4		; R0 <- R0 + 4
				
				MOV R1, #2_01011111	; R1 <- 01011111
				
				MOV R1, #0			; R1 <- 0
				
				ADDS R1, R1, #0x6A	; R1 <- R1 + 0x6A
                                
                BX      LR              ; Return from main
                ENDP

                ALIGN
                END