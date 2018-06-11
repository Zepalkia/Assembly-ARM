@------------------------------------------
@Change all char in a string from lower to upper case
@Args:
@	r0: the address of start
@	r1: the number of char
@Results:
@	r0: still the address of start
@	All ascii char are now in upper case
@------------------------------------------
strUpper:
	push	{r0, r2, ip, lr}
	subs	r1, r1, #1
	popmi	{r0, r2, ip, pc}
	ldrb	r2, [r0]
	cmp	r2, #97
	addlt	pc, pc, #8
	cmp	r2, #122
	suble	r2, r2, #32
	strb	r2, [r0]
	add	r0, r0, #1
	sub	pc, pc, #44

@-----------------------------------------
@Change all char in a string from upper to lower case
@Args:
@	r0: the address of start
@	r1: the number of char
@Results:
@	r0: still the address of start
@	All ascii char are now in lower case
@-----------------------------------------
strLower:
	push	{r0, r2, ip, lr}
	subs	r1, r1, #1
	popmi	{r0, r2, ip, pc}
	ldrb	r2, [r0]
	cmp	r2, #90
	addgt	pc, pc, #8
	cmp	r2, #65
	addge	r2, r2, #32
	strb	r2, [r0]
	add	r0, r0, #1
	sub	pc, pc, #44
