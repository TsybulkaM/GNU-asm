.data
	s_num: .asciz "238"

.text
	.globl _start
	
stoi:
	push %ebp
	mov %esp, %ebp

	push %ebx
	push %ecx
	
	movl 8(%ebp), %ebx
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
	
	mov %ebp, %esp
	pop %ebp
	
	ret

_start:
	nop

__begin:
	push $s_num
	call stoi
	add $4, %esp

__end:
	nop
