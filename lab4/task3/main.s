;ARM assembly code shell

        PRESERVE8
        THUMB

; Vector Table
        AREA    RESET, DATA, READONLY
        EXPORT  __Vectors

__Vectors
        DCD     0x20018000          ; Top of Stack (96KB RAM)
        DCD     Reset_Handler       ; Reset Handler

        AREA    |.text|, CODE, READONLY

; Reset Handler
Reset_Handler   PROC
                EXPORT  Reset_Handler
                BL      main            
                B       .
                ENDP


main            PROC
                EXPORT  main
                
				ldr r8, =0x20000000
				ldr r9, =0x20000014
				ldr r10, =0x20000028
				
				; 0x0FDF2DC20FDF2DC2
				 ldr r0, =0x0FDF2DC2	; lower half
				 ldr r1, =0x0FDF2DC2	; upper half
				 
				; 0x125CE62C125CE62C	
				 ldr r2, =0x125CE62C	; lower half
				 ldr r3, =0x125CE62C	; upper half
				 
				 ;sbcs r4, r0, r1		; lower half
				 ;sbc r5, r2, r3			; upper half
				 
				 ; storing first number's bytes
				 
				 ldr r4, =0xC2
				 ldr r5, =0x2D
				 ldr r6, =0xDF
				 ldr r7, =0x0F
				 
				 strb r4, [r8, #0]
				 strb r5, [r8, #1]
				 strb r6, [r8, #2]
				 strb r7, [r8, #3]
				 
				 ; storing seecond number's bytes
				 
				 ldr r4, =0x2C
				 ldr r5, =0xE6
				 ldr r6, =0x5C
				 ldr r7, =0x12
				 
				 strb r4, [r9, #0]
				 strb r5, [r9, #1]
				 strb r6, [r9, #2]
				 strb r7, [r9, #3]
				 
				 ; substraction byte by byte
				 ldrb r4, [r8, #0]		; first byte
				 ldrb r5, [r9, #0]
				 
				 subs r6, r4, r5
				 strb r6, [r10, #0]
				 
				 ldrb r4, [r8, #1]		; second byte
				 ldrb r5, [r9, #1]
				 
				 sbcs r6, r4, r5
				 strb r6, [r10, #1]
				 
				 ldrb r4, [r8, #2]		; third byte
				 ldrb r5, [r9, #2]
				 
				 sbcs r6, r4, r5
				 strb r6, [r10, #2]
				 
				 ldrb r4, [r8, #3]		; fourth byte
				 ldrb r5, [r9, #3]
				 
				 sbcs r6, r4, r5
				 strb r6, [r10, #3]
				 
				 ldrb r4, [r8, #0]		; fifth byte
				 ldrb r5, [r9, #0]
				 
				 sbcs r6, r4, r5
				 strb r6, [r10, #4]
				 
				 ldrb r4, [r8, #1]		; sixth byte
				 ldrb r5, [r9, #1]
				 
				 sbcs r6, r4, r5
				 strb r6, [r10, #5]
				 
				 ldrb r4, [r8, #2]		; seventh byte
				 ldrb r5, [r9, #2]
				 
				 sbcs r6, r4, r5
				 strb r6, [r10, #6]
				 
				 ldrb r4, [r8, #3]		; eighth byte
				 ldrb r5, [r9, #3]
				 
				 sbcs r6, r4, r5
				 strb r6, [r10, #7]

				 
				 
				 
			
                BX      LR              ; Return from main
                ENDP

                ALIGN
                END