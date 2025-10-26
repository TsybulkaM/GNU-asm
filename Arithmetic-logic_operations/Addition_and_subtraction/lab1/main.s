.text
.global _start

_start:
	mov $2, %eax
	mov $9, %ebx
	mov $3, %ecx
	
__begin:
	add %ecx, %eax
	sub %eax, %ebx
	mov %ebx, %edx
	
__end:
	nop				# for your b
	
	# Correct exit syslog, if you wish
    mov $1, %eax 
    mov $0, %ebx
    int $0x80
