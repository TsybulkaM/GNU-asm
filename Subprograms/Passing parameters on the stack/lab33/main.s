.text
	.globl _start

# arg1 - the base, arg2 - the exponent
pow:
	push %ebp
    mov %esp, %ebp
	
	mov $1, %eax
.loop:
	cmpl $0, 12(%ebp)
	je .epilog

	imul 8(%ebp), %eax
	
	decl 12(%ebp)
	jmp .loop

.epilog:
	mov %ebp, %esp
	pop %ebp
	ret 

_start:

__begin:
	pushl $10	# arg2
	pushl $2	# arg1
	call pow
	add $8, %esp

__end:
	nop
