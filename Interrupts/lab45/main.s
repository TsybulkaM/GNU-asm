.bss
    buffer: .space 12

.text
	.globl _start

_start:

__begin:
	mov $20, %eax
	int $0x80
    
    lea buffer, %esi
	mov $10, %ebx
	
	mov %esp, %ebp
    
.loop:
	cmp $0, %eax
	je .to_buffer
	xor %edx, %edx
	div %ebx
	
	add $'0', %edx
	push %edx
	
	jmp .loop
	
.to_buffer:
	xor %edx, %edx
	
.loop_fill_buff:
	cmp %ebp, %esp
	je .print
	
	pop %eax
	
	movb %al, (%esi)
	inc %esi
	inc %edx
	
	jmp .loop_fill_buff
	
.print:
	mov $4, %eax
	mov $1, %ebx
	lea buffer, %ecx
	# %edx already set
	int $0x80

__end:
	mov $1, %eax 
	mov $0, %ebx
	int $0x80
