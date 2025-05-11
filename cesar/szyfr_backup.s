# KLUCZ=X ./szyfr in.txt out.txt
.section .bss
buffer:     .space 4096     # for reading/writing file data (4KB)

.section .text
.global _start

_start:
    # --- Get command line arguments from stack ---
    # Stack layout at _start:
    # 0(%rsp): argc
    # 8(%rsp): argv[0] (program name)
    # 16(%rsp): argv[1] (input file path)
    # 24(%rsp): argv[2] (output file path)
    # ...
    # N(%rsp): NULL
    # N+8(%rsp): envp[0]
    # ...
    # M(%rsp): NULL (end of envp)
    movq %rsp, %rbx         # Use %rbx to conveniently access stack args/env

    # --- Open input file (argv[1]) ---
    movq 16(%rbx), %rdi     # Get argv[1] (input file path) into %rdi for syscall
    xorq %rsi, %rsi         # Flags: O_RDONLY (0)
    movq $2, %rax           # System call number (sys_open)
    syscall                 # Call kernel: open(path, flags)
    test %rax, %rax         # Check for errors (fd is non-negative on success)
    js fail                 # Jump to fail if rax < 0 (error opening input)
    movq %rax, %r12         # Save input file descriptor in %r12 (callee-saved)

    # --- Open output file (argv[2]) ---
    movq $257, %rax         # System call number (sys_openat)
    movq $-100, %rdi        # dirfd: AT_FDCWD (current working directory)
    movq 24(%rbx), %rsi     # Get argv[2] (output file path) into %rsi
    movq $577, %rdx         # flags: O_WRONLY | O_CREAT | O_TRUNC (decimal 577)
    movq $0644, %r10        # mode: 0644 octal (permissions if created)
    syscall                 # Call kernel: openat(dirfd, path, flags, mode)
    test %rax, %rax         # Check for errors
    js fail                 # Jump to fail if rax < 0 (error opening output)
    movq %rax, %r13         # Save output file descriptor in %r13 (callee-saved)

    # --- Find KLUCZ=key in environment variables ---
    movq (%rbx), %rcx       # Get argc from stack (at 0(%rsp)) into %rcx
    leaq 16(%rbx, %rcx, 8), %r15 # Calculate address of argv[argc] + 8 bytes = environ[0]
                                 # (argv starts at 8(%rsp), argc elements + prog name = rcx+1 elems * 8 bytes)
                                 # Simplified: address after the NULL terminating argv

find_key_loop:
    movq (%r15), %rdi       # Get pointer to the current environment string
    testq %rdi, %rdi        # Check if the pointer is NULL (end of environ array)
    je fail                 # If NULL, key not found, jump to fail (or handle as error)

    # Check for "KLUCZ=" prefix (7 bytes) - safer byte-by-byte check
    cmpl $0x43554C4B, (%rdi) # Compare first 4 bytes "KLUC" (little-endian: K=4B, L=4C, U=55, C=43)
    jne next_env_entry      # If not equal, try next environment variable
    cmpw $0x3D5A, 4(%rdi)    # Compare next 2 bytes "Z=" (little-endian: Z=5A, = = 3D)
    jne next_env_entry      # If not equal, try next environment variable
    cmpb $0, 6(%rdi)        # Check if the 7th byte exists (should be start of key or null)
                            # We actually need the byte *at* index 6, so just proceed
    # Prefix "KLUCZ=" matches if we are here

    # Prefix found, check length using strlen and extract key
    # We need the pointer %rdi for strlen, but also need it later to extract the key byte.
    # strlen clobbers %rdi. So, save %rdi before calling strlen.
    movq %rdi, %r14         # Save pointer to the start of "KLUCZ=..." string in %r14 (callee-saved)

    call strlen             # Call strlen (%rdi = input (already set), %rax = output length)

    # After strlen returns, %rax contains the length. %rdi is likely clobbered.
    cmpq $6, %rax           # Check if length is > 6 (needs "KLUCZ=" + at least one key byte)
    jbe next_env_entry      # If length <= 6, it is not our key (no byte after '='), try next

    # Key requirements met (prefix match, length > 6), extract the key byte
    movb 6(%r14), %r9b      # Get the key byte (at index 6) using the SAVED pointer in %r14
                            # Store the single key byte in %r9b
    jmp key_found           # Jump to the main processing loop

next_env_entry:
    addq $8, %r15           # Move %r15 to point to the next environment variable pointer
    jmp find_key_loop       # Continue searching the environment variables

