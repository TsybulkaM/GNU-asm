.text
.global _start

_start:
	mov $24, %edi
	mov $7, %esi
	
__begin:
	mov %edi, %eax
	
	div %esi
	
	mov %edx, %eax
	
__end:
	nop
	
    mov $1, %eax 
    mov $0, %ebx
    int $0x80
