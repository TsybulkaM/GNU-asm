.text
.global _start

_start:
	mov $9, %ecx			# result: 34
	
	mov $0, %ebx
	mov $1, %eax

__begin:
	sub $1, %ecx
	jle __end
	
	add %ebx, %eax
	sub %eax, %ebx
	neg %ebx
	
	jmp __begin

__end:
	nop

	mov $1, %eax 
	mov $0, %ebx
	int $0x80
