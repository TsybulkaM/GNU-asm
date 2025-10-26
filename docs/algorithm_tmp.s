.text
.global _start

_start:
	mov $0, %eax

__begin:
	

__end:
	nop

	mov $1, %eax 
	mov $0, %ebx
	int $0x80
