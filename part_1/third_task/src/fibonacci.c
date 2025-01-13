#include <stdio.h>


int calculateFibonacci(int n) {
    if (n == 0) return 0;
    if (n == 1) return 1;

    int fib0 = 0;
    int fib1 = 1;
    int fibN = 0;

    for (int i = 2; i <= n; i++) {
        fibN = fib0 + fib1;
        fib0 = fib1;
        fib1 = fibN;
    }

    return fibN;
}

int main() {
    int n = 7;

    int result = calculateFibonacci(n);
    if (result != -1) {
        printf("fibonacci(%d) = %d\n", n, result);
    }

    return 0;
}		
