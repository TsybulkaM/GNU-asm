.data
	string: .asciz "Assembler the best!"

.text
	.globl _start
	
get_word_length:
	push %ebx
	
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
	
	ret

_start:
	nop

__begin:
	mov $string, %ebx
	call get_word_length

__end:
	nop
