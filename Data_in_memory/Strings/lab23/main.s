.data
	s: .asciz "aBsCCa1AAA"
	
.text
	.globl _start
	
_start:
	mov $s, %esi
	
__begin:
	cmpb $0, (%esi)
	je __end

	cmpb $'A', (%esi)
	jl next_char
	cmpb $'Z', (%esi)
	jg next_char
	
	inc %eax
	
next_char:
	inc %esi
	jmp __begin
	
__end:
	nop
