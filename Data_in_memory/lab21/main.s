.data
	.set TYPE_SIZE, 4
	.set arr_size, 6

.bss
	arr: .space 24

.text
.global _start

_start:
	mov $0, %edx
	mov $arr, %edi 

__begin:
	cmp $arr_size, %edx
    jge __end
    
    mov %edx, %ecx
    imul %ecx, %ecx
    movl %ecx, (%edi)
    
    add $TYPE_SIZE, %edi
    
    inc %edx
    
	jmp __begin

__end:
	nop
