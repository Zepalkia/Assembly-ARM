#include "utils.s"
@-------------------------------------------------
@Init a random array in memory
@Args:
@	r0: length of array (in decimal)
@	r10: address of next free memory block
@Results:
@	r10: now point to the next free memory block
@	old r10: contains the address of the size-value
@	old r10+4 to r10-4: contains random 32bits values
@-------------------------------------------------
initArr:
	push	{r9, ip, lr}
	add	r9, r10, r0, lsl #2	@compute the end addr, size * sizeof(int)
	add	r9, r9, #4		@padding
	str	r9, [r10]		@store the end addr
	cmp	r9, r10			@if we're at the end...   <
	popeq	{r9, ip, pc}		@exit			  |
	add	r10, r10, #4		@			  |
	bl 	xorshift32		@needs utils.s		  |
	str	r0, [r10]		@append random value	  |
	sub	pc, pc, #28		@go back to start of loop ^
	pop	{r9, ip, pc}
	
@-------------------------------------------------
@Copy an array from idx0+1 to idx1
@Args:
@	r0: idx0 (pointer to start, the size-value)
@	r1: idx1 (decimal, not an adress)
@	r10: address of next free memory block
@Results:
@	r10: now point to the next free memory block
@	old r10: contains the address of the size-value
@	old r10+4 to r10-4: contains the r1 first values of the arr pointed by r0
@-------------------------------------------------
copyArr:
	push	{r2, r3, ip, lr}
	add	r0, r0, #4		@skip the size-value
	add	r2, r10, r1, lsl #2
	add	r2, r2, #4
	str	r2, [r10]		@size of new arr in r10
	add	r10, r10, #4		@
	add	r1, r0, r1, lsl #2	@r1 = adress of end
	cmp	r0, r1			@			<
	popge	{r2, r3, ip, pc}	@			|
	ldr	r2, [r0]		@			|
	str	r2, [r10]		@arr[i] => new[i]	|
	add	r0, #4			@			|
	add	r10, r10, #4		@			|
	sub	pc, pc, #32		@			^

@-------------------------------------------------
@Get the pointer to the r0-th array
@Args:
@	r0: id (decimal) of the array
@Results:
@	r0: contains the address to the size-value of the r0-th array
@-------------------------------------------------
getArr:
	push	{r1, ip, lr}
	mov	r1, r0
	ldr	r0, =#0x22000		@start of memory
	subs	r1, r1, #1
	popmi	{r1, ip, pc}
	ldr	r0, [r0]
	sub	pc, pc, #20
