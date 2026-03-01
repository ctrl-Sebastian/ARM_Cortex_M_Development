#include "stm32l476xx.h"

int32_t operation1, operation2, operation3, operation4, operation5, operation6, operation7, operation8;
int8_t num1 = 10, num2 = 29, num3  = -1, num4 = 1;
int8_t num5 = -21, num6 = 31, num7 = -110, num8 = -90;
int8_t  num9 = 100, num10 = 23, num11 = 25, num12 = 26;
int8_t num13 = -116, num14 = -60, num15 = 110, num16 = -90;


int main(void) {

	operation1 = num1 + num2;
	operation2 = num3 + num4;
	operation3 = num5 + num6;
	operation4 = num7 + num8;
	operation5 = num9 - num10;
	operation6 = num11 - num12;
	operation7 = num13 - num14;
	operation8 = num15 - num16;
}