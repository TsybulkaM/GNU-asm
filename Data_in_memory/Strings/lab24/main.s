.data
	s: .asciz "9aBs4CCa0AAA"
	
.text
	.globl _start
	
_start:
	mov $s, %esi
	
__begin:
	cmpb $0, (%esi)
	je __end

	cmpb $'0', (%esi)
	jl next_char
	cmpb $'9', (%esi)
	jg next_char
	
	inc %eax
	
next_char:
	inc %esi
	jmp __begin
	
__end:
	nop
