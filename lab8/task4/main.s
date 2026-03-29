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
array1	dcd 	1, 2, 3, 4, 5, 6, 7, 8, 9, 10
array2 	dcd		1, 2, 3, 4, 5, 6, 7, 8, 9, 10
size 	equ		10

		AREA	myResult, DATA, READWRITE
result	space	40

        AREA    |.text|, CODE, READONLY

; Reset Handler
Reset_Handler   PROC
                EXPORT  Reset_Handler
                BL      main            
                B       .
                ENDP


main            PROC
                EXPORT  main
                
                ldr r0, =array1
				ldr r1, =array2
				ldr r2, =result
				mov r3, #size
				
				push {r0-r3}
                
                bl equation

				pop {r0-r3}
stop			b stop
                                
                ENDP

equation		PROC
				push {r4-r7, lr}
				ldr	r4, [sp, #20]	; array 1
				ldr r5, [sp, #24]	; array 2
				ldr r6, [sp, #28]	; result
				ldr r7, [sp, #32]	; size
				
				mov r8, #0			; loop index
loop			cmp r8, r7
				bge done
				
				lsl r9, r8, #2		;r9 = i * 4
				
				ldr r0, [r4, r9]	; m = array1[i]
				ldr r1, [r5, r9]	; n = array2[i]
				
				push {r0, r1, r2}
				
				bl	addition
				
				pop {r0, r1, r2}
				
				str r2, [r6, r9]
				
				add r8, r8, #1
				b	loop
done			
				pop {r4-r7, pc}
				ENDP

addition		PROC
				
				ldr r0, [sp, #0]
				ldr r1, [sp, #4]
				
				add r2, r0, r1
				
				str r2, [sp, #8]
				
				BX	LR
				ENDP

                ALIGN
                END