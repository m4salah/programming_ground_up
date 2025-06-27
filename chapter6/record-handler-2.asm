%include "linux.asm"
%include "record-def-2.asm"

; PURPOSE: This function reads a record from the file descriptor
; INPUT: The file descriptor and a buffer
;
; OUTPUT: This function writes the data to the buffer
; and returns a status code.
global read_record
read_record:
	push rbp
	mov  rbp, rsp

	; rdi already holding the file descriptor 
	; rsi already holding the buffer address
	mov rax, SYS_READ
	mov rdx, RECORD_SIZE
	syscall

	mov rsp, rbp
	pop rbp
	ret


; PURPOSE: This function write a record to a file descriptor
; INPUT: The file descriptor and a buffer
;
; OUTPUT: This function writes a record to a file descriptor from a buffer
; and returns a status code.
global write_record
write_record:
	push rbp
	mov  rbp, rsp

	; rdi already holding the file descriptor 
	; rsi already holding the buffer address
	mov rax, SYS_WRITE
	mov rdx, RECORD_SIZE
	syscall

	mov rsp, rbp
	pop rbp
	ret
