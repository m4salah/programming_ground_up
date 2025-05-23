# Chapter 2 Review

## Know the Concepts

### What does if mean if a line in the program starts with the ’#’ character?

This mean this line will not be interpreted by the assembler and it's intend to be for the other programmer editing/reading the code explaining what's happening.

### What is the difference between an assembly language file and an object code file?

The assembly language file is the arguably the human readable form of the object file where the content is a set of instructions for the assembly language,
The object code file is the binary form of the assembly file it's like map 1 to 1 each instruction to it's binary form because the CPU understand binary not assembly instructions in ascii form

### What does the linker do?

convert the object file into executable files by the OS linking all the necessary lib or files needed into one executable file

### How do you check the result status code of the last program you ran?

```sh
echo $?
```

```fish
echo $status
```

### What is the difference between movl $1, %eax and movl 1, %eax?

`movl $1, %eax` will move the immediate value (1) into register `%eax`
`movl 1, %eax` will move the value inside memory address (1) into register %eax

### Which register holds the system call number?

mostly register `%eax`

### What are indexes used for?

The index used to determined a location for an element in the with knowing how much element take in the space and the the first element address.

### Why do indexes usually start at 0?

because we usually know the first element address so this is the 0 index we don't have to do anything else.
When you have an array in memory, the computer stores it as a contiguous block. If your array starts at memory address 1000, then:

- Element 0 is at address: 1000 + (0 × element_size) = 1000
- Element 1 is at address: 1000 + (1 × element_size) = 1004 (if each element is 4 bytes)
- Element 2 is at address: 1000 + (2 × element_size) = 1008
- ...etc
`base_address + (index × element_size)`

### If I issued the command `movl data_items(,%edi,4)`, `%eax` and `data_items` was address `3634` and `%edi` held the value `13`, what address would you be using to move into `%eax`?

The address will be = 3634 + (4 * 13) = 3686

### List the general-purpose registers

- %eax, %ebx, %ecx, %edx
- %esi, %edi
- %esp, %ebp
- %r8d, %r9d, %r10d, %r11d, %r12d, %r13d, %r14d, %r15d

### What is the difference between movl and movb?

- `movl`: move long it moves a 4 byte
- `movb`: move byte it moves 1 byte only

### What is flow control?

The path of the execution of the instruction, Without flow control, programs would only execute sequentially from top to bottom, which would make them very limited. Flow control allows programs to make decisions, repeat actions, and jump to different parts of code based on conditions.

### What does a conditional jump do?

It make the execution jump to a particular address with some condition in it like `jge`

### What things do you have to plan for when writing a program?

is specifying every step in details and what i will do in each step

### Go through every instruction and list what addressing mode is being used for each operand

```assembly
movl $5, %eax
movl (%ebx), %ecx
addl data_items(,%edi,4), %eax
```

1. immediate addressing mode
2. indirect addressing mode: `ebx` hold an address go grab the content in that address and put it in `ecx`
3. Indexed addressing mode

## Use the Concepts

### Modify the first program to return the value 3

```assembly
.section .data

# Here we have all the code that will be executed when the program is run
.section .text

# This mark the start symbol of the program to not remove it
# because assembler will use it to know where to start
.globl _start

_start:
 movl $1, %eax
 movl $3, %ebx
 int $0x80

```

### Modify the maximum program to find the minimum instead

The main difference here is changing the `jle` to `jge` and change the order of the end list logic to increment the `edi` first then access the element then do the end list comparison logic.

```assembly
# PURPOSE: This program finds the minimum number of a
# set of data items.
#
# VARIABLES: The registers have the following uses:
#
# %edi - Holds the index of the data item being examined
# %ebx - Largest data item found
# %eax - Current data item
#
# The following memory locations are used:
#
# data_items - contains the item data. A 0 is used
# to terminate the data
#

.section .data
data_items: #These are the data items
.long 3,67,34,222,45,75,54,34,44,33,22,11,66,0

.section .text

.globl _start

_start:
movl $0, %edi
movl data_items(,%edi, 4), %eax
movl %eax, %ebx

start_loop:
incl %edi
movl data_items(,%edi, 4), %eax
cmpl $0, %eax
je loop_exit
cmpl %ebx, %eax
jge start_loop
movl %eax, %ebx
jmp start_loop


loop_exit:
# %ebx is the status code for the exit system call
# and it already has the maximum number
movl $1, %eax #1 is the exit() syscall
int $0x80

```

### Modify the maximum program to use the number 255 to end the list rather than the number 0

The main difference here is changing the order of the end list logic to increment the `edi` first then access the element then do the end list comparison logic.

```assembly
# PURPOSE: This program finds the maximum number of a
# set of data items.
#
# VARIABLES: The registers have the following uses:
#
# %edi - Holds the index of the data item being examined
# %ebx - Largest data item found
# %eax - Current data item
#
# The following memory locations are used:
#
# data_items - contains the item data. A 0 is used
# to terminate the data
#

.section .data
data_items: #These are the data items
.long 3,67,34,222,45,75,54,34,44,33,22,11,66,255

.section .text

.globl _start

_start:
movl $0, %edi
movl data_items(,%edi, 4), %eax
movl %eax, %ebx

start_loop:
incl %edi
movl data_items(,%edi, 4), %eax
cmpl $255, %eax
je loop_exit
cmpl %ebx, %eax
jle start_loop
movl %eax, %ebx
jmp start_loop


loop_exit:
# %ebx is the status code for the exit system call
# and it already has the maximum number
movl $1, %eax #1 is the exit() syscall
int $0x80
```

