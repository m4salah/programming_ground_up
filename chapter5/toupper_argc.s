#PURPOSE: This program converts an input file
#	  to an output file with all letters 
#	  converted to uppercase.
#
#Processing: 1) Open the input file
#	     2) Open the output file
#	     3) While we're not at the end of the input file
#		a) read part of file into our memory buffer
#		b) go through each byte of memory
#			if the byte is lowercase letter,
#			convert it to uppercase
#		c) write the memory buffer to output file

.section .data

########CONSTANTS########

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
.equ ST_SIZE_RESERVE, 16	#reserve space for 2 quadwords
.equ ST_FD_IN, -8		#input file descriptor
.equ ST_FD_OUT, -16		#output file descriptor
.equ ST_ARGC, 0			#number of arguments
.equ ST_ARGV_0, 8		#name of program (64-bit pointers)
.equ ST_ARGV_1, 16		#input file name
.equ ST_ARGV_2, 24		#output file name

.globl _start
_start:

####Initialize program#####
#save stack pointer
mov %rsp, %rbp

cmp $3, %rbp
je open_files
jmp read_from_stdin

open_files:
# allocate space for file descriptors on the stack
sub $ST_SIZE_RESERVE, %rsp	#2 quadwords
open_fd_in:			#open input file
mov $SYS_OPEN, %rax		#system call number for open
mov ST_ARGV_1(%rbp), %rdi	#filename (first argument in rdi)
mov $O_RDONLY, %rsi		#flags (second argument in rsi)
mov $0666, %rdx		#mode (third argument in rdx)
syscall				#64-bit system call

store_fd_in:
mov %rax, ST_FD_IN(%rbp)	#store file descriptor

open_fd_out:
mov $SYS_OPEN, %rax
mov ST_ARGV_2(%rbp), %rdi	#output filename
mov $O_CREAT_WRONLY_TRUNC, %rsi
mov $0666, %rdx
syscall

store_fd_out:
mov %rax, ST_FD_OUT(%rbp)	#store file descriptor

read_loop_begin:
mov $SYS_READ, %rax		#read system call
mov ST_FD_IN(%rbp), %rdi	#file descriptor (first argument)
mov $BUFFER_DATA, %rsi		#buffer location (second argument)
mov $BUFFER_SIZE, %rdx		#buffer size (third argument)
syscall				#size of buffer read is returned to %rax

#exit if we have reached the end
cmp $END_OF_FILE, %rax		#check for the end of file marker
jle end_loop			#if found or on error, go to end

continue_read_loop:
#convert the block to uppercase
mov %rax, %rdi			#first argument: buffer size
mov $BUFFER_DATA, %rsi		#second argument: buffer location
call convert_to_upper		#call conversion function

#write the block out to the output file
mov %rax, %rdx			#buffer size (third argument)
mov $SYS_WRITE, %rax		#write system call
mov ST_FD_OUT(%rbp), %rdi	#file descriptor (first argument)
mov $BUFFER_DATA, %rsi		#buffer location (second argument)
syscall				#call kernel

#Continue the loop
jmp read_loop_begin

end_loop:
#Close the files
mov $SYS_CLOSE, %rax
mov ST_FD_OUT(%rbp), %rdi	#output file descriptor
syscall

mov $SYS_CLOSE, %rax
mov ST_FD_IN(%rbp), %rdi	#input file descriptor
syscall

#exit
mov $SYS_EXIT, %rax		#exit system call
mov $0, %rdi			#exit status
syscall

#PURPOSE: This function actually does the conversion 
#	  to uppercase for a block
#
#INPUT:	  First parameter (%rdi) is the length of the buffer
#	  Second parameter (%rsi) is the location of the block of
#	  memory to convert
#
#OUTPUT:  This function overwrites the current buffer
#	  with the upper-casified version
#
#VARIABLES:
#	  %rsi - beginning of buffer
#	  %rdi - length of buffer
#	  %rcx - current buffer offset
#	  %al - current byte being examined

#CONSTANTS
.equ LOWERCASE_A, 'a'		#lower boundary of our search
.equ LOWERCASE_Z, 'z'		#upper boundary of our search
.equ UPPER_CONVERSION, 'A' - 'a'#Conversion between upper and lower case

convert_to_upper:
push %rbp
mov %rsp, %rbp

#SET UP VARIABLES
# %rdi already contains buffer length
# %rsi already contains buffer address
mov $0, %rcx			#initialize offset to 0

cmp $0, %rdi			#check if the buffer length is zero
je end_convert_loop		#if so, just leave

convert_loop:
mov (%rsi,%rcx,1), %al		#get the current byte
				#byte = (buffer_start + offset)

cmp $LOWERCASE_A, %al		#check if the byte is between 'a'
jl next_byte			#and 'z'
cmp $LOWERCASE_Z, %al		#if not, go to next byte
jg next_byte

add $UPPER_CONVERSION, %al	#convert to uppercase
mov %al, (%rsi,%rcx,1)		#store it back into buffer

next_byte:
inc %rcx			#increment buffer offset
cmp %rcx, %rdi			#continue until we have reached the end
jne convert_loop

end_convert_loop:
mov %rbp, %rsp			#no return value, just leave
pop %rbp
ret

// This function read from the stdin and out to stderr
read_from_stdin:
# READ from the stdin
mov $SYS_READ, %rax
mov $STDIN, %rdi
mov $BUFFER_DATA, %rsi
mov $BUFFER_SIZE, %rdx
syscall

cmp $END_OF_FILE, %rax		#check for the end of file marker
jle end_stdin_loop			#if found or on error, go to end

push %rax
# write to the stderr
mov %rax, %rdi			#first argument: buffer size
mov $BUFFER_DATA, %rsi		#second argument: buffer location
call convert_to_upper
pop %rax
mov %rax, %rdx
mov $SYS_WRITE, %rax
mov $STDERR, %rdi
mov $BUFFER_DATA, %rsi
syscall

jmp read_from_stdin

end_stdin_loop:
# exit
mov $SYS_EXIT, %rax		#exit system call
mov $0, %rdi			#exit status
syscall

# To run: From the command line
# Takes the file toupper.s, changes all lowercase to uppercase and saves as a new file toupper.uppercase
#			as --64 toupper.s -o toupper.o
#			ld toupper.o -o toupper
#			./toupper toupper.s toupper.uppercase
