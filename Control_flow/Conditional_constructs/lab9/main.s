.text
.global _start

_start:
	mov $3, %ecx 
	mov $4, %edx 
	
__begin:
	sub %ecx, %edx
	jge __mov
	
	neg %edx
	
__mov:
	mov %edx, %ebx
	
__end:
	nop
	
    mov $1, %eax 
    mov $0, %ebx
    int $0x80
