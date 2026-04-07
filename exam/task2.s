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
                
                bl	delay
stop			b	stop
				

                
                
                                
                BX      LR              ; Return from main

                ENDP

delay			proc
				push	{r4}
				ldr		r0, =5000000
				
loop			nop
				nop
				nop
				nop
				nop
				nop
				subs	r0, r0, #1
				bne		loop
				
				pop 	{r4}
				bx		lr
			
				endp
                ALIGN
                END