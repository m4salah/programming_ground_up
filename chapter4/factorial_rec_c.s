# PURPOSE: This function is used to factorial
#
# INPUT: First argument - the number you want to factorial
#
# OUTPUT: Will give the factorial of the number N!
#

.section .data

.section .text

# to make this function global to use in other files
.global factorial

.type power, @function
factorial:
push %rbp
mov %rsp, %rbp
mov %rdi, %rax

base_case:
cmp $1, %rax
je end_factorial

rec_case:
push %rdi
dec %rdi
call factorial
pop %rbx
mul %rbx

end_factorial:
mov %rbp, %rsp
pop %rbp
ret

