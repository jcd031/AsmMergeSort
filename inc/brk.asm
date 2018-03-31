section .data
      iBreak dq 0             ; initial break address
      cBreak dq 0             ; current break address

%macro brkInit 0              ; calls sys_brk with 0
      mov rax, 12             ; sys_brk
      xor rdi, rdi            ; 
      syscall                 ; The program break is returned to rax.

      cmp [cBreak], byte 0    ; Check if brkInit has already been called
      jne %%skip
      mov [iBreak], rax       ; The break is stored in iBreak to mark the beginning of usable memory.
      mov [cBreak], rax       ; If the break has not been altered yet, the current break is set to the initial break.
%%skip:
%endmacro

%macro brkAlloc 1             ; Moves the program break %1 bytes
      push r11
      push rcx
      push qword [cBreak]

      mov rdi, [cBreak]
      add rdi, %1 
      mov rax, 12             ; sys_brk
      syscall

      mov [cBreak], rax       ; cBreak is moved up to reflect the change
      pop rax                 ; Return beginning of new allocation
      pop rcx                 ; Preserve old rcx
      pop r11                 ; Preserve old r11
%endmacro

%macro brkClear 0
      mov rax, 12
      mov rdi, [iBreak]
      syscall

      mov [cBreak], rax
%endmacro

%macro getiBreak 0
      mov rax, [iBreak]       ; Move the address of the initial break into rax
%endmacro

%macro getcBreak 0
      mov rax, [cBreak]       ; Move the address of the initial break into rax
%endmacro

;-------------------------------------------------------------------------------
; Usage example
;-------------------------------------------------------------------------------
;     brkInit                 ; Find the current break
;     brk 6                   ; Allocate 6 bytes
;
;     iBreakRAX               ; Dereference the value of the beginning of the heap
;
;                             ; Put each byte into memory
;     mov [rax],     dword "h" 
;     mov [rax + 1], dword "e" 
;     mov [rax + 2], dword "l" 
;     mov [rax + 3], dword "l" 
;     mov [rax + 4], dword "o" 
;     mov [rax + 5], dword 10
;
;     mov rax, 1              ; Print to system output
;     mov rdi, 1
;     mov rsi, [iBreak]       ; Start of the heap
;     mov rdx, 6              ; Length = count
;     syscall
;-------------------------------------------------------------------------------
; Note:  The value of cBreak does not necessarily mark the end of the heap.
;        For example, in 64-bit Linux, shifting the break for even 1 byte will
;        actually allocate 4KB of writeable memory. However, the program break 
;        will still only reflect the 1 byte change.
;-------------------------------------------------------------------------------
