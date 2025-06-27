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

record2:
fname2: db "Marilyn", 0 ; first name
times 40 - ($-fname2) db 0

lname2:db "Taylor" , 0 ;last name
times 40 - ($-lname2) db 0

job2:db "Doctor" , 0 ;job
times 40 - ($-job2) db 0

address2: db "2224 S Johannan St", 10, "Chicago, IL 12345",0
times 240 - ($-address2) db 0

age2: dd 29

record3:
fname3: db "Derrick", 0 ; first name
times 40 - ($-fname3) db 0

lname3: db "McIntire" , 0 ;last name
times 40 - ($-lname3) db 0

job3:db "Officer" , 0 ;job
times 40 - ($-job3) db 0

address3: db "500 W Oakland", 10, "San Diego, CA 54321",0
times 240 - ($-address3) db 0

age3: dd 36


filename: db "test2.data", 0

global _start

section .text
_start:
open_file:
mov rax, SYS_OPEN
mov rdi, filename
mov rsi, 0101o
mov rdx, 0666o
syscall

write_to_file:
write_record1:
mov rdi, rax
mov rsi, record1
call write_record

write_record2:
mov rsi, record2
call write_record

write_record3:
mov rsi, record3
call write_record

close_file:
; close the file descriptor 
mov rax, SYS_CLOSE
; rdi still holding the file descriptor
syscall

mov rdi, rax
mov rax, SYS_EXIT
syscall
