#include <stm32l476xx.h>

void sum(int *arr1, int *arr2, int *arr3, int size);

int main() {
	int size = 5;
	int arr1[5] = {1, 2, 3, 4, 5};
	int arr2[5] = {1, 2, 3, 4, 5};
	int arr3[5];
	
	sum(arr1, arr2, arr3, size);
	
	return 0;
}

void sum(int *arr1, int *arr2, int *arr3, int size) {
	for (int i = 0; i < size ; i++) {
		int sum = arr1[i] + arr2[i];
		if (sum < 60) {
			sum *= 5;
		}
		arr3[i] = sum;
	}
}