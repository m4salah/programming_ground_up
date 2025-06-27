# Chapter 6

## Know the Concepts

### What is a record?

The record is kind like structure data where it has fields and each fields contain the data represented.

### What is the advantage of fixed-length records over variable-length records?

The decoding and encoding of the record will be much easier with fixed length record because we know precisely each record where it begin and where it ends but the limitation here is the record can't be bigger for example if someone has a long name it will not fit all of it and also if most of the record is smaller than the allocated size for it, it will be a waste of space.
for variable length records we will have more complex logic to decode and encode the record but it will be memory friendly.

### How do you include constants in multiple assembly source files?

in `nasm` we use `%include "<file>"` for example `%include "linux.asm"`

### Why might you want to split up a project into multiple source files?

for maintainability and better read for the project because it will be very likely that there is separate teams for separate things in the project.
and also if there is something we can share between different module it will be  a separate files.

### What does the instruction `incl record_buffer + RECORD_AGE` do? What addressing mode is it using? How many operands does the `incl` instructions have in this case? Which parts are being handled by the assembler and which parts are being handled when the program is run?

It's indirect access memory it takes one operands access the location of that then increment it then write it back on it's original place in `nasm` it's like this `inc byte [record_buffer + RECORD_AGE]`.
The assembler access the `record_buffer` location then add to it `RECORD_AGE` (index) and when the program is run it access this location then increment it then write it back to the original place (in place).

## Use the Concepts

### Add another data member to the person structure defined in this chapter, and rewrite the reading and writing functions and programs to take them into account. Remember to reassemble and relink your files before running your programs

Reference those

- [read-records-2.asm](/chapter6/read-records-2.asm)
- [record-def-2.asm](/chapter6/record-def-2.asm)
- [record-handler-2.asm](/chapter6/record-handler-2.asm)
- [write-records-2.asm](/chapter6/write-records-2.asm)
- [read-records-job.asm](/chapter6/read-records-job.asm)

### Create a program that uses a loop to write 30 identical records to a file

Reference this  [write-records-3.asm](/chapter6/write-records-3.asm)

### Create a program to find the largest age in the file and return that age as the status code of the program

Reference this  [find-larges-age.asm](/chapter6/find-larges-age.asm)

### Create a program to find the smallest age in the file and return that age as the status code of the program

Reference this  [find-smallest-age.asm](/chapter6/find-smallest-age.asm)

## Going Further
