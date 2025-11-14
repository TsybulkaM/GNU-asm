.data
	n: .asciz "134"
	
.text
	.globl _start
	
_start:
	movl $n, %esi
	
__begin:
	movb (%esi), %bl
	cmp $0, %bl
	je __end

	imul $10, %eax
	subb $'0', %bl
	
	movzbl %bl, %ebx
	add %ebx, %eax

	inc %esi
	jmp __begin
	
__end:
	nop
