;ARM assembly code shell

        PRESERVE8
        THUMB

; Vector Table
        AREA    RESET, DATA, READONLY
        EXPORT  __Vectors

__Vectors
        DCD     0x20018000          ; Top of Stack (96KB RAM)
        DCD     Reset_Handler       ; Reset Handler
		
		
		AREA myData, DATA, READONLY
array		DCB 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
        
		AREA    |.text|, CODE, READONLY

; Reset Handler
Reset_Handler   PROC
                EXPORT  Reset_Handler
                BL      main            
                B       .
                ENDP


main            PROC
                EXPORT  main
                
                LDR R0, =array
				LDR R2, =0			; R2 will be holding the summation		
				
				LDRB R3, [R0], #1		
				ADD R2, R2, R3		
				
				LDRB R3, [R0], #1
				ADD R2, R2, R3
				
				LDRB R3, [R0], #1
				ADD R2, R2, R3
				
				LDRB R3, [R0], #1
				ADD R2, R2, R3
				
				LDRB R3, [R0], #1
				ADD R2, R2, R3
				
				LDRB R3, [R0], #1
				ADD R2, R2, R3
				
				LDRB R3, [R0], #1
				ADD R2, R2, R3
				
				LDRB R3, [R0], #1
				ADD R2, R2, R3
				
				LDRB R3, [R0], #1
				ADD R2, R2, R3
				
				LDRB R3, [R0], #1
				ADD R2, R2, R3
                
                                
                BX      LR              ; Return from main
                ENDP

                ALIGN
                END