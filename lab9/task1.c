#include <stm32l476xx.h>

void sum(int *arr1, int *arr2, int *arr3, int size);

int main() {
	int size = 5;										// size of array
	int arr1[5] = {1, 2, 3, 4, 5};	// array 1
	int arr2[5] = {1, 2, 3, 4, 5};	// array 2
	int arr3[5];										// result array
	
	sum(arr1, arr2, arr3, size);		// call sum subroutine
	
	return 0;
}

void sum(int *arr1, int *arr2, int *arr3, int size) {
	for (int i = 0; i < size ; i++) {	// for i = 0 to size do
		int sum = arr1[i] + arr2[i];		// sum
		if (sum < 60) {									// if sum is less than 60
			sum *= 5;											// multiply by 5
		}
		arr3[i] = sum;									// store the sum in result array
	}
}