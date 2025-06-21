# PURPOSE: This program displays the contents of an input file
# to the standard error
#
# Processing:
# 1) Open the input file
# 2) While we're not at the end of the input file
## a) read part of file into our memory buffer
## b) write the memory buffer to the standard error
#
# To run: From the command line
# as cat.s -o cat.o
# ld cat.o -o cat
# ./cat <input_file_name>

.section .data

# system call numbers (64-bit)
.equ SYS_READ, 0
.equ SYS_WRITE, 1
.equ SYS_OPEN, 2
.equ SYS_CLOSE, 3
.equ SYS_EXIT, 60

# options for open
.equ O_RDONLY, 0

# standard file descriptors
.equ STDIN, 0
.equ STDOUT, 1
.equ STDERR, 2

.equ END_OF_FILE, 0 # return value of read when end of file

.section .bss

# Buffer - Data from input file loaded into
.equ   BUFFER_SIZE, 512
.lcomm BUFFER_DATA, BUFFER_SIZE #creates buffer called buffer_data

#with size of 500 bytes.

.section .text

#STACK POSITIONS (64-bit offsets)
.equ ST_SIZE_RESERVE, 8 #reserve space for 2 quadwords
.equ ST_FD_IN, -8  #input file descriptor
.equ ST_ARGC, 0   #number of arguments
.equ ST_ARGV_0, 8  #name of program (64-bit pointers)
.equ ST_ARGV_1, 16  #input file name

.globl _start

_start:

	mov %rsp, %rbp
	sub $ST_SIZE_RESERVE, %rsp

# open the file
mov $SYS_OPEN, %rax
mov ST_ARGV_1(%rbp), %rdi
mov $O_RDONLY, %rsi
mov $0666, %rdx
syscall

mov %rax, ST_FD_IN(%rbp) #store file descriptor

read_loop_begin:
# READ the file to the buffer
mov $SYS_READ, %rax
mov ST_FD_IN(%rbp), %rdi
mov $BUFFER_DATA, %rsi
mov $BUFFER_SIZE, %rdx
syscall

cmp $END_OF_FILE, %rax
jle end_loop   #if found or on error, go to end

# write to the stderr
mov %rax, %rdx
mov $SYS_WRITE, %rax
mov $STDERR, %rdi
mov $BUFFER_DATA, %rsi
syscall

	jmp read_loop_begin

end_loop:
# close the file
mov $SYS_CLOSE, %rax
mov ST_ARGV_1(%rbp), %rdi
syscall

# exit
mov $SYS_EXIT, %rax  #exit system call
mov $0, %rdi   #exit status
syscall
