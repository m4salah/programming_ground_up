.section .data
.section .text

.global _start

_start:
mov $5, %rcx
mov $1, %rax

factorial_loop:
cmp $1, %rcx
je end_loop
mul %rcx
dec %rcx
jmp factorial_loop

end_loop:
mov %rax, %rdi
mov $60, %rax
syscall
