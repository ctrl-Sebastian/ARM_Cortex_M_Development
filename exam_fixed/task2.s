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
                
				;	4 secs delay in 120 GHz micro
				;	120*10^9 cycles per second
				;	0.0083 nano seconds per cycle
				;	4 * 
				
                bl	delay
stop			b	stop
				

                
                
                                
                BX      LR              ; Return from main

                ENDP

delay           proc
                push    {r4, r5}
                
                ldr     r4, =1000000    ; OUTER loop count
                
outer_loop
                ldr     r5, =48000      ; INNER loop count
                
inner_loop      
                nop                     ; Your 10-cycle loop design!
                nop
                nop
                nop
                nop
                nop
                subs    r5, r5, #1      
                bne     inner_loop      
                
                subs    r4, r4, #1      ; Decrement outer loop
                bne     outer_loop      
                
                pop     {r4, r5}
                bx      lr
            
                endp
                ALIGN
                END