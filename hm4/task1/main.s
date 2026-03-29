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
                
                ; Your code goes here
                
                
                                
                BX      LR              ; Return from main
                ENDP

delay_500ms     PROC
           
                PUSH    {r4, r5, lr}
                
                LDR     r4, =2500       
                
outer_loop
                LDR     r5, =1000       
                
inner_loop
                
                SUBS    r5, r5, #1      ; 1 cycle
                BNE     inner_loop      ; 3 cycles (taken)
                
                
                SUBS    r4, r4, #1
                BNE     outer_loop
                
                
                POP     {r4, r5, pc}
                ENDP

                ALIGN
                END