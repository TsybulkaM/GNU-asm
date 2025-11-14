.section .data
	.set TYPE_SIZE, 4
	arr: .long 10, -3, 4, 0, 1
	arr_end:
	.set arr_size, (arr_end - arr) / TYPE_SIZE

.section .text
.globl _start

_start:
	mov $0, %ecx
	mov $arr_size, %edx
	mov $arr, %edi

_begin:
    cmp $0, %edx
    je _end 

    cmpl $0, (%edi)
    jle _next_element
    
_inc_count:
    inc %ecx

_next_element:
    add $TYPE_SIZE, %edi
    
    dec %edx
    jmp _begin

_end:
	nop

	mov $1, %eax 
	mov $0, %ebx
	int $0x80
