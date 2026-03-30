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
                
                bl delay_500ms
                
                
stop			b stop                      
                BX      LR              ; Return from main
                ENDP

delay_500ms     PROC
           
                push    {r4, r5, lr}
                
                ldr     r4, =2500       
                
outer_loop
                ldr     r5, =1000       
                
inner_loop
                
                subs    r5, r5, #1      ; 1 cycle
                bne     inner_loop      ; 3 cycles (taken)
                
                
                subs    r4, r4, #1
                bne     outer_loop
                
                
                pop     {r4, r5, pc}
                ENDP

                ALIGN
                END