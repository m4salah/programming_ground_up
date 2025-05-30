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
mov %rdi, %rbx
mov %rsi, %rcx
# Initialize result
mov $1, %rax    # Start with 1

power_loop_start:
cmp $0, %rcx
je end_power
mul %rbx
dec %rcx
jmp power_loop_start

end_power:
mov %rbp, %rsp
pop %rbp
ret

