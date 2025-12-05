.data
	arr1: .long 2, 4, 6
	arr1_end:
	.set arr1_size, (arr1_end - arr1) / 4
	
	arr2: .long -10, -20, -30, -40
	arr2_end:
	.set arr2_size, (arr2_end - arr2) / 4
	
	arr3: .long -5, 15, 1
	arr3_end:
	.set arr3_size, (arr3_end - arr3) / 4

.section .text
    .globl _start
    
array_mean:
    push %ebx
    push %ecx
    push %edx
    push %esi
    
    mov %ecx, %esi
    xor %eax, %eax
    
.loop_sum:
    add (%ebx), %eax
    add $4, %ebx
    loop .loop_sum
    
    cltd
    idivl %esi
	
	pop %esi
    pop %edx
    pop %ecx
    pop %ebx
    ret

_start:
	nop
	
__begin:
    mov $arr1, %ebx
    mov $arr1_size, %ecx
    call array_mean
    mov %eax, %esi
    
    mov $arr2, %ebx
    mov $arr2_size, %ecx
    call array_mean
    mov %eax, %edi

    mov $arr3, %ebx
    mov $arr3_size, %ecx
    call array_mean

__end:
	# result1 - esi
	# result2 - edi
	# result3 - eax
	nop
