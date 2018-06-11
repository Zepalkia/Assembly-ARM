#include "../src/utils.s"
#include "../src/brainfxxx.s"

@This code interpret the following brainf*** programm which is the BF way of
@printing 'Hello World!'
@
@compilation: as -o main.o examples/BFInterpret.s src/*.s && gcc -o main main.o
@run: ./main

.data
prog: .asciz "++++++++++[>+>+++>+++++++>++++++++++<<<<-]>>>++.>+.+++++++..+++.<<++.>+++++++++++++++.>.+++.------.--------.<<+.<."

.text
.global main
main:
	push	{ip, lr}
	ldr	r0, =#0x100000
	bl	alloc			@allocate some space on the heap
	ldr	r10, =#0x22000		@start of the heap on raspbian (pi2)
	ldr	r0, =prog		@load the programm
	mov	r1, #114		@number of instructions
	mov	r2, #100		@number of cells
	bl	brainExec
	pop	{ip, pc}
