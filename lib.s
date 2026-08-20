.intel_syntax noprefix
.global cfmt 
.global exit 
.global strlen 
.global print 

.section .text

cfmt:
  push rdi
  mov rdi, rsi
  call strlen
  pop rdi
  
  add rax, 1 
  cmp rcx, rax
  jl cfmt_failure

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
    mov [rdi], al
    mov rax, 0
    ret 

  cfmt_failure:
    mov rax, 1
    ret 

exit: 
  # Argument passes through to the syscall
  mov rax, 60
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
