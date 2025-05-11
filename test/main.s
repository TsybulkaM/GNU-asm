.section .data
msg:
    .asciz "HeLLo WoRLd"     # строка, заканчивающаяся 0

.section .text
.global _start
_start:
    movq $0, %rcx            # индекс в строке

loop_start:
    movb msg(%rcx), %al       # загружаем символ
    cmpb $0, %al              # если конец строки
    je print
 
    cmpb $'A', %al
    jl next_char

    cmpb $'Z', %al 
    jg next_char

    addb $32, %al             # преобразуем в строчную
    movb %al, msg(%rcx)       # записываем обратно

next_char:
    incq %rcx                 # индекс++
    jmp loop_start

print:
    movq $1, %rax             # номер системного вызова sys_write = 4
    movq $1, %rdi             # дескриптор stdout
    lea msg, %rsi      	  # адрес строки msg
    movq $11, %rdx            # длина строки (11 символов)
    syscall

    movq $60, %rax             # номер системного вызова sys_exit = 1
    xorq %rdi, %rdi           # код возврата = 0
    syscall
