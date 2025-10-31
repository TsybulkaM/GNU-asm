.text
.global _start

_start:
	mov $-2, %edx 
	
__begin:
	cmp $0, %edx
	jge __end
	
	neg %edx
	
__end:
	mov %edx, %ebx

	nop
	
    mov $1, %eax 
    mov $0, %ebx
    int $0x80
