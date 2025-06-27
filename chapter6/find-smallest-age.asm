%include "linux.asm"
%include "record-def-2.asm"
%include "record-handler-2.asm"

section .data
filename: db "test2.data", 0

section .bss
record_buffer: resb RECORD_SIZE

global _start

section .text
_start:
ST_INPUT_DESCRIPTOR equ -8
mov rbp, rsp
sub rsp, 8

open_file:
mov rax, SYS_OPEN
mov rdi, filename
mov rsi, O_RDONLY
mov rdx, 0666o
syscall

; save the file descriptor
mov [rbp + ST_INPUT_DESCRIPTOR], rax

mov rbx, 255 ; this will be index to iterate
mov rdi, [rbp + ST_INPUT_DESCRIPTOR]
mov rsi, record_buffer
record_read_loop:
call read_record

cmp rax, RECORD_SIZE
jne finish_reading

cmp rbx, [record_buffer + RECORD_AGE]
jg new_age
jmp record_read_loop

new_age:
mov rbx, [record_buffer + RECORD_AGE]
jmp record_read_loop

finish_reading:
close_file:
; close the file descriptor 
mov rdi, [rbp + ST_INPUT_DESCRIPTOR]
mov rax, SYS_CLOSE
; rdi still holding the file descriptor
syscall

mov rdi, rbx
mov rax, SYS_EXIT
syscall
