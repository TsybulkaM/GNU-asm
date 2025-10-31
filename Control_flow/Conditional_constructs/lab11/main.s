.text
.global _start

_start:
	mov $3, %ebx 
	mov $-4, %ecx 
	mov $5, %edx 

__begin:
	cmp %ecx, %ebx
	jg .__second_r
	mov %ecx, %ebx
	
.__second_r:
	cmp %edx, %ebx
	jg __end
	mov %edx, %ebx
	
__end:
	mov %ebx, %ecx

	nop
	
    mov $1, %eax 
    mov %ecx, %ebx
    int $0x80
