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
array 
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

equation		PROC
				push {r4, r5}
				mov r4, #0
				mov r5, #0
				
loop			cmp r2, r1
				bge done
				

				
done			
				BX	LR
				ENDP

addition		PROC
	
				
	
				ENDP

                ALIGN
                END