.text
	.globl _start

# arg1 - %esi, return - %esi
cube:
	push %edi
	
	mov %esi, %edi
	imul %esi, %edi
	imul %esi, %edi
	
	mov %edi, %esi
	pop %edi
	ret 

_start:
	mov $4, %ebx
	mov $3, %ecx
	mov $2, %edx

__begin:
	mov %ebx, %esi
	call cube
	
	mov %esi, %eax
	
	mov %ecx, %esi
	call cube
	
	add %esi, %eax
	
	mov %edx, %esi
	call cube
	
	mov %esi, %edi
	
	xor %edx, %edx
	idiv %edi

__end:
	nop
