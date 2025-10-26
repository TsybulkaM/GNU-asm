.text
.global _start

_start:
	mov $3, %ebx
	mov $2, %ecx
	xor %edx, %edx
	
__begin:
	imul %ebx, %ebx
	imul %ecx, %ecx
	add %ecx, %edx
	add %ebx, %edx
	
__end:
	nop
	
    mov $1, %eax 
    mov $0, %ebx
    int $0x80