### Modify the maximum program to use an ending address rather than the number 0 to know when to stop

The main takeaway from here is using `%ecx` to hold the ending address of the list by getting the first element address then add to it the length of the list which is (4 * 14),
using  [leal](https://stackoverflow.com/a/11212925)  to get the address of the current element and store it in `edx`, `leal` NOT **dereference** the address here it's just compute the address

```assembly
# PURPOSE: This program finds the maximum number of a
# set of data items.
#
# VARIABLES: The registers have the following uses:
#
# %edi - Holds the index of the data item being examined
# %ebx - Largest data item found
# %eax - Current data item
# %ecx - the ending address of the data items
# %edx - Address of the current element being processed
#
# The following memory locations are used:
#
# data_items - contains the item data. A 0 is used
# to terminate the data
#

.section .data
data_items: #These are the data items
.long 3,67,34,222,45,75,54,34,44,33,22,11,66,0

.section .text

.globl _start

_start:
movl $0, %edi
movl data_items(,%edi, 4), %eax
movl %eax, %ebx
movl $data_items, %ecx # get the address of the first item
add $56, %ecx          # add 56 to get the end address

start_loop:
leal data_items(,%edi,4), %edx # get the address of the current item
cmpl %ecx, %edx                # compare with the end address
je loop_exit
incl %edi
movl data_items(,%edi, 4), %eax
cmpl %ebx, %eax
jle start_loop
movl %eax, %ebx
jmp start_loop


loop_exit:
# %ebx is the status code for the exit system call
# and it already has the maximum number
movl $1, %eax #1 is the exit() syscall
int $0x80
```

### Modify the maximum program to use a length count rather than the number 0 to know when to stop

store the length of the list into register `ecx` and compare the `edi` to it each time.

```assembly
# PURPOSE: This program finds the maximum number of a
# set of data items.
#
# VARIABLES: The registers have the following uses:
#
# %edi - Holds the index of the data item being examined
# %ebx - Largest data item found
# %eax - Current data item
#
# The following memory locations are used:
#
# data_items - contains the item data. A 0 is used
# to terminate the data
#

.section .data
data_items: #These are the data items
.long 3,67,34,222,45,75,54,34,44,33,22,11,66

.section .text

.globl _start

_start:
movl $12, %ecx                # set the length of the data items
movl $0, %edi
movl data_items(,%edi, 4), %eax
movl %eax, %ebx

start_loop:
cmpl %ecx, %edi
je loop_exit
incl %edi
movl data_items(,%edi, 4), %eax
cmpl %ebx, %eax
jle start_loop
movl %eax, %ebx
jmp start_loop


loop_exit:
# %ebx is the status code for the exit system call
# and it already has the maximum number
movl $1, %eax #1 is the exit() syscall
int $0x80

```

### What would the instruction `movl _start, %eax` do? Be specific, based on your knowledge of both addressing modes and the meaning of `_start`. How would this differ from the instruction `movl $_start, %eax`?

in the beginning the `_start` is just an address of the beginning of the program so in those cases

- `movl _start, %eax`: this instruction will mov whatever the value in the address `_start` into `%eax` so in this simple program, this instruction is essentially reading the first 4 bytes of machine code at that location and treating them as data. You'd end up with the actual machine code bytes (the opcode of the first instruction at start) in %eax as a 32-bit integer value.

```assembly
.section .data

.section .text

.globl _start

_start:
movl _start, %ebx
movl $1, %eax #1 is the exit() syscall
int $0x80
```

The value of `%ebx` will be 139 (0x8b) on my machine which is the opcode for [move]
(<https://www.cs.uaf.edu/2016/fall/cs301/lecture/09_28_machinecode.html>) which make sense because `_start` is the address of starting instruction `movl`

- `movl $_start, %eax`: immediate addressing will move the address of `_start` into `%eax` register, want the address value itself, not what's stored at that address.

## Going Further

### Modify the first program to leave off the int instruction line. Assemble, link, and execute the new program. What error message do you get. Why do you think this might be?

```assembly
# data section which has all the data needed for the program 
# we don't have any for the moment but we will need it later
.section .data

# Here we have all the code that will be executed when the program is run
.section .text

# This mark the start symbol of the program to not remove it
# because assembler will use it to know where to start
.globl _start

_start:
 movl $1, %eax
 movl $74, %ebx
```

The error message: `Job 1, './exite.1' terminated by signal SIGSEGV (Address boundary error)`
I think this the program never actually terminates properly.
When you remove int $0x80, the CPU doesn't know the program is supposed to end. It keeps executing whatever instructions happen to be in memory after your code. This could be:

- Uninitialized memory (garbage data interpreted as instructions)
- Other code from the operating system or loader
- Random data that gets interpreted as machine code

This typically results in:

- Segmentation fault - when the CPU tries to execute invalid instructions or access forbidden memory
- Illegal instruction error - when random data doesn't correspond to valid opcodes
- Unpredictable behavior - the program might appear to "work" but is actually running wild

### So far, we have discussed three approaches to finding the end of the list - using a special number, using the ending address, and using the length count. Which approach do you think is best? Why? Which approach would you use if you knew that the list was sorted? Why?

I think the length approach is the best one because we save the actual list from containing any magical number, and i can change the window size of my program on the list with any size.
if the list is sorted again i will use the length approach because i can lookup to maximum or minimum in constant time using the length.
