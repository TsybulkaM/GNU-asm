.data
	string: .ascii "Hello, world!"
	end_string:
	
	.set string_size, end_string - string
	

.text
	.globl _start

_start:
	mov $4, %eax
	mov $1, %ebx
	lea string, %ecx #mov $string, %ecx
	mov $string_size, %edx
	int $0x80

__begin:
	

__end:
	mov $1, %eax 
	mov $0, %ebx
	int $0x80
