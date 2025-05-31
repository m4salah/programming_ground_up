.section .data
.section .text
.global _start

_start:
push $5
call square
add $8, %rsp

mov %rax, %rdi
mov $60, %rax
syscall

.type square, @function
square:
push %rbp
mov %rsp, %rbp
mov 16(%rbp), %rax
mul %rax

# end
mov %rsp, %rbp
pop %rbp
ret

