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
                
				mov r0, #0		; A
				mov r1, #0		; counter
				
loop			cmp r1, #100	; compare counter with 100
				BGE endloop		; if counter >= 100, end loop
				add r0, #1		; increment A
				add r1, #1		; increment counter
				B loop			; branch to loop
endloop
                                
                BX      LR              ; Return from main
                ENDP

                ALIGN
                END