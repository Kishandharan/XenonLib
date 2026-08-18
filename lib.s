.intel_syntax noprefix
.global cfmt 
.global exit 
.global strlen 
.global print 

.section .text

cfmt:
  cfmt_loop:
    mov al, [rsi]
    cmp al, '%'
    je cfmt_handle_percent

    cmp al, 0
    je cfmt_ret

    mov [rdi], al

    inc rsi 
    inc rdi 
    jmp cfmt_loop

  cfmt_handle_percent:
    mov [rdi], dl 
    inc rsi 
    inc rdi
    jmp cfmt_loop 

  cfmt_ret: 
    ret 

exit: 
  mov rax, 60
  xor rdi, rdi
  syscall
  ret

strlen:
  xor rax, rax

  strlen_loop:
    cmp byte ptr [rdi], 0
    je strlen_done 
    inc rax
    inc rdi
    jmp strlen_loop

  strlen_done: 
    ret

print: 
  push rdi 
  call strlen
  push rax 
  mov rax, 1 
  mov rdi, 1 
  pop rdx
  pop rsi 
  syscall
  ret
