# PURPOSE: Program to illustrate how functions work
# This program will compute the value of
# 2^3 + 5^2
#
# Everything in the main program is stored in registers,
# so the data section doesn’t have anything.

.section .data

.section .text
.globl _start

_start:
# The return value in %rax
# We push the value into the stack
push $3
push $2
call power
add $16, %rsp
push %rax

# the power
push $2
# the base
push $5
# call the power function
call power
# clearing the stack
# because clearing the stack in x86 arch
# is the caller responsibilty
add $16, %rsp
# save the return the value into the stack
push %rax

push $3
push $0
call power
add $16, %rsp

pop %rbx
pop %rcx

# %rax already have the last value.
add %rax, %rbx
add %rcx, %rbx

# exit syscall
# https://electronicsreference.com/assembly-language/linux_syscalls/exit/
mov $60, %rax
mov %rbx, %rdi
syscall