# --- strlen function (calculates length of null-terminated string) ---
# Input: %rdi = pointer to string
# Output: %rax = length (excluding null terminator)
# Clobbers: %rax
strlen:
    xor %rax, %rax          # Initialize length counter %rax = 0
strlen_loop:
    cmpb $0, (%rdi, %rax)   # Compare byte at current offset (%rdi + %rax) to null
    je strlen_end           # If zero, end of string found
    inc %rax                # Increment length counter
    jmp strlen_loop         # Loop
strlen_end:
    ret                     # Return (length is in %rax)

# --- Key found, start reading/processing/writing loop ---
key_found:
read_loop:
    # --- Read data from input file ---
    movq %r12, %rdi         # Arg 1: fd_in (from %r12)
    leaq buffer(%rip), %rsi # Arg 2: Pointer to buffer
    movq $4096, %rdx        # Arg 3: Max bytes to read (buffer size)
    xorq %rax, %rax         # System call number (sys_read = 0)
    syscall                 # Call kernel: read(fd, buf, count)
    testq %rax, %rax        # Check result (%rax = bytes read)
    jle done                # If 0 bytes read (EOF) or < 0 (error), go to done/cleanup
                            # Note: A more robust check would separate EOF (je done) and error (js fail)
    movq %rax, %r8          # Save number of bytes read in %r8 (callee-saved)

    # --- Process buffer: XOR with key byte (%r9b) ---
    leaq buffer(%rip), %rdi # Get pointer to start of buffer for processing in %rdi

    # Process buffer in 8-byte chunks for potential efficiency
    movq %r8, %rcx          # Get bytes read into %rcx for chunk counter
    shrq $3, %rcx           # Divide by 8 to get number of full 8-byte chunks
    jz process_remainder    # If less than 8 bytes were read, skip chunk processing

process_chunks:
    movq (%rdi), %rax       # Load 8 bytes from buffer
    movq $0x0101010101010101, %rdx # Mask to replicate byte
    movzbq %r9b, %rsi       # Move key byte to 64-bit register zero-extended
    imulq %rsi, %rdx        # Replicate the key byte across all 8 bytes of %rdx
    xorq %rdx, %rax         # XOR the 8 buffer bytes with the replicated key bytes
    movq %rax, (%rdi)       # Store the processed 8 bytes back
    addq $8, %rdi           # Move buffer pointer forward by 8 bytes
    decq %rcx               # Decrement chunk counter
    jnz process_chunks      # Loop if more chunks remain

process_remainder:
    # Process any remaining bytes (0-7) individually
    movq %r8, %rcx          # Get original bytes read count
    andq $7, %rcx           # Get remainder (count % 8)
    jz write_processed_data # If remainder is 0, nothing left to process, go to write

process_remainder_loop:
    movb (%rdi), %al        # Load one byte from buffer into %al
    xorb %r9b, %al          # XOR with the key byte (%r9b)
    movb %al, (%rdi)        # Store processed byte back
    incq %rdi               # Increment buffer pointer
    decq %rcx               # Decrement remainder counter
    jnz process_remainder_loop # Loop if more remainder bytes

write_processed_data:
    # --- Write processed data to output file ---
    movq %r13, %rdi         # Arg 1: fd_out (from %r13)
    leaq buffer(%rip), %rsi # Arg 2: Pointer to the processed buffer
    movq %r8, %rdx          # Arg 3: Number of bytes to write (bytes read in this iteration)
    movq $1, %rax           # System call number (sys_write = 1)
    syscall                 # Call kernel: write(fd, buf, count)
    # Basic error check for write:
    cmpq %r8, %rax          # Did write return the expected number of bytes?
    jne fail                # If not, assume error and fail (could be more robust check for < 0)

    jmp read_loop           # Go back to read the next chunk of data

done:
    # Close input file descriptor
    movq %r12, %rdi         # fd_in
    movq $3, %rax           # System call number (sys_close)
    syscall
    # Ignore potential close errors for simplicity here

    # Close output file descriptor
    movq %r13, %rdi         # fd_out
    movq $3, %rax           # System call number (sys_close)
    syscall

    # Exit successfully
    xorq %rdi, %rdi         # Exit code 0
    movq $60, %rax          # System call number (sys_exit)
    syscall                 # Exit(0)

fail:
    movq $1, %rdi           # Exit code 1
    movq $60, %rax          # System call number (sys_exit)
    syscall                 # Exit(1)

