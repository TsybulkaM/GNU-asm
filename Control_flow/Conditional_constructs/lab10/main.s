.text
.global _start

_start:
	mov $3, %eax 
	mov $-4, %ebx 

__begin:
	cmp %eax, %ebx
	jg _mov
	mov %eax, %ebx
	
_mov:
	mov %ebx, %ecx
	
__end:
	nop
	
    mov $1, %eax 
    mov $0, %ebx
    int $0x80
