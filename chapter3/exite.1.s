# PURPOSE: Simple program that exits and returns a
# status code back to the Linux kernel
#
# INPUT: none
#
# OUTPUT: returns a status code. This can be viewed
# by typing
#
# bash: echo $?
# fish: echo $status
# after running the program 
# 
# To run the program on Linux:
# 1. as exite.s -o exite.o
# 2. ld exite.o -o exite
# 3. ./exite
# 4. echo $?

# data section which has all the data needed for the program 
# we don't have any for the moment but we will need it later
.section .data

# Here we have all the code that will be executed when the program is run
.section .text

# This mark the start symbol of the program to not remove it
# because assembler will use it to know where to start
.globl _start

_start:
	movl $1, %eax
	movl $74, %ebx
