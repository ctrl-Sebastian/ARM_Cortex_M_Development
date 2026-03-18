;ARM assembly code shell

        PRESERVE8
        THUMB

; Vector Table
        AREA    RESET, DATA, READONLY
        EXPORT  __Vectors

__Vectors
        DCD     0x20018000          ; Top of Stack (96KB RAM)
        DCD     Reset_Handler       ; Reset Handler

		AREA myData, DATA, READWRITE
i		SPACE	4

        AREA    |.text|, CODE, READONLY

; Reset Handler
Reset_Handler   PROC
                EXPORT  Reset_Handler
                BL      main            
                B       .
                ENDP


main            PROC
                EXPORT  main
     
				MOV R0, #37
				LDR R1, =i
				STR R0, [R1]
Loop
				LDR R0, [R1]
				CMP R0, #0
				BEQ Done
				SUB R0, R0, #1				
				STR R0, [R1]
				B Loop
Done
				B Done
                
                                
                BX      LR              ; Return from main
                ENDP

                ALIGN
                END