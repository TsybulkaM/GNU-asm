    .section .data
msg:
    .asciz "Hello from assembler!\n"

    .section .text
    .globl _start

_start:
    # write(1, msg, 23)
    movq $1, %rax        # syscall: sys_write
    movq $1, %rdi        # stdout
    leaq msg(%rip), %rsi # msg pointer
    movq $23, %rdx       # msg length
    syscall

    # exit(0)
    movq $60, %rax       # syscall: sys_exit
    xor %rdi, %rdi       # return code 0
    syscall
