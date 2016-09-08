section .data
global _start

_start:
  mov rax, 0
loop:
  add rax, 1
  cmp rax, 10
  jne loop

  mov rbx, rax
  mov rax, 2
  int 80h
