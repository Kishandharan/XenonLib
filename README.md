# XenonLib
Libc-Independent, minimal Assembly Library with a lot of helper functions. Uses x86_64 ASM in Linux, assembled with GAS using Intel-Syntax.

## Functions

### strlen
Calculates the length of a null-terminated string. Takes the starting address of the string in memory in the `RDI` register, and returns the length of the string in the `RAX` register. **To calculate the length of the string, this function overwrites the `RDI` register. So if you want the value of the `RDI` register to be preserved, you must save it yourselves before calling `strlen`**. Example code using `strlen`:

    .intel_syntax noprefix
    .global _start
    
    .section .text
      _start:
        lea rdi, [str1] # Address of string passed here
        call strlen
        
        mov rdx, rax
        mov rax, 1
        mov rdi, 1
        lea rsi, [str1]
        syscall
        
        mov rax, 60
        mov rdi, 0
        syscall
        
    .section .data
      str1: .asciz "Testing"
   
**Note: The string must be null-terminated for `strlen` to work.**

### tstrlen 
This function counts how many characters are there in a string until the first occurrence of a specific character is encountered. It takes the starting address of the string in `RDI` register and takes the character to count until in the `SIL` register, and returns the result in the `RAX` register. If the specified character does not exist in the string, it will simply return the length of the entire string. **This function overwrites the `RDI` register for calculations. So if you want its value preserved even after calling the function, you must save it yourselves before calling the function.** Example using `tstrlen`:

``` 
.intel_syntax noprefix 
.global _start 

.section .text 
  _start: 
    lea rdi, [str1]
    mov sil, 'o'
    call tstrlen
    
    push rax
    mov rax, 1 
    mov rdi, 1 
    lea rsi, [str1]
    pop rdx
    syscall 
    
    mov rax, 60 
    mov rdi, 0 
    syscall 

.section .data 
  str1: .ascii "Hello World"
``` 

**Note: You must pass in a null-terminated string to this function if you are not sure whether the character you have passed in as an argument is actually present in the string. You may use a string with no null-termination if you are absolutely sure that character is present somewhere in the string.**

### print

Prints a null-terminated string to `stdout`. This function takes the starting address of the string in memory in the `RDI` register and prints the string. **This function internally calls the `strlen` function to calculate the length of the null-terminated string to pass into the system call. Because of this, the string must be null-terminated here too. If you want the value of `RDI` preserved after calling this function, you must preserve it before calling this function due to the same reason.** Example using `print`:

    .intel_syntax noprefix
    .global _start
    
    .section .text
      _start:
        lea rdi, [str1]
        call print
        
        mov rax, 60
        mov rdi, 0
        syscall
        
    .section .data
      str1: .asciz "Testing"
This function also returns the length of the string in `RAX` due to the system call.

### exit
This exits the program. It takes the exit status in `RDI`. Example using `exit`:

    .intel_syntax noprefix
    .global _start
    
    .section .text
      _start:
        lea rdi, [str1]
        call print
        
        mov rdi, 0
        call exit
        
    .section .data
      str1: .asciz "Testing"
###  cfmt
This function replaces all the `%` symbols in a string with a character and writes the new string to another address, and returns without doing anything if the size is it allowed to use is less than the size required to write the newly formatted string. It takes the starting address of the buffer to write the new formatted string to in the `RDI` register, the starting address of the input string in the `RSI` register, the character to replace the `%` symbols with in the `DL` register, and the max amount of memory it can use in bytes in the `RCX` register. It returns whether the max size was enough or not in the `RAX` register. If it returns 1, it means the max limit isn't enough and it didn't do any formatting. If it returns 0, it means the size was enough and it successfully formatted the text.**This function overwrites the `RDI` register, the `RSI` register and the `RAX` register (for the return value). So if you want the value of these registers to be preserved even after the execution of this function, you must save them yourselves before you call this function.** Example using `cfmt`:

    .intel_syntax noprefix
    .global _start
    
    .section .text
      _start:
        lea rdi, [buf]
        lea rsi, [inp]
        mov dl, 'A'
        mov rcx, 1000
        call cfmt
        
        lea rdi, [buf]
        call print
        call exit
        
    .section .data
      buf: .skip 1000
      inp: .asciz "Testing%%%"
This function also adds a null-terminator at the end of the output string so that it can be easily passed into the other functions without any problems.
