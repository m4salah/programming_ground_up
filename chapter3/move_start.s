.section .data

.section .text

.globl _start

_start:
movl $_start, %ebx
movl $1, %eax          #1 is the exit() syscall
int $0x80
