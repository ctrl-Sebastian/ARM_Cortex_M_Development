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
                
				MOV R0, #0
				MOV R0, #0x27
				MOV R1, #5
				ADD R0, R0, R1
				LDR R2, =0x20000000
				STRB R0, [R2, #0]
				STRB R1, [R2, #1]
				LDR R3, =0x20000000
				LDRB R0, [R3, #0]
				LDRB R0, [R3, #1]
			
                BX      LR              ; Return from main
                ENDP

                ALIGN
                END