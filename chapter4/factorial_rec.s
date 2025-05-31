.section .data
.section .text

.global _start

_start:
push $6
call factorial_func
# clean the stack
add $8, %rsp

mov %rax, %rdi
mov $60, %rax
syscall

factorial_func:
push %rbp
mov %rsp, %rbp
sub $8, %rsp
mov 16(%rbp), %rax
cmp $1, %rax
je end_rec
push %rax
dec %rax
push %rax
call factorial_func
add $8, %rsp
pop %rcx
mul %rcx


end_rec:
mov %rbp, %rsp
pop %rbp
ret
