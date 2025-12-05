.data
	.set ARRAY_SIZE, 8

.bss
	fib_array: .space	4 * ARRAY_SIZE

.text
	.globl _start
	
fill_fib_array:
	push %ebp
	mov %esp, %ebp
	
	push %ebx
	push %ecx
	push %eax
	
	movl 8(%ebp), %ebx
	movl 12(%ebp), %ecx

	cmp $0, %ecx
	jle .epilog
	movl $1, (%ebx)
	dec %ecx
	add $4, %ebx
	
	cmp $0, %ecx
	jle .epilog
	movl $1, (%ebx)
	dec %ecx
	add $4, %ebx
	
.loop:
	cmp $0, %ecx
	jle .epilog
	
	movl -8(%ebx), %eax
    addl -4(%ebx), %eax
    movl %eax, (%ebx)
	
	add $4, %ebx
	dec %ecx
	
	jmp .loop
	
.epilog:
	pop %eax
	pop %ecx
	pop %ebx
	
	mov %ebp, %esp
	pop %ebp
	
	ret


_start:
	nop

__begin:
	push $ARRAY_SIZE
	push $fib_array
	call fill_fib_array
	
__end:
	nop
