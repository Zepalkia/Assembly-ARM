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
