; Common Linux Definitions

;; System Call Numbers
SYS_EXIT equ 60
SYS_READ equ 0
SYS_WRITE equ 1
SYS_OPEN equ 2
SYS_CLOSE equ 3
SYS_BRK equ 12

;; Standard File Descriptors
STDIN  equ 0
STDOUT equ 1
STDERR equ 2

;; Common Status Codes
END_OF_FILE equ 0

;; File Open Modes
O_RDONLY equ 0
O_WRONLY equ 1
O_RDWR   equ 2
O_CREAT  equ 64
O_TRUNC equ 512
O_APPEND equ 1024

