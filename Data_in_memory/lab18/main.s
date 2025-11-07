.section .data
	.set TYPE_SIZE, 4
	arr: .long 10, -3, 4, 0, 1
	arr_end:
	.set arr_size, (arr_end - arr) / TYPE_SIZE

.section .text
.globl _start

_start:
	mov $0, %eax
	mov $arr_size, %edx
	mov $arr, %edi 

_begin:
    cmp $0, %edx
    je _culc_mean 

    addl (%edi), %eax
    add $TYPE_SIZE, %edi
    
    dec %edx
    jmp _begin
    
_culc_mean:
	mov $arr_size, %ecx
	idiv %ecx
	
_end:
	nop

	mov $1, %eax 
	mov $0, %ebx
	int $0x80
