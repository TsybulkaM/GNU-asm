.text
.global _start

_start:
	mov $3, %ebx
	mov $2, %ecx
	
__begin:
	imul %ebx, %ebx
	imul %ecx, %ecx
	add %ecx, %ebx
	mov %ebx, %edx
	
__end:
    mov $1, %eax 
    mov $0, %ebx
    int $0x80
