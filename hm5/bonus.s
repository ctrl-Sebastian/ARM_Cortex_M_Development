; rising_edge_display.s
; STM32L476RG - Keil Bare-Metal ARM Assembly
;
; PC0-PC7: EXTI inputs, rising edge trigger
; ISR reads GPIOC IDR bits [7:0] and drives them onto PB0-PB7

; Peripheral Base Addresses
RCC_BASE        EQU     0x40021000
RCC_AHB2ENR     EQU     RCC_BASE + 0x4C
RCC_APB2ENR     EQU     RCC_BASE + 0x60

GPIOB_BASE      EQU     0x48000400
GPIOB_MODER     EQU     GPIOB_BASE + 0x00
GPIOB_ODR       EQU     GPIOB_BASE + 0x14

GPIOC_BASE      EQU     0x48000800
GPIOC_MODER     EQU     GPIOC_BASE + 0x00
GPIOC_PUPDR     EQU     GPIOC_BASE + 0x0C
GPIOC_IDR       EQU     GPIOC_BASE + 0x10  ; Input data register

SYSCFG_BASE     EQU     0x40010000
SYSCFG_EXTICR1  EQU     SYSCFG_BASE + 0x08
SYSCFG_EXTICR2  EQU     SYSCFG_BASE + 0x0C

EXTI_BASE       EQU     0x40010400
EXTI_IMR1       EQU     EXTI_BASE + 0x00
EXTI_RTSR1      EQU     EXTI_BASE + 0x08
EXTI_FTSR1      EQU     EXTI_BASE + 0x0C
EXTI_PR1        EQU     EXTI_BASE + 0x14

NVIC_ISER0      EQU     0xE000E100
                AREA    CODE, CODE, READONLY
                THUMB

                EXPORT  main
main
   ; 1. Clocks: GPIOB + GPIOC on AHB2, SYSCFG on APB2
    LDR     r0, =RCC_AHB2ENR
    LDR     r1, [r0]
    ORR     r1, r1, #0x06              ; WARNING FIX: 0x06 is (1<<1) OR (1<<2)
    STR     r1, [r0]

    LDR     r0, =RCC_APB2ENR
    LDR     r1, [r0]
    ORR     r1, r1, #(1<<0)
    STR     r1, [r0]

    ; 2. PC0-PC7 as input with pull-down
    LDR     r0, =GPIOC_MODER

    LDR     r1, [r0]
    LDR     r2, =0x0000FFFF            ; ERROR FIX: Load large number into r2 first
    BIC     r1, r1, r2                 ; Then use r2 to clear the bits
    STR     r1, [r0]

    LDR     r0, =GPIOC_PUPDR
    LDR     r1, [r0]
    LDR     r2, =0x0000FFFF            ; ERROR FIX
    BIC     r1, r1, r2
    LDR     r2, =0x0000AAAA            ; ERROR FIX
    ORR     r1, r1, r2                 ; Pull-down (10) for PC0-PC7
    STR     r1, [r0]

    ; 3. PB0-PB7 as output (LEDs)
    LDR     r0, =GPIOB_MODER
    LDR     r1, [r0]
    LDR     r2, =0x0000FFFF            ; ERROR FIX
    BIC     r1, r1, r2
    LDR     r2, =0x00005555            ; ERROR FIX
    ORR     r1, r1, r2                 ; Output (01) for PB0-PB7
    STR     r1, [r0]

    ; Clear LEDs initially
    LDR     r0, =GPIOB_ODR
    LDR     r1, [r0]
    BIC     r1, r1, #0xFF
    STR     r1, [r0]

    ; 4. Map EXTI0-7 Port C via SYSCFG
    LDR     r0, =SYSCFG_EXTICR1
    LDR     r1, =0x00002222
    STR     r1, [r0]

    LDR     r0, =SYSCFG_EXTICR2
    LDR     r1, =0x00002222
    STR     r1, [r0]

    
    ; 5. EXTI: rising edge only, unmask lines 0-7
    LDR     r0, =EXTI_RTSR1
    LDR     r1, [r0]
    ORR     r1, r1, #0xFF              ; Rising edge EXTI0-7
    STR     r1, [r0]

    LDR     r0, =EXTI_FTSR1            ; Ensure falling is off
    LDR     r1, [r0]
    BIC     r1, r1, #0xFF
    STR     r1, [r0]

    LDR     r0, =EXTI_IMR1
    LDR     r1, [r0]
    ORR     r1, r1, #0xFF              ; Unmask EXTI0-7
    STR     r1, [r0]

    ; 6. NVIC: enable IRQ6-10 and IRQ23
    LDR     r0, =NVIC_ISER0
    LDR     r1, [r0]
    ORR     r1, r1, #(2_11111 << 6)
	ORR 	r1, r1, #(1 << 23)
    STR     r1, [r0]

    ; 7. Enable global interrupts
    CPSIE   i

loop
    B       loop


; Core ISR: Read GPIOC IDR bits [7:0], write to PB0-PB7
; Called from all EXTI wrappers after pending bit is cleared

Handle_Rising_EXTI      PROC
    PUSH    {r0-r3, lr}

    ; Read current value of PC0-PC7
    LDR     r0, =GPIOC_IDR
    LDR     r1, [r0]
    AND     r1, r1, #0xFF              ; Keep only bits 7:0

    ; Write to PB0-PB7 (GPIOB ODR)
    LDR     r2, =GPIOB_ODR
    LDR     r3, [r2]
    BIC     r3, r3, #0xFF              ; Clear old LED values
    ORR     r3, r3, r1                 ; Apply new value
    STR     r3, [r2]

    POP     {r0-r3, pc}
    ENDP


; Per-line ISR wrappers: clear EXTI pending then branch
EXTI0_IRQHandler    PROC
    EXPORT  EXTI0_IRQHandler
    LDR     r0, =EXTI_PR1
    MOV     r1, #(1<<0)
    STR     r1, [r0]
    B       Handle_Rising_EXTI
    ENDP

EXTI1_IRQHandler    PROC
    EXPORT  EXTI1_IRQHandler
    LDR     r0, =EXTI_PR1
    MOV     r1, #(1<<1)
    STR     r1, [r0]
    B       Handle_Rising_EXTI
    ENDP

EXTI2_IRQHandler    PROC
    EXPORT  EXTI2_IRQHandler
    LDR     r0, =EXTI_PR1
    MOV     r1, #(1<<2)
    STR     r1, [r0]
    B       Handle_Rising_EXTI
    ENDP

EXTI3_IRQHandler    PROC
    EXPORT  EXTI3_IRQHandler
    LDR     r0, =EXTI_PR1
    MOV     r1, #(1<<3)
    STR     r1, [r0]
    B       Handle_Rising_EXTI
    ENDP

EXTI4_IRQHandler    PROC
    EXPORT  EXTI4_IRQHandler
    LDR     r0, =EXTI_PR1
    MOV     r1, #(1<<4)
    STR     r1, [r0]
    B       Handle_Rising_EXTI
    ENDP

EXTI9_5_IRQHandler  PROC
    EXPORT  EXTI9_5_IRQHandler
    LDR     r0, =EXTI_PR1
    LDR     r1, [r0]
    AND     r1, r1, #(0x7<<5)          ; Clear bits 5, 6, 7 that fired
    STR     r1, [r0]
    B       Handle_Rising_EXTI
    ENDP

    ALIGN
    END