# ==== Build & run ====
# Usage: bash br.sh task1/main.s

as --32 -g $1.s -o $1.o && ld -melf_i386 $1.o -o $1
./$1

echo "Program exited with code: $?"
