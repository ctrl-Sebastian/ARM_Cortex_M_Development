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
array			dcd		42, 30, 84, 126, 252, 1, 43
size			equ		7
		AREA	myResult, DATA, READWRITE
result			dcd		0

        AREA    |.text|, CODE, READONLY

; Reset Handler
Reset_Handler   PROC
                EXPORT  Reset_Handler
                BL      main            
                B       .
                ENDP


main            PROC
                EXPORT  main
                
                ldr		r0, =array
				ldr		r1, =size
				
				ldr		r2, =0
				push	{r2}
				
				bl		count
				
				pop {r3}				; counter result
				
				ldr		r4, =result
				str		r3, [r4]
                
stop			b		stop
                ENDP

count			PROC
	
				push 	{r4-r8, lr}
				
				mov		r4, #0			; counter
				mov		r5, #0			; loop index
				mov		r6, #42			; LCM Divisor ( 2 * 3 * 7 )
	
loop			cmp		r5, r1
				bge		done
				
				ldr		r7, [r0, r5, lsl #2]	; r5=i*4 ; 0=>0 ; 1=>4 ; 2=>8 ; 3=>12
				mov		r8, r7
				
				udiv	r7,	r7, r6				; divide by LCM
				mul		r7, r7, r6				; multiply by LCM
				
				cmp		r7, r8					; if equal add 1 to counter
				bne		skip
				add		r4, r4, #1
skip			add		r5, r5, #1
				
				b		loop
				
done			str		r4, [sp, #24]
				pop 	{r4-r8, pc}
				ENDP

                ALIGN
                END