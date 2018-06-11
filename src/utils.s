@-------------------------------------------------
@Initialize some Heap memory
@Args:
@	r0: Size to allocate
@Results:
@	Creation of a heap memory from 0x22000 to 0x22000+r0
@-------------------------------------------------
.extern sbrk
alloc:
	push	{ip, lr}
	push	{r0}
	mov	r0, #0
	bl	sbrk			@0x22000 on Raspbian (pi 2)
	pop	{r0}
	ldr	r7, =#0x2D		@Only for Unix x86 /!\
	swi	#0			@Call brk
	pop	{ip, pc}

@-------------------------------------------------
@Read chars from stdin until 'return' is pressed
@Args:
@	r0: the address of buffer
@	r1: size of the buffer (nBytes)
@Results:
@	r0: number of bytes read
@	The ascii values are stored from the original r0 until the end of the string
@-------------------------------------------------
input:
	push	{ip, lr}
	cmp	r1, #0
	movgt	r2, r1, lsl #2
	movle	r1, #255
	lslle	r1, #2
	mov	r1, r0
	mov	r0, #0			@0 = stdin
	mov	r7, #3			@see read(2)
	swi	#0
	pop	{ip, pc}

@-------------------------------------------------
@Write to console an array of ascii char
@Args:
@	r0: the address of start
@	r1: the number of char
@-------------------------------------------------
output:
	push	{ip, lr}
	mov	r2, r1, lsl #2		@size*sizeof
	mov	r1, r0
	mov	r0, #1			@1 = stdout
	mov	r7, #4			@see write(2)
	swi	#0
	pop	{ip, pc}

@-------------------------------------------------
@convert hex value to dec value (division by 4)
@Args:
@	r0: the hex value
@Results:
@	r0: the dec value
@-------------------------------------------------
hexToDec:
	push	{ip, lr}
	mov	r1, r0
	mov	r0, #0
	cmp	r1, #0
	pople	{ip, pc}
	sub	r1, #4
	add	r0, #1
	sub	pc, pc, #24
	
@-----------------------------------------------
@Generate a pseudo-random value
@Args:
@	r0: the seed
@Results:
@	r0: the random value
@-----------------------------------------------
xorshift32:
	push	{ip, lr}
	eor	r0, r0, r0, lsl #13	@r0 ^= (r0 << 13)
	eor	r0, r0, r0, lsr #17	@r0 ^= (r0 >> 17)
	eor	r0, r0, r0, lsl #5	@r0 ^= (r0 << 5)
	pop	{ip, pc}
