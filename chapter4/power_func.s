
# PURPOSE: This function is used to compute
# the value of a number raised to
# a power.
#
# INPUT: First argument - the base number
# Second argument - the power to
# raise it to
#
# OUTPUT: Will give the result as a return value
#
# NOTES: The power must be 1 or greater
#
# VARIABLES:
# %rbx - holds the base number
# %rcx - holds the power
#
# -8(%rbp) - holds the current result
#   8(%rbp) - holds the return address
# %rax is used for temporary storage
#

.section .data

.section .text

# to make this function global to use in other files
.global power

.type power, @function
power:
push %rbp
mov %rsp, %rbp
sub $8, %rsp        # %rbp is pointing to the return address, moving up to access the paramter, moving down to access the local storage.
mov 16(%rbp), %rbx  # 8(%rbp) pointing to the ret address
mov 24(%rbp), %rcx
mov %rbx, -8(%rbp)

power_loop_start:
cmp $1, %rcx
je end_power
mov -8(%rbp), %rax
imul %rbx, %rax
mov %rax, -8(%rbp)
dec %rcx
jmp power_loop_start

end_power:
mov -8(%rbp), %rax
mov %rbp, %rsp
pop %rbp
ret
