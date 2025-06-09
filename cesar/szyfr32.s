.section .bss
buffer:     .space 4096     # for reading/writing file data (4KB)

.section .text
.global _start

_start:
    # --- Get command line arguments from stack ---
    movl %esp, %ebp         # Save stack pointer in %ebp (safer)

    # --- Open input file (argv[1]) ---
    movl $5, %eax           # System call number (sys_open)
    movl 8(%ebp), %ebx      # Get argv[1] (input file path)
    xorl %ecx, %ecx         # Flags: O_RDONLY (0)
    int $0x80               # Call kernel
    cmpl $0, %eax           # Check for errors
    jl fail                 # Jump if error
    movl %eax, %esi         # Save input file descriptor in %esi

    # --- Open output file (argv[2]) ---
    movl $5, %eax           # System call number (sys_open)
    movl 12(%ebp), %ebx     # Get argv[2] (output file path)
    movl $577, %ecx         # flags: O_WRONLY | O_CREAT | O_TRUNC
    movl $0644, %edx        # mode: 0644 (permissions)
    int $0x80               # Call kernel
    cmpl $0, %eax           # Check for errors
    jl fail                 # Jump if error
    movl %eax, %edi         # Save output file descriptor in %edi

    # --- Find KLUCZ=key in environment variables ---
    movl 0(%ebp), %ecx      # Get argc
    leal 16(%ebp, %ecx, 4), %ebx  # Calculate address of envp[0]

find_key_loop:
    movl (%ebx), %edx       # Get pointer to current env string
    testl %edx, %edx        # Check if NULL
    je fail                 # Key not found, fail

    # Check for "KLUCZ=" prefix
    cmpl $0x43554C4B, (%edx)  # "KLUC"
    jne next_env_entry
    cmpw $0x3D5A, 4(%edx)     # "Z="
    jne next_env_entry

    # Extract key byte
    movb 6(%edx), %cl       # Store key byte in %cl
    jmp key_found

next_env_entry:
    addl $4, %ebx           # Next env pointer
    jmp find_key_loop

key_found:
read_loop:
    # --- Read data from input file ---
    movl $3, %eax           # System call number (sys_read)
    movl %esi, %ebx         # fd_in
    leal buffer, %ecx       # buffer address
    movl $4096, %edx        # bytes to read
    int $0x80               # Call kernel
    testl %eax, %eax        # Check result (bytes read)
    jle done                # EOF or error
    movl %eax, %ebp         # Save bytes read

    # --- Process buffer: XOR with key byte ---
    movl $buffer, %edx      # Buffer pointer
    movl %ebp, %eax         # Bytes to process
process_byte:
    movb (%edx), %bl        # Get byte
    xorb %cl, %bl           # XOR with key
    movb %bl, (%edx)        # Store back
    incl %edx               # Next byte
    decl %eax               # Count down
    jnz process_byte        # Continue until all bytes processed

    # --- Write processed data to output file ---
    movl $4, %eax           # System call number (sys_write)
    movl %edi, %ebx         # fd_out
    leal buffer, %ecx       # buffer address
    movl %ebp, %edx         # bytes to write
    int $0x80               # Call kernel
    cmpl %ebp, %eax         # Check if all bytes written
    jne fail                # Error if not

    jmp read_loop           # Process next chunk

done:
    # Close input file
    movl $6, %eax           # System call number (sys_close)
    movl %esi, %ebx         # fd_in
    int $0x80

    # Close output file
    movl $6, %eax           # System call number (sys_close)
    movl %edi, %ebx         # fd_out
    int $0x80

    # Exit successfully
    movl $1, %eax           # System call number (sys_exit)
    xorl %ebx, %ebx         # Exit code 0
    int $0x80

fail:
    movl $1, %eax           # System call number (sys_exit)
    movl $1, %ebx           # Exit code 1
    int $0x80
