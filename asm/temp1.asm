li x1, 100
li x2, 20

loop: beqz x2, done
	addi x2, x2, -1
	addi x1, x1, 100
done:
	li x3, 1