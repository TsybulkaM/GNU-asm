.section .data
	.set TYPE_SIZE, 4
	arr: .long 1, -3, 41, 10, 0
	arr_end:
	.set arr_size, (arr_end - arr) / TYPE_SIZE

.section .text
.globl _start

_start:
	mov $0, %eax
	mov $arr_size, %edx
	mov $arr, %edi

__begin:
    cmp $0, %edx
    je __end 

    cmpl %eax, (%edi)
    jle _next_element
    
_change_grt:
    movl (%edi), %eax
    mov %edi, %ebx

_next_element:
    add $TYPE_SIZE, %edi
    
    dec %edx
    jmp __begin

__end:
	nop
