.text
.global _start

_start:
	mov $5, %ebx
	
	mov $1, %edx

__begin:
	cmp $1, %ebx
	jle __end
	
	imul %ebx, %edx
	
	sub $1, %ebx
	jmp __begin

__end:
	nop

	mov $1, %eax 
	mov $0, %ebx
	int $0x80
