#include "../src/utils.s"
#include "../src/file.s"

@This code reads a file and output it to stdout using syscalls.
@He was tested on a raspberry pi 2 (Raspbian) but you can easily port the code on 
@another ARM system by changing some addresses and/or syscall references as long as
@you run an Unix-OS.
@
@compilation: as -o main.o examples/openFile.s src/*.s && gcc -o main main.o
@run: ./main

.data
file: .asciz "test.txt"

.text
.global main
main:
	push	{ip, lr}
	ldr	r0, =#0x100000
	bl	alloc			@allocate some space on the heap
	ldr	r0, =file
	bl	fileOpen		@open the file 'test.txt' (needs to be on the same folder)
	ldr	r1, =#0x22000		@start of the heap on raspbian (pi2)
	bl	fileRead
	ldr	r0, =#0x22004
	mov	r2, r3
	bl	output
	pop	{ip, pc}	
