@------------------------------------------------
@Open a file using syscall (Unix)
@Args:
@	r0: pointer to the filename
@Results:
@	r0: pointer to the start of the file
@
@Warning:
@O_CREAT is supposed to be 0x0200 (POSIX)
@but for some reasons it's 0x0040 on Raspbian..
@so if you compile on another unix system, check
@fcntl.h for the right value
@
@If r0 is not an address, it contains the error
@code return, you can check it in details by
@running your app with 'strace'
@------------------------------------------------
fileOpen:
	push	{ip, lr}
	ldr	r2, =#0x0002		@O_RDWR
	ldr	r3, =#0x0040		@O_CREAT
	orr	r1, r2, r3		@See fcntl.h
	ldr	r2, =#0666		@permissions
	mov	r7, #5
	swi	#0
	pop	{ip, pc}

@------------------------------------------------
@Read a file char by char
@Args:
@	r0: pointer to the file
@	r1: pointer to the memory where to put data
@Results:
@	r3: nChar
@	[old r4]: contains all char from the file
@------------------------------------------------
fileRead:
	push	{ip, lr}
	mov	r2, #1			@r2 = size (char, 1 byte)
	mov	r3, #0			@r3 = nChar
	mov	r4, r1			@r4 = next free memory cell
	add	r4, r4, #4
	mov	r7, #3			@r7 = syscall no.
	push	{r0}
	swi	#0
	cmp	r0, #0
	popeq	{r0, ip, pc}		@exit if EOF
	add	r3, r3, #1
	add	r0, r0, #1
	ldrb	r5, [r1]
	strb	r5, [r4]
	add	r4, r4, #1
	pop	{r0}
	sub	pc, pc, #48


fileWrite:
	push	{ip, lr}
	pop	{ip, pc}
