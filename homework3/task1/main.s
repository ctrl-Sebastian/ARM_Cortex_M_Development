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
x			dcd		1
y			dcd		2
			AREA	myRes, DATA, READWRITE
z			dcd		0

        AREA    |.text|, CODE, READONLY

; Reset Handler
Reset_Handler   PROC
                EXPORT  Reset_Handler
                BL      main            
                B       .
                ENDP


main            PROC
                EXPORT  main
                
                ldr 	r0, =x
			ldr 	r1, =y
			ldr 	r2, =z
		
			bl 		equation
		
			str 	r0, [r2]
		
stop		b		stop
			                                

            ENDP
equation	PROC
			push {r4-r7}
			; x^2
			ldr 	r6,	[r0]
			mul 	r4, r6, r6
			
			;(2*y)
			mov		r5, #2
			ldr		r7, [r1]
			mul		r5, r5, r7
			
			; x^2 + 2y
			add 	r4, r4, r5
			
			; x^2 + 2y - 128
			sub 	r4, r4, #128
			
			; store z in r0
			mov		r0, r4
			
			pop 	{r4-r7}
			bx		lr
			ENDP

			ALIGN
			END