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
                
				ldr r12, =0x20000000
				ldr r11, =0x0			; r11 will hold carry
				
				; first byte
				; 72 + 25
				; adding first byte
				ldr r0, =0x72
				ldr r1, =0x25
				
				and r2, r0, #0x0F
				and r3, r1, #0x0F
				
				and r4, r0, #0xF0
				and r5, r1, #0xF0
				
				; add first digit
				adds r6, r2, r3
				cmp r11, #1			; check carry flag
				addeq r6, #1
				moveq r11, #0
				cmp r6, #0x09		; compare if greater than 9
				movgt r11, #1
				
				cmp r11, #1			; check carry flag
				addeq r7, #1
				moveq r11, #0
				adds r7, r4, r5
				cmp r7, #0x90
				movgt r11, #1
				
				add r8, r7, r6
				strb r8, [r12, #2]	; store the byte
				
				ldr r0, =0x42
				ldr r1, =0x89
				
				and r2, r0, #0x0F
				and r3, r1, #0x0F
				
				and r4, r0, #0xF0
				and r5, r1, #0xF0
				
				; add first digit
				adds r6, r2, r3
				cmp r11, #1			; check carry flag
				addeq r6, #1
				moveq r11, #0
				cmp r6, #0x09		; compare if greater than 9
				movgt r11, #1
				addgt r6, #0x06
				
				cmp r11, #1			; check carry flag
				addeq r7, #1
				cmp r11, #1
				moveq r11, #0
				adds r7, r4, r5
				cmp r7, #0x90
				movgt r11, #1
				addgt r7, #0x60
				
				add r8, r7, r6
				strb r8, [r12, #1]	; store the byte
				
				
				ldr r0, =0x69
				ldr r1, =0x37
				
				and r2, r0, #0x0F
				and r3, r1, #0x0F
				
				and r4, r0, #0xF0
				and r5, r1, #0xF0
				
				; add first digit
				adds r6, r2, r3
				cmp r11, #1			; check carry flag
				addeq r6, #1
				cmp r11, #1	
				moveq r11, #0
				cmp r6, #0x09		; compare if greater than 9
				movgt r11, #1
				addgt r6, #0x06
				
				cmp r11, #1			; check carry flag
				addeq r7, #1
				cmp r11, #1	
				moveq r11, #0
				adds r7, r4, r5
				cmp r7, #0x90
				movgt r11, #1
				addge r7, #0x60

				add r8, r7, r6
				strb r8, [r12, #0]	; store the byte

			
                BX      LR              ; Return from main
                ENDP

                ALIGN
                END