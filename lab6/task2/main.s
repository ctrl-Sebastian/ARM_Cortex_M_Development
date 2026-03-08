;ARM assembly code shell

        PRESERVE8
        THUMB

; Vector Table
        AREA    RESET, DATA, READONLY
        EXPORT  __Vectors

__Vectors
        DCD     0x20018000          ; Top of Stack (96KB RAM)
        DCD     Reset_Handler       ; Reset Handler

		AREA	arrayData, DATA, READONLY
source_array	DCD	0xFC3FFC3F, 0xFC3FFC3F, 0xA2A2A2A2, 0xA2A2A2A2, 0xFFFEFFFE, 0xFFFEFFFE,0xC523C523, 0xC523C523, 0x36AD36AD, 0x36AD36AD, 0xFFFFFFFF, 0xFFFFFFFF,0x041D4235, 0x041D4235, 0x2FCC2FCC, 0x2FCC2FCC
size			equ		64	; declaring size of array
index			equ		0	; declaring index

        AREA    |.text|, CODE, READONLY

; Reset Handler
Reset_Handler   	
                EXPORT  Reset_Handler
                BL      main            
                B       .
                ENDP


main            PROC
                EXPORT  main
                				
				ldr r0, =source_array	; loading array address in r0

				mov r1, #index			; reseting r2 index to 0

loop			cmp r1, #size			; comparing index to the size

				BGE endloop				; if index >= size end loop
				
				; ------------------------------------------
				; loading the 64-bit element into r5 and r6
				; ------------------------------------------
				ldr r3, [r0, r1]
				add r1, r1, #4
				ldr r4, [r0, r1]
				
				; -----------------
				; shift left
				; -----------------
				
				;lsls r5, r3, #1			; shift left LOW
				;ORRCS r4, #0x00000001	; orr to store carry
				;lsls r6, r4, #1			; shift left HIGH
				
				; -----------------
				; rotate left
				; -----------------
				
				lsr r6, r3, #1				; rotate right LOW
				ORRCS r4, #0x10000000			; orr if carry
				lsr r5, r4, #1				; rotate right HIGH
				ORRCS r5, #0x10000000
				
				add r1, r1, #4
				
				B loop					; branch to loop
endloop

                BX      LR              ; Return from main
                ENDP

                ALIGN
                END