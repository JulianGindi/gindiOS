global start

section .bss

align 4096

p4_table:
  resb 4096
p3_table:
  resb 4096
p2_table:
  resb 4096

section .text
bits 32
start:
  ; Point the first entry of the level 4 page table to the first entry in the
  ; p3 table
  mov eax, p3_table
  or eax, 0b11
  mov dword [p4_table + 0], eax

  ; Point the first entry of the level 3 page table to the first entry in the
  ; p2 table
  mov eax, p2_table
  or eax, 0b11
  mov dword [p3_table + 0], eax

  ; Point each page table level 2 entry to a page
  mov ecx, 0    ; counter variable

  .map_p2_table:
  mov eax, 0x200000  ; 2MiB
  mul ecx
  or eax, 0b10000011
  mov [p2_table + ecx * 8], eax
  inc ecx
  cmp ecx, 512
  jne .map_p2_table

  ; move page table address to cr3
  mov eax, p4_table
  mov cr3, eax

  ; enable 'physical address extension'
  mov eax, cr4
  or eax, 1 << 5
  mov cr4, eax

  ; set the long mode bit
  mov ecx, 0xC0000080
  rdmsr
  or eax, 1 << 8
  wrmsr

  ; enable paging
  mov eax, cr0
  or eax, 1 << 31
  or eax, 1 << 16
  mov cr0, eax

  mov word [0xb8000], 0x0D4b ; K
  mov word [0xb8002], 0x0D6f ; o
  mov word [0xb8004], 0x0D6e ; n
  mov word [0xb8006], 0x0D69 ; i
  mov word [0xb8008], 0x0D63 ; c
  mov word [0xb800a], 0x0D68 ; h
  mov word [0xb800c], 0x0D69 ; i
  mov word [0xb800e], 0x0D77 ; w
  mov word [0xb8010], 0x0D61 ; a
  mov word [0xb8012], 0x0D21 ; !
  hlt
