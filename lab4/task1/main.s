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
				ldr r1, =0x20000014
				ldr r2, =0x20000028
				
				mov r3, #1
				mov r4, #3
				mov r5, #5
				mov r6, #7
				mov r7, #9
				
				str r3, [r0, #0]	; pre-index addressing mode
				str r4, [r0, #4]
				str r5, [r0, #8]
				str r6, [r0, #12]
				str r7, [r0, #16]


				mov r3, #2
				mov r4, #4
				mov r5, #6
				mov r6, #8
				mov r7, #10
				
				str r3, [r1, #0]	; pre-index addressing mode
				str r4, [r1, #4]
				str r5, [r1, #8]
				str r6, [r1, #12]
				str r7, [r1, #16]
				
				ldr r8, [r0, #0]	; pre-index addressing mode
				ldr r9, [r1, #0]
				adds r10, r8, r9
				str r10, [r2, #0]
				
				ldr r8, [r0, #4]	; pre-index addressing mode
				ldr r9, [r1, #4]
				adds r10, r8, r9
				str r10, [r2, #4]
				
				ldr r8, [r0, #8]	; pre-index addressing mode
				ldr r9, [r1, #8]
				adds r10, r8, r9
				str r10, [r2, #8]
				
				ldr r8, [r0, #12]	; pre-index addressing mode
				ldr r9, [r1, #12]
				adds r10, r8, r9
				str r10, [r2, #12]
				
				ldr r8, [r0, #16]	; pre-index addressing mode
				ldr r9, [r1, #16]
				adds r10, r8, r9
				str r10, [r2, #16]
				

				

				

				
				
			
                BX      LR              ; Return from main
                ENDP

                ALIGN
                END