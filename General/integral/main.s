    .text
    .code32
    .globl antiderivative
    .type antiderivative, @function

antiderivative:
    push %ebp
    mov %esp, %ebp

    # double x - 8(%ebp)
    fldl 8(%ebp)           # st0 = 
    fld %st(0)             # st0 = x, st1 = x
    fmulp				   # st0 = x*x
    fld1                   # st0 = 1.0, st1 = x*x
    faddp 				   # st0 = 1 + x*x
    fsqrt                  # st0 = sqrt(1 + x*x)
    fldl 8(%ebp)           # st0 = x, st1 = sqrt(...)
    fmulp 				   # st0 = x * sqrt(...)
    fld1                   # st0 = 1.0, st1 = x*sqrt(...)
    fld1                   # st0 = 1.0, st1 = 1.0, st2 = x*sqrt(...)
    faddp 				   # st0 = 2.0, st1 = x*sqrt(...)
    fld1                   # st0 = 1.0, st1 = 2.0, st2 = x*sqrt(...)
    fdivp 	               # st0 = 0.5, st1 = x*sqrt(...)
    fmulp                  # st0 = (x * sqrt(...)) / 2
    fldl 8(%ebp)           # st0 = x, st1 = result_part1
    fld %st(2)             # st0 = sqrt(1 + x*x), st1 = x, st2 = result_part1
    fadd %st(0), %st(1)    # st1 = x + sqrt(1 + x*x)
    fxch %st(1)            # обмен st0 и st1, st0 = x + sqrt(...)
    fabs                   # fabs(st0)
    fldln2                 # st0 = ln(2), st1 = |x + sqrt(...)|, st2 = result_part1
    fxch %st(1)            # st0 = |x + sqrt(...)|, st1 = ln(2), st2 = result_part1
    fyl2x                  # st0 = log2(|x + sqrt(...)|)
    fld1                   # st0 = 1.0, st1 = log2(...)
    fld1                   # st0 = 1.0, st1 = 1.0, st2 = log2(...)
    faddp 				   # st0 = 2.0, st1 = log2(...)
    fld1                   # st0 = 1.0, st1 = 2.0, st2 = log2(...)
    fdivp 	               # st0 = 0.5, st1 = log2(...)
    fmulp 	               # st0 = 0.5 * log2(...)
    faddp 	               # st0 = antiderivative result

    mov %ebp, %esp
    pop %ebp
    ret

    .globl main
    .type main, @function

main:
    push %ebp
    mov %esp, %ebp

    sub $16, %esp

    fldz
    fstpl (%esp)             # from = 0.0

    fld1
    fstpl 8(%esp)            # to = 1.0

    # antiderivative(to)
    fldl 8(%esp)
    sub $8, %esp
    fstpl (%esp)
    call antiderivative
    add $8, %esp
    fstpl 8(%esp)

    # antiderivative(from)
    fldl (%esp)
    sub $8, %esp
    fstpl (%esp)
    call antiderivative
    add $8, %esp
    fstpl (%esp)

    fldl 8(%esp)
    fldl (%esp)
    fsubp

    sub $8, %esp
    fstpl (%esp)

    call print
    add $8, %esp

    mov $0, %eax
    mov %ebp, %esp
    pop %ebp
    ret
