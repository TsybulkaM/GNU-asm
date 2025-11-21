.text
	.globl _start

# dividend - %ebx, divisor - %ecx, result - %eax
div_with_round:
	push %ebx
	push %edx
	
	mov %ebx, %eax
	xor %edx, %edx
	idiv %ecx
	
	mov %eax, %esi
	mov %ecx, %ebx
	sar $1, %ebx
	
	cmp %ebx, %edx
	jl .less
	
	inc %esi
	
.less:
	mov %esi, %eax
	
	pop %edx
	pop %ebx
	ret

_start:
	mov $20, %eax
	mov $11, %edx

__begin:
	mov %eax, %ebx
	mov %edx, %ecx
	
	call div_with_round

__end:
	nop
