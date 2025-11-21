.text
	.globl _start

# arg1 - %ebx, arg2 - %ecx, arg3 - %edx, ret - %al
is_right_angled_triangle:
	cmp %ebx, %edx
	jg .ac_next
	je .false
	xchg %ebx, %edx
	
.ac_next:
	cmp %ecx, %edx
	jg .bc_next
	je .false
	xchg %ecx, %edx
	
.bc_next:
	imul %ebx, %ebx
	imul %ecx, %ecx
	add %ebx, %ecx
	
	imul %edx, %edx
	
	cmp %ecx, %edx
	je .true
	
.false:
	movb $0, %al
	jmp .epilog
	
.true:
	movb $1, %al
	
.epilog:

	ret
	
_start:
	mov $3, %ebx
	mov $5, %ecx
	mov $4, %edx

__begin:
	call is_right_angled_triangle

__end:
	nop
