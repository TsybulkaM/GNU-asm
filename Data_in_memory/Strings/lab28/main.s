.bss
	s: .space 256
	
.text
	.globl _start
	
_start:
	mov $123, %eax
	mov $s, %esi
	mov $10, %ecx
	
	mov %esp, %ebp
	
__begin:
	xor %edx, %edx
	div %ecx
	
	addb $'0', %dl
	
	xor %ebx, %ebx
	movb %dl, %bl
	push %ebx
	
	cmp $0, %eax
	je _pop_loop
	
	jmp __begin
	
_pop_loop:
	cmp %ebp, %esp
	je _finish
	
	pop %ebx
	
	movb %bl, (%esi)
	inc %esi
	
	jmp _pop_loop
	
_finish:
	movb $0, (%esi)
	
__end:
	nop
