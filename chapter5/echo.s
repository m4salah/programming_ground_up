.section .data

#system call numbers (64-bit)
.equ SYS_READ, 0
.equ SYS_WRITE, 1
.equ SYS_OPEN, 2
.equ SYS_CLOSE, 3
.equ SYS_EXIT, 60

#options for open
.equ O_RDONLY, 0
.equ O_CREAT_WRONLY_TRUNC, 03101

#standard file descriptors
.equ STDIN, 0
.equ STDOUT, 1
.equ STDERR, 2

.equ END_OF_FILE, 0		#return value of read when end of file
.equ NUMBER_ARGUMENTS, 2


.section .bss
#Buffer - Data from input file loaded into, 
#	  converted to uppercase and written
#	  to output file
.equ BUFFER_SIZE, 500
.lcomm BUFFER_DATA, BUFFER_SIZE	#creates buffer called buffer_data
				#with size of 500 bytes.

.section .text

#STACK POSITIONS (64-bit offsets)
.equ ST_SIZE_RESERVE, 8	#reserve space for 2 quadwords
.equ ST_FD_IN, -8		#input file descriptor
.equ ST_ARGC, 0			#number of arguments
.equ ST_ARGV_0, 8		#name of program (64-bit pointers)
.equ ST_ARGV_1, 16		#input file name



.globl _start
_start:
mov %rsp, %rbp

read_loop_begin:
# READ from the stdin
mov $SYS_READ, %rax
mov $STDIN, %rdi
mov $BUFFER_DATA, %rsi
mov $BUFFER_SIZE, %rdx
syscall

cmp $END_OF_FILE, %rax		#check for the end of file marker
jle end_loop			#if found or on error, go to end

# write to the stderr
mov %rax, %rdx
mov $SYS_WRITE, %rax
mov $STDERR, %rdi
mov $BUFFER_DATA, %rsi
syscall

jmp read_loop_begin


end_loop:
# exit
mov $SYS_EXIT, %rax		#exit system call
mov $0, %rdi			#exit status
syscall
