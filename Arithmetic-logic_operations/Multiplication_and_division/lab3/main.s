.text
.global _start

_start:
	mov $24, %edi
	mov $10, %ebx
	
__begin:
	mov %esi, %eax
	div %ebx
	
	add %edx, %eax
	
__end:
	nop
	
    mov $1, %eax 
    mov $0, %ebx
    int $0x80
