@-------------------------------------------------
mergeSort:
	push	{ip, lr}
	ldr	r9, =#0x22000
	mov	r0, r9			@r0->start of the memory
	ldr	r1, [r0]		@r1->end of the array
	mov	r2, #1			@r2 = current size
	push	{r0, r1}
	mov	r0, r1
	sub	r0, r0, r9
	bl	hexToDec
	mov	r3, r0
	sub	r3, r3, #2		@r3 = size-1 (-2 for padding)
	pop	{r0, r1}
D1:	cmp	r2, r3			@if current_size > (size-1)...	     <
	popgt	{ip, pc}		@exit				     |
	mov	r4, #0			@r4 = left idx			     |
D2:	cmp	r4, r3			@if left_idx >= (size-1)...	<    |
	addge	pc, pc,	#52		@exit				| v  |
	add	r5, r4, r2		@				| |  |
	sub	r5, r5, #1		@r5 = middle		        | |  |
	push	{r0}			@				| |  |
	lsl	r0, r2, #1		@				| |  |
	sub	r0, r0, #1		@				| |  |
	add	r0, r0, r4		@				| |  |
D3:	mov	r1, r3			@				| |  |
	bl	min			@				| |  |
	mov	r6, r0			@				| |  |
	pop	{r0}			@r6 = right idx			| |  |
	bl	merge			@				| |  |
	lsl	r9, r2, #1		@r9 = current_size*2		| |  |
	add	r4, r4, r9		@left idx += r9			| |  |
	sub	pc, pc, #68 		@				^ |  |
	lsl	r2, r2, #1		@current_size *= 2		  <  |
	sub	pc, pc, #88		@go back to start of loop	     ^
	pop	{ip, pc}
	
@-------------------------------------------------
@merge arrays arr[left..mid] & [mid+1..right]
@Args:
@	r0->start of the array
@	r4 = left
@	r5 = middle
@	r6 = right
@------------------------------------------------
merge:
	push	{r0-r10, ip, lr}
	mov	r1, r4			@r1 = left
	mov	r2, r5			@r2 = middle
	mov	r3, r6			@r3 = right
	sub	r4, r2, r1		@
	add	r4, r4, #1		@r4 = size_1
	sub	r5, r3, r2		@r5 = size_2
	push	{r0, r1}
	mov	r0, #0
	bl	getArr
	add	r0, r0, r1, lsl #2	@r0 = addr+left*4
	mov	r1, r4
	bl	copyArr			@arr no 1> L
	mov	r0, #0
	bl	getArr
	mov	r6, r2
	add	r6, r6, #1
	add	r0, r0, r6, lsl #2	@r0 = addr+(middle+1)*4
	mov	r1, r5
	bl	copyArr
	pop	{r0, r1}		@arr no2> R
	mov	r6, #0			@r6 = i
	mov	r7, #0			@r7 = j
	mov	r8, r1			@r8 = k = left
	mov	r0, #1
	bl	getArr
	add	r1, r0, #4		@r1 = addr(L[0])
	mov	r0, #2
	bl	getArr
	add	r2, r0, #4		@r2 = addr(R[0])
	mov	r0, #4
	mul	r9, r0, r8
	add	r9, r9, #4
	mov	r0, #0
	bl	getArr
	add	r9, r9, r0		@r9 = addr(arr[0])
	cmp	r6, r4			@if i < size_1...		    <
	addge	pc, pc, #64		@...else			v   |
	cmp	r7, r5			@if j < size_2...		|   | 
	addge	pc, pc, #56		@...else			| v | 
	push	{r1, r2}		@				| | |
	ldr	r1, [r1]		@r1 = L[i]			| | |
	ldr	r2, [r2]		@r2 = R[j]			| | |
	cmp	r1, r2			@if L[i] <= R[j]...		| | |
	strle	r1, [r9]		@				| | |
	pople	{r1,r2}			@				| | |
	addle	r6, r6, #1		@i++				| | |
	addle	r1, r1, #4		@r1 = addr(R[i])		| | |
	strgt	r2, [r9]		@else...			| | |
	popgt	{r1,r2}			@				| | |
	addgt	r7, r7, #1		@j++				| | |
	addgt	r2, r2, #4		@r2 = addr(R[j])		| | |
	add	r8, r8, #1		@k++				| | |
	add	r9, r9, #4		@r9 = addr(arr[k])		| | |
	sub	pc, pc, #80		@				| | ^
	cmp	r6, r4			@if i < size_1			< <
	ldrlt	r3, [r1]		@				|
	strlt	r3, [r9]		@				|
	addlt	r1, r1, #4		@				|
	addlt	r9, r9, #4		@				|
	addlt	r6, r6, #1		@				|
	sublt	pc, pc, #32 		@				^
	cmp	r7, r5			@if j < size_2 			<
	ldrlt	r3, [r2]		@				|
	strlt	r3, [r9]		@				|
	addlt	r2, r2, #4		@				|
	addlt	r9, r9, #4		@				|
	addlt	r7, r7, #1		@				|
	sublt	pc, pc, #32		@				^
	pop	{r0-r10, ip, pc}	
