%include "inc/brk.asm"
; mergeSort(byte ptr left = rbx, byte ptr right = rdx)
mergeSort:
      brkInit
_mergeSortRec:
      cmp rbx, rdx
      jge _mergeSortEnd       ; if l < r

; Calculate m while avoiding overflow
      mov rcx, rdx            ; m = r
      sub rcx, rbx            ; m = r - l
      shr rcx, 2              ; m = (r-l)/2
      add rcx, rbx            ; m = l + (r-l)/2

      push rbx
      push rcx
      push rdx
      mov rdx, rcx
      call _mergeSortRec
      pop rdx
      pop rcx
      pop rbx

      push rbx
      push rcx
      push rdx
      mov rbx, rcx
      inc rbx
      call _mergeSortRec
      pop rdx
      pop rcx
      pop rbx

      call _merge
_mergeSortEnd:
      ret

; merge(byte ptr left = rbx, byte ptr mid = rcx, byte ptr right = rdx)
_merge:
; int i, j, k
      xor r15, r15            ; i = 0
      mov r13, rbx

; n1 = m - l + 1
      mov r12, rcx
      sub r12, r13            ; n1 = m - l
      add r12, 1              ; n1 = m - l + 1

; n2 = r - m
      mov r11, rdx
      sub r11, rcx

; Create temp array
      mov r10, r11            ; size = n1 + n2
      add r10, r12

      brkAlloc r10

; Copy data into temp array
_copyLoop:
      ;mov r9, [%3 - r10]
      mov r9, [r13 + r15]
      mov [rax + r15], r9
      inc r15
      cmp r15, r10
      jle _copyLoop
      
; merge the two arrays back into the original array
; i = r15, j = r14, k = r13
; n1 = r12, n2 = r11
      mov r15, rax            ; i = 0 + offset
      mov r14, rax            ; j = offset
      add r14, r12            ; j = m + offset
      add r12, rax
      add r10, rax
_mergeLoop:
      cmp r15, r12            ;_ 
      jge _mergeLoopEnd       ; |
      cmp r14, r10            ; |
      jge _mergeLoopEnd       ; | while(i < n1 && j < n2)

      mov r8b, byte [r14]     ;_
      mov r9b, byte [r15]     ; |
      cmp r9b, r8b            ; |
      jg _mergeLoopElse       ; | if (L[i] <= R[j])
      
      mov byte [r13], r9b     ; arr[k] = L[i]
      inc r15                 ; i++
      jmp _mergeEndif

_mergeLoopElse:               ; else
      mov byte [r13], r8b     ; arr[k] = R[j]
      inc r14                 ; j++
_mergeEndif:

      inc r13                 ; k++
      jmp _mergeLoop          ; loop
_mergeLoopEnd:

; Copy any remaining elements into the array
_remainingL:
      cmp r15, r12
      jge _remainingR

      mov r9b, byte [r15]
      mov byte [r13], r9b     ; arr[k] = L[i]
      inc r15                 ; i++
      inc r13                 ; k++
      jmp _remainingL
_remainingR:
      cmp r14, r10
      jge _endMerge

      mov r8b, byte [r14]     
      mov byte [r13], r8b     ; arr[k] = R[j]
      inc r14                 ; j++
      inc r13                 ; k++
      jmp _remainingR
_endMerge:
      ret
