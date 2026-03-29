#include <stdio.h>
int main() {
    int arr1[5] = {1, 2, 3, 4, 5};
    int arr2[5] = {6, 7, 8, 9, 10};
    int result[5];

    for (int i = 0; i < 5; i++)
    {
        int sum = arr1[i] + arr2[i];
        if (sum < 60) {
            result[i] = sum * 5;
        } else {
            result[i] = sum;
        }
    }

    for (int i = 0; i < 5; i++)
    {
        printf("%d ", result[i]);
    }
    return 0;
}