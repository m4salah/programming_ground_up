%include "linux.asm"
%include "record-def-2.asm"
%include "record-handler-2.asm"
%include "count-chars.asm"
%include "write-newline.asm"

section .data
filename: db "test2.data", 0

section .bss
record_buffer: resb RECORD_SIZE


global _start

section .text
_start:
ST_INPUT_DESCRIPTOR equ -8
ST_OUTPUT_DESCRIPTOR equ -16
mov rbp, rsp
sub rsp, 16
open_file:
mov rax, SYS_OPEN
mov rdi, filename
mov rsi, O_RDONLY
mov rdx, 0666o
syscall

; save the file descriptor into the stack
mov [rbp + ST_INPUT_DESCRIPTOR], rax
mov qword [rbp + ST_OUTPUT_DESCRIPTOR], STDOUT

record_read_loop:
mov rdi, [rbp + ST_INPUT_DESCRIPTOR]
mov rsi, record_buffer
call read_record

cmp rax, RECORD_SIZE
jne finish_reading

mov rdi, RECORD_FIRSTNAME + record_buffer
call count_chars

mov rdx, rax
mov rax, SYS_WRITE
mov rdi, [rbp + ST_OUTPUT_DESCRIPTOR]
mov rsi, RECORD_FIRSTNAME + record_buffer
syscall

mov rdi, [rbp + ST_OUTPUT_DESCRIPTOR]
call write_newline
jmp record_read_loop

finish_reading:
mov rax, SYS_EXIT
mov rdi, 0
syscall
