	.text

l0:
	# address of LED
	li	t2, 0x00080000

l1:
	# call function
	jal	l3

	# 16 MHz -> 4000000 cycles for 2 instrustions loop @ 2 Hz
	li	t0, 4000000
l2:
	addi    t0, t0, -1
	bnez	t0, l2
	j	l1

l3:
	# inc binary count for LED
	addi    t1, t1, 1
	sb      t1, (t2)
	ret
