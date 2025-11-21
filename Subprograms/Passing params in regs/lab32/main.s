.data
	long1: .word 3
	long2: .word 20

.text
	.globl _start

# arg1 - %esi, arg2 - %edi
swapw:
	push %ecx
	push %eax
	
	movw (%esi), %cx
    movw (%edi), %ax
    movw %ax, (%esi)
    movw %cx, (%edi)
    
    pop %eax 
    pop %ecx
	ret

_start:

__begin:
	mov $long1, %esi
	mov $long2, %edi
	
	call swapw

__end:
	# x/hd &long1
	# x/hd &long2
	nop
