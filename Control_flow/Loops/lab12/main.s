.text
.global _start

_start:
	mov $3, %ebx
	mov $4, %ecx
	
	mov $1, %edx

__begin:
	cmp $0, %ecx
	je __end
	sub $1, %ecx
	
	imul %ebx, %edx
	
	jmp __begin

__end:
	nop

	mov $1, %eax 
	mov $0, %ebx
	int $0x80
