.text
.global _start

_start:
	mov $2, %eax 
	mov $7, %ebx
	mov $5, %edx
	
__begin:
	imul %eax, %eax
	add %ebx, %eax
	mov %edx, %ebx
	
	xor %edx, %edx
	idiv %ebx
	
	mov %eax, %ecx
	
__end:
	nop
	
    mov $1, %eax 
    mov $0, %ebx
    int $0x80
