.text
.global _start

_start:
	mov $27, %eax
	mov $6, %ebx

__begin:
	cmp $0, %ebx
	je __end
	
	mov %ebx, %ecx
	
	xor %edx, %edx
	idiv %ebx
	
	mov %edx, %ebx
	mov %ecx, %eax
	
	jmp __begin

__end:
	nop

	mov $1, %eax 
	mov $0, %ebx
	int $0x80
