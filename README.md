# AsmMergeSort

The driver program **driver.asm** simply initializes a char array and calls the library functions I wrote. It will only work on 64-bit Linux, since the system interrupts are different for each OS.

The actual merge sort is implemented in **inc/mergeSort.asm** using dynamic memory allocation with **brk.asm** and **mmap.asm**.

**linux64.asm** just contains everything specific to 64-bit Linux. This could be switched out with another operating system's calls.
