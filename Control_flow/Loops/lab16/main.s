.text
.global _start

_start:
	mov $9, %ecx			# result: 88
	
	mov $0, %ebx
	mov $1, %edx

__begin:
	add %edx, %eax
	
	sub $1, %ecx
	jle __end
	
	add %ebx, %edx
	sub %edx, %ebx
	neg %ebx
	
	jmp __begin

__end:
	nop

	mov $1, %eax 
	mov $0, %ebx
	int $0x80
