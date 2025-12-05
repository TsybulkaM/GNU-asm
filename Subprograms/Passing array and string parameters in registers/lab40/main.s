.data
	s_num: .asciz "238"

.text
	.globl _start
	
stoi:
	push %ebx
	push %ecx
	
	xor %eax, %eax
	
.loop:
	cmpb $0, (%ebx)
	je .epilog
	
	imul $10, %eax
	
	movzbl (%ebx), %ecx
	sub $'0', %ecx
	add %ecx, %eax
	
	inc %ebx
	
	jmp .loop
	
.epilog:
	pop %ecx
	pop %ebx
	
	ret

_start:
	nop

__begin:
	mov $s_num, %ebx
	call stoi

__end:
	nop
