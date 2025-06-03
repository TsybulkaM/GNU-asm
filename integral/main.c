#include <stdio.h>
#include <stdint.h>
#include <math.h>

double _antiderivative(double x) {
    return (x*sqrt((1+x*x)))/2 + log(fabs(sqrt(1+x*x)+x))/2;
}

double antiderivative(double x)
{
    double result;
    const double half = 0.5;

    __asm__ __volatile__ (
        // Calculate sqrt(1 + x^2)
        "fldl %[x]          \n\t" // ST(0) = x
        "fld %%st(0)        \n\t" // ST(0) = x, ST(1) = x
        "fmulp              \n\t" // ST(0) = x^2
        "fld1               \n\t" // ST(0) = 1, ST(1) = x^2
        "faddp              \n\t" // ST(0) = 1 + x^2
        "fsqrt              \n\t" // ST(0) = sqrt(1 + x^2) [sqrt_val]

        // Calculate term1 = 0.5 * x * sqrt_val
        "fldl %[x]          \n\t" // ST(0) = x, ST(1) = sqrt_val
        "fmul %%st(1), %%st \n\t" // ST(0) = x * sqrt_val, ST(1) = sqrt_val  (fmul ST(i), ST(0))
        "fldl %[half]       \n\t" // ST(0) = 0.5, ST(1) = x*sqrt_val, ST(2) = sqrt_val
        "fmulp              \n\t" // ST(0) = 0.5 * x * sqrt_val [term1], ST(1) = sqrt_val

        // Calculate term2 = 0.5 * ln(x + sqrt_val)
        // Need x + sqrt_val first. sqrt_val is in ST(1)
        "fldl %[x]          \n\t" // ST(0) = x, ST(1) = term1, ST(2) = sqrt_val
        // Add ST(2) [sqrt_val] to ST(0) [x], store result in ST(0)
        "fadd %%st(2), %%st \n\t" // ST(0) = x + sqrt_val, ST(1) = term1, ST(2) = sqrt_val

        // Now calculate ln(x + sqrt_val)
        "fldln2             \n\t" // ST(0) = ln(2), ST(1) = x+sqrt_val, ST(2) = term1, ST(3) = sqrt_val
        "fxch %%st(1)       \n\t" // ST(0) = x+sqrt_val, ST(1) = ln(2), ST(2) = term1, ST(3) = sqrt_val
        "fyl2x              \n\t" // ST(0) = ln(x+sqrt_val), ST(1) = term1, ST(2) = sqrt_val
                                 // Pops ln(2) and (x+sqrt_val), pushes result

        // Multiply by 0.5
        "fldl %[half]       \n\t" // ST(0) = 0.5, ST(1) = ln(x+sqrt_val), ST(2) = term1, ST(3) = sqrt_val
        "fmulp              \n\t" // ST(0) = 0.5 * ln(x+sqrt_val) [term2], ST(1) = term1, ST(2) = sqrt_val

        // Add term1 + term2
        "faddp              \n\t" // ST(0) = term2 + term1, ST(1) = sqrt_val
                                 // Adds ST(1) to ST(0), stores in ST(0), pops ST(1)

        // Store result and clean up stack
        "fstpl %[res]       \n\t" // Store result from ST(0), pop ST(0). Stack: ST(0) = sqrt_val
        "fstp %%st(0)       \n\t" // Pop remaining sqrt_val to leave stack empty.

        : [res] "=m"(result)              // Output: result variable in memory
        : [x] "m"(x), [half] "m"(half)    // Inputs: x and half variables from memory
        : "st", "st(1)", "st(2)", "st(3)" // Clobbers: list FPU registers potentially modified
    );

    return result;
}
int main()
{
    const uint8_t from = 0;
    const uint8_t to = 1;
    double result = 
		antiderivative((double)(to)) - antiderivative((double)(from));

    printf("Result: %f\n", result);
    
    double check_F1 = 0.5 * (1.0 * sqrt(1.0 + 1.0*1.0) + 
		log(1.0 + sqrt(1.0 + 1.0*1.0)));
    double check_F0 = 0.5 * (0.0 * sqrt(1.0 + 0.0*0.0) + 
		log(0.0 + sqrt(1.0 + 0.0*0.0)));
    printf("Result check using math.h: %f\n", check_F1 - check_F0);

    return 0;
}
