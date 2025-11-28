.data
	arr: .long 5, 4, -1, 3

.text
	.globl _start

# arg1 - num1, arg2 - num2, arg3 - num3
max3:
	push %ebp
    mov %esp, %ebp
    
    mov 8(%ebp), %eax
	
	cmpl 12(%ebp), %eax
	jg .next
	movl 12(%ebp), %eax

.next:
	cmpl 16(%ebp), %eax
	jg .end
	movl 16(%ebp), %eax

.end:
	mov %ebp, %esp
	pop %ebp
	ret 

_start:

__begin:
	movl $arr, %ebx
	pushl (%ebx)
	pushl 4(%ebx)
	pushl 8(%ebx)
	call max3
	add $12, %esp

__end:
	nop
