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
                
                ldr r0, =array
				ldr r1, size
				ldr r2, =0			; index
                
                bl average

stop			b stop
                                
                ENDP

average			PROC
				push {r4, r5}
				mov r4, #0
				mov r5, #0
				
loop			cmp r2, r1
				bge done
				
				ldrsh 	r4, [r0, r2, lsl #2]
				add		r5, r4
				add 	r2, r2, #1
				b		loop
				
				
done			sdiv r0, r5, r1
				pop {r4, r5}
				BX	LR
				ENDP

                ALIGN
                END