; Sebastian Manuel De Leon Santos
		AREA	myData, DATA, READONLY
a		rn		0
b		rn		1
c		rn		2
d		rn		3

        AREA    myCode, CODE, READONLY

main            PROC
                EXPORT  main
                
                
                ;char A,B,C; 
				;int D; A = 2; B = 6; C= -10;
				;D= (A + B)*C
					
				mov a, #2			; 1 cycle
				strb a, [SP, #0]	; 2 cycles
				
				mov b, #6			; 1 cycle
				strb b, [SP, #1]	; 2 cycle
				
				mov c, #-10			; 1 cycle
				strb c, [SP, #2]	; 2 cycle
				
				add d, a, b			; 1 cycle
				mul d, c			; 1 cycle
				
				str d, [SP, #3]		; 2 cycle
				
				
                
                                
                BX      LR              ; Return from main
                ENDP

                ALIGN
                END	