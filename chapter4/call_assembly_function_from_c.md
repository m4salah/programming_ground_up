# How to call assembly function from c code

First we have obey the C calling convention
which is the first argument in `%rsi`, second in `%rdi`
So in `./power_func_c.s` we are making `power` function
compatible with The C calling convention, the return value stored in `%rax`

## How to run the code

```sh
gcc power.c power_func_c.s -o power && ./power
```

This will print whatever the base^power in the power.c
