; PURPOSE: Count the characters until a null byte is reached.
;
; INPUT: The address of the character string
;
; OUTPUT: Returns the count in %eax
;
; PROCESS:
; Registers used:
; %rcx - character count
; %al - current character
; %rdx - current character address

global count_chars
count_chars:
push rbp
mov rbp, rsp

mov rbx, 0
count_loop_begin:
mov al, [rdi]
cmp al, 0
je count_loop_end
inc rbx
inc rdi
jmp count_loop_begin

count_loop_end:
mov rax, rbx
mov rsp, rbp
pop rbp
ret
