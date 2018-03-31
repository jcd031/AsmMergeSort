section .bss

%macro mmap 1
      mov ax, 9               ; sys_mmap      
      xor rdi, rdi            ; addr = NULL, mmap chooses address
      mov rsi, %1             ; length = %1
      mov rdx, $7             ; prot = PROT_READ|PROT_WRITE|PROT_EXEC
      mov r10, $22            ; flags = MAP_PRIVATE|MAP_ANONYMOUS
      mov r8, -1              ; fd = -1
      xor r9, r9              ; offset = 0
      syscall
%endmacro

%macro mmap 2
      mov ax, 9               ; sys_mmap      
      mov rdi, %1             ; addr = %1
      mov rsi, %2             ; length = %2
      mov rdx, $7             ; prot = PROT_READ|PROT_WRITE|PROT_EXEC
      mov r10, $22            ; flags = MAP_PRIVATE|MAP_ANONYMOUS
      mov r8, -1              ; fd = -1
      xor r9, r9              ; offset = 0
      syscall
%endmacro

%macro munmap 2
      mov rdi, %1             ; addr = %1
      mov rax, 11             ; sys_munmap
      mov rsi, %2             ; length = %2
      syscall
%endmacro
