%include "inc/linux64.asm"
%include "inc/mergeSort.asm"

section .data
      text db "This is a test"
      newLine db 10, 0
      charList db "5", "2", "0", "9", "1", "2", "6", "8", "3"

section .bss
      name resb 5

section .text
      global _start

_start:
      print charList
      print newLine

      mov rbx, charList
      mov rdx, rbx
      add rdx, 8

      push rbx
      push rdx
      call mergeSort

      print charList
      print newLine
      exit

