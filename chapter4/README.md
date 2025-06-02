This is the description of how the function is called with it's parameter like where to store the parameter and how to access them

## Stack

First we need to understand how the stack works, The stack is a chunk of memory that growth to the bottom <https://en.wikipedia.org/wiki/Stack-based_memory_allocation> ![Stack](ProgramCallStack2_en.svg.png)
As you can see the stack start for the top and grow downwards each function call creates a new stack frame to store it's parameters, and local variables, you can push to the stack with `pushl` that pushes wither register of memory value into the top of the stack but the "top" of the stack is actually the bottom of the stack’s memory.

There is register which know where is the "top" of the stack called `%esp` (stack pointer) always contains a pointer to the current top of the stack, every time we use `pushl` the register `%esp` get subtracted by 4 (word size) because each word is 4 byte.

If you want to remove something from the stack you has to use `popl` that add 4 to the register `%esp`, `popl` will puts the value on top of the stack to whatever register you want.

- If you want to access the value of the top of the stack use `movl (%esp), %eax`, this is indirect access because the `%esp` hold an address but we want the value so we use `(%esp)`

## C language calling convention

Which is the most popular one because it's used in all Unix OS, you can use whatever calling convention you want you can make your own calling convention but when you want to call a function from another language you have obey their calling convention.

Before calling a function we have to push all the parameter into the stack in reverse order like
`add(int a, int b)` -> `pushl b, pushl a`
The we use `call` instruction to call the function it does two things

1. it pushes the address of the next instruction, which is the return address, onto the stack
2. Then it modifies the instruction pointer `%eip` to point to the start of the function

The stack will look something like this

```sh
Parameter #N
...
Parameter 2
Parameter 1
Return Address <--- (%esp)
```

The function itself must do something before doing anything and it's called "prologue"

1. Save the current base pointer register `%ebp` by doing `pushl %ebp` The base pointer is a special register used for accessing function parameters and local variables.
2. Copies the stack pointer register into the base pointer register by doing `movl %esp, %ebp` This allows you to be able to access the function parameters as fixed indexes from the base pointer

`%ebp` Will always be pointing to the beginning of the function when it's called This allow us to know where is our parameters and the local variables even while you may be pushing things on and off the stack. `%ebp`  always be where the stack pointer was at the beginning of the function, so it is more or less a constant reference to the *stack frame* (the stack frame consists of all of the stack variables used within a function, including parameters, local variables, and the return address)

At this point, the stack looks like this

```sh
Parameter #N <--- N*4+4(%ebp)
...
Parameter 2 <--- 12(%ebp)
Parameter 1 <--- 8(%ebp)
Return Address <--- 4(%ebp)
Old %ebp <--- (%esp) and (%ebp)
```

3. The funciton reserve space for all the local variables that the function will use it suppose we need two local variables each is 4 bytes so we will `subl $8, %esp` subtract the 8 bytes from the `%esp`

The stack look like this now

```sh
Parameter #N <--- N*4+4(%ebp)
...
Parameter 2 <--- 12(%ebp)
Parameter 1 <--- 8(%ebp)
Return Address <--- 4(%ebp)
Old %ebp <--- (%ebp)
Local Variable 1 <--- -4(%ebp)
Local Variable 2 <--- -8(%ebp) and (%esp)
```

So we can now access all of the data we need for this function by using base pointer addressing using different offsets from `%ebp`.

When the function finishes and return it does three things.

1. It stores it’s return value in `%eax`.
2. It resets the stack to what it was when it was called (it gets rid of the current stack frame and puts the stack frame of the calling code back into effect).
3. It returns control back to wherever it was called from. This is done using the ret instruction, which pops whatever value is at the top of the stack, and sets the instruction pointer, `%eip`, to that value.

So, before a function returns control to the code that called it, it must restore the previous stack frame. Note also that without doing this, ret wouldn’t work, because in our current stack frame, the return address is not at the top of the stack. Therefore, before we return, we have to reset the stack pointer %esp and base pointer %ebp to what they were when the function began. Therefore to return from the function you have to do the following:

```asm
movl %ebp, %esp
popl %ebp
ret
```

## Reference

- <https://wiki.osdev.org/System_V_ABI>
- <https://wiki.osdev.org/Calling_Conventions>
- <https://uclibc.org/docs/psABI-i386.pdf>
- <https://www.sco.com/developers/devspecs/abi386-4.pdf>
- <https://www.youtube.com/watch?v=9lzW0I9_cpY>
- <https://refspecs.linuxfoundation.org/LSB_5.0.0/LSB-Core-IA64/LSB-Core-IA64/book1.html>

# Review

## Know the Concepts

### What are primitives?

The primitives is the the most basic things we can't go beyond that like the assembly instruction it the most primitives things we can't break the instruction into smaller one (maybe some instruction are), like also integer. primitives instructions are for example `mov`, `add`, ...etc.

### What are calling conventions?

It's a set of rules of how we pass the parameters to a function and where to expect the return value of it. how the value will be passed to the program, ...etc. we can make our own or we use some calling convention popular like the C calling convention, it may be vary from programming language to another one.

### What is the stack?

In memory the stack it's a chunk of memory that grow downwards the `%rsp` have the address of the top of the stack

### How do `pushl` and `popl` affect the stack? What special-purpose register do they affect?

`pushl` pushes a value from register to the top of the stack this affect the stack pointer`esp`  to make decrease by word size (4byte) and make the stack grow downwards
`popl` pop the value from the top of the stack to a register it increment the `esp` register

