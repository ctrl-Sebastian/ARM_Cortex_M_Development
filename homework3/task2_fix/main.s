	AREA	myData, DATA, READONLY
size		dcd		10
	AREA	arrayData, DATA, READWRITE
array		dcd		1, 2, 3, 4, 5, 6, 7, 8, 9, 10
	
	AREA    myCode, CODE, READONLY

main            PROC
                EXPORT  main
                
                ldr 	r0, =array
				ldr		r1, =size
				ldr		r1, [r1]
				ldr		r2, =0x0
		
				bl 		operation
		
stop			b		stop
				ENDP

operation		PROC
				push 	{r4, r5, r6}
				
				mov		r5, r1
				mov		r6, r2
				
loop			cmp		r6, r5
				bge		sub_done
				
				ldr 	r4, [r0]
				mul		r4, r4, r4
				add		r4, r4, #64
				str		r4, [r0]
				
				add		r0, r0, #4
				add		r6, r6, #1
				b 		loop
	
sub_done			
				pop 	{r4, r5, r6}
				bx		lr
				ENDP

				ALIGN
				END