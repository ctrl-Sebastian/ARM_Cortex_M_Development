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
source_array	DCD		0xFFFFFFFF, 0xC5C5C5C5, 0xA3A3A3A3, 0x2F362F36, 0xD3E7D3E7

		AREA	myData, DATA, READWRITE
dest_array		space	20
size			equ		20	; declaring size of array
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
				ldr r3, [r0, r2]
				str r3, [r1, r2]
				add r2, r2, #4
				B copy_arr_loop
end_copy_arr_loop
				
				mov r2, #index			; reseting r2 index to 0

loop			cmp r2, #size			; comparing index to the size

				BGE endloop				; if index >= size end loop
				
				ldr r4, [r1, r2]
				lsls r4, #1
				ldr r4, [r1, r2]
				lsrs r4, #1
				ldr r4, [r1, r2]
				rors r4, #1				; rotate right
				ldr r4, [r1, r2]
				rors r4, #31			; rotate left
				
				add r2, r2, #4
				
				B loop					; branch to loop
endloop

                BX      LR              ; Return from main
                ENDP

                ALIGN
                END