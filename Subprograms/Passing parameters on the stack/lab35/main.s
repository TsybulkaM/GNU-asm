.text
	.globl _start
	
is_triangles_sides:
	push %ebp
    mov %esp, %ebp
    
    mov 8(%ebp), %eax
    
    movl 8(%ebp), %ecx
    addl 12(%ebp), %ecx
    addl 16(%ebp), %ecx
	
	cmpl 12(%ebp), %eax
	jg .next
	movl 12(%ebp), %eax

.next:
	cmpl 16(%ebp), %eax
	jg .verdict
	movl 16(%ebp), %eax
    
.verdict:
	sub %eax, %ecx
	cmp %ecx, %eax
	jge .set_neg

.set_pos:
	mov $1, %al
	jmp .end

.set_neg:
	mov $0, %al

.end:
	mov %ebp, %esp
	pop %ebp
	ret 

_start:
	mov $0, %eax

__begin:
	pushl $6
	pushl $3
	pushl $4
	call is_triangles_sides
	add $12, %esp

__end:
	nop
