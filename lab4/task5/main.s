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
array		dcd -2560, 740, -840, -2560, 4580
			ALIGN

        AREA    |.text|, CODE, READONLY

; Reset Handler
Reset_Handler   PROC
                EXPORT  Reset_Handler
                BL      main            
                B       .
                ENDP


main            PROC
                EXPORT  main
                
				ldr r0, =array		; setting r0 to hold the address of the array
				ldr r1, [r0]		; loading  -2560 into r1
				
				ldr r2, [r0, #4]	; loading 740 into r2
				mul r1, r1, r2		; multiplying
				sxth r1, r1			; truncating to 2 bytes
				
				ldr r2, [r0, #8]
				mul r1, r1, r2
				sxth r1, r1
				
				ldr r2, [r0, #12]
				mul r1, r1, r2
				sxth r1, r1
				
				ldr r2, [r0, #16]
				mul r1, r1, r2
				sxth r1, r1
			
                BX      LR              ; Return from main
                ENDP

                ALIGN
                END