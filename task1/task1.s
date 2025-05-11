	.section .text
	.globl _start
	
_start:
	movq $5, %rdi
	movq $60, %rax
	syscall
	
# To check run: 
# ./task1
# echo $?
# -> 5
