;ARM assembly code shell

        PRESERVE8
        THUMB

; Vector Table
        AREA    RESET, DATA, READONLY
        EXPORT  __Vectors

__Vectors
        DCD     0x20018000          ; Top of Stack (96KB RAM)
        DCD     Reset_Handler       ; Reset Handler

		AREA	myData, DATA, READONLY
a		rn		0
b		rn		1
c		rn		2
d		rn		3

        AREA    |.text|, CODE, READONLY

; Reset Handler
Reset_Handler   PROC
                EXPORT  Reset_Handler
                BL      main            
                B       .
                ENDP


main            PROC
                EXPORT  main
                
                
                ;char A,B,C; 
				;int D; A = 2; B = 6; C= -10;
				;D= (A + B)*C
				
				ldr a, =2
				ldr b, =6
				ldr c, =-10
                
                                
                BX      LR              ; Return from main
                ENDP

                ALIGN
                END	