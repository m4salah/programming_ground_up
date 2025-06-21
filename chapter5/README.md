# Chapter 5 Review

## Know the Concepts

### Describe the lifecycle of a file descriptor

From my understanding  the lifecycle will be
open -> read/write -> close

### What are the standard file descriptors and what are they used for?

`stdin 0`: This is the standard input it's the standard way of input something to a program. it's streamed
`stdout 1`: The standard output the way of output something. it's streamed
`srderr 2`: When program error out, the stderr is not streamed

### What is a buffer?

It's a chuck of space that hold temporarily value to use then the buffer is cleared then reused.
Buffers exist to manage differences in speed between data producers and consumers

### What is the difference between the .data section and the .bss section?

`.data`: is the initialized variables in section which take from the binary space
`.bss`[block starting symbol](https://en.wikipedia.org/wiki/.bss):  in the uninitialized variables section in and doesn't take any space from the binary file.

### What are the system calls related to reading and writing files?

- open syscall: to bind the file to a file descriptor to interact with it.
- read syscall: read the until nth byte using the file descriptor.
- write syscall: write to a file some bytes using also the file descriptor.

## Use the Concepts

### Modify the `toupper` program so that it reads from `STDIN` and writes to `STDOUT` instead of using the files on the command-line

reference the [echo.s](/chapter5/echo.s)

### Change the size of the buffer

reference the [toupper_buf.s](/chapter5/toupper_buf.s)

### Rewrite the program so that it uses storage in the .bss section rather than the stack to store the file descriptors

reference the [toupper.bss.s](/chapter5/toupper.bss.s)

### Write a program that will create a file called heynow.txt and write the words "Hey diddle diddle!" into it

reference the [hello_writer.s](/chapter5/hello_writer.s)

## Going Further

### What difference does the size of the buffer make?

The smaller the buffer the memory will be reduced but the CPU will make more cycle to read more, and vice versa so bigger the buffer more speed our program but there is a spot between the speed and memory we should try different buffer size to see what is that spot.

### What error results can be returned by each of these system calls?

The best way to know is to read the man page for it

1. [open errors](https://www.man7.org/linux/man-pages/man2/open.2.html#ERRORS):  one of them related to access.
2. [read errors](https://www.man7.org/linux/man-pages/man2/read.2.html#ERRORS)
3. [write errors](https://www.man7.org/linux/man-pages/man2/write.2.html#ERRORS)

### Make the program able to either operate on command-line arguments or use STDIN or STDOUT based on the number of command-line arguments specified by ARGC

reference the [toupper_argc.s](/chapter5/toupper_argc.s)

### Modify the program so that it checks the results of each system call, and prints out an error message to STDOUT when it occurs

reference the [toupper_err.s](/chapter5/toupper_err.s)
