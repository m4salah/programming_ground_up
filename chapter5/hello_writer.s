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

hello: .string "Hey diddle diddle!\n"
.equ MESSAGE_LEN, . - hello - 1  
     # . for the current address, hello for the address of the message, 1 for the null terminator so it's like current_address - the begin adress - 1
file: .string "heynow.txt"

.section .text

.globl _start
_start:

open_fd_out:
mov $SYS_OPEN, %rax
mov $file, %rdi	#output filename
mov $O_CREAT_WRONLY_TRUNC, %rsi
mov $0666, %rdx
syscall

write_msg_to_fd_out:
mov %rax, %rdi	#output filename
mov $SYS_WRITE, %rax
mov $hello, %rsi
mov $MESSAGE_LEN, %rdx
syscall

#exit
mov $0, %rdi			#exit status
mov $SYS_EXIT, %rax		#exit system call
syscall
