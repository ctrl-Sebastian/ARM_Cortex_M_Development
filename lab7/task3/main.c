#include "stm32l476xx.h"

void delay(int outter, int inner);

int main(void) {
    /* 1. Enable Clock for GPIO Port A */
    RCC->AHB2ENR |= RCC_AHB2ENR_GPIOAEN;

    /* 2. Configure PA5 as Output */
    // Each pin in MODER uses 2 bits. PA5 uses bits 10 and 11.
    // Logic: Clear bits 10 and 11, then set bit 10 to '1' for Output mode (01).
    GPIOA->MODER &= ~(3 << 10); // Clear bits 10 and 11 (3 is 11 in binary)
    GPIOA->MODER |= (1 << 10);  // Set bit 10 to 1

    while (1) {
        /* 3. Toggle the LED using BSRR for safety */
        GPIOA->BSRR = (1 << 5);      // Set PA5 High
        delay(1000, 500);
       
        GPIOA->BSRR = (1 << (5 + 16)); // Reset PA5 Low (Bit 21)
				delay(1000, 500);
    }
}

void delay(int outter, int inner) {
    __asm {
					mov r4, outter
out 
					mov r5, inner
in
					subs r5, r5, #1
					bne in
					subs r4, r4, #1
					bne out
				}
}