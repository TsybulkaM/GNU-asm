.data
	.set ARRAY_SIZE, 8
	
.bss
	fib_array: .space	4 * ARRAY_SIZE

.text
	.globl _start


_start:
	mov $ARRAY_SIZE, %ecx
	mov $fib_array, %edi
	
	cmp $0, %ecx
	jle __end
	movl $1, (%edi)
	dec %ecx
	add $4, %edi
	
	cmp $0, %ecx
	jle __end
	movl $1, (%edi)
	dec %ecx
	add $4, %edi

__begin:
	cmp $0, %ecx
	jle __end
	
	movl -8(%edi), %eax
    addl -4(%edi), %eax
    movl %eax, (%edi)
	
	add $4, %edi
	dec %ecx
	
	jmp __begin
	
__end:
	nop
