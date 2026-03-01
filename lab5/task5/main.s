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
source_array	DCB		0x0, 0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8, 0x9; declaring array

		AREA	myData, DATA, READWRITE
dest_array		space	10
size			equ		10	; declaring size of array
index			equ		0	; declaring index

        AREA    |.text|, CODE, READONLY

; Reset Handler
Reset_Handler   PROC
                EXPORT  Reset_Handler
                BL      main            
                B       .
                ENDP


main            PROC
                EXPORT  main
                				
				ldr r0, =source_array	; loading array address in r0
				ldr r1, =dest_array		
				mov r2, #index			; current index
				
copy_arr_loop
				cmp r2, #size
				BGE end_copy_arr_loop
				ldrb r3, [r0, r2]
				strb r3, [r1, r2]
				add r2, r2, #1
				B copy_arr_loop
end_copy_arr_loop
				
				mov r2, #index			; reseting r2 index to 0

loop			cmp r2, #size			; comparing index to the size

				BGE endloop				; if index >= size end loop
				
				ldrb r3, [r1, r2]		; load byte in index to r2
			
				add r3, r3, #1			; add 1 to the byte in r2
				
				strb r3, [r1, r2]		; store the byte in r2 back in the
										; same position in the array
										
				add r2, r2, #1			; add 1 to index
				
				B loop					; branch to loop
endloop

                BX      LR              ; Return from main
                ENDP

                ALIGN
                END