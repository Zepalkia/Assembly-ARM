@-------------------------------------------------
@brainf*** interpreter, execute a code stored as an ascii string
@Args:
@	r0: address of start of the code to interprete
@	r1: length of the code (nOp)
@	r2: length of the tape of cells
@	r10: pointer to the first cell (see alloc function)
@Example-program:
@++++++++++[>+>+++>+++++++>++++++++++<<<<-]>>>++.>+.+++++++..+++.<<++.>+++++++++++++++.>.+++.------.--------.<<+.<.
@This will print "Hello  World!" if passed to this function (nOp = 114)
@-------------------------------------------------

brainExec:
	push	{ip, lr}
	mov	r8, r10			@r8 = first cell
	@add	r9, r10, r2, lsl #2	@r9 = last cell		<<<
	add	r9, r10, r2
	bl	brfInit
	add	r1, r0, r1		@r1 = end of the code 
	cmp	r0, r1
	popgt	{ip, pc}
	ldrb	r2, [r0]
	cmp	r2, #43			@if instr == '+'
	beq	incV
	cmp	r2, #45			@if instr == '-'
	beq	decV
	cmp	r2, #62			@if instr == '>'	
	beq	incP
	cmp	r2, #60			@if instr == '<'
	beq	decP
	cmp	r2, #91			@if instr == '['
	beq	jumpF
	cmp	r2, #93			@if instr == ']'
	beq	jumpB
	cmp	r2, #46			@if instr == '.'
	beq	outV
	cmp	r2, #44			@if instr == ','
	beq	inV
brf1:	add	r0, r0, #1
	sub	pc, pc, #88

brfInit:
	push	{ip, lr}
	mov	r6, #0
	mov	r7, r8
	cmp	r7, r9
	popgt	{ip, pc}
	strb	r6, [r7]
	add	r7, r7, #1
	sub	pc, pc, #24

incP:
	add	r10, r10, #1
	cmp	r10, r9
	movgt	r10, r8
	b	brf1

decP:
	sub	r10, r10, #1
	cmp	r10, r8
	movlt	r10, r9
	b	brf1

incV:
	ldrb	r3, [r10]
	add	r3, r3, #1
	strb	r3, [r10]
	b	brf1

decV:
	ldrb	r3, [r10]
	sub	r3, r3, #1
	strb	r3, [r10]
	b	brf1

jumpF:
	ldrb	r3, [r10]
	cmp	r3, #0
	bne	brf1
	add	r0, r0, #1
	ldrb	r2, [r0]
	cmp	r2, #93
	beq	brf1
	sub	pc, pc, #24
jumpB:
	ldrb	r3, [r10]
	cmp	r3, #0
	beq	brf1
	sub	r0, r0, #1
	ldrb	r2, [r0]
	cmp	r2, #91
	beq	brf1
	sub	pc, pc, #24

outV:
	push	{r0, r1, r2, r8, r9, r10}
	mov	r2, #1
	mov	r1, r10
	mov	r0, #1
	mov	r7, #4
	swi	#0
	pop	{r0, r1, r2, r8, r9, r10}
	b	brf1
inV:
	push	{r0, r1, r2, r8, r9, r10}
	mov	r2, #1
	mov	r1, r10
	mov	r0, #0
	mov	r7, #3
	swi	#0
	pop	{r0, r1, r2, r8, r9, r10}
	b	brf1
