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
	push %ebp
    mov %esp, %ebp
    
    push %ecx
    push %ebx
    push %edx
    
    movl 8(%ebp), %ebx
    movl 12(%ebp), %ecx
    xor %eax, %eax
    
.loop_sum:
    addl (%ebx), %eax
    addl $4, %ebx
    loop .loop_sum
    
    xor %edx, %edx
    cltd
    idivl 12(%ebp)
	
    pop %edx
    pop %ebx
    pop %ecx
    
    mov %ebp, %esp
	pop %ebp
	
    ret

_start:
	nop
	
__begin:
    push $arr1_size
    push $arr1
    call array_mean
    mov %eax, %esi
    add $8, %esp
    
    push $arr2_size
    push $arr2
    call array_mean
    mov %eax, %edi
    add $8, %esp

    push $arr3_size
    push $arr3
    call array_mean
    add $8, %esp

__end:
	# result1 - esi
	# result2 - edi
	# result3 - eax
	nop
