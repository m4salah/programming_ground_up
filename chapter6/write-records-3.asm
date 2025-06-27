%include "linux.asm"
%include "record-def-2.asm"
%include "record-handler-2.asm"

section .data
record1:
fname: db "Fredrid", 0 ; first name
times 40 - ($-fname) db 0

lname:db "Bartlett" , 0 ;last name
times 40 - ($-lname) db 0

job:db "Engineer" , 0 ;job
times 40 - ($-job) db 0

address: db "4242 S Prairie", 10, "Tulsa, OK 55555",0
times 240 - ($-address) db 0

age: dd 45

filename: db "test3.data", 0

global _start

section .text
_start:
open_file:
mov rax, SYS_OPEN
mov rdi, filename
mov rsi, 0101o
mov rdx, 0666o
syscall

mov rdi, rax
mov rbx, 0
write_to_file:
write_record1:
mov rsi, record1
call write_record
inc rbx
cmp rbx, 30
jl write_to_file

close_file:
; close the file descriptor 
mov rax, SYS_CLOSE
; rdi still holding the file descriptor
syscall

mov rdi, rax
mov rax, SYS_EXIT
syscall
