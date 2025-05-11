#include <stdio.h>
#include <stdint.h>
#include <math.h>
#include <unistd.h>   // Для __NR_openat (если доступен) или номера syscall, и AT_FDCWD
#include <fcntl.h>    // Для констант O_WRONLY, O_CREAT, O_TRUNC
#include <sys/stat.h> // Для прав доступа S_IRUSR, S_IWUSR и т.д.
#include <errno.h>    // Для переменной errno
#include <string.h>

#ifndef __NR_openat
#define __NR_openat 257
#endif

double antiderivative(double x)
{
    double result;

    if (x <= 0.0)
    {
        return NAN;
    }

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