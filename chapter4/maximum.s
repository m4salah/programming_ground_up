.section .data
data_items1: #These are the data items
.quad 3,67,34,222,45,75,54,34,44,33,22,11,66

data_items2: #These are the data items
.quad 3,67,34,45,75,54,34,44,33,22,11,66

data_items3: #These are the data items
.quad 3,67,34,45,54,34,44,33,22,11,66

.section .text

.global _start
.global maximum

_start:
push $13
push $data_items1
call maximum
add $16, %rsp

push $12
push $data_items2
call maximum
add $16, %rsp

push $11
push $data_items3
call maximum
add $16, %rsp

exit:
# exit syscall
# https://electronicsreference.com/assembly-language/linux_syscalls/exit/
mov %rax, %rdi
mov $60, %rax
syscall


.type maximum, @function
maximum:
push %rbp
mov %rsp, %rbp
mov 16(%rbp), %rbx # Pointer to the first element in the list
mov 24(%rbp), %rcx # The length of the list
mov $0, %rdi       # The index iterator
mov (%rbx, %rdi, 8), %rax

loop:
cmp %rdi, %rcx
je loop_end
inc %rdi
cmp %rax, (%rbx, %rdi, 8)
jle loop
mov (%rbx, %rdi, 8), %rax
jmp loop

loop_end:
mov %rbp, %rsp
pop %rbp
ret

