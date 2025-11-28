.data
	arr: .long 2, 3, -1, 5
	arr_end:
	.set arr_size, (arr_end - arr) / 4

.section .text
    .globl _start
    
arr_sum:
	push %ebp
	mov %esp, %ebp
	
	push %ebx
	push %ecx
	
	xor %eax, %eax
    movl 12(%ebp), %ebx
    movl 8(%ebp), %ecx
	
.loop:
	addl (%ebx), %eax
	add $4, %ebx
	
	dec %ecx
	jnz .loop
	
.epilog:
	pop %ecx
	pop %ebx
	
	mov %ebp, %esp
	pop %ebp
	ret

_start:
	nop
	
__begin:
	pushl $arr
	pushl $arr_size
	
	call arr_sum
	
	add $8, %esp

__end:
	nop
