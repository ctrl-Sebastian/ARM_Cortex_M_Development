#include <stdio.h>
// Y  = x^3– 24z^2 – 64m +1024

int equation(int x, int z, int m) {
    int y = (x * x * x) - (24 * z * z) - (64*m) + 1024;
    return y;
}

void main() {
    int x = 2, z = 5, m = 7;
    int y = 0;
    y = equation(x, z, m);

    printf("Y = %d\n", y);
}