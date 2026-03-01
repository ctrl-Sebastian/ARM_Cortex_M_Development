;ARM assembly code shell

        PRESERVE8
        THUMB

; Vector Table
        AREA    RESET, DATA, READONLY
        EXPORT  __Vectors

__Vectors
        DCD     0x20018000          ; Top of Stack (96KB RAM)
        DCD     Reset_Handler       ; Reset Handler

		AREA	readonlyData, DATA, READONLY
var1		dcd		10
		AREA	readwriteData, DATA, READWRITE
var2		dcd		0

        AREA    |.text|, CODE, READONLY

; Reset Handler
Reset_Handler   PROC
                EXPORT  Reset_Handler
                BL      main            
                B       .
                ENDP


main            PROC
                EXPORT  main
                
				ldr r0, =var1	; 2 cycles (pseudo instruction)
				ldr r1, [r0]	; 2 cycle (memory read and loading)
				ldr r2, =var2	; 2 cycles
				
				cmp r1, #0		; 1 cycle
				BGT then		; 3 cycles
				mov r3, #-50	; 0 cycles (skipped)
				B theend		; 0 cycles (skipped)
then			mov r3, #100	; 1 cycle
theend				
				str r3, [r2]	; 2 cycles (get value and store in memory)
                                ; 13 cycles in total
                BX      LR              ; Return from main
                ENDP

                ALIGN
                END