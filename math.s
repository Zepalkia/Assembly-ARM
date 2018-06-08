@-------------------------------------------------
@Compute min(x,y)
@Args:
@	r0: x
@	r1: y
@Results:
@	r0: min(x,y)
@-------------------------------------------------
min:
	push	{ip, lr}
	cmp	r0, r1
	movgt	r0, r1	
	pop	{ip, pc}
