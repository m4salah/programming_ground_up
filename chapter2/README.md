# Chapter 2 Review

## Know the Concepts

### Descript fetch-execute cycle

All the data live in the memory and this cycle begin by fetching the appropriate data to begin process on, and the data travel in #data_bus then the CPU use something called instruction decoder to know what operation the CPU will do then the CPU execute this instruction in whatever matter.

### What is a register? How would computation be more difficult without registers?

The registers is general purpose bucket for anything the size of the bucket depending on the architecture if it's 32bit so the size of each bucket is 4 byte.
if there is no register the CPU will constantly access the memory for each cycle to retrieve or write the data and this will be more inefficient.

### How do you represent numbers larger than 255?How big are the registers on the machines we will be using?

easy use more bytes in 32bit machine it will use 4 byte by default

### How does a computer know how to interpret a given byte or set of bytes of memory?

It all depends on what we tell the computer to do with it, it all just a numbers in the end if we tell the CPU this number is an address it will treat it as address and will try to lookup the data there, if we tell it it's a literal value and this the data i need it will treat it so.

### What are the addressing modes and what are they used for?

1. **Immediate mode:** it's literally take the value as it's like put value 0 to register eax
2. **Direct Addressing mode**: access the data given that address like put the data found in address 2004 in register eax.
3. **Indexed addressing mode:** It's like the previous but we specify the index register and we can also specify the multiplier so if we have address 2002 and the index is 4 so we will access the byte in address 2006 this allow us to access byte by byte but if we want to access the word by word we will specify the word size in the multiplier which is 4 in 32bit machine
4. **Indirect accessing mode:** Where the instruction contain a register say eax and in the register there is a value say 4 so we will use this value (4) as address to get whatever data in address 4, in direct access mode we will just the value 4 but in indirect access mode we will use it as address to lookup the value.
5. **Base pointer addressing mode:** This is similar to the the indirect accessing mode but we will specify the offset to add to the register before using it as lookup address.

### What does the instruction pointer do?

The instruction pointer or the program counter is special purpose register holds the memory address of the next instruction would be executed <https://en.wikipedia.org/wiki/Program_counter>

## Use the Concepts

### What data would you use in an employee record? How would you lay it out in memory?

I will store name, age, salary, department, and address.

1. **ID**: one word (4 byte)
2. **Name:** i will store a pointer to his name in the memory. (4 byte)
3. **Age:** one word to store it (4 byte)
4. **Salary:** one word also (4 byte)
5. **Address**: pointer to the actual address to the memory. (4 byte)

### If I had the pointer the the beginning of the employee record above, and wanted to access a particular piece of data inside of it, what addressing mode would I use?

Probably it will be the **indexed addressing mode** if the info is already in record like the (ID, Age, and Salary) but for the **name** and **address** it will be **Indirect accessing mode** because it hold another address containing the actual data.

### In base pointer addressing mode, if you have a register holding the value 3122, and an offset of 20, what address would you be trying to access?

i till be 3122 + 20 = 3142

### In indexed addressing mode, if the base address is 6512, the index register has a 5, and the multiplier is 4, what address would you be trying to access?

6512 + ( 4 * 5) = 6532

### In indexed addressing mode, if the base address is 123472, the index register has a 0, and the multiplier is 4, what address would you be trying to access?

the same address 123472

### In indexed addressing mode, if the base address is 9123478, the index register has a 20, and the multiplier is 1, what address would you be trying to access?

it will be 9123478 + (20 * 1) = 9123498

## Going Further

### What are the minimum number of addressing modes needed for computation?

I think 1 will be enough <https://stackoverflow.com/a/35223096>

### Why include addressing modes that aren’t strictly needed?

I think for convenient and simplicity, and in my head it will be easier for the CPU to separate it to handle each in a special/performant way.

### Research and then describe how pipelining (or one of the other complicating factors) affects the fetch-execute cycle

The pipelining is the process which use different hardware element/component to make the fetch-decode-execute cycle, it's like converting the the cycle into production line and there is different hardware element sitting on this production line one doing fetch, one doing decode, and one doing execute this opens the door for a lot optimization like make two hardware making the execute to make it faster but in the other hand i need to fill this production line with a lot of useful things to fill it
<https://en.wikipedia.org/wiki/Instruction_pipelining>
<https://www.youtube.com/watch?v=BVNx3wtJ9vs>
<https://www.youtube.com/watch?v=eVRdfl4zxfI>

### Research and then describe the tradeoffs between fixed-length instructions and variable-length instructions

For fixed length instruction have a lot of performance advantages like the fetch-decode-execute cycle will be simpler because the CPU know exactly where is the next instruction, and also the Pipeline will be more efficient because the CPU exactly the length of each instruction but the disadvantages here is maybe waste of space if the instruction hold less than the fixed length.
For variable length instruction it's obviously more flexible in the space but it will make the fetch-decode-execute cycle more complex and also the pipelining will be more complicated to handle it
<https://csbranch.com/index.php/2024/09/06/fixed-length-vs-variable-length-instructions/>

## Resources

- <https://lists.gnu.org/archive/html/pgubook-readers/2004-12/msg00006.html>
- <https://www.youtube.com/watch?v=-HNpim5x-IE&t=114s>
- <https://download-mirror.savannah.gnu.org/releases/pgubook/ProgrammingGroundUp-1-0-booksize.pdf>
