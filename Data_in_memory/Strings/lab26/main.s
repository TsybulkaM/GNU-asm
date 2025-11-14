.data
	s: .asciz "ABCBA"
	s_end:
	.set s_size, s_end - s - 1
	.set s_size_half, s_size / 2
	 
.text
	.globl _start
	
_start:
	movl $s, %esi
	movl $s_end - 2, %edi
	
__begin:
	cmp $s_size_half, %ebx
	je set_pos

	movb (%esi), %al
	
	cmpb %al, (%edi)
	jne set_neg
	
	inc %ebx
	inc %esi
	dec %edi
	
	jmp __begin

set_neg:
	mov $0, %al
	jmp __end
	
set_pos:
	mov $1, %al
	jmp __end
	
__end:
	nop
