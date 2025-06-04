.section .text

.global _start

_start:
	li t0, 0x81000000
	li t1, 0x75
	li t2, 0x00010000
	li t3, 0x81020001
	addi t1, t1, 1
_loop:
	sd t1, 0(t0)
	add t0, t0, t2
	addi t1, t1, 2
	blt t0, t3, _loop
	jal .
