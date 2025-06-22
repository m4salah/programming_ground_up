%include "linux.asm"

section .data
newline db 10

global write_newline
section .text
write_newline:
push rbp
mov rbp, rsp

mov rax, SYS_WRITE
mov rdi, STDOUT
mov rsi, newline
mov rdx, 1
syscall

mov rsp, rbp
pop rbp
ret
