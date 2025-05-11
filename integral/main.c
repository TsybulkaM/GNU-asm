#include <stdio.h>
#include <stdint.h>
#include <math.h>

#ifndef __NR_openat
#define __NR_openat 257
#endif

double antiderivative(double x)
{
    double result;

    asm volatile(
        "fldl %2;\n\t"
    );

    return result;
}

int main()
{
    const uint8_t from = 0;
    const uint8_t to = 1;
    double result = antiderivative((double)(to)) - antiderivative((double)(from));

    printf("Result: %f\n", result);

    return 0;
}