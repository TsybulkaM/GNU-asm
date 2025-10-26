.text
.global _start

_start:
	mov $2, %eax 
	mov $3, %ecx
	mov $5, %edx
	mov $7, %ebx
	
__begin:
	imul %ecx, %eax
	imul %edx, %edx
	sub %edx, %eax
	neg %ebx
	
	xor %edx, %edx
	cdq					# for storing negative value in eax
	idiv %ebx
	
	movl %eax, %ecx
	
__end:
	nop
	
    mov $1, %eax 
    mov $0, %ebx
    int $0x80
