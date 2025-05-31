
.global square

.type square, @function
square:
push %rbp
mov %rsp, %rbp
mov %rdi, %rax
mul %rax

# end
mov %rsp, %rbp
pop %rbp
ret

