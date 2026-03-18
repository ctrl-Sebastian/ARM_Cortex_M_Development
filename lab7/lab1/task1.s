		AREA	myData, DATA, READONLY
a				rn		0					; renaming register 0 to a
b				rn		1					; renaming register 1 to b
c				rn		2					; renaming register 2 to c
d				rn		3					; renaming register 3 to d

		AREA    myCode, CODE, READONLY

main            PROC
                EXPORT  main
                
				
				movw r12, #0x0000			; setting r12 to 0x20000000 as my base address
				movt r12, #0x2000
				
				mov a, #2					; a = 2
				mov b, #6					; b = 6
				mov c, #-10					; c = -10
				
				strb a, [r12], #1			; storing byte (char) a in memory
				strb b, [r12], #1			; storing byte (char) b in memory
				strb c, [r12], #1			; storing byte (char) c in memory
				
				add d, a, b					; d = (a + b)
				mul d, c					; d = (a + b) * c
				
				str d, [r12]				; storing word (int) d in memory
				
				
                BX	LR
                ENDP
                ALIGN
                END