.section .data
msg:
    .asciz "HeLLo WoRLd"

.section .text
.global _start
_start:
    movq $0, %rcx

loop_start:
    movb msg(%rcx), %al
    cmpb $0, %al
    je print
 
    cmpb $'A', %al
    jl next_char

    cmpb $'Z', %al 
    jg next_char

    addb $32, %al
    movb %al, msg(%rcx)

next_char:
    incq %rcx
    jmp loop_start

print:
    movq $1, %rax
    movq $1, %rdi
    lea msg, %rsi
    movq $11, %rdx
    syscall

    movq $60, %rax
    xorq %rdi, %rdi
    syscall
