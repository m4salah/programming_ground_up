.section .data
.section .text

.global _start

_start:
# call factorial_func with 6
push $5
call factorial_func
# clean the stack
add $8, %rsp

# as usual exit syscall
mov %rax, %rdi
mov $60, %rax
syscall

factorial_func:
push %rbp
mov %rsp, %rbp
# move the passed paramater to rax register
mov 16(%rbp), %rax
# this is the base case for the recusion
cmp $1, %rax
je end_rec
# Save the original value into the stack
push %rax
# decrement rax to pass it again into factorial func
dec %rax
# pass the decremented rax to the stack preparing it to call
push %rax
# ------------------------------------------
# call factorial_func with the decremented rax
call factorial_func
# clean the stack
add $8, %rsp
# ------------------------------------------
# pop the original rax into rcx
pop %rcx
# multipy rcx to rax and save the value to rax which is the return value
mul %rcx


end_rec:
mov %rbp, %rsp
pop %rbp
ret
