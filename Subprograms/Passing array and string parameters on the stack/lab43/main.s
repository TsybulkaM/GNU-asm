.data
	string: .asciz "Assembler the best!"

.text
	.globl _start
	
get_word_length:
	push %ebp
	mov %esp, %ebp
	
	push %ebx
	
	mov 8(%ebp), %ebx
	xor %ecx, %ecx
	
.loop:
	cmpb $0, (%ebx)
	je .epilog
	cmpb $' ', (%ebx)
	je .epilog
	cmpb $'\t', (%ebx)
	je .epilog
	
	inc %ecx
	inc %ebx
	
	jmp .loop
	
.epilog:
	pop %ebx
	
	mov %ebp, %esp
	pop %ebp
	
	ret

_start:
	nop

__begin:
	push $string
	call get_word_length

__end:
	nop
