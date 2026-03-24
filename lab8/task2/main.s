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
array	dcd 	1, 2, 3, 4, 5, 6, 7
size	dcb		7
result	dcd		0		

        AREA    |.text|, CODE, READONLY

; Reset Handler
Reset_Handler   PROC
                EXPORT  Reset_Handler
                BL      main            
                B       .
                ENDP


main            PROC
                EXPORT  main
                
				ldr r4, =0x20000000
                ldr r0, =array
				ldr r1, size
				ldr r2, =0			; index
                ldr r3, =0x00000000
				push {r3}
				push {r0, r1, r2}
				
									
                bl average

				ldr r5, [sp, #12]
				str r5, [r4]

stop			b stop
                                
                ENDP

average			PROC					;stack
				push {r4, r5}			;r3		+20
				ldr r0, [sp, #8]		;r2		+16
				ldr r1, [sp, #12]		;r1		+12
				ldr r2, [sp, #16]		;r0		+8
										;r5		+4
				mov r4, #0				;r4		+0
				mov r5, #0				; after popin r4 and r5
										; all of them reduce by 8
loop			cmp r2, r1				
				bge done
				
				ldrsh 	r4, [r0, r2, lsl #2]
				add		r5, r4
				add 	r2, r2, #1
				b		loop
				
				
done			sdiv r0, r5, r1
				str r0, [sp, #20]
				pop {r4, r5}
				BX	LR
				ENDP

                ALIGN
                END