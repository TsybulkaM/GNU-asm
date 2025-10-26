## Build and run

### Install 32-bit C development libraries

```bash
sudo apt update
sudo apt install gcc-multilib libc6-dev-i386
```

### Compiling and Linking

```bash
gcc -mem32 -c main.s -o main.o
gcc -mem32 -c func.c -o func.o
gcc -mem32 main.o func.o -o test -lm
```
