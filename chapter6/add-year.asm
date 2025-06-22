%include "linux.asm"
%include "record-def.asm"
%include "record-handler.asm"
%include "count-chars.asm"
%include "write-newline.asm"

section .data
input_filename: db "test.data", 0
output_filename: db "testout.data", 0

section .bss
record_buffer: resb RECORD_SIZE


global _start

section .text
_start:
ST_INPUT_DESCRIPTOR equ -8
ST_OUTPUT_DESCRIPTOR equ -16
mov rbp, rsp
sub rsp, 16

open_input_file:
mov rax, SYS_OPEN
mov rdi, input_filename
mov rsi, O_RDONLY
mov rdx, 0666o
syscall

; save the input file descriptor into the stack
mov [rbp + ST_INPUT_DESCRIPTOR], rax

open_output_file:
mov rax, SYS_OPEN
mov rdi, output_filename
mov rsi, O_RDONLY | O_CREAT | O_WRONLY
mov rdx, 0666o
syscall

; save the output file descriptor into the stack
mov [rbp + ST_OUTPUT_DESCRIPTOR], rax

record_read_loop:
mov rdi, [rbp + ST_INPUT_DESCRIPTOR]
mov rsi, record_buffer
call read_record

cmp rax, RECORD_SIZE
jne finish_reading

inc byte [record_buffer + RECORD_AGE]

mov rdi, [rbp + ST_OUTPUT_DESCRIPTOR]
mov rsi, record_buffer
call write_record

jmp record_read_loop

finish_reading:
mov rax, SYS_EXIT
mov rdi, 0
syscall
