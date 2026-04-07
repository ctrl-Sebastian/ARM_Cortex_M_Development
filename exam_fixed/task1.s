		AREA	myData, DATA, READWRITE
									;0						
array	dcd		0x00000000, 0x00000000,0x00000000, 0x00000001,0x00000000, 0x00000002,0x00000000, 0x00000003,0x00000000, 0x00000004,0x00000000, 0x00000005,0x00000000, 0x00000006,0x00000000, 0x00000007,0x00000000, 0x00000008,0x00000000, 0x00000009
				
index	equ		80
	
        AREA    |.text|, CODE, READONLY
			EXPORT main
			ENTRY
			
main
                
                ldr r0, =array		;addres of array
				ldr r1, =index
                
				push	{r0, r1}
				
				bl	addition
				
				;	add		sp, sp, #8			; clean stack
				
stop			b		stop



addition		proc
	
				push {r4-r8}
				
				ldr		r4, [sp, #20]		;r4 holds addres of array
				ldr		r5, [sp, #24]		; r5 holds size
				ldr		r6, =0
				
				
loop			cmp		r6, r5
				bge		done
				
				
				ldr 	r7, [r4, r6]		; upper word
				add		r6, r6, #4	
				ldr		r8, [r4, r6]		; lower word
				sub		r6, r6, #4
				
				adds	r8, r8, #5
				adc		r7, r7, #0
				
				str		r7, [r4, r6]
				add		r6, r6, #4
				str		r8, [r4, r6]
				sub		r6, r6, #4
				
				add		r6, r6, #8
				b		loop
				
				
done	
				pop	{r4-r8}
				bx		lr
	
				endp


                ALIGN
                END