### What are local variables and what are they used for?

local variables is temporarily storage in the function that store something to it and restore it later, the life time of it is the lifetime of the function.
it's used for storing something temporarily inside the function,

### Why are local variables so necessary in recursive functions?

To store the value before pushing another call to the function, because each call to the function all the registers will be wiped.

### What are `%ebp` and `%esp` used for?

`esp` hold the current address of the top of the stack
`ebp` hold the address of the beginning of the stack frame it's used to access parameters, and local variables in the function

### What is a stack frame?
<https://stackoverflow.com/a/10057535>
It's a frame of data get pushed into the stack likely it will be the function call the stack frame begin when you push the return address then the `ebp` then the local variables needed inside the function before the return address there is the function parameters.

## Use the Concepts

### Write a function called square which receives one argument and returns the square of that argument

```asm
.section .data
.section .text
.global _start

_start:
push $5
call square
add $8, %rsp

mov %rax, %rdi
mov $60, %rax
syscall

square:
push %rbp
mov %rsp, %rbp
mov 16(%rbp), %rax
mul %rax

# end
mov %rsp, %rbp
pop %rbp
ret
```

### Write a program to test your square function

```c
// square.c
#include <assert.h>
#include <stdio.h>

int square(int);

int square_c(int a) { return a * a; }

int main() {

  for (int i = 0; i < 2000; i++) {
    assert(square(i) == square_c(i));
  }

  printf("Passed!\n");
}
```

```asm
# square_c.s

.global square

.type square, @function
square:
push %rbp
mov %rsp, %rbp
mov %rdi, %rax
mul %rax

# end
mov %rsp, %rbp
pop %rbp
ret
```

to run the tests

```sh
gcc square.c square_c.s -o square && ./square
```

If you see the output "Passed!" the test cased passed
this tests, tests the first billion integer only.
I write also rust code that call square assembly and test the first billion number

### Convert the maximum program given in the Section called Finding a Maximum Value in Chapter 3 so that it is a function which takes a pointer to several values and returns their maximum. Write a program that calls maximum with 3 different lists, and returns the result of the last one as the program’s exit status code

```asm
.section .data
data_items1: #These are the data items
.quad 3,67,34,222,45,75,54,34,44,33,22,11,66

data_items2: #These are the data items
.quad 3,67,34,45,75,54,34,44,33,22,11,66

data_items3: #These are the data items
.quad 3,67,34,45,54,34,44,33,22,11,66

.section .text

.global _start
.global maximum

_start:
push $13
push $data_items1
call maximum
add $16, %rsp

push $12
push $data_items2
call maximum
add $16, %rsp

push $11
push $data_items3
call maximum
add $16, %rsp

exit:
# exit syscall
# https://electronicsreference.com/assembly-language/linux_syscalls/exit/
mov %rax, %rdi
mov $60, %rax
syscall


.type maximum, @function
maximum:
push %rbp
mov %rsp, %rbp
mov 16(%rbp), %rbx # Pointer to the first element in the list
mov 24(%rbp), %rcx # The length of the list
mov $0, %rdi       # The index iterator
mov (%rbx, %rdi, 8), %rax

loop:
cmp %rdi, %rcx
je loop_end
inc %rdi
cmp %rax, (%rbx, %rdi, 8)
jle loop
mov (%rbx, %rdi, 8), %rax
jmp loop

loop_end:
mov %rbp, %rsp
pop %rbp
ret
```

### Explain the problems that would arise without a standard calling convention

Without standard calling convention everyone will do his own and this will separate the programming language from calling each other and benefit from each others in some areas. and calling function from another calling convention will be a mess the registers will be out of values and undefined behaviors will occur a lot.

## Going Further

### Do you think it’s better for a system to have a large set of primitives or a small one, assuming that the larger set can be written in terms of the smaller one?

The tradeoff here if you want higher abstraction or lower abstraction if we want higher abstraction is that will affect the complexity of designing the CPU. We need to have the right balance between the two

### The factorial function can be written non-recursively. Do so

```asm
.section .data
.section .text

.global _start

_start:
mov $5, %rcx
mov $1, %rax

factorial_loop:
cmp $1, %rcx
je end_loop
mul %rcx
dec %rcx
jmp factorial_loop

end_loop:
mov %rax, %rdi
mov $60, %rax
syscall
```

### Find an application on the computer you use regularly. Try to locate a specific feature, and practice breaking that feature out into functions. Define the function interfaces between that feature and the rest of the program

I use Obsidian So I will choose the render line which take a line and render it in markdown syntax, so i think the function will be `render` which take a buffer (line) and the output will be appropriate rendered like `render(char *buffer, size_t length)`

### Come up with your own calling convention. Rewrite the programs in this chapter using it. An example of a different calling convention would be to pass parameters in registers rather than the stack, to pass them in a different order, to return values in other registers or memory locations. Whatever you pick, be consistent and apply it throughout the whole program

in x86_64 calling convention the first 9 parameters passed in registers like `rdi`, `rsi` and so on more than that it will be pushed to the stack I have written multiple ones using this calling convention to call this function from C like `factorial_rec_c.s` this is using x86_64 calling convention, `factorial.c` this used to call `factrorial` function from `factorial_rec_c.s`.

### Can you build a calling convention without using the stack? What limitations might it have?

Yes you can but the limitation here is the number of parameters will be passed it will be limited across all the programming language.

### What test cases should we use in our example program to check to see if it is working properly?

1. Test the simplest case
2. Test the edge cases
3. Invalid input cases
