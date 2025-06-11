#include "asm.h"

.section .text._start
.global _start
_start:
	# Set Trap Address
	la t0, ____mtrap_location____
	csrw mtvec, t0
	la t0, ____strap_location____
	csrw stvec, t0
	la sp, ____stack_start____
	jal main

.section .text
main:
	jal start_kernel
	jal .
