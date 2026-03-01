;ARM assembly code shell

        PRESERVE8
        THUMB

; Vector Table
        AREA    RESET, DATA, READONLY
        EXPORT  __Vectors

__Vectors
        DCD     0x20018000          ; Top of Stack (96KB RAM)
        DCD     Reset_Handler       ; Reset Handler

		AREA myData, DATA, READONLY
array			dcb		144, 143, 82, 22, 212, 32, 163

        AREA    |.text|, CODE, READONLY

; Reset Handler
Reset_Handler   PROC
                EXPORT  Reset_Handler
                BL      main            
                B       .
                ENDP


main            PROC
                EXPORT  main
                
				ldr r0, =0x20000000
				ldr r1, =array
				
				; storing the array elements in memory
				ldrb r2, [r1, #0]
				strb r2, [r0, #0]
				
				ldrb r2, [r1, #1]
				strb r2, [r0, #1]
				
				ldrb r2, [r1, #2]
				strb r2, [r0, #2]
				
				ldrb r2, [r1, #3]
				strb r2, [r0, #3]
				
				ldrb r2, [r1, #4]
				strb r2, [r0, #4]
				
				ldrb r2, [r1, #5]
				strb r2, [r0, #5]
				
				ldrb r2, [r1, #6]
				strb r2, [r0, #6]
				
				; incrementing each array element
			
				ldrb r2, [r0]
				add r2, #1
				strb r2, [r0], #1
				
				ldrb r2, [r0]
				add r2, #1
				strb r2, [r0], #1
				
				ldrb r2, [r0]
				add r2, #1
				strb r2, [r0], #1
				
				ldrb r2, [r0]
				add r2, #1
				strb r2, [r0], #1
				
				ldrb r2, [r0]
				add r2, #1
				strb r2, [r0], #1
				
				ldrb r2, [r0]
				add r2, #1
				strb r2, [r0], #1
				
				ldrb r2, [r0]
				add r2, #1
				strb r2, [r0], #1
				
				
				
				
				
				
                                
                BX      LR              ; Return from main
                ENDP

                ALIGN
                END