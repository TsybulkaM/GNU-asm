.data
	s: .asciz "9aBs4CCa0Afz"
	
.text
	.globl _start
	
_start:
	mov $s, %esi
	
__begin:
	cmpb $0, (%esi)
	je __end

	cmpb $'a', (%esi)
	jl next_char
	cmpb $'z', (%esi)
	jg next_char
	
	subb $32, (%esi)
	
next_char:
	inc %esi
	jmp __begin
	
__end:
	nop
